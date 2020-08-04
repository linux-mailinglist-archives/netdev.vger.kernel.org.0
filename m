Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB95323B9CB
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 13:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgHDLna convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Aug 2020 07:43:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2602 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726086AbgHDLn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 07:43:29 -0400
Received: from dggeme704-chm.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 53A3C4D7CF9D23A0DFB2;
        Tue,  4 Aug 2020 19:43:25 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme704-chm.china.huawei.com (10.1.199.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 4 Aug 2020 19:43:24 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Tue, 4 Aug 2020 19:43:25 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     David Miller <davem@davemloft.net>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mac80211: use eth_zero_addr() to clear mac address
Thread-Topic: [PATCH] mac80211: use eth_zero_addr() to clear mac address
Thread-Index: AdZp/oZEl8jyk1WSTI2ToHiijIYl0A==
Date:   Tue, 4 Aug 2020 11:43:24 +0000
Message-ID: <0def73ad11944166a0a01391627cc02d@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.177.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> David Miller wrote:
>>From: linmiaohe <linmiaohe@huawei.com>
>>Date: Sat, 1 Aug 2020 17:12:38 +0800
>>
>> From: Miaohe Lin <linmiaohe@huawei.com>
>> 
>> Use eth_zero_addr() to clear mac address instead of memset().
>> 
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>
>If you're going to make this change, you should probably convert this macro to use eth_addr_copy() at the same time.

Many thanks for your reply. I think we should not convert this macro to use ether_addr_copy (). Because ether_addr_copy() required
@dst and @src must both be aligned to u16 and we may not always meet this condition.

Thanks again.

