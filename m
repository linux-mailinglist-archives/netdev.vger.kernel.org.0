Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B5E5BFBEF
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 12:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiIUKB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 06:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiIUKB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 06:01:26 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7B21DA63
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 03:01:19 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MXYlv5Wt6zHp1s;
        Wed, 21 Sep 2022 17:59:07 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 18:01:17 +0800
Subject: Re: [RFCv8 PATCH net-next 02/55] net: replace general features
 macroes with global netdev_features variables
From:   "shenjian (K)" <shenjian15@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
 <20220918094336.28958-3-shenjian15@huawei.com>
 <20220920131233.61a1b28c@kernel.org>
 <35b4b477-14b0-1952-4515-c96933e6f6dd@huawei.com>
Message-ID: <0f60d53a-bde7-d5c7-f589-99774485f545@huawei.com>
Date:   Wed, 21 Sep 2022 18:01:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <35b4b477-14b0-1952-4515-c96933e6f6dd@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/9/21 14:33, shenjian (K) 写道:
>
>
> 在 2022/9/21 4:12, Jakub Kicinski 写道:
>> On Sun, 18 Sep 2022 09:42:43 +0000 Jian Shen wrote:
>>> -#define NETIF_F_NEVER_CHANGE (NETIF_F_VLAN_CHALLENGED | \
>>> -                 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
>>> +#define NETIF_F_NEVER_CHANGE    netdev_never_change_features
>> We shouldn't be changing all these defines here, because that breaks
>> the build AFAIU.
> ok, will keep them until remove the __NETIF_F(name) macro.
>
But I don't see how it break build. Do you mean the definition of

WG_NETDEV_FEATURES in drivers/net/wireguard/device.c ？

>
>>   Can we not use the lowercase names going forward?
>> .
> ok
>
> .
>

