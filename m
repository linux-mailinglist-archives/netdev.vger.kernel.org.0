Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFD824BE2
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 11:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfEUJnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 05:43:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34578 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfEUJnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 05:43:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4L9YG3x009437;
        Tue, 21 May 2019 09:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=uXxA+Lrz6O9ikN77iRAc+b8oa9fON8t2eTarboRRdEM=;
 b=dutO34mRU663iRN0xd6QXwL5xXmAg70xP1yshhxJj+NFGRrysHPE6KbAlV0iIspd+9Oq
 NQSzgdYSIT5JK7sRAboAH4M4CVuZoW7fqvZ3obBzW5UWm7U6tw2qxHzKmwaVSxX+6Ca+
 teuGMUG8oV5DfRan49i+vuMEglhCXusNg+NbZVPjuyOwi+2iWoNrlzzZSYl768ngafQc
 GQ2rtZcKb3IAcrUPF8smwTAp6sUv3KeQzPk0rby+RkqpnWgo00Qhdja088k5zse2N99y
 2oz90NjvGiGoJ4ih72BUxIxWSOMQwhdhUtiSQjhu/fINdMnIxppcYZOmef5XZoWx3Yiq /Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sj7jdmbrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 09:43:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4L9fUCD094085;
        Tue, 21 May 2019 09:43:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2sks1y3xcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 09:43:08 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4L9h3ZE022493;
        Tue, 21 May 2019 09:43:03 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 May 2019 09:43:02 +0000
Date:   Tue, 21 May 2019 12:42:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Karsten Keil <isdn@linux-pingi.de>, Joe Perches <joe@perches.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] mISDN: Fix indenting in dsp_cmx.c
Message-ID: <20190521094256.GA11899@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905210062
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We used a script to indent this code back in 2012, but I guess it got
confused by the ifdefs and added some extra tabs.  This patch removes
them.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/isdn/mISDN/dsp_cmx.c | 427 +++++++++++++++++------------------
 1 file changed, 213 insertions(+), 214 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index d4b6f01a3f0e..6d2088fbaf69 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1676,9 +1676,9 @@ dsp_cmx_send(void *arg)
 #ifdef CMX_CONF_DEBUG
 			if (conf->software && members > 1)
 #else
-				if (conf->software && members > 2)
+			if (conf->software && members > 2)
 #endif
-					mustmix = 1;
+				mustmix = 1;
 		}
 
 		/* transmission required */
