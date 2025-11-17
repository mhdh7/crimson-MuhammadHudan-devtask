// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import library yang diperlukan dari OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title SalaryEWAContract
 * @dev Kontrak ini mengelola gaji karyawan dan mengizinkan Earned Wage Access (EWA).
 */
contract SalaryEWAContract is Ownable, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    // === STATE VARIABLES ===

    // Alamat token ERC20 yang digunakan untuk pembayaran gaji (Phii Coin)
    IERC20 public immutable salaryToken;

    // Status Karyawan
    enum EmployeeStatus { Active, Inactive }

    // Struktur data untuk menyimpan informasi setiap karyawan
    struct Employee {
        uint256 monthlySalary;      // Gaji bulanan total (dalam 'wei')
        uint256 fundedAmount;       // Saldo yang didepositkan Employer untuk karyawan ini
        uint256 withdrawnAmount;    // Total yang sudah ditarik (termasuk EWA)
        uint256 lastEwaRequestTime; // Waktu terakhir request EWA (untuk mencegah double request)
        uint256 registrationTime;   // Waktu karyawan didaftarkan (untuk acuan periode gaji)
        EmployeeStatus status;
    }

    // Mapping dari alamat karyawan ke data mereka
    mapping(address => Employee) public employees;

    // Durasi periode gaji (misalnya 30 hari)
    uint256 public constant PAY_PERIOD_SECONDS = 30 days;

    // === EVENTS ===

    event EmployeeRegistered(address indexed employee, uint256 monthlySalary);
    event EmployeeDeactivated(address indexed employee);
    event SalaryFunded(address indexed from, uint256 amount);
    event EwaRequested(address indexed employee, uint256 amount);
    event SalaryWithdrawn(address indexed employee, uint256 amount);
    event FundsRefunded(address indexed employer, uint256 amount);

    // === MODIFIERS ===

    /**
     * @dev Memastikan bahwa pemanggil fungsi adalah karyawan yang aktif dan terdaftar.
     */
    modifier onlyActiveEmployee() {
        require(
            employees[msg.sender].status == EmployeeStatus.Active,
            "Only active employees"
        );
        _;
    }

    // === CONSTRUCTOR ===

    /**
     * @dev Menyiapkan kontrak dengan alamat token gaji (Phii Coin).
     * @param _tokenAddress Alamat kontrak ERC20 Phii Coin.
     * @param _initialOwner Alamat yang akan menjadi Owner/Employer.
     */
    constructor(address _tokenAddress, address _initialOwner) Ownable(_initialOwner) {
        require(_tokenAddress != address(0), "Invalid token address");
        salaryToken = IERC20(_tokenAddress);
    }

    // === FUNGSI-FUNGSI (Akan diisi di Fase 4) ===

    // --- Fungsi Admin (Employer) ---

    // function registerEmployee(address _employee, uint256 _monthlySalary) external onlyOwner {
    //     // TODO: Logika untuk mendaftarkan karyawan
    // }

    // function fund(uint256 _totalAmount) external onlyOwner {
    //     // TODO: Logika untuk Employer mengirimkan token ke kontrak
    // }

    // function deactivateEmployee(address _employee) external onlyOwner {
    //     // TODO: Logika untuk menonaktifkan karyawan
    // }

    // function refundUnusedFunds() external onlyOwner nonReentrant {
    //     // TODO: Logika untuk mengambil kembali dana yang tidak terpakai
    // }


    // --- Fungsi Karyawan (Employee) ---

    // function requestAdvance(uint256 _amount) external onlyActiveEmployee nonReentrant {
    //     // TODO: Logika inti EWA
    // }

    // function withdrawRemainingSalary() external onlyActiveEmployee nonReentrant {
    //     // TODO: Logika untuk menarik sisa gaji di akhir periode
    // }


    // --- Fungsi View (Read-Only) ---

    // function getEmployeeInfo(address _employee) external view returns (Employee memory) {
    //     // TODO: Mengembalikan info karyawan
    // }

    // function getAccruedSalary(address _employee) public view returns (uint256) {
    //     // TODO: Logika perhitungan gaji akrual
    // }
}
