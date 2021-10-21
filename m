Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB7D435847
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 03:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhJUBg6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 Oct 2021 21:36:58 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49759 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhJUBg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 21:36:58 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 19L1YQX70030853, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 19L1YQX70030853
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Oct 2021 09:34:27 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 21 Oct 2021 09:34:26 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 20 Oct 2021 18:34:25 -0700
Received: from RTEXMBS04.realtek.com.tw ([fe80::dc53:1026:298b:c584]) by
 RTEXMBS04.realtek.com.tw ([fe80::dc53:1026:298b:c584%5]) with mapi id
 15.01.2308.015; Thu, 21 Oct 2021 09:34:25 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "cgel.zte@gmail.com" <cgel.zte@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "lv.ruyi@zte.com.cn" <lv.ruyi@zte.com.cn>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>
Subject: RE: [PATCH] rtw89: fix error function parameter
Thread-Topic: [PATCH] rtw89: fix error function parameter
Thread-Index: AQHXxJzcl/L9Ey4To0qT1Twz/99G66vbD7qAgAAPjTCAAIsVYIABAw9g
Date:   Thu, 21 Oct 2021 01:34:25 +0000
Message-ID: <3e121f8f6dd4411eace22a7030824ce4@realtek.com>
References: <20211019035311.974706-1-lv.ruyi@zte.com.cn>
        <163471982441.1743.9901035714649893101.kvalo@codeaurora.org>
        <3aa076f0e39a485ca090f8c14682b694@realtek.com>
 <878ryof1xc.fsf@codeaurora.org>
In-Reply-To: <878ryof1xc.fsf@codeaurora.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/10/20_=3F=3F_11:54:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/21/2021 01:02:29
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 166865 [Oct 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 463 463 5854868460de3f0d8e8c0a4df98aeb05fb764a09
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;127.0.0.199:7.1.2;wireless.wiki.kernel.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/21/2021 01:05:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: kvalo=codeaurora.org@mg.codeaurora.org <kvalo=codeaurora.org@mg.codeaurora.org> On Behalf Of Kalle
> Valo
> Sent: Wednesday, October 20, 2021 6:04 PM
> To: Pkshih <pkshih@realtek.com>
> Cc: cgel.zte@gmail.com; davem@davemloft.net; kuba@kernel.org; lv.ruyi@zte.com.cn;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Zeal Robot
> <zealci@zte.com.cn>
> Subject: Re: [PATCH] rtw89: fix error function parameter
> 
> Pkshih <pkshih@realtek.com> writes:
> 
> >> -----Original Message-----
> >> From: kvalo=codeaurora.org@mg.codeaurora.org
> >> <kvalo=codeaurora.org@mg.codeaurora.org> On Behalf Of Kalle
> >> Valo
> >> Sent: Wednesday, October 20, 2021 4:50 PM
> >> To: cgel.zte@gmail.com
> >> Cc: davem@davemloft.net; kuba@kernel.org; Pkshih
> >> <pkshih@realtek.com>; lv.ruyi@zte.com.cn;
> >> linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> >> linux-kernel@vger.kernel.org; Zeal Robot
> >> <zealci@zte.com.cn>
> >> Subject: Re: [PATCH] rtw89: fix error function parameter
> >>
> >> cgel.zte@gmail.com wrote:
> >>
> >> > From: Lv Ruyi <lv.ruyi@zte.com.cn>
> >> >
> >> > This patch fixes the following Coccinelle warning:
> >> > drivers/net/wireless/realtek/rtw89/rtw8852a.c:753:
> >> > WARNING  possible condition with no effect (if == else)
> >> >
> >> > Reported-by: Zeal Robot <zealci@zte.com.cn>
> >> > Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> >> > Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> >>
> >> Failed to apply, please rebase on top of wireless-drivers-next.
> >>
> >> error: patch failed: drivers/net/wireless/realtek/rtw89/rtw8852a.c:753
> >> error: drivers/net/wireless/realtek/rtw89/rtw8852a.c: patch does not apply
> >> error: Did you hand edit your patch?
> >> It does not apply to blobs recorded in its index.
> >> hint: Use 'git am --show-current-patch' to see the failed patch
> >> Applying: rtw89: fix error function parameter
> >> Using index info to reconstruct a base tree...
> >> Patch failed at 0001 rtw89: fix error function parameter
> >>
> >> Patch set to Changes Requested.
> >>
> >
> > I think this is because the patch is translated into spaces instead of tabs,
> > in this and following statements.
> > "                if (is_2g)"
> 
> Ah, I did wonder why it failed as I didn't see any similar patches. We
> have an item about this in the wiki:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#format_issues
> 

I don't know why neither.

I check the mail header of this patch, the mailer is
"X-Mailer: git-send-email 2.25.1". It should work properly.

Lv Ruyi, could you help to check what happens?

--
Ping-Ke

