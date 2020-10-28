Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04F429DBD1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390854AbgJ2AN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50794 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390851AbgJ2ANy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXa32-003uH4-QY; Wed, 28 Oct 2020 02:14:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "Alexander A . Klimov" <grandmaster@al2klimov.de>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        dccp@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: dccp: Fix most of the kerneldoc warnings
Date:   Wed, 28 Oct 2020 02:14:12 +0100
Message-Id: <20201028011412.931250-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/dccp/ccids/ccid2.c:190: warning: Function parameter or member 'hc' not described in 'ccid2_update_used_window'
net/dccp/ccids/ccid2.c:190: warning: Function parameter or member 'new_wnd' not described in 'ccid2_update_used_window'
net/dccp/ccids/ccid2.c:360: warning: Function parameter or member 'sk' not described in 'ccid2_rtt_estimator'
net/dccp/ccids/ccid3.c:112: warning: Function parameter or member 'sk' not described in 'ccid3_hc_tx_update_x'
net/dccp/ccids/ccid3.c:159: warning: Function parameter or member 'hc' not described in 'ccid3_hc_tx_update_s'
net/dccp/ccids/ccid3.c:268: warning: Function parameter or member 'sk' not described in 'ccid3_hc_tx_send_packet'
net/dccp/ccids/ccid3.c:667: warning: Function parameter or member 'sk' not described in 'ccid3_first_li'
net/dccp/ccids/ccid3.c:85: warning: Function parameter or member 'hc' not described in 'ccid3_update_send_interval'
net/dccp/ccids/lib/loss_interval.c:85: warning: Function parameter or member 'lh' not described in 'tfrc_lh_update_i_mean'
net/dccp/ccids/lib/loss_interval.c:85: warning: Function parameter or member 'skb' not described in 'tfrc_lh_update_i_mean'
net/dccp/ccids/lib/packet_history.c:392: warning: Function parameter or member 'h' not described in 'tfrc_rx_hist_sample_rtt'
net/dccp/ccids/lib/packet_history.c:392: warning: Function parameter or member 'skb' not described in 'tfrc_rx_hist_sample_rtt'
net/dccp/feat.c:1003: warning: Function parameter or member 'dreq' not described in 'dccp_feat_server_ccid_dependencies'
net/dccp/feat.c:1040: warning: Function parameter or member 'array_len' not described in 'dccp_feat_prefer'
net/dccp/feat.c:1040: warning: Function parameter or member 'array' not described in 'dccp_feat_prefer'
net/dccp/feat.c:1040: warning: Function parameter or member 'preferred_value' not described in 'dccp_feat_prefer'
net/dccp/output.c:151: warning: Function parameter or member 'dp' not described in 'dccp_determine_ccmps'
net/dccp/output.c:242: warning: Function parameter or member 'sk' not described in 'dccp_xmit_packet'
net/dccp/output.c:305: warning: Function parameter or member 'sk' not described in 'dccp_flush_write_queue'
net/dccp/output.c:305: warning: Function parameter or member 'time_budget' not described in 'dccp_flush_write_queue'
net/dccp/output.c:378: warning: Function parameter or member 'sk' not described in 'dccp_retransmit_skb'
net/dccp/qpolicy.c:88: warning: Function parameter or member '' not described in 'dccp_qpolicy_operations'
net/dccp/qpolicy.c:88: warning: Function parameter or member '{' not described in 'dccp_qpolicy_operations'
net/dccp/qpolicy.c:88: warning: Function parameter or member 'params' not described in 'dccp_qpolicy_operations'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dccp/ackvec.c                   | 5 +++++
 net/dccp/ccids/ccid2.c              | 5 +++++
 net/dccp/ccids/ccid3.c              | 6 ++++++
 net/dccp/ccids/lib/loss_interval.c  | 3 +++
 net/dccp/ccids/lib/packet_history.c | 3 +++
 net/dccp/feat.c                     | 6 ++++++
 net/dccp/output.c                   | 9 +++++++++
 net/dccp/qpolicy.c                  | 6 ++++--
 8 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/net/dccp/ackvec.c b/net/dccp/ackvec.c
