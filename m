Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4239F34E1BF
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhC3HHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:07:38 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3055 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhC3HHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:07:11 -0400
Received: from dggeml405-hub.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4F8gQs48C3zWRV2;
        Tue, 30 Mar 2021 15:03:49 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggeml405-hub.china.huawei.com (10.3.17.49) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 30 Mar 2021 15:07:07 +0800
Received: from [127.0.0.1] (10.69.26.252) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 30 Mar
 2021 15:07:06 +0800
Subject: Re: [PATCH net-next 0/4] net: remove repeated words
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>
References: <1617087846-14270-1-git-send-email-tanhuazhong@huawei.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <403d1cdf-56bb-7c79-4831-f40f65c7cd6c@huawei.com>
Date:   Tue, 30 Mar 2021 15:07:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1617087846-14270-1-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, please ignore this series, will resend later.


On 2021/3/30 15:04, Huazhong Tan wrote:
> This patch-set removes some repeated words in comments.
>
> Peng Li (4):
>    net: i40e: remove repeated words
>    net: bonding: remove repeated word
>    net: phy: remove repeated word
>    net: ipa: remove repeated words
>
>   drivers/net/bonding/bond_alb.c              | 2 +-
>   drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ++--
>   drivers/net/ipa/ipa_endpoint.c              | 4 ++--
>   drivers/net/phy/mdio_bus.c                  | 2 +-
>   4 files changed, 6 insertions(+), 6 deletions(-)
>

