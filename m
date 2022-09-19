Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9DA5BCA40
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiISLH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiISLH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:07:27 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D18DEA6;
        Mon, 19 Sep 2022 04:07:25 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MWMGC3WhhzMmwB;
        Mon, 19 Sep 2022 19:02:43 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 19:07:22 +0800
Message-ID: <6524401a-4e1f-61bf-5b8d-e56b4fcdc67d@huawei.com>
Date:   Mon, 19 Sep 2022 19:07:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [RFC PATCH net-next 1/2] net: sched: act_api: add helper macro
 for tcf_action in module and net init/exit
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20220916085155.33750-1-shaozhengchao@huawei.com>
 <20220916085155.33750-2-shaozhengchao@huawei.com>
 <YyYZ5cKm5TiuKBgv@pop-os.localdomain>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <YyYZ5cKm5TiuKBgv@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/18 3:03, Cong Wang wrote:
> On Fri, Sep 16, 2022 at 04:51:54PM +0800, Zhengchao Shao wrote:
>> Helper macro for tcf_action that don't do anything special in module
>> and net init/exit. This eliminates a lot of boilerplate. Each module
>> may only use this macro once, and calling it replaces module/net_init()
>> and module/net_exit().
>>
> 
> This looks over engineering to me. I don't think this reduces any code
> size or help any readability.
> 
> Thanks.
Hi Wang:
	Thank you for your review. I think this macro can simplify
repeated code when adding action modules later.

Zhengchao Shao
