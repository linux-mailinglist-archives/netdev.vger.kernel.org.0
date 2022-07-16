Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C222576C54
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 09:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiGPHNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 03:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGPHNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 03:13:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3531A38E;
        Sat, 16 Jul 2022 00:13:21 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LlK995nTnzVfmC;
        Sat, 16 Jul 2022 15:09:33 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Jul 2022 15:13:18 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Jul 2022 15:13:18 +0800
Subject: Re: [PATCH bpf-next v2 0/3] Use lightweigt version of bpftool
To:     Quentin Monnet <quentin@isovalent.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20220714024612.944071-1-pulehui@huawei.com>
 <CAEf4BzZ_L+94O00mMDUh8ps8RTF=kcvX1zS5ocK8fPk4uw-_kg@mail.gmail.com>
 <21cec7bd-e4fb-73f7-a6a6-7f52c03ae7e9@isovalent.com>
From:   Pu Lehui <pulehui@huawei.com>
Message-ID: <0235c3d5-30dd-8c80-b532-00c1590bbb58@huawei.com>
Date:   Sat, 16 Jul 2022 15:13:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <21cec7bd-e4fb-73f7-a6a6-7f52c03ae7e9@isovalent.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/7/16 1:15, Quentin Monnet wrote:
> On 15/07/2022 17:56, Andrii Nakryiko wrote:
>> On Wed, Jul 13, 2022 at 7:16 PM Pu Lehui <pulehui@huawei.com> wrote:
>>>
>>> Currently, samples/bpf, tools/runqslower and bpf/iterators use bpftool
>>> for vmlinux.h, skeleton, and static linking only. We can uselightweight
>>> bootstrap version of bpftool to handle these, and it will be faster.
>>>
>>> v2:
>>> - make libbpf and bootstrap bpftool independent. and make it simple.
>>>
>>
>> Quentin, does this patch set look good to you?
> 
> [Apologies, the mail server has been filtering Pu's emails as spam for
> some reason and I had missed the discussion :s]
> 
> Looks OK to me:
> Acked-by: Quentin Monnet <quentin@isovalent.com>
> 
> Although I'm a bit sorry to see the sharing of libbpf between bpftool
> and libbpf go away. But OK. We can maybe reintroduce it through
> bpftool's Makefile or a separate include Makefile in the future.
> 
> Quentin
> .

Hi, Quentin,

so much thanks for your review and ack. and apologies for not receiving 
your advice in time due to the misconfiguration of mail server[0]. and 
looking forward to your improvement for bpftool.

[0]https://lore.kernel.org/all/20220523152516.7sr247i3bzwhr44w@quack3.lan/

> 
