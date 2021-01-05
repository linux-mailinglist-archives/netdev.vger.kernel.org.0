Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622702EA57B
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 07:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbhAEGg7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Jan 2021 01:36:59 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2936 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbhAEGg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 01:36:59 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4D92mk023mz5DWZ;
        Tue,  5 Jan 2021 14:35:18 +0800 (CST)
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.164]) by
 DGGEMM404-HUB.china.huawei.com ([10.3.20.212]) with mapi id 14.03.0509.000;
 Tue, 5 Jan 2021 14:36:05 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        xudingke <xudingke@huawei.com>
Subject: RE: [PATCH net] macvlan: fix null pointer dereference in
 macvlan_changelink_sources()
Thread-Topic: [PATCH net] macvlan: fix null pointer dereference in
 macvlan_changelink_sources()
Thread-Index: AQHW3pfqleWSwPOZWEisddWzX/Y9naoXf7CAgAEcS9A=
Date:   Tue, 5 Jan 2021 06:36:04 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DBB3AEE@DGGEMM533-MBX.china.huawei.com>
References: <1609324695-1516-1-git-send-email-wangyunjian@huawei.com>
 <20210104133517.68198ccd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210104133517.68198ccd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.243.127]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski [mailto:kuba@kernel.org]
> Sent: Tuesday, January 5, 2021 5:35 AM
> To: wangyunjian <wangyunjian@huawei.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; Lilijun (Jerry)
> <jerry.lilijun@huawei.com>; xudingke <xudingke@huawei.com>
> Subject: Re: [PATCH net] macvlan: fix null pointer dereference in
> macvlan_changelink_sources()
> 
> On Wed, 30 Dec 2020 18:38:15 +0800 wangyunjian wrote:
> > From: Yunjian Wang <wangyunjian@huawei.com>
> >
> > Currently pointer data is dereferenced when declaring addr before
> > pointer data is null checked. This could lead to a null pointer
> > dereference. Fix this by checking if pointer data is null first.
> >
> > Fixes: 79cf79abce71 ("macvlan: add source mode")
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> 
> I don't see it. All calls to macvlan_changelink_sources() are under
> if (data) { ... } so data is never NULL. Looks like we should rather
> clean up macvlan_changelink_sources() to not check data for
> MACVLAN_MACADDR_SET.
> 
> WDYT?

OK, thanks for your suggestion, will include them in next version.

Yunjian
