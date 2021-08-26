Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF103F8148
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 05:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237332AbhHZDug convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Aug 2021 23:50:36 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:37515 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhHZDuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 23:50:35 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 17Q3mKQ61021020, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36501.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 17Q3mKQ61021020
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Aug 2021 11:48:20 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36501.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 26 Aug 2021 11:48:19 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 26 Aug 2021 11:48:18 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Thu, 26 Aug 2021 11:48:18 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Kees Cook <keescook@chromium.org>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        Kaixu Xia <kaixuxia@tencent.com>,
        Joe Perches <joe@perches.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH] rtlwifi: rtl8192de: Restore channel index initialization
Thread-Topic: [PATCH] rtlwifi: rtl8192de: Restore channel index initialization
Thread-Index: AQHXmd9h/5hSWDmaB0eK6ixaYO0v8quE8ftA//+aYgCAAJKPAA==
Date:   Thu, 26 Aug 2021 03:48:18 +0000
Message-ID: <0a292d54a2574fb486f905c1c8c94bcf@realtek.com>
References: <20210825183103.1142909-1-keescook@chromium.org>
 <0f63064fd9f4464a87d9358e874c6b84@realtek.com>
 <202108251935.1F1CBBD3@keescook>
In-Reply-To: <202108251935.1F1CBBD3@keescook>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/8/25_=3F=3F_11:16:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36501.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/26/2021 03:28:23
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165781 [Aug 25 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 457 457 f9912fc467375383fbac52a53ade5bbe1c769e2a
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: lore.kernel.org:7.1.1;realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/26/2021 03:30:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Kees Cook [mailto:keescook@chromium.org]
> Sent: Thursday, August 26, 2021 10:36 AM
> To: Pkshih
> Cc: Kalle Valo; David S. Miller; Jakub Kicinski; Larry Finger; Colin Ian King; Kaixu Xia; Joe Perches;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-hardening@vger.kernel.org
> Subject: Re: [PATCH] rtlwifi: rtl8192de: Restore channel index initialization
> 
> On Thu, Aug 26, 2021 at 12:45:53AM +0000, Pkshih wrote:
> >
> >
> > > -----Original Message-----
> > > From: Kees Cook [mailto:keescook@chromium.org]
> > > Sent: Thursday, August 26, 2021 2:31 AM
> > > To: Pkshih
> > > Cc: Kees Cook; Kalle Valo; David S. Miller; Jakub Kicinski; Larry Finger; Colin Ian King; Kaixu
> Xia;
> > > Joe Perches; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org;
> > > linux-hardening@vger.kernel.org
> > > Subject: [PATCH] rtlwifi: rtl8192de: Restore channel index initialization
> > >
> > > 2G channel indexes still need "place" to be initialized, since it is
> > > returned from this function when channel is less than 14.
> > >
> > > Fixes: 369956ae5720 ("rtlwifi: rtl8192de: Remove redundant variable initializations")
> >
> > Like the patch "rtlwifi: rtl8192de: Fix initialization of place in _rtl92c_phy_get_rightchnlplace()"
> > you sent before, please help to correct the removal of the commit 369956ae5720.
> > I think we can add following into this patch.
> >
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > @@ -1363,7 +1363,7 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
> >
> >  u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
> >  {
> > -       u8 place = chnl;
> > +       u8 place;
> >
> >         if (chnl > 14) {
> >                 for (place = 14; place < sizeof(channel_all); place++) {
> 
> Oh, er, it looks like Nathan found this before me, yes. I think
> https://lore.kernel.org/linux-wireless/20210823222014.764557-1-nathan@kernel.org/
> is the complete patch.
> 

Oops. Sorry, I misread the author who isn't you.


