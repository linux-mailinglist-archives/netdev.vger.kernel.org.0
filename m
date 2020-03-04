Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D9F1789ED
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 06:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgCDFRP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Mar 2020 00:17:15 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:43985 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgCDFRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 00:17:15 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 0245GcJ7015193, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTEXMB06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 0245GcJ7015193
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 4 Mar 2020 13:16:38 +0800
Received: from RTEXMB03.realtek.com.tw (172.21.6.96) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 13:16:38 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 13:16:37 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Wed, 4 Mar 2020 13:16:37 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
CC:     "Mancini, Jason" <Jason.Mancini@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: v5.5-rc1 and beyond insta-kills some Comcast wifi routers
Thread-Topic: v5.5-rc1 and beyond insta-kills some Comcast wifi routers
Thread-Index: AQHV8eKYmDBcKgCqq0WSUKvXILk0y6g34qhg
Date:   Wed, 4 Mar 2020 05:16:37 +0000
Message-ID: <4bd036de86c94545af3e5d92f0920ac2@realtek.com>
References: <DM6PR12MB4331FD3C4EF86E6AF2B3EBC7E5E50@DM6PR12MB4331.namprd12.prod.outlook.com>
        <4e2a1fc1-4c14-733d-74e2-750ef1f81bf6@infradead.org>
 <87h7z4r9p5.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87h7z4r9p5.fsf@kamboji.qca.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:
> 
> Randy Dunlap <rdunlap@infradead.org> writes:
> 
> > [add netdev mailing list + 2 patch signers]
> 
> Adding also linux-wireless. It's always best to send questions about any
> wireless issues to linux-wireless
> 
> > On 3/3/20 7:34 PM, Mancini, Jason wrote:
> >> [I can't seem to access the linux-net ml per kernel.org faq, apology
> >> in advance.]
> >>
> >> This change, which I think first appeared for v5.5-rc1, basically
> >> within seconds, knocks out our [apparently buggy] Comcast wifi for
> >> about 2-3 minutes.  Is there a boot option (or similar) where I can
> >> achieve prior kernel behavior?  Otherwise I am stuck on kernel 5.4
> >> (or Win10) it seems, or forever compiling custom kernels for my
> >> choice of distribution [as I don't have physical access to the router
> >> in question.]
> >> Thanks!
> >> Jason
> >>
> >> ================
> >>
> >> 127eef1d46f80056fe9f18406c6eab38778d8a06 is the first bad commit
> >> commit 127eef1d46f80056fe9f18406c6eab38778d8a06
> >> Author: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >> Date:   Wed Oct 2 14:35:23 2019 +0800
> 
> Can you try if this fixes it:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.gi
> t/commit/?id=74c3d72cc13401f9eb3e3c712855e9f8f2d2682b
> 

Kalle is providing the right possible patch to fix it.

The first bad commit you found, that causes this issue, introduced TX-AMSDU.
But we found that enabling TX-AMSDU on 2.4G band is not working while
connecting to some APs. So, you can try if the patch provided by Kalle works.
(I hope so). Otherwise, you can enable the kernel log debug mask by:
echo 0xffffffff > /sys/module/rtw88/parameters/debug_mask.
And collect the log to see if there's anything wrong.

Yen-Hsuan
