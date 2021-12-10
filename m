Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF7746FD33
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhLJJEA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Dec 2021 04:04:00 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40835 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbhLJJD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:03:59 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BA904Lc8029046, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BA904Lc8029046
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Dec 2021 17:00:04 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 17:00:03 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 17:00:03 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Fri, 10 Dec 2021 17:00:03 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Jian-Hong Pan <jhp@endlessos.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Kai-Heng Feng (kai.heng.feng@canonical.com)" 
        <kai.heng.feng@canonical.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessos.org" <linux@endlessos.org>
Subject: RE: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
Thread-Topic: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
Thread-Index: AQHX7Z6qoa2juW6HuEaQNtYEJNeW8KwrYzIg
Date:   Fri, 10 Dec 2021 09:00:03 +0000
Message-ID: <6b0fcc8cf3bd4a77ad190dc6f72eb66f@realtek.com>
References: <20211210081659.4621-1-jhp@endlessos.org>
In-Reply-To: <20211210081659.4621-1-jhp@endlessos.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/12/10_=3F=3F_06:12:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Kai-Heng

> -----Original Message-----
> From: Jian-Hong Pan <jhp@endlessos.org>
> Sent: Friday, December 10, 2021 4:17 PM
> To: Pkshih <pkshih@realtek.com>; Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo
> <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux@endlessos.org; Jian-Hong Pan <jhp@endlessos.org>
> Subject: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
> 
> More and more laptops become frozen, due to the equipped RTL8821CE.
> 
> This patch follows the idea mentioned in commits 956c6d4f20c5 ("rtw88:
> add quirks to disable pci capabilities") and 1d4dcaf3db9bd ("rtw88: add
> quirk to disable pci caps on HP Pavilion 14-ce0xxx"), but disables its
> PCI ASPM capability of RTL8821CE directly, instead of checking DMI.
> 
> Buglink:https://bugzilla.kernel.org/show_bug.cgi?id=215239
> Fixes: 1d4dcaf3db9bd ("rtw88: add quirk to disable pci caps on HP Pavilion 14-ce0xxx")
> Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>

We also discuss similar thing in this thread: 
https://bugzilla.kernel.org/show_bug.cgi?id=215131

Since we still want to turn on ASPM to save more power, I would like to 
enumerate the blacklist. Does it work to you?
If so, please help to add one quirk entry of your platform.

Another thing is that "attachment 299735" is another workaround for certain
platform. And, we plan to add quirk to enable this workaround.
Could you try if it works to you?

Thank you
--
Ping-Ke

