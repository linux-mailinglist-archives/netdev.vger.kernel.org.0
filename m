Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F389A68C4BA
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjBFR2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjBFR20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:28:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE66274AE;
        Mon,  6 Feb 2023 09:28:13 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316HHfZL031307;
        Mon, 6 Feb 2023 17:28:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Yi7tMCagomrraOAxNvv3rBt0QfJlgwXJYv7M2Dy/XvY=;
 b=fHYftA9gLSuu+eMVmLDlrpaocA6fiRzYw9b6tiTGdDmE8iwZ/U0Zkd0UztCt86XKLhMM
 vUuPsePClgaNzqFWhPOSgSCKYxbyabRTjtXol3Dr/KDblvwZAH9dUxIqhnZfeRK4kp9f
 cK7kYmV+WuRqGjYwHS1+F3ef2iK9IftoTMw0YOJ4YZfURd+tx5LlHa6JsltnfGhLFa9G
 1+5HfM8PsRUh2rSOYCtBjFediUHg5l6wCH0koqjBksJdKFZ79IwGu37MjwY6q/zsgDlI
 Bbn1C3jtUwF+JGcP7Ai3plxOjk+S3Wvg+F3eJl03ZgoGLUIZw2CoSurwMFw0ZL7KILV0 sQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk5tvg7yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 17:28:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3161E5mE002393;
        Mon, 6 Feb 2023 17:28:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06jn8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 17:28:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316HS4wE47514050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 17:28:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13F8520049;
        Mon,  6 Feb 2023 17:28:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E927F2004B;
        Mon,  6 Feb 2023 17:28:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  6 Feb 2023 17:28:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id A04ECE04E8; Mon,  6 Feb 2023 18:28:03 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 1/4] s390/ctcm: cleanup indenting
Date:   Mon,  6 Feb 2023 18:27:51 +0100
Message-Id: <20230206172754.980062-2-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230206172754.980062-1-wintera@linux.ibm.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nfmkqfp2BdyP9XLVOfqUYWqtkJN9w16l
X-Proofpoint-ORIG-GUID: nfmkqfp2BdyP9XLVOfqUYWqtkJN9w16l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060149
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of multiple smatch warnings, like:
warn: inconsistent indenting

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/ctcm_fsms.c | 32 ++++++++++++++++----------------
 drivers/s390/net/ctcm_main.c | 16 ++++++++--------
 drivers/s390/net/ctcm_mpc.c  | 15 ++++++++-------
 3 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index dfb84bb03d32..90ec477386a8 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -370,7 +370,7 @@ static void chx_rx(fsm_instance *fi, int event, void *arg)
 					CTCM_FUNTAIL, dev->name, len);
 		priv->stats.rx_dropped++;
 		priv->stats.rx_length_errors++;
-						goto again;
+		goto again;
 	}
 	if (len > ch->max_bufsize) {
 		CTCM_DBF_TEXT_(TRACE, CTC_DBF_NOTICE,
@@ -378,7 +378,7 @@ static void chx_rx(fsm_instance *fi, int event, void *arg)
 				CTCM_FUNTAIL, dev->name, len, ch->max_bufsize);
 		priv->stats.rx_dropped++;
 		priv->stats.rx_length_errors++;
-						goto again;
+		goto again;
 	}
 
 	/*
@@ -403,7 +403,7 @@ static void chx_rx(fsm_instance *fi, int event, void *arg)
 		*((__u16 *)skb->data) = len;
 		priv->stats.rx_dropped++;
 		priv->stats.rx_length_errors++;
-						goto again;
+		goto again;
 	}
 	if (block_len > 2) {
 		*((__u16 *)skb->data) = block_len - 2;
@@ -1006,7 +1006,7 @@ static void ctcm_chx_txretry(fsm_instance *fi, int event, void *arg)
 			use gptr as mpc indicator */
 		if (!(gptr && (fsm_getstate(gptr->fsm) != MPCG_STATE_READY)))
 			ctcm_chx_restart(fi, event, arg);
-				goto done;
+		goto done;
 	}
 
 	CTCM_DBF_TEXT_(TRACE, CTC_DBF_DEBUG,
@@ -1024,7 +1024,7 @@ static void ctcm_chx_txretry(fsm_instance *fi, int event, void *arg)
 						CTCM_FUNTAIL, ch->id);
 			fsm_event(priv->fsm, DEV_EVENT_TXDOWN, dev);
 			ctcm_chx_restart(fi, event, arg);
-				goto done;
+			goto done;
 		}
 		fsm_addtimer(&ch->timer, 1000, CTC_EVENT_TIMER, ch);
 		if (event == CTC_EVENT_TIMER) /* for TIMER not yet locked */
