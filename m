Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755E4396AC1
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 03:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhFAB4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 21:56:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2806 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhFAB4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 21:56:06 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvFTL4yXdzWp5B;
        Tue,  1 Jun 2021 09:49:42 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 09:54:22 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-sctp@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 net-next] sctp: sm_statefuns: Fix spelling mistakes
Date:   Tue, 1 Jun 2021 10:08:01 +0800
Message-ID: <20210601020801.3625358-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
genereate ==> generate
correclty ==> correctly
boundries ==> boundaries
failes ==> fails
isses ==> issues
assocition ==> association
signe ==> sign
assocaition ==> association
managemement ==> management
restransmissions ==> retransmission
sideffect ==> sideeffect
bomming ==> booming
chukns ==> chunks
SHUDOWN ==> SHUTDOWN
violationg ==> violating
explcitly ==> explicitly
CHunk ==> Chunk

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/sctp/sm_statefuns.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index fd1e319eda00..4f30388a0dd0 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -361,7 +361,7 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 
 	/* If the INIT is coming toward a closing socket, we'll send back
 	 * and ABORT.  Essentially, this catches the race of INIT being
-	 * backloged to the socket at the same time as the user isses close().
+	 * backloged to the socket at the same time as the user issues close().
 	 * Since the socket and all its associations are going away, we
 	 * can treat this OOTB
 	 */
@@ -608,8 +608,8 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct net *net,
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 			SCTP_STATE(SCTP_STATE_COOKIE_ECHOED));
 
-	/* SCTP-AUTH: genereate the assocition shared keys so that
-	 * we can potentially signe the COOKIE-ECHO.
+	/* SCTP-AUTH: generate the association shared keys so that
+	 * we can potentially sign the COOKIE-ECHO.
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_SHKEY, SCTP_NULL());
 
@@ -787,7 +787,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 		goto nomem_init;
 
 	/* SCTP-AUTH:  Now that we've populate required fields in
-	 * sctp_process_init, set up the assocaition shared keys as
+	 * sctp_process_init, set up the association shared keys as
 	 * necessary so that we can potentially authenticate the ACK
 	 */
 	error = sctp_auth_asoc_init_active_key(new_asoc, GFP_ATOMIC);
@@ -838,7 +838,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 
 	/* Add all the state machine commands now since we've created
 	 * everything.  This way we don't introduce memory corruptions
-	 * during side-effect processing and correclty count established
+	 * during side-effect processing and correctly count established
 	 * associations.
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
@@ -923,7 +923,7 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 						  commands);
 
 	/* Reset init error count upon receipt of COOKIE-ACK,
-	 * to avoid problems with the managemement of this
+	 * to avoid problems with the management of this
 	 * counter in stale cookie situations when a transition back
 	 * from the COOKIE-ECHOED state to the COOKIE-WAIT
 	 * state is performed.
@@ -2950,7 +2950,7 @@ enum sctp_disposition sctp_sf_do_9_2_reshutack(
 						  commands);
 
 	/* Since we are not going to really process this INIT, there
-	 * is no point in verifying chunk boundries.  Just generate
+	 * is no point in verifying chunk boundaries.  Just generate
 	 * the SHUTDOWN ACK.
 	 */
 	reply = sctp_make_shutdown_ack(asoc, chunk);
@@ -3560,7 +3560,7 @@ enum sctp_disposition sctp_sf_do_9_2_final(struct net *net,
 		goto nomem_chunk;
 
 	/* Do all the commands now (after allocation), so that we
-	 * have consistent state if memory allocation failes
+	 * have consistent state if memory allocation fails
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
 
@@ -3747,7 +3747,7 @@ static enum sctp_disposition sctp_sf_shut_8_4_5(
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	/* We need to discard the rest of the packet to prevent
-	 * potential bomming attacks from additional bundled chunks.
+	 * potential boomming attacks from additional bundled chunks.
 	 * This is documented in SCTP Threats ID.
 	 */
 	return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -4257,7 +4257,7 @@ enum sctp_disposition sctp_sf_eat_fwd_tsn_fast(
 }
 
 /*
- * SCTP-AUTH Section 6.3 Receiving authenticated chukns
+ * SCTP-AUTH Section 6.3 Receiving authenticated chunks
  *
  *    The receiver MUST use the HMAC algorithm indicated in the HMAC
  *    Identifier field.  If this algorithm was not specified by the
@@ -4812,7 +4812,7 @@ static enum sctp_disposition sctp_sf_violation_ctsn(
 
 /* Handle protocol violation of an invalid chunk bundling.  For example,
  * when we have an association and we receive bundled INIT-ACK, or
- * SHUDOWN-COMPLETE, our peer is clearly violationg the "MUST NOT bundle"
+ * SHUTDOWN-COMPLETE, our peer is clearly violating the "MUST NOT bundle"
  * statement from the specs.  Additionally, there might be an attacker
  * on the path and we may not want to continue this communication.
  */
@@ -5208,7 +5208,7 @@ enum sctp_disposition sctp_sf_cookie_wait_prm_shutdown(
  * Inputs
  * (endpoint, asoc)
  *
- * The RFC does not explcitly address this issue, but is the route through the
+ * The RFC does not explicitly address this issue, but is the route through the
  * state table when someone issues a shutdown while in COOKIE_ECHOED state.
  *
  * Outputs
@@ -5932,7 +5932,7 @@ enum sctp_disposition sctp_sf_t1_cookie_timer_expire(
 /* RFC2960 9.2 If the timer expires, the endpoint must re-send the SHUTDOWN
  * with the updated last sequential TSN received from its peer.
  *
- * An endpoint should limit the number of retransmissions of the
+ * An endpoint should limit the number of retransmission of the
  * SHUTDOWN chunk to the protocol parameter 'Association.Max.Retrans'.
  * If this threshold is exceeded the endpoint should destroy the TCB and
  * MUST report the peer endpoint unreachable to the upper layer (and
@@ -6010,7 +6010,7 @@ enum sctp_disposition sctp_sf_t2_timer_expire(
 }
 
 /*
- * ADDIP Section 4.1 ASCONF CHunk Procedures
+ * ADDIP Section 4.1 ASCONF Chunk Procedures
  * If the T4 RTO timer expires the endpoint should do B1 to B5
  */
 enum sctp_disposition sctp_sf_t4_timer_expire(
@@ -6441,7 +6441,7 @@ static int sctp_eat_data(const struct sctp_association *asoc,
 		chunk->ecn_ce_done = 1;
 
 		if (af->is_ce(sctp_gso_headskb(chunk->skb))) {
-			/* Do real work as sideffect. */
+			/* Do real work as side effect. */
 			sctp_add_cmd_sf(commands, SCTP_CMD_ECN_CE,
 					SCTP_U32(tsn));
 		}
-- 
2.25.1