@@ -1699,263 +1699,262 @@ dsp_cmx_send(void *arg)
 #ifdef CMX_CONF_DEBUG
 		if (conf->software && members > 1) {
 #else
-			if (conf->software && members > 2) {
+		if (conf->software && members > 2) {
 #endif
-				/* check for hdlc conf */
-				member = list_entry(conf->mlist.next,
-						    struct dsp_conf_member, list);
-				if (member->dsp->hdlc)
-					continue;
-				/* mix all data */
-				memset(mixbuffer, 0, length * sizeof(s32));
-				list_for_each_entry(member, &conf->mlist, list) {
-					dsp = member->dsp;
-					/* get range of data to mix */
-					c = mixbuffer;
-					q = dsp->rx_buff;
-					r = dsp->rx_R;
-					rr = (r + length) & CMX_BUFF_MASK;
-					/* add member's data */
-					while (r != rr) {
-						*c++ += dsp_audio_law_to_s32[q[r]];
-						r = (r + 1) & CMX_BUFF_MASK;
-					}
+			/* check for hdlc conf */
+			member = list_entry(conf->mlist.next,
+					    struct dsp_conf_member, list);
+			if (member->dsp->hdlc)
+				continue;
+			/* mix all data */
+			memset(mixbuffer, 0, length * sizeof(s32));
+			list_for_each_entry(member, &conf->mlist, list) {
+				dsp = member->dsp;
+				/* get range of data to mix */
+				c = mixbuffer;
+				q = dsp->rx_buff;
+				r = dsp->rx_R;
+				rr = (r + length) & CMX_BUFF_MASK;
+				/* add member's data */
+				while (r != rr) {
+					*c++ += dsp_audio_law_to_s32[q[r]];
+					r = (r + 1) & CMX_BUFF_MASK;
 				}
+			}
 
-				/* process each member */
-				list_for_each_entry(member, &conf->mlist, list) {
-					/* transmission */
-					dsp_cmx_send_member(member->dsp, length,
-							    mixbuffer, members);
-				}
+			/* process each member */
+			list_for_each_entry(member, &conf->mlist, list) {
+				/* transmission */
+				dsp_cmx_send_member(member->dsp, length,
+						    mixbuffer, members);
+			}
+		}
+	}
+
+	/* delete rx-data, increment buffers, change pointers */
+	list_for_each_entry(dsp, &dsp_ilist, list) {
+		if (dsp->hdlc)
+			continue;
+		p = dsp->rx_buff;
+		q = dsp->tx_buff;
+		r = dsp->rx_R;
+		/* move receive pointer when receiving */
+		if (!dsp->rx_is_off) {
+			rr = (r + length) & CMX_BUFF_MASK;
+			/* delete rx-data */
+			while (r != rr) {
+				p[r] = dsp_silence;
+				r = (r + 1) & CMX_BUFF_MASK;
 			}
+			/* increment rx-buffer pointer */
+			dsp->rx_R = r; /* write incremented read pointer */
 		}
 
-		/* delete rx-data, increment buffers, change pointers */
-		list_for_each_entry(dsp, &dsp_ilist, list) {
-			if (dsp->hdlc)
-				continue;
-			p = dsp->rx_buff;
-			q = dsp->tx_buff;
-			r = dsp->rx_R;
-			/* move receive pointer when receiving */
-			if (!dsp->rx_is_off) {
-				rr = (r + length) & CMX_BUFF_MASK;
+		/* check current rx_delay */
+		delay = (dsp->rx_W-dsp->rx_R) & CMX_BUFF_MASK;
+		if (delay >= CMX_BUFF_HALF)
+			delay = 0; /* will be the delay before next write */
+		/* check for lower delay */
+		if (delay < dsp->rx_delay[0])
+			dsp->rx_delay[0] = delay;
+		/* check current tx_delay */
+		delay = (dsp->tx_W-dsp->tx_R) & CMX_BUFF_MASK;
+		if (delay >= CMX_BUFF_HALF)
+			delay = 0; /* will be the delay before next write */
+		/* check for lower delay */
+		if (delay < dsp->tx_delay[0])
+			dsp->tx_delay[0] = delay;
+		if (jittercheck) {
+			/* find the lowest of all rx_delays */
+			delay = dsp->rx_delay[0];
+			i = 1;
+			while (i < MAX_SECONDS_JITTER_CHECK) {
+				if (delay > dsp->rx_delay[i])
+					delay = dsp->rx_delay[i];
+				i++;
+			}
+			/*
+			 * remove rx_delay only if we have delay AND we
+			 * have not preset cmx_delay AND
+			 * the delay is greater dsp_poll
+			 */
+			if (delay > dsp_poll && !dsp->cmx_delay) {
+				if (dsp_debug & DEBUG_DSP_CLOCK)
+					printk(KERN_DEBUG
+					       "%s lowest rx_delay of %d bytes for"
+					       " dsp %s are now removed.\n",
+					       __func__, delay,
+					       dsp->name);
+				r = dsp->rx_R;
+				rr = (r + delay - (dsp_poll >> 1))
+					& CMX_BUFF_MASK;
 				/* delete rx-data */
 				while (r != rr) {
 					p[r] = dsp_silence;
 					r = (r + 1) & CMX_BUFF_MASK;
 				}
 				/* increment rx-buffer pointer */
-				dsp->rx_R = r; /* write incremented read pointer */
+				dsp->rx_R = r;
+				/* write incremented read pointer */
 			}
-
-			/* check current rx_delay */
-			delay = (dsp->rx_W-dsp->rx_R) & CMX_BUFF_MASK;
-			if (delay >= CMX_BUFF_HALF)
-				delay = 0; /* will be the delay before next write */
-			/* check for lower delay */
-			if (delay < dsp->rx_delay[0])
-				dsp->rx_delay[0] = delay;
-			/* check current tx_delay */
-			delay = (dsp->tx_W-dsp->tx_R) & CMX_BUFF_MASK;
-			if (delay >= CMX_BUFF_HALF)
-				delay = 0; /* will be the delay before next write */
-			/* check for lower delay */
-			if (delay < dsp->tx_delay[0])
-				dsp->tx_delay[0] = delay;
-			if (jittercheck) {
-				/* find the lowest of all rx_delays */
-				delay = dsp->rx_delay[0];
-				i = 1;
-				while (i < MAX_SECONDS_JITTER_CHECK) {
-					if (delay > dsp->rx_delay[i])
-						delay = dsp->rx_delay[i];
-					i++;
-				}
-				/*
-				 * remove rx_delay only if we have delay AND we
-				 * have not preset cmx_delay AND
-				 * the delay is greater dsp_poll
-				 */
-				if (delay > dsp_poll && !dsp->cmx_delay) {
-					if (dsp_debug & DEBUG_DSP_CLOCK)
-						printk(KERN_DEBUG
-						       "%s lowest rx_delay of %d bytes for"
-						       " dsp %s are now removed.\n",
-						       __func__, delay,
-						       dsp->name);
-					r = dsp->rx_R;
-					rr = (r + delay - (dsp_poll >> 1))
-						& CMX_BUFF_MASK;
-					/* delete rx-data */
-					while (r != rr) {
-						p[r] = dsp_silence;
-						r = (r + 1) & CMX_BUFF_MASK;
-					}
-					/* increment rx-buffer pointer */
-					dsp->rx_R = r;
-					/* write incremented read pointer */
-				}
-				/* find the lowest of all tx_delays */
-				delay = dsp->tx_delay[0];
-				i = 1;
-				while (i < MAX_SECONDS_JITTER_CHECK) {
-					if (delay > dsp->tx_delay[i])
-						delay = dsp->tx_delay[i];
-					i++;
-				}
-				/*
-				 * remove delay only if we have delay AND we
-				 * have enabled tx_dejitter
-				 */
-				if (delay > dsp_poll && dsp->tx_dejitter) {
-					if (dsp_debug & DEBUG_DSP_CLOCK)
-						printk(KERN_DEBUG
-						       "%s lowest tx_delay of %d bytes for"
-						       " dsp %s are now removed.\n",
-						       __func__, delay,
-						       dsp->name);
-					r = dsp->tx_R;
-					rr = (r + delay - (dsp_poll >> 1))
-						& CMX_BUFF_MASK;
-					/* delete tx-data */
-					while (r != rr) {
-						q[r] = dsp_silence;
-						r = (r + 1) & CMX_BUFF_MASK;
-					}
-					/* increment rx-buffer pointer */
-					dsp->tx_R = r;
-					/* write incremented read pointer */
-				}
-				/* scroll up delays */
-				i = MAX_SECONDS_JITTER_CHECK - 1;
-				while (i) {
-					dsp->rx_delay[i] = dsp->rx_delay[i - 1];
-					dsp->tx_delay[i] = dsp->tx_delay[i - 1];
-					i--;
+			/* find the lowest of all tx_delays */
+			delay = dsp->tx_delay[0];
+			i = 1;
+			while (i < MAX_SECONDS_JITTER_CHECK) {
+				if (delay > dsp->tx_delay[i])
+					delay = dsp->tx_delay[i];
+				i++;
+			}
+			/*
+			 * remove delay only if we have delay AND we
+			 * have enabled tx_dejitter
+			 */
+			if (delay > dsp_poll && dsp->tx_dejitter) {
+				if (dsp_debug & DEBUG_DSP_CLOCK)
+					printk(KERN_DEBUG
+					       "%s lowest tx_delay of %d bytes for"
+					       " dsp %s are now removed.\n",
+					       __func__, delay,
+					       dsp->name);
+				r = dsp->tx_R;
+				rr = (r + delay - (dsp_poll >> 1))
+					& CMX_BUFF_MASK;
+				/* delete tx-data */
+				while (r != rr) {
+					q[r] = dsp_silence;
+					r = (r + 1) & CMX_BUFF_MASK;
 				}
-				dsp->tx_delay[0] = CMX_BUFF_HALF; /* (infinite) delay */
-				dsp->rx_delay[0] = CMX_BUFF_HALF; /* (infinite) delay */
+				/* increment rx-buffer pointer */
+				dsp->tx_R = r;
+				/* write incremented read pointer */
 			}
+			/* scroll up delays */
+			i = MAX_SECONDS_JITTER_CHECK - 1;
+			while (i) {
+				dsp->rx_delay[i] = dsp->rx_delay[i - 1];
+				dsp->tx_delay[i] = dsp->tx_delay[i - 1];
+				i--;
+			}
+			dsp->tx_delay[0] = CMX_BUFF_HALF; /* (infinite) delay */
+			dsp->rx_delay[0] = CMX_BUFF_HALF; /* (infinite) delay */
 		}
+	}
 
-		/* if next event would be in the past ... */
-		if ((s32)(dsp_spl_jiffies + dsp_tics-jiffies) <= 0)
-			dsp_spl_jiffies = jiffies + 1;
-		else
-			dsp_spl_jiffies += dsp_tics;
+	/* if next event would be in the past ... */
+	if ((s32)(dsp_spl_jiffies + dsp_tics-jiffies) <= 0)
+		dsp_spl_jiffies = jiffies + 1;
+	else
+		dsp_spl_jiffies += dsp_tics;
 
-		dsp_spl_tl.expires = dsp_spl_jiffies;
-		add_timer(&dsp_spl_tl);
+	dsp_spl_tl.expires = dsp_spl_jiffies;
+	add_timer(&dsp_spl_tl);
 
-		/* unlock */
-		spin_unlock_irqrestore(&dsp_lock, flags);
-	}
+	/* unlock */
+	spin_unlock_irqrestore(&dsp_lock, flags);
+}
 
 /*
  * audio data is transmitted from upper layer to the dsp
  */
-	void
-		dsp_cmx_transmit(struct dsp *dsp, struct sk_buff *skb)
-	{
-		u_int w, ww;
-		u8 *d, *p;
-		int space; /* todo: , l = skb->len; */
+void
+dsp_cmx_transmit(struct dsp *dsp, struct sk_buff *skb)
+{
+	u_int w, ww;
+	u8 *d, *p;
+	int space; /* todo: , l = skb->len; */
 #ifdef CMX_TX_DEBUG
-		char debugbuf[256] = "";
+	char debugbuf[256] = "";
 #endif
 
-		/* check if there is enough space, and then copy */
-		w = dsp->tx_W;
-		ww = dsp->tx_R;
-		p = dsp->tx_buff;
-		d = skb->data;
-		space = (ww - w - 1) & CMX_BUFF_MASK;
-		/* write-pointer should not overrun nor reach read pointer */
-		if (space < skb->len) {
-			/* write to the space we have left */
-			ww = (ww - 1) & CMX_BUFF_MASK; /* end one byte prior tx_R */
-			if (dsp_debug & DEBUG_DSP_CLOCK)
-				printk(KERN_DEBUG "%s: TX overflow space=%d skb->len="
-				       "%d, w=0x%04x, ww=0x%04x\n", __func__, space,
-				       skb->len, w, ww);
-		} else
-			/* write until all byte are copied */
-			ww = (w + skb->len) & CMX_BUFF_MASK;
-		dsp->tx_W = ww;
-
+	/* check if there is enough space, and then copy */
+	w = dsp->tx_W;
+	ww = dsp->tx_R;
+	p = dsp->tx_buff;
+	d = skb->data;
+	space = (ww - w - 1) & CMX_BUFF_MASK;
+	/* write-pointer should not overrun nor reach read pointer */
+	if (space < skb->len) {
+		/* write to the space we have left */
+		ww = (ww - 1) & CMX_BUFF_MASK; /* end one byte prior tx_R */
+		if (dsp_debug & DEBUG_DSP_CLOCK)
+			printk(KERN_DEBUG "%s: TX overflow space=%d skb->len="
+			       "%d, w=0x%04x, ww=0x%04x\n", __func__, space,
+			       skb->len, w, ww);
+	} else
+		/* write until all byte are copied */
+		ww = (w + skb->len) & CMX_BUFF_MASK;
+	dsp->tx_W = ww;
 		/* show current buffer */
 #ifdef CMX_DEBUG
-		printk(KERN_DEBUG
-		       "cmx_transmit(dsp=%lx) %d bytes to 0x%x-0x%x. %s\n",
-		       (u_long)dsp, (ww - w) & CMX_BUFF_MASK, w, ww, dsp->name);
+	printk(KERN_DEBUG
+	       "cmx_transmit(dsp=%lx) %d bytes to 0x%x-0x%x. %s\n",
+	       (u_long)dsp, (ww - w) & CMX_BUFF_MASK, w, ww, dsp->name);
 #endif
 
-		/* copy transmit data to tx-buffer */
+	/* copy transmit data to tx-buffer */
 #ifdef CMX_TX_DEBUG
-		sprintf(debugbuf, "TX getting (%04x-%04x)%p: ", w, ww, p);
+	sprintf(debugbuf, "TX getting (%04x-%04x)%p: ", w, ww, p);
 #endif
-		while (w != ww) {
+	while (w != ww) {
 #ifdef CMX_TX_DEBUG
-			if (strlen(debugbuf) < 48)
-				sprintf(debugbuf + strlen(debugbuf), " %02x", *d);
+		if (strlen(debugbuf) < 48)
+			sprintf(debugbuf + strlen(debugbuf), " %02x", *d);
 #endif
-			p[w] = *d++;
-			w = (w + 1) & CMX_BUFF_MASK;
-		}
+		p[w] = *d++;
+		w = (w + 1) & CMX_BUFF_MASK;
+	}
 #ifdef CMX_TX_DEBUG
-		printk(KERN_DEBUG "%s\n", debugbuf);
+	printk(KERN_DEBUG "%s\n", debugbuf);
 #endif
 
-	}
+}
 
 /*
  * hdlc data is received from card and sent to all members.
  */
-	void
-		dsp_cmx_hdlc(struct dsp *dsp, struct sk_buff *skb)
-	{
-		struct sk_buff *nskb = NULL;
-		struct dsp_conf_member *member;
-		struct mISDNhead *hh;
-
-		/* not if not active */
-		if (!dsp->b_active)
-			return;
+void
+dsp_cmx_hdlc(struct dsp *dsp, struct sk_buff *skb)
+{
+	struct sk_buff *nskb = NULL;
+	struct dsp_conf_member *member;
+	struct mISDNhead *hh;
 
-		/* check if we have sompen */
-		if (skb->len < 1)
-			return;
+	/* not if not active */
+	if (!dsp->b_active)
+		return;
 
-		/* no conf */
-		if (!dsp->conf) {
-			/* in case of software echo */
-			if (dsp->echo.software) {
-				nskb = skb_clone(skb, GFP_ATOMIC);
-				if (nskb) {
-					hh = mISDN_HEAD_P(nskb);
-					hh->prim = PH_DATA_REQ;
-					hh->id = 0;
-					skb_queue_tail(&dsp->sendq, nskb);
-					schedule_work(&dsp->workq);
-				}
+	/* check if we have sompen */
+	if (skb->len < 1)
+		return;
+
+	/* no conf */
+	if (!dsp->conf) {
+		/* in case of software echo */
+		if (dsp->echo.software) {
+			nskb = skb_clone(skb, GFP_ATOMIC);
+			if (nskb) {
+				hh = mISDN_HEAD_P(nskb);
+				hh->prim = PH_DATA_REQ;
+				hh->id = 0;
+				skb_queue_tail(&dsp->sendq, nskb);
+				schedule_work(&dsp->workq);
 			}
-			return;
 		}
-		/* in case of hardware conference */
-		if (dsp->conf->hardware)
-			return;
-		list_for_each_entry(member, &dsp->conf->mlist, list) {
-			if (dsp->echo.software || member->dsp != dsp) {
-				nskb = skb_clone(skb, GFP_ATOMIC);
-				if (nskb) {
-					hh = mISDN_HEAD_P(nskb);
-					hh->prim = PH_DATA_REQ;
-					hh->id = 0;
-					skb_queue_tail(&member->dsp->sendq, nskb);
-					schedule_work(&member->dsp->workq);
-				}
+		return;
+	}
+	/* in case of hardware conference */
+	if (dsp->conf->hardware)
+		return;
+	list_for_each_entry(member, &dsp->conf->mlist, list) {
+		if (dsp->echo.software || member->dsp != dsp) {
+			nskb = skb_clone(skb, GFP_ATOMIC);
+			if (nskb) {
+				hh = mISDN_HEAD_P(nskb);
+				hh->prim = PH_DATA_REQ;
+				hh->id = 0;
+				skb_queue_tail(&member->dsp->sendq, nskb);
+				schedule_work(&member->dsp->workq);
 			}
 		}
 	}
+}
-- 
2.20.1

