Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CAD241AAC
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 13:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgHKLyb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Aug 2020 07:54:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3052 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728663AbgHKLyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 07:54:31 -0400
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id ED2C23C5DDC4E34D64B4;
        Tue, 11 Aug 2020 19:54:28 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme752-chm.china.huawei.com (10.3.19.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 11 Aug 2020 19:54:28 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Tue, 11 Aug 2020 19:54:28 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pshelar@ovn.org" <pshelar@ovn.org>,
        "martin.varghese@nokia.com" <martin.varghese@nokia.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shmulik@metanetworks.com" <shmulik@metanetworks.com>,
        "kyk.segfault@gmail.com" <kyk.segfault@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: eliminate meaningless memcpy to data in
 pskb_carve_inside_nonlinear()
Thread-Topic: [PATCH] net: eliminate meaningless memcpy to data in
 pskb_carve_inside_nonlinear()
Thread-Index: AdZv1br+L6bqa4jMT5W4+rGy9yynuw==
Date:   Tue, 11 Aug 2020 11:54:28 +0000
Message-ID: <4916edcf633b4f3290d8fde26167805c@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.252]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
>Miaohe Lin <linmiaohe@huawei.com> wrote:
>> The skb_shared_info part of the data is assigned in the following loop.
>
>Where?
>

It's at the below for (i = 0; i < nfrags; i++) loop. But I missed something as Eric Dumazet pointed out.
Sorry about it.

