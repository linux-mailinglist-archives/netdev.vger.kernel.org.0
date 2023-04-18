Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3476E64F6
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjDRMxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjDRMxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:53:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E65146CD;
        Tue, 18 Apr 2023 05:53:35 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [7.192.105.130])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q13f01yJkzSsKd;
        Tue, 18 Apr 2023 20:49:28 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 20:53:33 +0800
Subject: Re: [PATCH 5.10 1/5] udp: Call inet6_destroy_sock() in
 setsockopt(IPV6_ADDRFORM).
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <kuba@kernel.org>, <kuniyu@amazon.com>, <netdev@vger.kernel.org>
References: <cover.1680589114.git.william.xuanziyang@huawei.com>
 <e553cbe5451685574d097486135b804ab595d344.1680589114.git.william.xuanziyang@huawei.com>
 <2023041820-storable-trimester-e98d@gregkh>
 <2023041845-resize-elude-7fb6@gregkh>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <60508ed0-dfe0-5981-6358-f87c860ccc8c@huawei.com>
Date:   Tue, 18 Apr 2023 20:53:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2023041845-resize-elude-7fb6@gregkh>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, Apr 18, 2023 at 12:21:21PM +0200, Greg KH wrote:
>> On Tue, Apr 04, 2023 at 05:24:28PM +0800, Ziyang Xuan wrote:
>>> From: Kuniyuki Iwashima <kuniyu@amazon.com>
>>>
>>> commit 21985f43376cee092702d6cb963ff97a9d2ede68 upstream.
>>
>> Why is this only relevant for 5.10.y?  What about 5.15.y?
>>
>> For obvious reasons, we can not take patches only for older branches as
>> that would cause people to have regressions when moving to newer kernel
>> releases.  So can you please fix this up by sending a 5.15.y series, and
>> this 5.10.y series again, and we can queue them all up at the same time?
> 
> Also a 6.1.y series to be complete.
> 
4.14.y, 4.19.y, 5.4.y, 5.10.y, 5.15.y and 6.1.y are all involved.
Can I send series for them all together?

William Xuan

> thanks,
> 
> greg k-h
> .
> 
