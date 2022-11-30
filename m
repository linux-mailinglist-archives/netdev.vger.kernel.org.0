Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E448B63D0D0
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 09:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiK3IhD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Nov 2022 03:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbiK3Igr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 03:36:47 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 176E8206;
        Wed, 30 Nov 2022 00:36:43 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2AU8ZDNG0032302, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2AU8ZDNG0032302
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 30 Nov 2022 16:35:13 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 30 Nov 2022 16:35:58 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 30 Nov 2022 16:35:58 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 30 Nov 2022 16:35:58 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>,
        "Bernie Huang" <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        neo_jou <neo_jou@realtek.com>
Subject: RE: [PATCH v4 07/11] wifi: rtw88: Add common USB chip support
Thread-Topic: [PATCH v4 07/11] wifi: rtw88: Add common USB chip support
Thread-Index: AQHZA9rfU40VmmVRiUGte21yFx1HBa5WonIA///29oCAAIjmkA==
Date:   Wed, 30 Nov 2022 08:35:57 +0000
Message-ID: <2f65e44cf7d14a228f03eb0ba3b018d7@realtek.com>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
 <20221129100754.2753237-8-s.hauer@pengutronix.de>
 <4eee82341ef84d4aa063edeb6f23a70d@realtek.com>
 <20221130081323.GE29728@pengutronix.de>
In-Reply-To: <20221130081323.GE29728@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/30_=3F=3F_06:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Wednesday, November 30, 2022 4:13 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: linux-wireless@vger.kernel.org; Neo Jou <neojou@gmail.com>; Hans Ulli Kroll <linux@ulli-kroll.de>;
> Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum <alex@appudo.com>;
> Da Xue <da@libre.computer>; Bernie Huang <phhuang@realtek.com>; Viktor Petrenko <g0000ga@gmail.com>;
> neo_jou <neo_jou@realtek.com>
> Subject: Re: [PATCH v4 07/11] wifi: rtw88: Add common USB chip support
> 
> On Wed, Nov 30, 2022 at 01:40:36AM +0000, Ping-Ke Shih wrote:
> >
> >
> > > -----Original Message-----
> > > From: Sascha Hauer <s.hauer@pengutronix.de>
> > > Sent: Tuesday, November 29, 2022 6:08 PM
> > > To: linux-wireless@vger.kernel.org
> > > Cc: Neo Jou <neojou@gmail.com>; Hans Ulli Kroll <linux@ulli-kroll.de>; Ping-Ke Shih
> <pkshih@realtek.com>;
> > > Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; netdev@vger.kernel.org;
> > > linux-kernel@vger.kernel.org; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> > > kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum
> <alex@appudo.com>;
> > > Da Xue <da@libre.computer>; Bernie Huang <phhuang@realtek.com>; Viktor Petrenko <g0000ga@gmail.com>;
> > > Sascha Hauer <s.hauer@pengutronix.de>; neo_jou <neo_jou@realtek.com>
> > > Subject: [PATCH v4 07/11] wifi: rtw88: Add common USB chip support
> > >
> > > Add the common bits and pieces to add USB support to the RTW88 driver.
> > > This is based on https://github.com/ulli-kroll/rtw88-usb.git which
> > > itself is first written by Neo Jou.
> > >
> > > Signed-off-by: neo_jou <neo_jou@realtek.com>
> > > Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
> > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > ---
> >
> > > +static void rtw_usb_write_port_tx_complete(struct urb *urb)
> > > +{
> > > +	struct rtw_usb_txcb *txcb = urb->context;
> > > +	struct rtw_dev *rtwdev = txcb->rtwdev;
> > > +	struct ieee80211_hw *hw = rtwdev->hw;
> > > +	int max_iter = RTW_USB_MAX_XMITBUF_SZ;
> > > +
> > > +	while (true) {
> > > +		struct sk_buff *skb = skb_dequeue(&txcb->tx_ack_queue);
> > > +		struct ieee80211_tx_info *info;
> > > +		struct rtw_usb_tx_data *tx_data;
> > > +
> > > +		if (!skb)
> > > +			break;
> > > +
> > > +		if (!--max_iter) {
> >
> > Don't you need to free 'skb'? or you should not dequeue skb in this situation?
> 
> My first reaction here was to call skb_queue_purge(), but that is
> implemented as:
> 
> 	while ((skb = skb_dequeue(list)) != NULL)
> 		kfree_skb(skb);
> 
> So basically it brings us into the same endless loop we are trying to
> break out here.
> 
> If it was me I would just remove this check. *txcb is allocated once
> in rtw_usb_tx_agg_skb(), &txcb->tx_ack_queue is added the number of skbs
> that fit into RTW_USB_MAX_XMITBUF_SZ and here we dequeue these skbs
> again. No other code even has the pointer to add skbs to this queue
> concurrently.

Agree with you after I trace the flow again. The number of skb is limited
and all skb(s) belong to this urb must be freed in one go, or we don't
have another chance to free them. Therefore, I think we can use this
chunk of v3.

Ping-Ke

