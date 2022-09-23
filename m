Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7264D5E71FA
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbiIWCjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiIWCjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:39:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604681117E;
        Thu, 22 Sep 2022 19:39:36 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MYbq12gs9zlXRN;
        Fri, 23 Sep 2022 10:35:25 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 10:39:34 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 23 Sep
 2022 10:39:34 +0800
Subject: Re: [PATCH net-next 2/2] net: hns3: PF add support setting parameters
 of congestion control algorithm by devlink param
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@mellanox.com>, <moshe@mellanox.com>, <davem@davemloft.net>,
        <idosch@nvidia.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao418@huawei.com>
References: <20220923013818.51003-1-huangguangbin2@huawei.com>
 <20220923013818.51003-3-huangguangbin2@huawei.com>
 <20220922192313.628470a6@kernel.org>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <5f77197f-a3ea-7ab5-2dc7-577d0ec7b8f7@huawei.com>
Date:   Fri, 23 Sep 2022 10:39:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20220922192313.628470a6@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/23 10:23, Jakub Kicinski wrote:
> On Fri, 23 Sep 2022 09:38:18 +0800 Guangbin Huang wrote:
>> Some new devices support dynamiclly configuring parameters of congestion
>> control algorithm, this patch implement it by devlink param.
>>
>> Examples of read and set command are as follows:
>>
>> $ devlink dev param set pci/0000:35:00.0 name algo_param value \
>>    "type@dcqcn_alp@30_f@35_tmp@11_tkp@11_ai@60_maxspeed@17_g@11_al@19_cnptime@20" \
>>    cmode runtime
>>
>> $ devlink dev param show pci/0000:35:00.0 name algo_param
>> pci/0000:35:00.0:
>>    name algo_param type driver-specific
>>      values:
>>        cmode runtime value type@dcqcn_ai@60_f@35_tkp@11_tmp@11_alp@30_maxspeed@17_g@11_al@19_cnptime@20
> 
> Please put your RDMA params to the RDMA subsystem.
> It's not what devlink is for. In general 95% of the time devlink params
> are not the answer upstream.
> .
> 
Ok, I will discuss with our team.
