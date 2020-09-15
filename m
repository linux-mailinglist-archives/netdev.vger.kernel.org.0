Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD389269B82
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgIOBpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:45:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:12868 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbgIOBpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 21:45:19 -0400
IronPort-SDR: cotPfYnMu1ZvQwlASjQ1xL9izJ2xw2QNFV+iJiGjdMwF3rizr57XIF1h+J6/aKmIYvoMRGDlQm
 2FgSBMwGlfUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220742442"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="220742442"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
IronPort-SDR: rPW9WpCQgWxz7HTTuNenrUS4CfQzNdyMUCplN0X3E2dKFfZsphcNfUHzd01xE0Bya+CCU0+Im4
 cdCzgp0baXFg==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482571940"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v2 02/10] intel-ethernet: clean up W=1 warnings in kdoc
Date:   Mon, 14 Sep 2020 18:44:47 -0700
Message-Id: <20200915014455.1232507-3-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This takes care of all of the trivial W=1 fixes in the Intel
Ethernet drivers, which allows developers and maintainers to
build more of the networking tree with more complete warning
checks.

Almost all of the changes were trivial comment updates on
function headers, with one debug message added to use a
variable after it's assignment.

Inspired by Lee Jones' series of wireless work to do the same.
Compile tested only.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/e100.c             |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c   |  8 +--
 drivers/net/ethernet/intel/e1000/e1000_main.c | 39 +++++++++------
 .../net/ethernet/intel/e1000e/80003es2lan.c   |  1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c   | 16 +++---
 drivers/net/ethernet/intel/e1000e/netdev.c    | 50 ++++++++++++++-----
 drivers/net/ethernet/intel/e1000e/phy.c       |  3 ++
 drivers/net/ethernet/intel/e1000e/ptp.c       |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |  2 -
 drivers/net/ethernet/intel/i40e/i40e_common.c |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 17 ++++---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |  1 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  7 +--
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  9 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 20 ++++----
 drivers/net/ethernet/intel/igb/e1000_82575.c  |  6 +--
 drivers/net/ethernet/intel/igb/e1000_i210.c   |  5 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c    |  1 +
 drivers/net/ethernet/intel/igb/e1000_mbx.c    |  1 +
 drivers/net/ethernet/intel/igb/igb_main.c     | 28 ++++++-----
 drivers/net/ethernet/intel/igb/igb_ptp.c      |  8 +--
 drivers/net/ethernet/intel/igbvf/netdev.c     | 17 +++++--
 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c      |  4 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   | 17 ++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c  |  8 +--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  3 +-
 28 files changed, 171 insertions(+), 113 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 36da059388dc..79c7a92aed16 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -384,7 +384,7 @@ enum cb_status {
 	cb_ok       = 0x2000,
 };
 
-/**
+/*
  * cb_command - Command Block flags
  * @cb_tx_nc:  0: controller does CRC (normal),  1: CRC from skb memory
  */
diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index 4e7a0810eaeb..fb8514078caf 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -139,6 +139,7 @@ static void e1000_phy_init_script(struct e1000_hw *hw)
 		 * at the end of this routine.
 		 */
 		ret_val = e1000_read_phy_reg(hw, 0x2F5B, &phy_saved_data);
+		e_dbg("Reading PHY register 0x2F5B failed: %d\n", ret_val);
 
 		/* Disabled the PHY transmitter */
 		e1000_write_phy_reg(hw, 0x2F5B, 0x0003);
@@ -1897,7 +1898,6 @@ void e1000_config_collision_dist(struct e1000_hw *hw)
 /**
  * e1000_config_mac_to_phy - sync phy and mac settings
  * @hw: Struct containing variables accessed by shared code
- * @mii_reg: data to write to the MII control register
  *
  * Sets MAC speed and duplex settings to reflect the those in the PHY
  * The contents of the PHY register containing the needed information need to
@@ -2922,7 +2922,7 @@ static s32 e1000_read_phy_reg_ex(struct e1000_hw *hw, u32 reg_addr,
  *
  * @hw: Struct containing variables accessed by shared code
  * @reg_addr: address of the PHY register to write
- * @data: data to write to the PHY
+ * @phy_data: data to write to the PHY
  *
  * Writes a value to a PHY register
  */
@@ -4778,8 +4778,6 @@ void e1000_reset_adaptive(struct e1000_hw *hw)
 /**
  * e1000_update_adaptive - update adaptive IFS
  * @hw: Struct containing variables accessed by shared code
- * @tx_packets: Number of transmits since last callback
- * @total_collisions: Number of collisions since last callback
  *
  * Called during the callback/watchdog routine to update IFS value based on
  * the ratio of transmits to collisions.
@@ -5064,8 +5062,6 @@ static s32 e1000_check_polarity(struct e1000_hw *hw,
 /**
  * e1000_check_downshift - Check if Downshift occurred
  * @hw: Struct containing variables accessed by shared code
- * @downshift: output parameter : 0 - No Downshift occurred.
- *                                1 - Downshift occurred.
  *
  * returns: - E1000_ERR_XXX
  *            E1000_SUCCESS
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 1e6ec081fd9d..906591614553 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -199,8 +199,10 @@ module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
 /**
- * e1000_get_hw_dev - return device
- * used by hardware layer to print debugging information
+ * e1000_get_hw_dev - helper function for getting netdev
+ * @hw: pointer to HW struct
+ *
+ * return device used by hardware layer to print debugging information
  *
  **/
 struct net_device *e1000_get_hw_dev(struct e1000_hw *hw)
