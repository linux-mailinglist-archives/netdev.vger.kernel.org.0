Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407325C6AB
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 03:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfGBBgH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Jul 2019 21:36:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2961 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726688AbfGBBgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 21:36:07 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 689A3440031BAAE7975D;
        Tue,  2 Jul 2019 09:36:04 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 2 Jul 2019 09:36:03 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 2 Jul 2019 09:36:03 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1591.008;
 Tue, 2 Jul 2019 09:36:03 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     David Ahern <dsahern@gmail.com>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>
Subject: Re: Re: [PATCH v4] net: netfilter: Fix rpfilter dropping vrf packets
 by mistake
Thread-Topic: Re: [PATCH v4] net: netfilter: Fix rpfilter dropping vrf packets
 by mistake
Thread-Index: AdUwdbuw7kxy122jSLKo2Pj9ldiskw==
Date:   Tue, 2 Jul 2019 01:36:03 +0000
Message-ID: <d83d74962272446a9bac45291d03b068@huawei.com>
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


On Sat, July 2, 2019 at 02:02:59AM, Pablo wrote:
>
> Probably this?
>
>         } else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev) ||
>                    (flags & XT_RPFILTER_LOOSE) == 0) {
>                 fl6.flowi6_oif = dev->ifindex;
>         }
>
> Thanks.

I would send patch v5 according to this. Many Thanks.
Have a nice day.
Best wishes.
