Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AA74F044B
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 17:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355893AbiDBPIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 11:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348745AbiDBPIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 11:08:50 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EE1165BE;
        Sat,  2 Apr 2022 08:06:57 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KW0dg1S0BzBrgq;
        Sat,  2 Apr 2022 23:02:47 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.21; Sat, 2 Apr 2022 23:06:53 +0800
Message-ID: <7845dd59-d877-e528-74f6-6c7a101b0282@huawei.com>
Date:   Sat, 2 Apr 2022 23:06:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH bpf-next] bpf, arm64: sign return address for jited code
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20220318102936.838459-1-xukuohai@huawei.com>
 <da82d26e-8269-5b95-2cbb-1c147e55fcd4@iogearbox.net>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <da82d26e-8269-5b95-2cbb-1c147e55fcd4@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/2/2022 4:22 AM, Daniel Borkmann wrote:
> On 3/18/22 11:29 AM, Xu Kuohai wrote:
>> Sign return address for jited code when the kernel is built with pointer
>> authentication enabled.
>>
>> 1. Sign lr with paciasp instruction before lr is pushed to stack. Since
>>     paciasp acts like landing pads for function entry, no need to insert
>>     bti instruction before paciasp.
>>
>> 2. Authenticate lr with autiasp instruction after lr is poped from stack.
>>
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> 
> This would need a rebase, but please also use the commit description to 
> provide
> some more details how this inter-operates wrt BPF infra such as tail 
> calls and
> BPF-2-BPF calls when we look back into this in few months from now.
> 
> Thanks,
> Daniel
> .

updated in v2, thanks.

