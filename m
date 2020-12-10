Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7E42D69F8
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 22:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394077AbgLJVeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 16:34:07 -0500
Received: from smtprelay0113.hostedemail.com ([216.40.44.113]:57970 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405007AbgLJVeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 16:34:03 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 649B3182CED5B;
        Thu, 10 Dec 2020 21:33:10 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1606:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3355:3622:3866:3867:3870:4078:4081:4117:4321:5007:6117:6119:7903:10004:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12555:12712:12737:12740:12760:12895:13019:13161:13229:13439:14196:14659:21080:21433:21451:21627:21990:30045:30054:30055:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: flesh54_1015f55273fb
X-Filterd-Recvd-Size: 6022
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Thu, 10 Dec 2020 21:33:08 +0000 (UTC)
Message-ID: <f47638bfbf8ee77b9a188c83fbb6f346b1ac111c.camel@perches.com>
Subject: Re: [PATCH wireless -next] cw1200: txrx: convert comma to semicolon
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 10 Dec 2020 13:33:07 -0800
In-Reply-To: <20201210185002.10F2FC43464@smtp.codeaurora.org>
References: <20201209135550.2004-1-zhengyongjun3@huawei.com>
         <20201210185002.10F2FC43464@smtp.codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-10 at 18:50 +0000, Kalle Valo wrote:
> Zheng Yongjun <zhengyongjun3@huawei.com> wrote:
> 
> > Replace a comma between expression statements by a semicolon.
> > 
> > Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> Patch applied to wireless-drivers-next.git, thanks.
> 
> c42d492c672a cw1200: txrx: convert comma to semicolon
> 

There's are several of these in drivers/net/wireless:

Using a cocci script posted by Julia:
---
diff -u -p a/mediatek/mt76/mt7915/mcu.c b/mediatek/mt76/mt7915/mcu.c
--- a/mediatek/mt76/mt7915/mcu.c
+++ b/mediatek/mt76/mt7915/mcu.c
@@ -1148,7 +1148,7 @@ mt7915_mcu_sta_ba_tlv(struct sk_buff *sk
 	tlv = mt7915_mcu_add_tlv(skb, STA_REC_BA, sizeof(*ba));
 
 	ba = (struct sta_rec_ba *)tlv;
-	ba->ba_type = tx ? MT_BA_TYPE_ORIGINATOR : MT_BA_TYPE_RECIPIENT,
+	ba->ba_type = tx ? MT_BA_TYPE_ORIGINATOR : MT_BA_TYPE_RECIPIENT;
 	ba->winsize = cpu_to_le16(params->buf_size);
 	ba->ssn = cpu_to_le16(params->ssn);
 	ba->ba_en = enable << params->tid;
@@ -1676,7 +1676,7 @@ mt7915_mcu_wtbl_ht_tlv(struct sk_buff *s
 		tlv = mt7915_mcu_add_nested_tlv(skb, WTBL_VHT, sizeof(*vht),
 						wtbl_tlv, sta_wtbl);
 		vht = (struct wtbl_vht *)tlv;
-		vht->ldpc = sta->vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC,
+		vht->ldpc = sta->vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC;
 		vht->vht = true;
 
 		af = FIELD_GET(IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK,
@@ -2858,7 +2858,7 @@ int mt7915_mcu_init(struct mt7915_dev *d
 	};
 	int ret;
 
-	dev->mt76.mcu_ops = &mt7915_mcu_ops,
+	dev->mt76.mcu_ops = &mt7915_mcu_ops;
 
 	ret = mt7915_driver_own(dev);
 	if (ret)
diff -u -p a/mediatek/mt76/mt7615/usb_mcu.c b/mediatek/mt76/mt7615/usb_mcu.c
--- a/mediatek/mt76/mt7615/usb_mcu.c
+++ b/mediatek/mt76/mt7615/usb_mcu.c
@@ -61,7 +61,7 @@ int mt7663u_mcu_init(struct mt7615_dev *
 	};
 	int ret;
 
-	dev->mt76.mcu_ops = &mt7663u_mcu_ops,
+	dev->mt76.mcu_ops = &mt7663u_mcu_ops;
 
 	/* usb does not support runtime-pm */
 	clear_bit(MT76_STATE_PM, &dev->mphy.state);
diff -u -p a/mediatek/mt76/mt7615/mcu.c b/mediatek/mt76/mt7615/mcu.c
--- a/mediatek/mt76/mt7615/mcu.c
+++ b/mediatek/mt76/mt7615/mcu.c
@@ -982,7 +982,7 @@ mt7615_mcu_sta_ba_tlv(struct sk_buff *sk
 	tlv = mt7615_mcu_add_tlv(skb, STA_REC_BA, sizeof(*ba));
 
 	ba = (struct sta_rec_ba *)tlv;
-	ba->ba_type = tx ? MT_BA_TYPE_ORIGINATOR : MT_BA_TYPE_RECIPIENT,
+	ba->ba_type = tx ? MT_BA_TYPE_ORIGINATOR : MT_BA_TYPE_RECIPIENT;
 	ba->winsize = cpu_to_le16(params->buf_size);
 	ba->ssn = cpu_to_le16(params->ssn);
 	ba->ba_en = enable << params->tid;
@@ -2472,7 +2472,7 @@ int mt7615_mcu_init(struct mt7615_dev *d
 	};
 	int ret;
 
-	dev->mt76.mcu_ops = &mt7615_mcu_ops,
+	dev->mt76.mcu_ops = &mt7615_mcu_ops;
 
 	ret = mt7615_mcu_drv_pmctrl(dev);
 	if (ret)
diff -u -p a/mediatek/mt76/mt7615/sdio_mcu.c b/mediatek/mt76/mt7615/sdio_mcu.c
--- a/mediatek/mt76/mt7615/sdio_mcu.c
+++ b/mediatek/mt76/mt7615/sdio_mcu.c
@@ -139,7 +139,7 @@ int mt7663s_mcu_init(struct mt7615_dev *
 	if (ret)
 		return ret;
 
-	dev->mt76.mcu_ops = &mt7663s_mcu_ops,
+	dev->mt76.mcu_ops = &mt7663s_mcu_ops;
 
 	ret = mt76_get_field(dev, MT_CONN_ON_MISC, MT_TOP_MISC2_FW_N9_RDY);
 	if (ret) {
diff -u -p a/st/cw1200/txrx.c b/st/cw1200/txrx.c
--- a/st/cw1200/txrx.c
+++ b/st/cw1200/txrx.c
@@ -650,7 +650,7 @@ cw1200_tx_h_rate_policy(struct cw1200_co
 	wsm->flags |= t->txpriv.rate_id << 4;
 
 	t->rate = cw1200_get_tx_rate(priv,
-		&t->tx_info->control.rates[0]),
+		&t->tx_info->control.rates[0]);
 	wsm->max_tx_rate = t->rate->hw_value;
 	if (t->rate->flags & IEEE80211_TX_RC_MCS) {
 		if (cw1200_ht_greenfield(&priv->ht_info))
diff -u -p a/intersil/prism54/islpci_dev.c b/intersil/prism54/islpci_dev.c
--- a/intersil/prism54/islpci_dev.c
+++ b/intersil/prism54/islpci_dev.c
@@ -121,7 +121,7 @@ isl_upload_firmware(islpci_private *priv
 			while (_fw_len > 0) {
 				/* use non-swapping writel() */
 				__raw_writel(*fw_ptr, dev_fw_ptr);
-				fw_ptr++, dev_fw_ptr++;
+				fw_ptr++; dev_fw_ptr++;
 				_fw_len -= 4;
 			}
 
diff -u -p a/intel/iwlwifi/mvm/debugfs.c b/intel/iwlwifi/mvm/debugfs.c
--- a/intel/iwlwifi/mvm/debugfs.c
+++ b/intel/iwlwifi/mvm/debugfs.c
@@ -1949,7 +1949,7 @@ static ssize_t iwl_dbgfs_mem_write(struc
 		return -EFAULT;
 	}
 
-	hcmd.flags = CMD_WANT_SKB | CMD_SEND_IN_RFKILL,
+	hcmd.flags = CMD_WANT_SKB | CMD_SEND_IN_RFKILL;
 	hcmd.data[0] = (void *)cmd;
 	hcmd.len[0] = cmd_size;
 
diff -u -p a/ralink/rt2x00/rt2800lib.c b/ralink/rt2x00/rt2800lib.c
--- a/ralink/rt2x00/rt2800lib.c
+++ b/ralink/rt2x00/rt2800lib.c
@@ -3487,7 +3487,7 @@ static void rt2800_config_channel_rf55xx
 			rt2800_rfcsr_write(rt2x00dev, 52, 0x0C);
 			rt2800_rfcsr_write(rt2x00dev, 54, 0xF8);
 			if (rf->channel <= 50) {
-				rt2800_rfcsr_write(rt2x00dev, 55, 0x06),
+				rt2800_rfcsr_write(rt2x00dev, 55, 0x06);
 				rt2800_rfcsr_write(rt2x00dev, 56, 0xD3);
 			} else if (rf->channel >= 52) {
 				rt2800_rfcsr_write(rt2x00dev, 55, 0x04);



