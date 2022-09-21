Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334565BF66D
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 08:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiIUGdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 02:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIUGdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 02:33:06 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB54792FA
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 23:33:05 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXT5P13QzzlWrG;
        Wed, 21 Sep 2022 14:28:57 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 14:33:04 +0800
Subject: Re: [RFCv8 PATCH net-next 02/55] net: replace general features
 macroes with global netdev_features variables
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
 <20220918094336.28958-3-shenjian15@huawei.com>
 <20220920131233.61a1b28c@kernel.org>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <35b4b477-14b0-1952-4515-c96933e6f6dd@huawei.com>
Date:   Wed, 21 Sep 2022 14:33:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220920131233.61a1b28c@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2022/9/21 4:12, Jakub Kicinski Ð´µÀ:
> On Sun, 18 Sep 2022 09:42:43 +0000 Jian Shen wrote:
>> -#define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
>> -				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
>> +#define NETIF_F_NEVER_CHANGE	netdev_never_change_features
> We shouldn't be changing all these defines here, because that breaks
> the build AFAIU.
ok, will keep them until remove the __NETIF_F(name) macro.


>   Can we not use the lowercase names going forward?
> .
ok
