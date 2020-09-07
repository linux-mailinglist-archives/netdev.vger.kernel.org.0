Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1076A25F182
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 03:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgIGBiC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 6 Sep 2020 21:38:02 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3089 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726620AbgIGBiC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 21:38:02 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 665F9A55ABC537D36746;
        Mon,  7 Sep 2020 09:38:00 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 7 Sep 2020 09:38:00 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Mon, 7 Sep 2020 09:37:59 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "willemb@google.com" <willemb@google.com>,
        "mstarovoitov@marvell.com" <mstarovoitov@marvell.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Fix some comments
Thread-Topic: [PATCH] net: Fix some comments
Thread-Index: AdaEt4HHdoN5qEbocEahlzYIVnjrgw==
Date:   Mon, 7 Sep 2020 01:37:59 +0000
Message-ID: <e474644c67d245e18f2c64efecbd9c42@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.74]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
>On Sat, 5 Sep 2020 05:14:48 -0400 Miaohe Lin wrote:
>> Since commit 8d7017fd621d ("blackhole_netdev: use blackhole_netdev to 
>> invalidate dst entries"), we use blackhole_netdev to invalidate dst 
>> entries instead of loopback device anymore. Also fix broken NETIF_F_HW_CSUM spell.
>> 
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>
>Well spotted, but these two changes are in no way related, could you please send two separate patches?

Will do. Thanks. :)