@@ -1251,12 +1251,12 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
 	if ((ch->collect_len <= 0) || (grp->in_sweep != 0)) {
 		spin_unlock(&ch->collect_lock);
 		fsm_newstate(fi, CTC_STATE_TXIDLE);
-				goto done;
+		goto done;
 	}
 
 	if (ctcm_checkalloc_buffer(ch)) {
 		spin_unlock(&ch->collect_lock);
-				goto done;
+		goto done;
 	}
 	ch->trans_skb->data = ch->trans_skb_data;
 	skb_reset_tail_pointer(ch->trans_skb);
@@ -1389,7 +1389,7 @@ static void ctcmpc_chx_rx(fsm_instance *fi, int event, void *arg)
 		CTCM_DBF_TEXT_(MPC_ERROR, CTC_DBF_ERROR,
 			"%s(%s): TRANS_SKB = NULL",
 				CTCM_FUNTAIL, dev->name);
-			goto again;
+		goto again;
 	}
 
 	if (len < TH_HEADER_LENGTH) {
@@ -1409,7 +1409,7 @@ static void ctcmpc_chx_rx(fsm_instance *fi, int event, void *arg)
 				"%s(%s): skb allocation failed",
 						CTCM_FUNTAIL, dev->name);
 			fsm_event(priv->mpcg->fsm, MPCG_EVENT_INOP, dev);
-					goto again;
+			goto again;
 		}
 		switch (fsm_getstate(grp->fsm)) {
 		case MPCG_STATE_RESET:
@@ -1441,9 +1441,9 @@ static void ctcmpc_chx_rx(fsm_instance *fi, int event, void *arg)
 		skb_reset_tail_pointer(ch->trans_skb);
 		ch->trans_skb->len = 0;
 		ch->ccw[1].count = ch->max_bufsize;
-			if (do_debug_ccw)
+		if (do_debug_ccw)
 			ctcmpc_dumpit((char *)&ch->ccw[0],
-					sizeof(struct ccw1) * 3);
+				      sizeof(struct ccw1) * 3);
 		dolock = !in_hardirq();
 		if (dolock)
 			spin_lock_irqsave(
@@ -1562,7 +1562,7 @@ void ctcmpc_chx_rxidle(fsm_instance *fi, int event, void *arg)
 		if (rc != 0) {
 			fsm_newstate(fi, CTC_STATE_RXINIT);
 			ctcm_ccw_check_rc(ch, rc, "initial RX");
-				goto done;
+			goto done;
 		}
 		break;
 	default:
@@ -1677,10 +1677,10 @@ static void ctcmpc_chx_attnbusy(fsm_instance *fsm, int event, void *arg)
 		if (fsm_getstate(ch->fsm) == CH_XID0_INPROGRESS) {
 			fsm_newstate(ch->fsm, CH_XID0_PENDING) ;
 			fsm_deltimer(&grp->timer);
-				goto done;
+			goto done;
 		}
 		fsm_event(grp->fsm, MPCG_EVENT_INOP, dev);
-				goto done;
+		goto done;
 	case MPCG_STATE_XID2INITX:
 		/* XID2 was received before ATTN Busy for second
 		   channel.Send yside xid for second channel.
@@ -1768,7 +1768,7 @@ static void ctcmpc_chx_send_sweep(fsm_instance *fsm, int event, void *arg)
 		/* give the previous IO time to complete */
 		fsm_addtimer(&wch->sweep_timer,
 			200, CTC_EVENT_RSWEEP_TIMER, wch);
-				goto done;
+		goto done;
 	}
 
 	skb = skb_dequeue(&wch->sweep_queue);
@@ -1780,7 +1780,7 @@ static void ctcmpc_chx_send_sweep(fsm_instance *fsm, int event, void *arg)
 		ctcm_clear_busy_do(dev);
 		dev_kfree_skb_any(skb);
 		fsm_event(grp->fsm, MPCG_EVENT_INOP, dev);
-				goto done;
+		goto done;
 	} else {
 		refcount_inc(&skb->users);
 		skb_queue_tail(&wch->io_queue, skb);
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index bdfab9ea0046..28db69d91f17 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -494,7 +494,7 @@ static int ctcm_transmit_skb(struct channel *ch, struct sk_buff *skb)
 			ch->collect_len += l;
 		}
 		spin_unlock_irqrestore(&ch->collect_lock, saveflags);