index 8f3dd3b1d2d0..c4bbac99740d 100644
--- a/net/dccp/ackvec.c
+++ b/net/dccp/ackvec.c
@@ -242,6 +242,8 @@ static void dccp_ackvec_add_new(struct dccp_ackvec *av, u32 num_packets,
 
 /**
  * dccp_ackvec_input  -  Register incoming packet in the buffer
+ * @av: Ack Vector to register packet to
+ * @skb: Packet to register
  */
 void dccp_ackvec_input(struct dccp_ackvec *av, struct sk_buff *skb)
 {
@@ -273,6 +275,9 @@ void dccp_ackvec_input(struct dccp_ackvec *av, struct sk_buff *skb)
 
 /**
  * dccp_ackvec_clear_state  -  Perform house-keeping / garbage-collection
+ * @av: Ack Vector record to clean
+ * @ackno: last Ack Vector which has been acknowledged
+ *
  * This routine is called when the peer acknowledges the receipt of Ack Vectors
  * up to and including @ackno. While based on section A.3 of RFC 4340, here
  * are additional precautions to prevent corrupted buffer state. In particular,
diff --git a/net/dccp/ccids/ccid2.c b/net/dccp/ccids/ccid2.c
index 3da1f77bd039..4d9823d6dced 100644
--- a/net/dccp/ccids/ccid2.c
+++ b/net/dccp/ccids/ccid2.c
@@ -181,6 +181,9 @@ MODULE_PARM_DESC(ccid2_do_cwv, "Perform RFC2861 Congestion Window Validation");
 
 /**
  * ccid2_update_used_window  -  Track how much of cwnd is actually used
+ * @hc: socket to update window
+ * @new_wnd: new window values to add into the filter
+ *
  * This is done in addition to CWV. The sender needs to have an idea of how many
  * packets may be in flight, to set the local Sequence Window value accordingly
  * (RFC 4340, 7.5.2). The CWV mechanism is exploited to keep track of the
@@ -349,6 +352,8 @@ static void ccid2_hc_tx_packet_sent(struct sock *sk, unsigned int len)
 
 /**
  * ccid2_rtt_estimator - Sample RTT and compute RTO using RFC2988 algorithm
+ * @sk: socket to perform estimator on
+ *
  * This code is almost identical with TCP's tcp_rtt_estimator(), since
  * - it has a higher sampling frequency (recommended by RFC 1323),
  * - the RTO does not collapse into RTT due to RTTVAR going towards zero,
diff --git a/net/dccp/ccids/ccid3.c b/net/dccp/ccids/ccid3.c
index b9ee1a4a8955..685067982e06 100644
--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -79,6 +79,8 @@ static inline u64 rfc3390_initial_rate(struct sock *sk)
 
 /**
  * ccid3_update_send_interval  -  Calculate new t_ipi = s / X_inst
+ * @hc: socket to be have the send interval updated
+ *
  * This respects the granularity of X_inst (64 * bytes/second).
  */
 static void ccid3_update_send_interval(struct ccid3_hc_tx_sock *hc)
@@ -99,6 +101,7 @@ static u32 ccid3_hc_tx_idle_rtt(struct ccid3_hc_tx_sock *hc, ktime_t now)
 
 /**
  * ccid3_hc_tx_update_x  -  Update allowed sending rate X
+ * @sk: socket to be updated
  * @stamp: most recent time if available - can be left NULL.
  *
  * This function tracks draft rfc3448bis, check there for latest details.
@@ -151,6 +154,7 @@ static void ccid3_hc_tx_update_x(struct sock *sk, ktime_t *stamp)
 
 /**
  *	ccid3_hc_tx_update_s - Track the mean packet size `s'
+ *	@hc: socket to be updated
  *	@len: DCCP packet payload size in bytes
  *
  *	cf. RFC 4342, 5.3 and  RFC 3448, 4.1
@@ -259,6 +263,7 @@ static void ccid3_hc_tx_no_feedback_timer(struct timer_list *t)
 
 /**
  * ccid3_hc_tx_send_packet  -  Delay-based dequeueing of TX packets
+ * @sk: socket to send packet from
  * @skb: next packet candidate to send on @sk
  *
  * This function uses the convention of ccid_packet_dequeue_eval() and
@@ -655,6 +660,7 @@ static int ccid3_hc_rx_insert_options(struct sock *sk, struct sk_buff *skb)
 
 /**
  * ccid3_first_li  -  Implements [RFC 5348, 6.3.1]
+ * @sk: socket to calculate loss interval for
  *
  * Determine the length of the first loss interval via inverse lookup.
  * Assume that X_recv can be computed by the throughput equation
diff --git a/net/dccp/ccids/lib/loss_interval.c b/net/dccp/ccids/lib/loss_interval.c
index 67abad695e66..da95319842bb 100644
--- a/net/dccp/ccids/lib/loss_interval.c
+++ b/net/dccp/ccids/lib/loss_interval.c
@@ -79,6 +79,9 @@ static void tfrc_lh_calc_i_mean(struct tfrc_loss_hist *lh)
 
 /**
  * tfrc_lh_update_i_mean  -  Update the `open' loss interval I_0
+ * @lh: histogram to update
+ * @skb: received socket triggering loss interval update
+ *
  * For recomputing p: returns `true' if p > p_prev  <=>  1/p < 1/p_prev
  */
 u8 tfrc_lh_update_i_mean(struct tfrc_loss_hist *lh, struct sk_buff *skb)
diff --git a/net/dccp/ccids/lib/packet_history.c b/net/dccp/ccids/lib/packet_history.c
index af08e2df7108..0cdda3c66fb5 100644
--- a/net/dccp/ccids/lib/packet_history.c
+++ b/net/dccp/ccids/lib/packet_history.c
@@ -385,6 +385,9 @@ static inline struct tfrc_rx_hist_entry *
 
 /**
  * tfrc_rx_hist_sample_rtt  -  Sample RTT from timestamp / CCVal
+ * @h: receive histogram
+ * @skb: packet containing timestamp.
+ *
  * Based on ideas presented in RFC 4342, 8.1. Returns 0 if it was not able
  * to compute a sample with given data - calling function should check this.
  */
diff --git a/net/dccp/feat.c b/net/dccp/feat.c
index 788dd629c420..a13917b103aa 100644
--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -996,6 +996,8 @@ int dccp_feat_finalise_settings(struct dccp_sock *dp)
 
 /**
  * dccp_feat_server_ccid_dependencies  -  Resolve CCID-dependent features
+ * @dreq: server socket to resolve
+ *
  * It is the server which resolves the dependencies once the CCID has been
  * fully negotiated. If no CCID has been negotiated, it uses the default CCID.
  */
@@ -1033,6 +1035,10 @@ static int dccp_feat_preflist_match(u8 *servlist, u8 slen, u8 *clilist, u8 clen)
 
 /**
  * dccp_feat_prefer  -  Move preferred entry to the start of array
+ * @preferred_value: Entry to move to start of array
+ * @array: Array of preferred entries
+ * @array_len: Size of he array
+ *
  * Reorder the @array_len elements in @array so that @preferred_value comes
  * first. Returns >0 to indicate that @preferred_value does occur in @array.
  */
diff --git a/net/dccp/output.c b/net/dccp/output.c
index 50e6d5699bb2..f2c8d6fe423b 100644
--- a/net/dccp/output.c
+++ b/net/dccp/output.c
@@ -143,6 +143,8 @@ static int dccp_transmit_skb(struct sock *sk, struct sk_buff *skb)
 
 /**
  * dccp_determine_ccmps  -  Find out about CCID-specific packet-size limits
+ * @dp: socket to find packet size limits of
+ *
  * We only consider the HC-sender CCID for setting the CCMPS (RFC 4340, 14.),
  * since the RX CCID is restricted to feedback packets (Acks), which are small
  * in comparison with the data traffic. A value of 0 means "no current CCMPS".
@@ -236,6 +238,8 @@ static int dccp_wait_for_ccid(struct sock *sk, unsigned long delay)
 
 /**
  * dccp_xmit_packet  -  Send data packet under control of CCID
+ * @sk: socket to send data packet on
+ *
  * Transmits next-queued payload and informs CCID to account for the packet.
  */
 static void dccp_xmit_packet(struct sock *sk)
@@ -296,6 +300,9 @@ static void dccp_xmit_packet(struct sock *sk)
 
 /**
  * dccp_flush_write_queue  -  Drain queue at end of connection
+ * @sk: Socket to be drained
+ * @time_budget: time allowed to drain the queue.
+ *
  * Since dccp_sendmsg queues packets without waiting for them to be sent, it may
  * happen that the TX queue is not empty at the end of a connection. We give the
  * HC-sender CCID a grace period of up to @time_budget jiffies. If this function
@@ -367,6 +374,8 @@ void dccp_write_xmit(struct sock *sk)
 
 /**
  * dccp_retransmit_skb  -  Retransmit Request, Close, or CloseReq packets
+ * @sk: Socket to perform retransmit on
+ *
  * There are only four retransmittable packet types in DCCP:
  * - Request  in client-REQUEST  state (sec. 8.1.1),
  * - CloseReq in server-CLOSEREQ state (sec. 8.3),
diff --git a/net/dccp/qpolicy.c b/net/dccp/qpolicy.c
index db2448c33a62..5ba204ec0aca 100644
--- a/net/dccp/qpolicy.c
+++ b/net/dccp/qpolicy.c
@@ -65,14 +65,16 @@ static bool qpolicy_prio_full(struct sock *sk)
  * @push: add a new @skb to the write queue
  * @full: indicates that no more packets will be admitted
  * @top:  peeks at whatever the queueing policy defines as its `top'
+ * @params: parameter passed to policy operation
  */
-static struct dccp_qpolicy_operations {
+struct dccp_qpolicy_operations {
 	void		(*push)	(struct sock *sk, struct sk_buff *skb);
 	bool		(*full) (struct sock *sk);
 	struct sk_buff*	(*top)  (struct sock *sk);
 	__be32		params;
+};
 
-} qpol_table[DCCPQ_POLICY_MAX] = {
+static struct dccp_qpolicy_operations qpol_table[DCCPQ_POLICY_MAX] = {
 	[DCCPQ_POLICY_SIMPLE] = {
 		.push   = qpolicy_simple_push,
 		.full   = qpolicy_simple_full,
-- 
2.28.0

