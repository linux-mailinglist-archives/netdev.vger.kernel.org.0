Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C5D6B45A
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 04:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfGQCLV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jul 2019 22:11:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2424 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbfGQCLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 22:11:21 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 78D2F484A41040BB8CD1;
        Wed, 17 Jul 2019 10:11:19 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 17 Jul 2019 10:11:19 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 17 Jul 2019 10:11:19 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1591.008;
 Wed, 17 Jul 2019 10:11:18 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "fw@strlen.de" <fw@strlen.de>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>
Subject: Re: [PATCH v5] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
Thread-Topic: [PATCH v5] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
Thread-Index: AdU8QlbhtubzmFNYThKSosUPU/VBFA==
Date:   Wed, 17 Jul 2019 02:11:18 +0000
Message-ID: <e2f6a02b54724c5bb04a4ba34100d2fd@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, Jul 17, 2019 at 19:17:36PM +0000, Pablo wrote:
> > On Tue, Jul 02, 2019 at 03:59:36AM +0000, Miaohe Lin wrote:
> > When firewalld is enabled with ipv4/ipv6 rpfilter, vrf
> > ipv4/ipv6 packets will be dropped. Vrf device will pass through 
> > netfilter hook twice. One with enslaved device and another one with l3 
> > master device. So in device may dismatch witch out device because out 
> > device is always enslaved device.So failed with the check of the 
> > rpfilter and drop the packets by mistake.
>
> Applied to nf.git, thanks.

Many thanks. It's really a longterm stuff. Thanks for your
patience. Have a nice day!

Best wishes.
