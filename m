Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738592062C3
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393181AbgFWVHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:07:34 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:12411 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403815AbgFWUfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:35:09 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKZ6G5019554;
        Tue, 23 Jun 2020 13:35:07 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 11/12] cxgb4: update kernel-doc line comments
Date:   Wed, 24 Jun 2020 01:51:41 +0530
Message-Id: <7a47ab3a3241f727237413eb1972f2f0694d5536.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update several kernel-doc line comments to fix warnings reported by
make W=1.

Fixes following class of warnings reported by make W=1 in several
places:
l2t.c:616: warning: Cannot understand  * @dev: net_device pointer
t4_hw.c:3175: warning: Function parameter or member 'adap' not
described in 't4_get_exprom_version'
t4_hw.c:3175: warning: Excess function parameter 'adapter' description
in 't4_get_exprom_version'

Fixes: 56d36be4dd5f ("cxgb4: Add HW and FW support code")
Fixes: fd3a47900b6f ("cxgb4: Add packet queues and packet DMA code")
Fixes: 26f7cbc0a5a4 ("cxgb4: Don't attempt to upgrade T4 firmware when cxgb4 will end up as a slave")
Fixes: 793dad94e745 ("RDMA/cxgb4: Fix bug for active and passive LE hash collision path")
Fixes: ba3f8cd55f2a ("cxgb4: Add support in cxgb4 to get expansion rom version via ethtool")
Fixes: f7502659cec8 ("cxgb4: Add API to alloc l2t entry; also update existing ones")
Fixes: ddc7740d9a7c ("cxgb4: Decode link down reason code obtained from firmware")
Fixes: 193c4c2845f7 ("cxgb4: Update T6 Buffer Group and Channel Mappings")
Fixes: 8f46d46715a1 ("cxgb4: Use Firmware params to get buffer-group map")
Fixes: a456950445a0 ("cxgb4: time stamping interface for PTP")
Fixes: 9c33e4208bce ("cxgb4: Add PTP Hardware Clock (PHC) support")
Fixes: c3168cabe1af ("cxgb4/cxgbvf: Handle 32-bit fw port capabilities")
Fixes: 5ccf9d049615 ("cxgb4: update API for TP indirect register access")
Fixes: 3bdb376e6944 ("cxgb4: introduce SMT ops to prepare for SMAC rewrite support")
Fixes: 736c3b94474e ("cxgb4: collect egress and ingress SGE queue contexts")
Fixes: f56ec6766dcf ("cxgb4: Add support for ethtool i2c dump")
Fixes: 9d5fd927d20b ("cxgb4/cxgb4vf: add support for ndo_set_vf_vlan")
Fixes: 98f3697f8d41 ("cxgb4: add tc flower match support for tunnel VNI")
Fixes: 02d805dc5fe3 ("cxgb4: use new fw interface to get the VIN and smt index")
Fixes: 3f8cfd0d95e6 ("cxgb4/cxgb4vf: Program hash region for {t4/t4vf}_change_mac()")
Fixes: d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE doorbell queue timer")
Fixes: 0e395b3cb1fb ("cxgb4: add FLOWC based QoS offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  3 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_ptp.c    |  3 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c      |  1 +
 drivers/net/ethernet/chelsio/cxgb4/sched.c    |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 19 +++++-----
 drivers/net/ethernet/chelsio/cxgb4/smt.c      |  2 ++
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    | 36 +++++++++----------
 8 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 9fd496732b2c..f27be1132d37 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -588,7 +588,7 @@ static void fw_caps_to_lmm(enum fw_port_type port_type,
 /**
  *	lmm_to_fw_caps - translate ethtool Link Mode Mask to Firmware
  *	capabilities
- *	@et_lmm: ethtool Link Mode Mask
+ *	@link_mode_mask: ethtool Link Mode Mask
  *
  *	Translate ethtool Link Mode Mask into a Firmware Port capabilities
  *	value.
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 472e7c9e47bd..0329a6b52087 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -449,7 +449,7 @@ static int set_rxmode(struct net_device *dev, int mtu, bool sleep_ok)
  *		   or -1
  *	@addr: the new MAC address value
  *	@persist: whether a new MAC allocation should be persistent
- *	@add_smt: if true also add the address to the HW SMT
+ *	@smt_idx: the destination to store the new SMT index.
  *
  *	Modifies an MPS filter and sets it to the new MAC address if
  *	@tcam_idx >= 0, or adds the MAC address to a new filter if
@@ -1615,6 +1615,7 @@ static int tid_init(struct tid_info *t)
  *	@stid: the server TID
  *	@sip: local IP address to bind server to
  *	@sport: the server's TCP port
+ *	@vlan: the VLAN header information
  *	@queue: queue to direct messages from this server to
  *
  *	Create an IP server for the given port and address.
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index f5bc996ac77d..70dbee89118e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
@@ -194,6 +194,7 @@ int cxgb4_ptp_redirect_rx_packet(struct adapter *adapter, struct port_info *pi)
 }
 
 /**
+ * cxgb4_ptp_adjfreq - Adjust frequency of PHC cycle counter
  * @ptp: ptp clock structure
  * @ppb: Desired frequency change in parts per billion
  *
@@ -229,7 +230,7 @@ static int cxgb4_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 
 /**
  * cxgb4_ptp_fineadjtime - Shift the time of the hardware clock
- * @ptp: ptp clock structure
+ * @adapter: board private structure
  * @delta: Desired change in nanoseconds
  *
  * Adjust the timer by resetting the timecounter structure.
diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
index 0ed20a9cca14..c4864125fe02 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -609,6 +609,7 @@ struct l2t_entry *t4_l2t_alloc_switching(struct adapter *adap, u16 vlan,
 }
 
 /**
+ * cxgb4_l2t_alloc_switching - Allocates an L2T entry for switch filters
  * @dev: net_device pointer
  * @vlan: VLAN Id
  * @port: Associated port
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.c b/drivers/net/ethernet/chelsio/cxgb4/sched.c
index fde93c50cfec..a1b14468d1ff 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.c
@@ -598,7 +598,7 @@ struct sched_class *cxgb4_sched_class_alloc(struct net_device *dev,
 /**
  * cxgb4_sched_class_free - free a scheduling class
  * @dev: net_device pointer
- * @e: scheduling class
+ * @classid: scheduling class id to free
  *
  * Frees a scheduling class if there are no users.
  */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 72ff46b16704..32a45dc51ed7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -302,7 +302,7 @@ static void deferred_unmap_destructor(struct sk_buff *skb)
 
 /**
  *	free_tx_desc - reclaims Tx descriptors and their buffers
- *	@adapter: the adapter
+ *	@adap: the adapter
  *	@q: the Tx queue to reclaim descriptors from
  *	@n: the number of descriptors to reclaim
  *	@unmap: whether the buffers should be unmapped for DMA
@@ -722,6 +722,7 @@ static inline unsigned int flits_to_desc(unsigned int n)
 /**
  *	is_eth_imm - can an Ethernet packet be sent as immediate data?
  *	@skb: the packet
+ *	@chip_ver: chip version
  *
  *	Returns whether an Ethernet packet is small enough to fit as
  *	immediate data. Return value corresponds to headroom required.
@@ -749,6 +750,7 @@ static inline int is_eth_imm(const struct sk_buff *skb, unsigned int chip_ver)
 /**
  *	calc_tx_flits - calculate the number of flits for a packet Tx WR
  *	@skb: the packet
+ *	@chip_ver: chip version
  *
  *	Returns the number of flits needed for a Tx WR for the given Ethernet
  *	packet, including the needed WR and CPL headers.
@@ -804,6 +806,7 @@ static inline unsigned int calc_tx_flits(const struct sk_buff *skb,
 /**
  *	calc_tx_descs - calculate the number of Tx descriptors for a packet
  *	@skb: the packet
+ *	@chip_ver: chip version
  *
  *	Returns the number of Tx descriptors needed for the given Ethernet
  *	packet, including the needed WR and CPL headers.
@@ -2408,9 +2411,9 @@ static void eosw_txq_flush_pending_skbs(struct sge_eosw_txq *eosw_txq)
 
 /**
  * cxgb4_ethofld_send_flowc - Send ETHOFLD flowc request to bind eotid to tc.
- * @dev - netdevice
- * @eotid - ETHOFLD tid to bind/unbind
- * @tc - traffic class. If set to FW_SCHED_CLS_NONE, then unbinds the @eotid
+ * @dev: netdevice
+ * @eotid: ETHOFLD tid to bind/unbind
+ * @tc: traffic class. If set to FW_SCHED_CLS_NONE, then unbinds the @eotid
  *
  * Send a FLOWC work request to bind an ETHOFLD TID to a traffic class.
  * If @tc is set to FW_SCHED_CLS_NONE, then the @eotid is unbound from
@@ -2689,7 +2692,6 @@ static inline unsigned int calc_tx_flits_ofld(const struct sk_buff *skb)
 
 /**
  *	txq_stop_maperr - stop a Tx queue due to I/O MMU exhaustion
- *	@adap: the adapter
  *	@q: the queue to stop
  *
  *	Mark a Tx queue stopped due to I/O MMU exhaustion and resulting
@@ -3284,7 +3286,7 @@ enum {
 
 /**
  *     t4_systim_to_hwstamp - read hardware time stamp
- *     @adap: the adapter
+ *     @adapter: the adapter
  *     @skb: the packet
  *
  *     Read Time Stamp from MPS packet and insert in skb which
@@ -3318,8 +3320,9 @@ static noinline int t4_systim_to_hwstamp(struct adapter *adapter,
 
 /**
  *     t4_rx_hststamp - Recv PTP Event Message
- *     @adap: the adapter
+ *     @adapter: the adapter
  *     @rsp: the response queue descriptor holding the RX_PKT message
+ *     @rxq: the response queue holding the RX_PKT message
  *     @skb: the packet
  *
  *     PTP enabled and MPS packet, read HW timestamp
@@ -3343,7 +3346,7 @@ static int t4_rx_hststamp(struct adapter *adapter, const __be64 *rsp,
 
 /**
  *      t4_tx_hststamp - Loopback PTP Transmit Event Message
- *      @adap: the adapter
+ *      @adapter: the adapter
  *      @skb: the packet
  *      @dev: the ingress net device
  *
diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.c b/drivers/net/ethernet/chelsio/cxgb4/smt.c
index 01c65d13fc0e..cbe72ed27b1e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.c
@@ -103,6 +103,7 @@ static void t4_smte_free(struct smt_entry *e)
 }
 
 /**
+ * cxgb4_smt_release - Release SMT entry
  * @e: smt entry to release
  *
  * Releases ref count and frees up an smt entry from SMT table
@@ -231,6 +232,7 @@ static struct smt_entry *t4_smt_alloc_switching(struct adapter *adap, u16 pfvf,
 }
 
 /**
+ * cxgb4_smt_alloc_switching - Allocates an SMT entry for switch filters.
  * @dev: net_device pointer
  * @smac: MAC address to add to SMT
  * Returns pointer to the SMT entry created
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 1c8068c02728..1aa6dc10dc0b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3163,7 +3163,7 @@ int t4_get_tp_version(struct adapter *adapter, u32 *vers)
 
 /**
  *	t4_get_exprom_version - return the Expansion ROM version (if any)
- *	@adapter: the adapter
+ *	@adap: the adapter
  *	@vers: where to place the version
  *
  *	Reads the Expansion ROM header from FLASH and returns the version
@@ -5310,7 +5310,7 @@ static unsigned int t4_use_ldst(struct adapter *adap)
  * @cmd: TP fw ldst address space type
  * @vals: where the indirect register values are stored/written
  * @nregs: how many indirect registers to read/write
- * @start_idx: index of first indirect register to read/write
+ * @start_index: index of first indirect register to read/write
  * @rw: Read (1) or Write (0)
  * @sleep_ok: if true we may sleep while awaiting command completion
  *
@@ -6115,7 +6115,7 @@ void t4_pmrx_get_stats(struct adapter *adap, u32 cnt[], u64 cycles[])
 
 /**
  *	compute_mps_bg_map - compute the MPS Buffer Group Map for a Port
- *	@adap: the adapter
+ *	@adapter: the adapter
  *	@pidx: the port index
  *
  *	Computes and returns a bitmap indicating which MPS buffer groups are
@@ -6252,7 +6252,7 @@ static unsigned int t4_get_tp_e2c_map(struct adapter *adapter, int pidx)
 
 /**
  *	t4_get_tp_ch_map - return TP ingress channels associated with a port
- *	@adapter: the adapter
+ *	@adap: the adapter
  *	@pidx: the port index
  *
  *	Returns a bitmap indicating which TP Ingress Channels are associated
@@ -6589,7 +6589,7 @@ int t4_mdio_rd(struct adapter *adap, unsigned int mbox, unsigned int phy_addr,
  *	@phy_addr: the PHY address
  *	@mmd: the PHY MMD to access (0 for clause 22 PHYs)
  *	@reg: the register to write
- *	@valp: value to write
+ *	@val: value to write
  *
  *	Issues a FW command through the given mailbox to write a PHY register.
  */
@@ -6615,7 +6615,7 @@ int t4_mdio_wr(struct adapter *adap, unsigned int mbox, unsigned int phy_addr,
 
 /**
  *	t4_sge_decode_idma_state - decode the idma state
- *	@adap: the adapter
+ *	@adapter: the adapter
  *	@state: the state idma is stuck in
  */
 void t4_sge_decode_idma_state(struct adapter *adapter, int state)
@@ -6782,7 +6782,7 @@ void t4_sge_decode_idma_state(struct adapter *adapter, int state)
  *      t4_sge_ctxt_flush - flush the SGE context cache
  *      @adap: the adapter
  *      @mbox: mailbox to use for the FW command
- *      @ctx_type: Egress or Ingress
+ *      @ctxt_type: Egress or Ingress
  *
  *      Issues a FW command through the given mailbox to flush the
  *      SGE context cache.
@@ -6809,7 +6809,7 @@ int t4_sge_ctxt_flush(struct adapter *adap, unsigned int mbox, int ctxt_type)
 
 /**
  *	t4_read_sge_dbqtimers - read SGE Doorbell Queue Timer values
- *	@adap - the adapter
+ *	@adap: the adapter
  *	@ndbqtimers: size of the provided SGE Doorbell Queue Timer table
  *	@dbqtimers: SGE Doorbell Queue Timer table
  *
@@ -7092,6 +7092,7 @@ static int t4_fw_halt(struct adapter *adap, unsigned int mbox, int force)
 /**
  *	t4_fw_restart - restart the firmware by taking the uP out of RESET
  *	@adap: the adapter
+ *	@mbox: mailbox to use for the FW command
  *	@reset: if we want to do a RESET to restart things
  *
  *	Restart firmware previously halted by t4_fw_halt().  On successful
@@ -7630,6 +7631,8 @@ int t4_cfg_pfvf(struct adapter *adap, unsigned int mbox, unsigned int pf,
  *	@nmac: number of MAC addresses needed (1 to 5)
  *	@mac: the MAC addresses of the VI
  *	@rss_size: size of RSS table slice associated with this VI
+ *	@vivld: the destination to store the VI Valid value.
+ *	@vin: the destination to store the VIN value.
  *
  *	Allocates a virtual interface for the given physical port.  If @mac is
  *	not %NULL it contains the MAC addresses of the VI as assigned by FW.
@@ -7848,7 +7851,7 @@ int t4_free_raw_mac_filt(struct adapter *adap, unsigned int viid,
  *      t4_alloc_encap_mac_filt - Adds a mac entry in mps tcam with VNI support
  *      @adap: the adapter
  *      @viid: the VI id
- *      @mac: the MAC address
+ *      @addr: the MAC address
  *      @mask: the mask
  *      @vni: the VNI id for the tunnel protocol
  *      @vni_mask: mask for the VNI id
@@ -7897,11 +7900,11 @@ int t4_alloc_encap_mac_filt(struct adapter *adap, unsigned int viid,
  *	t4_alloc_raw_mac_filt - Adds a mac entry in mps tcam
  *	@adap: the adapter
  *	@viid: the VI id
- *	@mac: the MAC address
+ *	@addr: the MAC address
  *	@mask: the mask
  *	@idx: index at which to add this entry
- *	@port_id: the port index
  *	@lookup_type: MAC address for inner (1) or outer (0) header
+ *	@port_id: the port index
  *	@sleep_ok: call is allowed to sleep
  *
  *	Adds the mac entry at the specified index using raw mac interface.
@@ -8126,7 +8129,7 @@ int t4_free_mac_filt(struct adapter *adap, unsigned int mbox,
  *	@idx: index of existing filter for old value of MAC address, or -1
  *	@addr: the new MAC address value
  *	@persist: whether a new MAC allocation should be persistent
- *	@add_smt: if true also add the address to the HW SMT
+ *	@smt_idx: the destination to store the new SMT index.
  *
  *	Modifies an exact-match filter and sets it to the new MAC address.
  *	Note that in general it is not possible to modify the value of a given
@@ -8448,7 +8451,6 @@ int t4_ofld_eq_free(struct adapter *adap, unsigned int mbox, unsigned int pf,
 
 /**
  *	t4_link_down_rc_str - return a string for a Link Down Reason Code
- *	@adap: the adapter
  *	@link_down_rc: Link Down Reason Code
  *
  *	Returns a string representation of the Link Down Reason Code.
@@ -8472,9 +8474,7 @@ static const char *t4_link_down_rc_str(unsigned char link_down_rc)
 	return reason[link_down_rc];
 }
 
-/**
- * Return the highest speed set in the port capabilities, in Mb/s.
- */
+/* Return the highest speed set in the port capabilities, in Mb/s. */
 static unsigned int fwcap_to_speed(fw_port_cap32_t caps)
 {
 	#define TEST_SPEED_RETURN(__caps_speed, __speed) \
@@ -9110,7 +9110,6 @@ static int t4_get_flash_params(struct adapter *adap)
 /**
  *	t4_prep_adapter - prepare SW and HW for operation
  *	@adapter: the adapter
- *	@reset: if true perform a HW reset
  *
  *	Initialize adapter SW state for the various HW modules, set initial
  *	values for some adapter tunables, take PHYs out of reset, and
@@ -10395,6 +10394,7 @@ int t4_sched_params(struct adapter *adapter, u8 type, u8 level, u8 mode,
 /**
  *	t4_i2c_rd - read I2C data from adapter
  *	@adap: the adapter
+ *	@mbox: mailbox to use for the FW command
  *	@port: Port number if per-port device; <0 if not
  *	@devid: per-port device ID or absolute device ID
  *	@offset: byte offset into device I2C space
@@ -10450,7 +10450,7 @@ int t4_i2c_rd(struct adapter *adap, unsigned int mbox, int port,
 
 /**
  *      t4_set_vlan_acl - Set a VLAN id for the specified VF
- *      @adapter: the adapter
+ *      @adap: the adapter
  *      @mbox: mailbox to use for the FW command
  *      @vf: one of the VFs instantiated by the specified PF
  *      @vlan: The vlanid to be set
-- 
2.24.0