@@ -354,7 +356,7 @@ static void e1000_release_manageability(struct e1000_adapter *adapter)
 
 /**
  * e1000_configure - configure the hardware for RX and TX
- * @adapter = private board structure
+ * @adapter: private board structure
  **/
 static void e1000_configure(struct e1000_adapter *adapter)
 {
@@ -3489,8 +3491,9 @@ static void e1000_dump(struct e1000_adapter *adapter)
 /**
  * e1000_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: number of the Tx queue that hung (unused)
  **/
-static void e1000_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void e1000_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
@@ -3787,7 +3790,8 @@ static irqreturn_t e1000_intr(int irq, void *data)
 
 /**
  * e1000_clean - NAPI Rx polling callback
- * @adapter: board private structure
+ * @napi: napi struct containing references to driver info
+ * @budget: budget given to driver for receive packets
  **/
 static int e1000_clean(struct napi_struct *napi, int budget)
 {
@@ -3818,6 +3822,7 @@ static int e1000_clean(struct napi_struct *napi, int budget)
 /**
  * e1000_clean_tx_irq - Reclaim resources after transmit completes
  * @adapter: board private structure
+ * @tx_ring: ring to clean
  **/
 static bool e1000_clean_tx_irq(struct e1000_adapter *adapter,
 			       struct e1000_tx_ring *tx_ring)
@@ -3933,7 +3938,7 @@ static bool e1000_clean_tx_irq(struct e1000_adapter *adapter,
  * @adapter:     board private structure
  * @status_err:  receive descriptor status and error fields
  * @csum:        receive descriptor csum field
- * @sk_buff:     socket buffer with received data
+ * @skb:         socket buffer with received data
  **/
 static void e1000_rx_checksum(struct e1000_adapter *adapter, u32 status_err,
 			      u32 csum, struct sk_buff *skb)
@@ -3970,6 +3975,9 @@ static void e1000_rx_checksum(struct e1000_adapter *adapter, u32 status_err,
 
 /**
  * e1000_consume_page - helper function for jumbo Rx path
+ * @bi: software descriptor shadow data
+ * @skb: skb being modified
+ * @length: length of data being added
  **/
 static void e1000_consume_page(struct e1000_rx_buffer *bi, struct sk_buff *skb,
 			       u16 length)
@@ -4003,6 +4011,7 @@ static void e1000_receive_skb(struct e1000_adapter *adapter, u8 status,
 /**
  * e1000_tbi_adjust_stats
  * @hw: Struct containing variables accessed by shared code
+ * @stats: point to stats struct
  * @frame_len: The length of the frame in question
  * @mac_addr: The Ethernet destination address of the frame in question
  *
@@ -4548,6 +4557,8 @@ e1000_alloc_jumbo_rx_buffers(struct e1000_adapter *adapter,
 /**
  * e1000_alloc_rx_buffers - Replace used receive buffers; legacy & extended
  * @adapter: address of board private structure
+ * @rx_ring: pointer to ring struct
+ * @cleaned_count: number of new Rx buffers to try to allocate
  **/
 static void e1000_alloc_rx_buffers(struct e1000_adapter *adapter,
 				   struct e1000_rx_ring *rx_ring,
@@ -4662,7 +4673,7 @@ static void e1000_alloc_rx_buffers(struct e1000_adapter *adapter,
 
 /**
  * e1000_smartspeed - Workaround for SmartSpeed on 82541 and 82547 controllers.
- * @adapter:
+ * @adapter: address of board private structure
  **/
 static void e1000_smartspeed(struct e1000_adapter *adapter)
 {
@@ -4718,10 +4729,10 @@ static void e1000_smartspeed(struct e1000_adapter *adapter)
 }
 
 /**
- * e1000_ioctl -
- * @netdev:
- * @ifreq:
- * @cmd:
+ * e1000_ioctl - handle ioctl calls
+ * @netdev: pointer to our netdev
+ * @ifr: pointer to interface request structure
+ * @cmd: ioctl data
  **/
 static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
@@ -4737,9 +4748,9 @@ static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 
 /**
  * e1000_mii_ioctl -
- * @netdev:
- * @ifreq:
- * @cmd:
+ * @netdev: pointer to our netdev
+ * @ifr: pointer to interface request structure
+ * @cmd: ioctl data
  **/
 static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
 			   int cmd)
diff --git a/drivers/net/ethernet/intel/e1000e/80003es2lan.c b/drivers/net/ethernet/intel/e1000e/80003es2lan.c
index 4b103cca8a39..be9c695dde12 100644
--- a/drivers/net/ethernet/intel/e1000e/80003es2lan.c
+++ b/drivers/net/ethernet/intel/e1000e/80003es2lan.c
@@ -1072,7 +1072,6 @@ static s32 e1000_setup_copper_link_80003es2lan(struct e1000_hw *hw)
 /**
  *  e1000_cfg_on_link_up_80003es2lan - es2 link configuration after link-up
  *  @hw: pointer to the HW structure
- *  @duplex: current duplex setting
  *
  *  Configure the KMRN interface by applying last minute quirks for
  *  10/100 operation.
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index b2f2fcfdf732..ded74304e8cf 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -743,7 +743,7 @@ static s32 e1000_init_mac_params_ich8lan(struct e1000_hw *hw)
 /**
  *  __e1000_access_emi_reg_locked - Read/write EMI register
  *  @hw: pointer to the HW structure
- *  @addr: EMI address to program
+ *  @address: EMI address to program
  *  @data: pointer to value to read/write from/to the EMI address
  *  @read: boolean flag to indicate read or write
  *
@@ -2266,7 +2266,7 @@ static s32 e1000_k1_gig_workaround_hv(struct e1000_hw *hw, bool link)
 /**
  *  e1000_configure_k1_ich8lan - Configure K1 power state
  *  @hw: pointer to the HW structure
- *  @enable: K1 state to configure
+ *  @k1_enable: K1 state to configure
  *
  *  Configure the K1 power state based on the provided parameter.
  *  Assumes semaphore already acquired.
@@ -2405,8 +2405,10 @@ static s32 e1000_set_mdio_slow_mode_hv(struct e1000_hw *hw)
 }
 
 /**
- *  e1000_hv_phy_workarounds_ich8lan - A series of Phy workarounds to be
- *  done after every PHY reset.
+ *  e1000_hv_phy_workarounds_ich8lan - apply PHY workarounds
+ *  @hw: pointer to the HW structure
+ *
+ *  A series of PHY workarounds to be done after every PHY reset.
  **/
 static s32 e1000_hv_phy_workarounds_ich8lan(struct e1000_hw *hw)
 {
@@ -2694,8 +2696,10 @@ s32 e1000_lv_jumbo_workaround_ich8lan(struct e1000_hw *hw, bool enable)
 }
 
 /**
- *  e1000_lv_phy_workarounds_ich8lan - A series of Phy workarounds to be
- *  done after every PHY reset.
+ *  e1000_lv_phy_workarounds_ich8lan - apply ich8 specific workarounds
+ *  @hw: pointer to the HW structure
+ *
+ *  A series of PHY workarounds to be done after every PHY reset.
  **/
 static s32 e1000_lv_phy_workarounds_ich8lan(struct e1000_hw *hw)
 {
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 664e8ccc88d2..99f4ec9b5696 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -501,6 +501,7 @@ static void e1000e_dump(struct e1000_adapter *adapter)
 
 /**
  * e1000_desc_unused - calculate if we have unused descriptors
+ * @ring: pointer to ring struct to perform calculation on
  **/
 static int e1000_desc_unused(struct e1000_ring *ring)
 {
@@ -577,6 +578,7 @@ static void e1000e_rx_hwtstamp(struct e1000_adapter *adapter, u32 status,
 /**
  * e1000_receive_skb - helper function to handle Rx indications
  * @adapter: board private structure
+ * @netdev: pointer to netdev struct
  * @staterr: descriptor extended error and status field as written by hardware
  * @vlan: descriptor vlan field as written by hardware (no le/be conversion)
  * @skb: pointer to sk_buff to be indicated to stack
@@ -601,8 +603,7 @@ static void e1000_receive_skb(struct e1000_adapter *adapter,
  * e1000_rx_checksum - Receive Checksum Offload
  * @adapter: board private structure
  * @status_err: receive descriptor status and error fields
- * @csum: receive descriptor csum field
- * @sk_buff: socket buffer with received data
+ * @skb: socket buffer with received data
  **/
 static void e1000_rx_checksum(struct e1000_adapter *adapter, u32 status_err,
 			      struct sk_buff *skb)
@@ -673,6 +674,8 @@ static void e1000e_update_tdt_wa(struct e1000_ring *tx_ring, unsigned int i)
 /**
  * e1000_alloc_rx_buffers - Replace used receive buffers
  * @rx_ring: Rx descriptor ring
+ * @cleaned_count: number to reallocate
+ * @gfp: flags for allocation
  **/
 static void e1000_alloc_rx_buffers(struct e1000_ring *rx_ring,
 				   int cleaned_count, gfp_t gfp)
@@ -741,6 +744,8 @@ static void e1000_alloc_rx_buffers(struct e1000_ring *rx_ring,
 /**
  * e1000_alloc_rx_buffers_ps - Replace used receive buffers; packet split
  * @rx_ring: Rx descriptor ring
+ * @cleaned_count: number to reallocate
+ * @gfp: flags for allocation
  **/
 static void e1000_alloc_rx_buffers_ps(struct e1000_ring *rx_ring,
 				      int cleaned_count, gfp_t gfp)
@@ -844,6 +849,7 @@ static void e1000_alloc_rx_buffers_ps(struct e1000_ring *rx_ring,
  * e1000_alloc_jumbo_rx_buffers - Replace used jumbo receive buffers
  * @rx_ring: Rx descriptor ring
  * @cleaned_count: number of buffers to allocate this pass
+ * @gfp: flags for allocation
  **/
 
 static void e1000_alloc_jumbo_rx_buffers(struct e1000_ring *rx_ring,
@@ -933,6 +939,8 @@ static inline void e1000_rx_hash(struct net_device *netdev, __le32 rss,
 /**
  * e1000_clean_rx_irq - Send received data up the network stack
  * @rx_ring: Rx descriptor ring
+ * @work_done: output parameter for indicating completed work
+ * @work_to_do: how many packets we can clean
  *
  * the return value indicates whether actual cleaning was done, there
  * is no guarantee that everything was cleaned
@@ -1327,6 +1335,8 @@ static bool e1000_clean_tx_irq(struct e1000_ring *tx_ring)
 /**
  * e1000_clean_rx_irq_ps - Send received data up the network stack; packet split
  * @rx_ring: Rx descriptor ring
+ * @work_done: output parameter for indicating completed work
+ * @work_to_do: how many packets we can clean
  *
  * the return value indicates whether actual cleaning was done, there
  * is no guarantee that everything was cleaned
@@ -1517,9 +1527,6 @@ static bool e1000_clean_rx_irq_ps(struct e1000_ring *rx_ring, int *work_done,
 	return cleaned;
 }
 
-/**
- * e1000_consume_page - helper function
- **/
 static void e1000_consume_page(struct e1000_buffer *bi, struct sk_buff *skb,
 			       u16 length)
 {
@@ -1531,7 +1538,9 @@ static void e1000_consume_page(struct e1000_buffer *bi, struct sk_buff *skb,
 
 /**
  * e1000_clean_jumbo_rx_irq - Send received data up the network stack; legacy
- * @adapter: board private structure
+ * @rx_ring: Rx descriptor ring
+ * @work_done: output parameter for indicating completed work
+ * @work_to_do: how many packets we can clean
  *
  * the return value indicates whether actual cleaning was done, there
  * is no guarantee that everything was cleaned
@@ -1994,6 +2003,7 @@ static irqreturn_t e1000_intr_msix_rx(int __always_unused irq, void *data)
 
 /**
  * e1000_configure_msix - Configure MSI-X hardware
+ * @adapter: board private structure
  *
  * e1000_configure_msix sets up the hardware to properly
  * generate MSI-X interrupts.
@@ -2072,6 +2082,7 @@ void e1000e_reset_interrupt_capability(struct e1000_adapter *adapter)
 
 /**
  * e1000e_set_interrupt_capability - set MSI or MSI-X if supported
+ * @adapter: board private structure
  *
  * Attempt to configure interrupts using the best available
  * capabilities of the hardware and kernel.
@@ -2127,6 +2138,7 @@ void e1000e_set_interrupt_capability(struct e1000_adapter *adapter)
 
 /**
  * e1000_request_msix - Initialize MSI-X interrupts
+ * @adapter: board private structure
  *
  * e1000_request_msix allocates MSI-X vectors and requests interrupts from the
  * kernel.
@@ -2180,6 +2192,7 @@ static int e1000_request_msix(struct e1000_adapter *adapter)
 
 /**
  * e1000_request_irq - initialize interrupts
+ * @adapter: board private structure
  *
  * Attempts to configure interrupts using the best available
  * capabilities of the hardware and kernel.
@@ -2240,6 +2253,7 @@ static void e1000_free_irq(struct e1000_adapter *adapter)
 
 /**
  * e1000_irq_disable - Mask off interrupt generation on the NIC
+ * @adapter: board private structure
  **/
 static void e1000_irq_disable(struct e1000_adapter *adapter)
 {
@@ -2262,6 +2276,7 @@ static void e1000_irq_disable(struct e1000_adapter *adapter)
 
 /**
  * e1000_irq_enable - Enable default interrupt generation settings
+ * @adapter: board private structure
  **/
 static void e1000_irq_enable(struct e1000_adapter *adapter)
 {
@@ -2332,6 +2347,8 @@ void e1000e_release_hw_control(struct e1000_adapter *adapter)
 
 /**
  * e1000_alloc_ring_dma - allocate memory for a ring structure
+ * @adapter: board private structure
+ * @ring: ring struct for which to allocate dma
  **/
 static int e1000_alloc_ring_dma(struct e1000_adapter *adapter,
 				struct e1000_ring *ring)
@@ -2507,7 +2524,6 @@ void e1000e_free_rx_resources(struct e1000_ring *rx_ring)
 
 /**
  * e1000_update_itr - update the dynamic ITR value based on statistics
- * @adapter: pointer to adapter
  * @itr_setting: current adapter->itr
  * @packets: the number of packets during this measurement interval
  * @bytes: the number of bytes during this measurement interval
@@ -3049,12 +3065,13 @@ static void e1000_configure_tx(struct e1000_adapter *adapter)
 	}
 }
 
+#define PAGE_USE_COUNT(S) (((S) >> PAGE_SHIFT) + \
+			   (((S) & (PAGE_SIZE - 1)) ? 1 : 0))
+
 /**
  * e1000_setup_rctl - configure the receive control registers
  * @adapter: Board private structure
  **/
-#define PAGE_USE_COUNT(S) (((S) >> PAGE_SHIFT) + \
-			   (((S) & (PAGE_SIZE - 1)) ? 1 : 0))
 static void e1000_setup_rctl(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
@@ -3605,6 +3622,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 /**
  * e1000e_config_hwtstamp - configure the hwtstamp registers and enable/disable
  * @adapter: board private structure
+ * @config: timestamp configuration
  *
  * Outgoing time stamping can be enabled and disabled. Play nice and
  * disable it when requested, although it shouldn't cause any overhead
@@ -3808,6 +3826,7 @@ void e1000e_power_up_phy(struct e1000_adapter *adapter)
 
 /**
  * e1000_power_down_phy - Power down the PHY
+ * @adapter: board private structure
  *
  * Power down the PHY so no link is implied when interface is down.
  * The PHY cannot be powered down if management or WoL is active.
@@ -3820,6 +3839,7 @@ static void e1000_power_down_phy(struct e1000_adapter *adapter)
 
 /**
  * e1000_flush_tx_ring - remove all descriptors from the tx_ring
+ * @adapter: board private structure
  *
  * We want to clear all pending descriptors from the TX ring.
  * zeroing happens when the HW reads the regs. We  assign the ring itself as
@@ -3854,6 +3874,7 @@ static void e1000_flush_tx_ring(struct e1000_adapter *adapter)
 
 /**
  * e1000_flush_rx_ring - remove all descriptors from the rx_ring
+ * @adapter: board private structure
  *
  * Mark all descriptors in the RX ring as consumed and disable the rx ring
  */
@@ -3886,6 +3907,7 @@ static void e1000_flush_rx_ring(struct e1000_adapter *adapter)
 
 /**
  * e1000_flush_desc_rings - remove all descriptors from the descriptor rings
+ * @adapter: board private structure
  *
  * In i219, the descriptor rings must be emptied before resetting the HW
  * or before changing the device state to D3 during runtime (runtime PM).
@@ -3968,6 +3990,7 @@ static void e1000e_systim_reset(struct e1000_adapter *adapter)
 
 /**
  * e1000e_reset - bring the hardware into a known good state
+ * @adapter: board private structure
  *
  * This function boots the hardware and enables some settings that
  * require a configuration cycle of the hardware - those cannot be
@@ -4847,7 +4870,7 @@ static void e1000e_update_phy_task(struct work_struct *work)
 
 /**
  * e1000_update_phy_info - timre call-back to update PHY info
- * @data: pointer to adapter cast into an unsigned long
+ * @t: pointer to timer_list containing private info adapter
  *
  * Need to wait a few seconds after link up to get diagnostic information from
  * the phy
@@ -5187,7 +5210,7 @@ static void e1000e_check_82574_phy_workaround(struct e1000_adapter *adapter)
 
 /**
  * e1000_watchdog - Timer Call-back
- * @data: pointer to adapter cast into an unsigned long
+ * @t: pointer to timer_list containing private info adapter
  **/
 static void e1000_watchdog(struct timer_list *t)
 {
@@ -5972,8 +5995,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 /**
  * e1000_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: index of the hung queue (unused)
  **/
-static void e1000_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void e1000_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
@@ -6174,7 +6198,7 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
 /**
  * e1000e_hwtstamp_ioctl - control hardware time stamping
  * @netdev: network interface device structure
- * @ifreq: interface request
+ * @ifr: interface request
  *
  * Outgoing time stamping can be enabled and disabled. Play nice and
  * disable it when requested, although it shouldn't cause any overhead
diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index e11c877595fb..bdd9dc163f15 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -2311,6 +2311,7 @@ s32 e1000e_determine_phy_address(struct e1000_hw *hw)
 /**
  *  e1000_get_phy_addr_for_bm_page - Retrieve PHY page address
  *  @page: page to access
+ *  @reg: register to check
  *
  *  Returns the phy address for the page requested.
  **/
@@ -2728,6 +2729,7 @@ void e1000_power_down_phy_copper(struct e1000_hw *hw)
  *  @offset: register offset to be read
  *  @data: pointer to the read data
  *  @locked: semaphore has already been acquired or not
+ *  @page_set: BM_WUC_PAGE already set and access enabled
  *
  *  Acquires semaphore, if necessary, then reads the PHY register at offset
  *  and stores the retrieved information in data.  Release any acquired
@@ -2836,6 +2838,7 @@ s32 e1000_read_phy_reg_page_hv(struct e1000_hw *hw, u32 offset, u16 *data)
  *  @offset: register offset to write to
  *  @data: data to write at register offset
  *  @locked: semaphore has already been acquired or not
+ *  @page_set: BM_WUC_PAGE already set and access enabled
  *
  *  Acquires semaphore, if necessary, then writes the data to PHY register
  *  at the offset.  Release any acquired semaphores before exiting.
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index 34b988d70488..8d21bcb427ec 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -144,7 +144,7 @@ static int e1000e_phc_get_syncdevicetime(ktime_t *device,
 /**
  * e1000e_phc_getsynctime - Reads the current system/device cross timestamp
  * @ptp: ptp clock structure
- * @cts: structure containing timestamp
+ * @xtstamp: structure containing timestamp
  *
  * Read device and system (ART) clock simultaneously and return the scaled
  * clock values in ns.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index befd3018183f..a2dba32383f6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -278,8 +278,6 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
 /**
  * i40e_client_add_instance - add a client instance struct to the instance list
  * @pf: pointer to the board struct
- * @client: pointer to a client struct in the client list.
- * @existing: if there was already an existing instance
  *
  **/
 static void i40e_client_add_instance(struct i40e_pf *pf)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 6ab52cbd697a..adc9e4fa4789 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -3766,9 +3766,7 @@ i40e_status i40e_aq_stop_lldp(struct i40e_hw *hw, bool shutdown_agent,
 /**
  * i40e_aq_start_lldp
  * @hw: pointer to the hw struct
- * @buff: buffer for result
  * @persist: True if start of LLDP should be persistent across power cycles
- * @buff_size: buffer size
  * @cmd_details: pointer to command details structure or NULL
  *
  * Start the embedded LLDP Agent on all ports.
@@ -5395,6 +5393,7 @@ static void i40e_mdio_if_number_selection(struct i40e_hw *hw, bool set_mdio,
  * @hw: pointer to the hw struct
  * @phy_select: select which phy should be accessed
  * @dev_addr: PHY device address
+ * @page_change: flag to indicate if phy page should be updated
  * @set_mdio: use MDIO I/F number specified by mdio_num
  * @mdio_num: MDIO I/F number
  * @reg_addr: PHY register address
@@ -5439,6 +5438,7 @@ enum i40e_status_code i40e_aq_set_phy_register_ext(struct i40e_hw *hw,
  * @hw: pointer to the hw struct
  * @phy_select: select which phy should be accessed
  * @dev_addr: PHY device address
+ * @page_change: flag to indicate if phy page should be updated
  * @set_mdio: use MDIO I/F number specified by mdio_num
  * @mdio_num: MDIO I/F number
  * @reg_addr: PHY register address
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 05c6d3ea11e6..4553700ce686 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -287,6 +287,7 @@ void i40e_service_event_schedule(struct i40e_pf *pf)
 /**
  * i40e_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue number timing out
  *
  * If any port has noticed a Tx timeout, it is likely that the whole
  * device is munged, not just the one netdev port, so go for the full
@@ -1609,6 +1610,8 @@ static int i40e_set_mac(struct net_device *netdev, void *p)
  * i40e_config_rss_aq - Prepare for RSS using AQ commands
  * @vsi: vsi structure
  * @seed: RSS hash seed
+ * @lut: pointer to lookup table of lut_size
+ * @lut_size: size of the lookup table
  **/
 static int i40e_config_rss_aq(struct i40e_vsi *vsi, const u8 *seed,
 			      u8 *lut, u16 lut_size)
@@ -5815,7 +5818,6 @@ static int i40e_vsi_reconfig_rss(struct i40e_vsi *vsi, u16 rss_size)
 /**
  * i40e_channel_setup_queue_map - Setup a channel queue map
  * @pf: ptr to PF device
- * @vsi: the VSI being setup
  * @ctxt: VSI context structure
  * @ch: ptr to channel structure
  *
@@ -6058,8 +6060,7 @@ static inline int i40e_setup_hw_channel(struct i40e_pf *pf,
 /**
  * i40e_setup_channel - setup new channel using uplink element
  * @pf: ptr to PF device
- * @type: type of channel to be created (VMDq2/VF)
- * @uplink_seid: underlying HW switching element (VEB) ID
+ * @vsi: pointer to the VSI to set up the channel within
  * @ch: ptr to channel structure
  *
  * Setup new channel (VSI) based on specified type (VMDq2/VF)
@@ -7780,7 +7781,7 @@ int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 /**
  * i40e_parse_cls_flower - Parse tc flower filters provided by kernel
  * @vsi: Pointer to VSI
- * @cls_flower: Pointer to struct flow_cls_offload
+ * @f: Pointer to struct flow_cls_offload
  * @filter: Pointer to cloud filter structure
  *
  **/
@@ -8161,8 +8162,8 @@ static int i40e_delete_clsflower(struct i40e_vsi *vsi,
 
 /**
  * i40e_setup_tc_cls_flower - flower classifier offloads
- * @netdev: net device to configure
- * @type_data: offload data
+ * @np: net device to configure
+ * @cls_flower: offload data
  **/
 static int i40e_setup_tc_cls_flower(struct i40e_netdev_priv *np,
 				    struct flow_cls_offload *cls_flower)
@@ -9586,6 +9587,7 @@ static int i40e_reconstitute_veb(struct i40e_veb *veb)
 /**
  * i40e_get_capabilities - get info about the HW
  * @pf: the PF struct
+ * @list_type: AQ capability to be queried
  **/
 static int i40e_get_capabilities(struct i40e_pf *pf,
 				 enum i40e_admin_queue_opc list_type)
@@ -10547,7 +10549,7 @@ static void i40e_service_task(struct work_struct *work)
 
 /**
  * i40e_service_timer - timer callback
- * @data: pointer to PF struct
+ * @t: timer list pointer
  **/
 static void i40e_service_timer(struct timer_list *t)
 {
@@ -12380,6 +12382,7 @@ static int i40e_get_phys_port_id(struct net_device *netdev,
  * @addr: the MAC address entry being added
  * @vid: VLAN ID
  * @flags: instructions from stack about fdb operation
+ * @extack: netlink extended ack, unused currently
  */
 static int i40e_ndo_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			    struct net_device *dev,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index ff7b19c6bc73..7a879614ca55 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -259,7 +259,6 @@ static u32 i40e_ptp_get_rx_events(struct i40e_pf *pf)
 /**
  * i40e_ptp_rx_hang - Detect error case when Rx timestamp registers are hung
  * @pf: The PF private data structure
- * @vsi: The VSI with the rings relevant to 1588
  *
  * This watchdog task is scheduled to detect error case where hardware has
  * dropped an Rx packet that was timestamped when the ring is full. The
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 91ab824926b9..828dff2e7ed2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1755,7 +1755,6 @@ static inline void i40e_rx_hash(struct i40e_ring *ring,
  * @rx_ring: rx descriptor ring packet is being transacted on
  * @rx_desc: pointer to the EOP Rx descriptor
  * @skb: pointer to current skb being populated
- * @rx_ptype: the packet type decoded by hardware
  *
  * This function checks the ring, descriptor, and packet information in
  * order to populate the hash, checksum, VLAN, protocol, and
@@ -3499,7 +3498,7 @@ static inline int i40e_tx_map(struct i40e_ring *tx_ring, struct sk_buff *skb,
 
 /**
  * i40e_xmit_xdp_ring - transmits an XDP buffer to an XDP Tx ring
- * @xdp: data to transmit
+ * @xdpf: data to transmit
  * @xdp_ring: XDP Tx ring
  **/
 static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
@@ -3694,7 +3693,9 @@ netdev_tx_t i40e_lan_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 /**
  * i40e_xdp_xmit - Implements ndo_xdp_xmit
  * @dev: netdev
- * @xdp: XDP buffer
+ * @n: number of frames
+ * @frames: array of XDP buffer pointers
+ * @flags: XDP extra info
  *
  * Returns number of frames successfully sent. Frames that fail are
  * free'ed via XDP return API.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 8e133d6545bd..f32a907b4419 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2234,7 +2234,8 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 }
 
 /**
- * i40e_validate_queue_map
+ * i40e_validate_queue_map - check queue map is valid
+ * @vf: the VF structure pointer
  * @vsi_id: vsi id
  * @queuemap: Tx or Rx queue map
  *
@@ -3150,8 +3151,8 @@ static int i40e_vc_disable_vlan_stripping(struct i40e_vf *vf, u8 *msg)
 
 /**
  * i40e_validate_cloud_filter
- * @mask: mask for TC filter
- * @data: data for TC filter
+ * @vf: pointer to VF structure
+ * @tc_filter: pointer to filter requested
  *
  * This function validates cloud filter programmed as TC filter for ADq
  **/
@@ -3284,7 +3285,7 @@ static int i40e_validate_cloud_filter(struct i40e_vf *vf,
 /**
  * i40e_find_vsi_from_seid - searches for the vsi with the given seid
  * @vf: pointer to the VF info
- * @seid - seid of the vsi it is searching for
+ * @seid: seid of the vsi it is searching for
  **/
 static struct i40e_vsi *i40e_find_vsi_from_seid(struct i40e_vf *vf, u16 seid)
 {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d870343cf689..08610a3f978a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -147,6 +147,7 @@ void iavf_schedule_reset(struct iavf_adapter *adapter)
 /**
  * iavf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue number that is timing out
  **/
 static void iavf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
@@ -2572,8 +2573,8 @@ static int iavf_validate_ch_config(struct iavf_adapter *adapter,
 }
 
 /**
- * iavf_del_all_cloud_filters - delete all cloud filters
- * on the traffic classes
+ * iavf_del_all_cloud_filters - delete all cloud filters on the traffic classes
+ * @adapter: board private structure
  **/
 static void iavf_del_all_cloud_filters(struct iavf_adapter *adapter)
 {
@@ -2592,7 +2593,7 @@ static void iavf_del_all_cloud_filters(struct iavf_adapter *adapter)
 /**
  * __iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
- * @type_date: tc offload data
+ * @type_data: tc offload data
  *
  * This function processes the config information provided by the
  * user to configure traffic classes/queue channels and packages the
@@ -2690,7 +2691,7 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 /**
  * iavf_parse_cls_flower - Parse tc flower filters provided by kernel
  * @adapter: board private structure
- * @cls_flower: pointer to struct flow_cls_offload
+ * @f: pointer to struct flow_cls_offload
  * @filter: pointer to cloud filter structure
  */
 static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
@@ -3064,8 +3065,8 @@ static int iavf_delete_clsflower(struct iavf_adapter *adapter,
 
 /**
  * iavf_setup_tc_cls_flower - flower classifier offloads
- * @netdev: net device to configure
- * @type_data: offload data
+ * @adapter: board private structure
+ * @cls_flower: pointer to flow_cls_offload struct with flow info
  */
 static int iavf_setup_tc_cls_flower(struct iavf_adapter *adapter,
 				    struct flow_cls_offload *cls_flower)
@@ -3112,7 +3113,7 @@ static LIST_HEAD(iavf_block_cb_list);
  * iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
  * @type: type of offload
- * @type_date: tc offload data
+ * @type_data: tc offload data
  *
  * This function is the callback to ndo_setup_tc in the
  * netdev_ops.
@@ -3768,8 +3769,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 /**
  * iavf_suspend - Power management suspend routine
- * @pdev: PCI device information struct
- * @state: unused
+ * @dev_d: device info pointer
  *
  * Called when the system (VM) is entering sleep/suspend.
  **/
@@ -3799,7 +3799,7 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 
 /**
  * iavf_resume - Power management resume routine
- * @pdev: PCI device information struct
+ * @dev_d: device info pointer
  *
  * Called when the system (VM) is resumed from sleep/suspend.
  **/
diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index a32391e82762..50863fd87d53 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -2554,7 +2554,7 @@ static s32 igb_update_nvm_checksum_i350(struct e1000_hw *hw)
 /**
  *  __igb_access_emi_reg - Read/write EMI register
  *  @hw: pointer to the HW structure
- *  @addr: EMI address to program
+ *  @address: EMI address to program
  *  @data: pointer to value to read/write from/to the EMI address
  *  @read: boolean flag to indicate read or write
  **/
@@ -2590,7 +2590,7 @@ s32 igb_read_emi_reg(struct e1000_hw *hw, u16 addr, u16 *data)
  *  igb_set_eee_i350 - Enable/disable EEE support
  *  @hw: pointer to the HW structure
  *  @adv1G: boolean flag enabling 1G EEE advertisement
- *  @adv100m: boolean flag enabling 100M EEE advertisement
+ *  @adv100M: boolean flag enabling 100M EEE advertisement
  *
  *  Enable/disable EEE based on setting in dev_spec structure.
  *
@@ -2646,7 +2646,7 @@ s32 igb_set_eee_i350(struct e1000_hw *hw, bool adv1G, bool adv100M)
  *  igb_set_eee_i354 - Enable/disable EEE support
  *  @hw: pointer to the HW structure
  *  @adv1G: boolean flag enabling 1G EEE advertisement
- *  @adv100m: boolean flag enabling 100M EEE advertisement
+ *  @adv100M: boolean flag enabling 100M EEE advertisement
  *
  *  Enable/disable EEE legacy mode based on setting in dev_spec structure.
  *
diff --git a/drivers/net/ethernet/intel/igb/e1000_i210.c b/drivers/net/ethernet/intel/igb/e1000_i210.c
index c393cb2c0f16..9265901455cd 100644
--- a/drivers/net/ethernet/intel/igb/e1000_i210.c
+++ b/drivers/net/ethernet/intel/igb/e1000_i210.c
@@ -357,13 +357,14 @@ static s32 igb_read_invm_word_i210(struct e1000_hw *hw, u8 address, u16 *data)
 /**
  * igb_read_invm_i210 - Read invm wrapper function for I210/I211
  *  @hw: pointer to the HW structure
- *  @words: number of words to read
+ *  @offset: offset to read from
+ *  @words: number of words to read (unused)
  *  @data: pointer to the data read
  *
  *  Wrapper function to return data formerly found in the NVM.
  **/
 static s32 igb_read_invm_i210(struct e1000_hw *hw, u16 offset,
-				u16 words __always_unused, u16 *data)
+				u16 __always_unused words, u16 *data)
 {
 	s32 ret_val = 0;
 
diff --git a/drivers/net/ethernet/intel/igb/e1000_mac.c b/drivers/net/ethernet/intel/igb/e1000_mac.c
index 3254737c07a3..fd8eb2f9ab9d 100644
--- a/drivers/net/ethernet/intel/igb/e1000_mac.c
+++ b/drivers/net/ethernet/intel/igb/e1000_mac.c
@@ -166,6 +166,7 @@ static s32 igb_find_vlvf_slot(struct e1000_hw *hw, u32 vlan, bool vlvf_bypass)
  *  @vlan: VLAN id to add or remove
  *  @vind: VMDq output index that maps queue to VLAN id
  *  @vlan_on: if true add filter, if false remove
+ *  @vlvf_bypass: skip VLVF if no match is found
  *
  *  Sets or clears a bit in the VLAN filter table array based on VLAN id
  *  and if we are adding or removing the filter
diff --git a/drivers/net/ethernet/intel/igb/e1000_mbx.c b/drivers/net/ethernet/intel/igb/e1000_mbx.c
index 46debd991bfe..33cceb77e960 100644
--- a/drivers/net/ethernet/intel/igb/e1000_mbx.c
+++ b/drivers/net/ethernet/intel/igb/e1000_mbx.c
@@ -9,6 +9,7 @@
  *  @msg: The message buffer
  *  @size: Length of buffer
  *  @mbx_id: id of mailbox to read
+ *  @unlock: skip locking or not
  *
  *  returns SUCCESS if it successfully read message from buffer
  **/
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index e1e37d0b7703..44157fcd3cf7 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -549,8 +549,7 @@ static void igb_dump(struct igb_adapter *adapter)
 
 /**
  *  igb_get_i2c_data - Reads the I2C SDA data bit
- *  @hw: pointer to hardware structure
- *  @i2cctl: Current value of I2CCTL register
+ *  @data: opaque pointer to adapter struct
  *
  *  Returns the I2C data bit value
  **/
@@ -3868,6 +3867,7 @@ static int igb_sw_init(struct igb_adapter *adapter)
 /**
  *  igb_open - Called when a network interface is made active
  *  @netdev: network interface device structure
+ *  @resuming: indicates whether we are in a resume call
  *
  *  Returns 0 on success, negative value on failure
  *
@@ -3985,6 +3985,7 @@ int igb_open(struct net_device *netdev)
 /**
  *  igb_close - Disables a network interface
  *  @netdev: network interface device structure
+ *  @suspending: indicates we are in a suspend call
  *
  *  Returns 0, this is not allowed to fail
  *
@@ -5219,7 +5220,7 @@ static void igb_check_lvmmc(struct igb_adapter *adapter)
 
 /**
  *  igb_watchdog - Timer Call-back
- *  @data: pointer to adapter cast into an unsigned long
+ *  @t: pointer to timer_list containing our private info pointer
  **/
 static void igb_watchdog(struct timer_list *t)
 {
@@ -6192,8 +6193,9 @@ static netdev_tx_t igb_xmit_frame(struct sk_buff *skb,
 /**
  *  igb_tx_timeout - Respond to a Tx Hang
  *  @netdev: network interface device structure
+ *  @txqueue: number of the Tx queue that hung (unused)
  **/
-static void igb_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void igb_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
@@ -8181,7 +8183,6 @@ static inline void igb_rx_hash(struct igb_ring *ring,
  *  igb_is_non_eop - process handling of non-EOP buffers
  *  @rx_ring: Rx ring being processed
  *  @rx_desc: Rx descriptor for current buffer
- *  @skb: current socket buffer containing buffer in progress
  *
  *  This function updates next to clean.  If the buffer is an EOP buffer
  *  this function exits returning false, otherwise it will place the
@@ -8460,8 +8461,9 @@ static bool igb_alloc_mapped_page(struct igb_ring *rx_ring,
 }
 
 /**
- *  igb_alloc_rx_buffers - Replace used receive buffers; packet split
- *  @adapter: address of board private structure
+ *  igb_alloc_rx_buffers - Replace used receive buffers
+ *  @rx_ring: rx descriptor ring to allocate new receive buffers
+ *  @cleaned_count: count of buffers to allocate
  **/
 void igb_alloc_rx_buffers(struct igb_ring *rx_ring, u16 cleaned_count)
 {
@@ -8530,9 +8532,9 @@ void igb_alloc_rx_buffers(struct igb_ring *rx_ring, u16 cleaned_count)
 
 /**
  * igb_mii_ioctl -
- * @netdev:
- * @ifreq:
- * @cmd:
+ * @netdev: pointer to netdev struct
+ * @ifr: interface structure
+ * @cmd: ioctl command to execute
  **/
 static int igb_mii_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
@@ -8560,9 +8562,9 @@ static int igb_mii_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 
 /**
  * igb_ioctl -
- * @netdev:
- * @ifreq:
- * @cmd:
+ * @netdev: pointer to netdev struct
+ * @ifr: interface structure
+ * @cmd: ioctl command to execute
  **/
 static int igb_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 490368d3d03c..7cc5428c3b3d 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -957,8 +957,8 @@ void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector,
 
 /**
  * igb_ptp_get_ts_config - get hardware time stamping config
- * @netdev:
- * @ifreq:
+ * @netdev: netdev struct
+ * @ifr: interface struct
  *
  * Get the hwtstamp_config settings to return to the user. Rather than attempt
  * to deconstruct the settings from the registers, just return a shadow copy
@@ -1141,8 +1141,8 @@ static int igb_ptp_set_timestamp_mode(struct igb_adapter *adapter,
 
 /**
  * igb_ptp_set_ts_config - set hardware time stamping config
- * @netdev:
- * @ifreq:
+ * @netdev: netdev struct
+ * @ifr: interface struct
  *
  **/
 int igb_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr)
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 19269f5d52bc..ee9f8c1dca83 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -61,7 +61,7 @@ static const struct igbvf_info *igbvf_info_tbl[] = {
 
 /**
  * igbvf_desc_unused - calculate if we have unused descriptors
- * @rx_ring: address of receive ring structure
+ * @ring: address of receive ring structure
  **/
 static int igbvf_desc_unused(struct igbvf_ring *ring)
 {
@@ -74,6 +74,8 @@ static int igbvf_desc_unused(struct igbvf_ring *ring)
 /**
  * igbvf_receive_skb - helper function to handle Rx indications
  * @adapter: board private structure
+ * @netdev: pointer to netdev struct
+ * @skb: skb to indicate to stack
  * @status: descriptor status field as written by hardware
  * @vlan: descriptor vlan field as written by hardware (no le/be conversion)
  * @skb: pointer to sk_buff to be indicated to stack
@@ -233,6 +235,8 @@ static void igbvf_alloc_rx_buffers(struct igbvf_ring *rx_ring,
 /**
  * igbvf_clean_rx_irq - Send received data up the network stack; legacy
  * @adapter: board private structure
+ * @work_done: output parameter used to indicate completed work
+ * @work_to_do: input parameter setting limit of work
  *
  * the return value indicates whether actual cleaning was done, there
  * is no guarantee that everything was cleaned
@@ -406,6 +410,7 @@ static void igbvf_put_txbuf(struct igbvf_adapter *adapter,
 /**
  * igbvf_setup_tx_resources - allocate Tx resources (Descriptors)
  * @adapter: board private structure
+ * @tx_ring: ring being initialized
  *
  * Return 0 on success, negative on failure
  **/
@@ -444,6 +449,7 @@ int igbvf_setup_tx_resources(struct igbvf_adapter *adapter,
 /**
  * igbvf_setup_rx_resources - allocate Rx resources (Descriptors)
  * @adapter: board private structure
+ * @rx_ring: ring being initialized
  *
  * Returns 0 on success, negative on failure
  **/
@@ -540,7 +546,7 @@ void igbvf_free_tx_resources(struct igbvf_ring *tx_ring)
 
 /**
  * igbvf_clean_rx_ring - Free Rx Buffers per Queue
- * @adapter: board private structure
+ * @rx_ring: ring structure pointer to free buffers from
  **/
 static void igbvf_clean_rx_ring(struct igbvf_ring *rx_ring)
 {
@@ -760,7 +766,7 @@ static void igbvf_set_itr(struct igbvf_adapter *adapter)
 
 /**
  * igbvf_clean_tx_irq - Reclaim resources after transmit completes
- * @adapter: board private structure
+ * @tx_ring: ring structure to clean descriptors from
  *
  * returns true if ring is completely cleaned
  **/
@@ -1891,7 +1897,7 @@ static bool igbvf_has_link(struct igbvf_adapter *adapter)
 
 /**
  * igbvf_watchdog - Timer Call-back
- * @data: pointer to adapter cast into an unsigned long
+ * @t: timer list pointer containing private struct
  **/
 static void igbvf_watchdog(struct timer_list *t)
 {
@@ -2372,8 +2378,9 @@ static netdev_tx_t igbvf_xmit_frame(struct sk_buff *skb,
 /**
  * igbvf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue timing out (unused)
  **/
-static void igbvf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void igbvf_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index c6968fdb6caa..3183150c7995 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4653,7 +4653,7 @@ int igc_close(struct net_device *netdev)
 /**
  * igc_ioctl - Access the hwtstamp interface
  * @netdev: network interface device structure
- * @ifreq: interface request data
+ * @ifr: interface request data
  * @cmd: ioctl command
  **/
 static int igc_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 36c999250fcc..7aee56346656 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -420,7 +420,7 @@ static void igc_ptp_tx_work(struct work_struct *work)
 /**
  * igc_ptp_set_ts_config - set hardware time stamping config
  * @netdev: network interface device structure
- * @ifreq: interface request data
+ * @ifr: interface request data
  *
  **/
 int igc_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr)
@@ -447,7 +447,7 @@ int igc_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr)
 /**
  * igc_ptp_get_ts_config - get hardware time stamping config
  * @netdev: network interface device structure
- * @ifreq: interface request data
+ * @ifr: interface request data
  *
  * Get the hwtstamp_config settings to return to the user. Rather than attempt
  * to deconstruct the settings from the registers, just return a shadow copy
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 048351cf0e4a..1588376d4c67 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -1109,7 +1109,7 @@ ixgb_set_multi(struct net_device *netdev)
 
 /**
  * ixgb_watchdog - Timer Call-back
- * @data: pointer to netdev cast into an unsigned long
+ * @t: pointer to timer_list containing our private info pointer
  **/
 
 static void
@@ -1531,10 +1531,11 @@ ixgb_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 /**
  * ixgb_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue hanging (unused)
  **/
 
 static void
-ixgb_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+ixgb_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 
@@ -1746,7 +1747,8 @@ ixgb_intr(int irq, void *data)
 
 /**
  * ixgb_clean - NAPI Rx polling callback
- * @adapter: board private structure
+ * @napi: napi struct pointer
+ * @budget: max number of receives to clean
  **/
 
 static int
@@ -1865,7 +1867,7 @@ ixgb_clean_tx_irq(struct ixgb_adapter *adapter)
  * ixgb_rx_checksum - Receive Checksum Offload for 82597.
  * @adapter: board private structure
  * @rx_desc: receive descriptor
- * @sk_buff: socket buffer with received data
+ * @skb: socket buffer with received data
  **/
 
 static void
@@ -1923,6 +1925,8 @@ static void ixgb_check_copybreak(struct napi_struct *napi,
 /**
  * ixgb_clean_rx_irq - Send received data up the network stack,
  * @adapter: board private structure
+ * @work_done: output pointer to amount of packets cleaned
+ * @work_to_do: how much work we can complete
  **/
 
 static bool
@@ -2042,6 +2046,7 @@ ixgb_clean_rx_irq(struct ixgb_adapter *adapter, int *work_done, int work_to_do)
 /**
  * ixgb_alloc_rx_buffers - Replace used receive buffers
  * @adapter: address of board private structure
+ * @cleaned_count: how many buffers to allocate
  **/
 
 static void
@@ -2211,7 +2216,7 @@ static pci_ers_result_t ixgb_io_error_detected(struct pci_dev *pdev,
 
 /**
  * ixgb_io_slot_reset - called after the pci bus has been reset.
- * @pdev    pointer to pci device with error
+ * @pdev: pointer to pci device with error
  *
  * This callback is called after the PCI bus has been reset.
  * Basically, this tries to restart the card from scratch.
@@ -2259,7 +2264,7 @@ static pci_ers_result_t ixgb_io_slot_reset(struct pci_dev *pdev)
 
 /**
  * ixgb_io_resume - called when its OK to resume normal operations
- * @pdev    pointer to pci device with error
+ * @pdev: pointer to pci device with error
  *
  * The error recovery driver tells us that its OK to resume
  * normal operation. Implementation resembles the second-half
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0b675c34ce49..02899f79f0ff 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6175,8 +6175,9 @@ static void ixgbe_set_eee_capable(struct ixgbe_adapter *adapter)
 /**
  * ixgbe_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue number that timed out
  **/
-static void ixgbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void ixgbe_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index 7980d7265e10..f77fa3e4fdd1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -771,7 +771,7 @@ static s32 ixgbe_mii_bus_write_generic(struct ixgbe_hw *hw, int addr,
 
 /**
  *  ixgbe_mii_bus_read - Read a clause 22/45 register
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  **/
@@ -786,7 +786,7 @@ static s32 ixgbe_mii_bus_read(struct mii_bus *bus, int addr, int regnum)
 
 /**
  *  ixgbe_mii_bus_write - Write a clause 22/45 register
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  *  @val: value to write
@@ -803,7 +803,7 @@ static s32 ixgbe_mii_bus_write(struct mii_bus *bus, int addr, int regnum,
 
 /**
  *  ixgbe_x550em_a_mii_bus_read - Read a clause 22/45 register on x550em_a
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  **/
@@ -820,7 +820,7 @@ static s32 ixgbe_x550em_a_mii_bus_read(struct mii_bus *bus, int addr,
 
 /**
  *  ixgbe_x550em_a_mii_bus_write - Write a clause 22/45 register on x550em_a
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  *  @val: value to write
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 50afec43e001..ba54c728aef2 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -246,8 +246,9 @@ static void ixgbevf_tx_timeout_reset(struct ixgbevf_adapter *adapter)
 /**
  * ixgbevf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: transmit queue hanging (unused)
  **/
-static void ixgbevf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void ixgbevf_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 
-- 
2.28.0