-				goto done;
+		goto done;
 	}
 	spin_unlock_irqrestore(&ch->collect_lock, saveflags);
 	/*
@@ -685,7 +685,7 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 		ch->collect_len += skb->len;
 
 		spin_unlock_irqrestore(&ch->collect_lock, saveflags);
-			goto done;
+		goto done;
 	}
 
 	/*
@@ -885,7 +885,7 @@ static netdev_tx_t ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 			"%s(%s): NULL sk_buff passed",
 					CTCM_FUNTAIL, dev->name);
 		priv->stats.tx_dropped++;
-					goto done;
+		goto done;
 	}
 	if (skb_headroom(skb) < (TH_HEADER_LENGTH + PDU_HEADER_LENGTH)) {
 		CTCM_DBF_TEXT_(MPC_TRACE, CTC_DBF_ERROR,
@@ -908,7 +908,7 @@ static netdev_tx_t ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 			priv->stats.tx_errors++;
 			priv->stats.tx_carrier_errors++;
 			fsm_event(grp->fsm, MPCG_EVENT_INOP, dev);
-					goto done;
+			goto done;
 		}
 		newskb->protocol = skb->protocol;
 		skb_reserve(newskb, TH_HEADER_LENGTH + PDU_HEADER_LENGTH);
@@ -931,7 +931,7 @@ static netdev_tx_t ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 		priv->stats.tx_dropped++;
 		priv->stats.tx_errors++;
 		priv->stats.tx_carrier_errors++;
-					goto done;
+		goto done;
 	}
 
 	if (ctcm_test_and_set_busy(dev)) {
@@ -943,7 +943,7 @@ static netdev_tx_t ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 		priv->stats.tx_errors++;
 		priv->stats.tx_carrier_errors++;
 		fsm_event(grp->fsm, MPCG_EVENT_INOP, dev);
-					goto done;
+		goto done;
 	}
 
 	netif_trans_update(dev);
@@ -957,7 +957,7 @@ static netdev_tx_t ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 		priv->stats.tx_carrier_errors++;
 		ctcm_clear_busy(dev);
 		fsm_event(grp->fsm, MPCG_EVENT_INOP, dev);
-					goto done;
+		goto done;
 	}
 	ctcm_clear_busy(dev);
 done:
@@ -1421,7 +1421,7 @@ static int add_channel(struct ccw_device *cdev, enum ctcm_channel_types type,
 				"%s (%s) already in list, using old entry",
 				__func__, (*c)->id);
 
-				goto free_return;
+		goto free_return;
 	}
 
 	spin_lock_init(&ch->collect_lock);
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 8ac213a55141..b8a226c6e1a9 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -481,7 +481,7 @@ void ctc_mpc_establish_connectivity(int port_num,
 				grp->estconnfunc = NULL;
 			}
 			fsm_deltimer(&grp->timer);
-				goto done;
+			goto done;
 		}
 		if ((wch->in_mpcgroup) &&
 				(fsm_getstate(wch->fsm) == CH_XID0_PENDING))
@@ -495,7 +495,7 @@ void ctc_mpc_establish_connectivity(int port_num,
 				grp->estconnfunc = NULL;
 			}
 			fsm_deltimer(&grp->timer);
-				goto done;
+			goto done;
 			}
 		break;
 	case MPCG_STATE_XID0IOWAIT:
@@ -896,8 +896,9 @@ void mpc_group_ready(unsigned long adev)
 		grp->estconnfunc(grp->port_num, 0,
 				    grp->group_max_buflen);
 		grp->estconnfunc = NULL;
-	} else 	if (grp->allochanfunc)
+	} else if (grp->allochanfunc) {
 		grp->allochanfunc(grp->port_num, grp->group_max_buflen);
+	}
 
 	grp->send_qllc_disc = 1;
 	grp->changed_side = 0;
@@ -1109,7 +1110,7 @@ static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 
 				priv->stats.rx_dropped++;
 				priv->stats.rx_length_errors++;
-					goto done;
+				goto done;
 			}
 			skb_reset_mac_header(pskb);
 			new_len = curr_pdu->pdu_offset;
@@ -1132,7 +1133,7 @@ static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 						CTCM_FUNTAIL, dev->name);
 				priv->stats.rx_dropped++;
 				fsm_event(grp->fsm, MPCG_EVENT_INOP, dev);
-						goto done;
+				goto done;
 			}
 			skb_put_data(skb, pskb->data, new_len);
 
@@ -1543,7 +1544,7 @@ static int mpc_validate_xid(struct mpcg_info *mpcginfo)
 		CTCM_DBF_TEXT_(MPC_ERROR, CTC_DBF_ERROR,
 			"%s(%s): xid = NULL",
 				CTCM_FUNTAIL, ch->id);
-			goto done;
+		goto done;
 	}
 
 	CTCM_D3_DUMP((char *)xid, XID2_LENGTH);
@@ -1556,7 +1557,7 @@ static int mpc_validate_xid(struct mpcg_info *mpcginfo)
 		CTCM_DBF_TEXT_(MPC_ERROR, CTC_DBF_ERROR,
 			"%s(%s): r/w channel pairing mismatch",
 				CTCM_FUNTAIL, ch->id);
-			goto done;
+		goto done;
 	}
 
 	if (xid->xid2_dlc_type == XID2_READ_SIDE) {
-- 
2.37.2

