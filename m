Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F62A63AC15
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiK1PWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiK1PWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:22:32 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7AEB1C3
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:22:30 -0800 (PST)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NLTht549nzRpVr;
        Mon, 28 Nov 2022 23:21:50 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 28 Nov
 2022 23:22:28 +0800
Subject: Re: [RFCv8 PATCH net-next 00/55] net: extend the type of
 netdev_features_t to bitmap
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <saeed@kernel.org>,
        <leon@kernel.org>, <netdev@vger.kernel.org>, <linuxarm@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
 <20221125154421.82829-1-alexandr.lobakin@intel.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <724a884e-d5ca-8192-b3be-bf68711be515@huawei.com>
Date:   Mon, 28 Nov 2022 23:22:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20221125154421.82829-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/11/25 23:44, Alexander Lobakin 写道:
> From: Jian Shen <shenjian15@huawei.com>
> Date: Sun, 18 Sep 2022 09:42:41 +0000
>
>> For the prototype of netdev_features_t is u64, and the number
>> of netdevice feature bits is 64 now. So there is no space to
>> introduce new feature bit.
>>
>> This patchset try to solve it by change the prototype of
>> netdev_features_t from u64 to structure below:
>> 	typedef struct {
>> 		DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
>> 	} netdev_features_t;
>>
>> With this change, it's necessary to introduce a set of bitmap
>> operation helpers for netdev features. [patch 1]
> Hey,
>
> what's the current status, how's going?
>
> [...]
Hi, Alexander

Sorry to reply late, I'm still working on this, dealing with split the 
patchset.

Btw, could you kindly review this V8 set?  I have adjusted the protocol 
of many interfaces and helpers,
to avoiding return or pass data large than 64bits. Hope to get more 
opinions.

Thanks!

Jian
>> -- 
>> 2.33.0
> Thanks,
> Olek
> .
>

