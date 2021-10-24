Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285E14387E8
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhJXJaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:30:03 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26186 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhJXJaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 05:30:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HcXlL181Fz8tk6;
        Sun, 24 Oct 2021 17:26:22 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:27:40 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:27:40 +0800
From:   Hou Tao <houtao1@huawei.com>
Subject: Re: [PATCH bpf-next v3 2/4] bpf: factor out helpers to check ctx
 access for BTF function
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211022075511.1682588-1-houtao1@huawei.com>
 <20211022075511.1682588-3-houtao1@huawei.com>
 <20211023001832.jvz5lbnj33l4y3jb@kafai-mbp.dhcp.thefacebook.com>
Message-ID: <64e808b8-a1e8-1b64-15a4-179f84c06fa6@huawei.com>
Date:   Sun, 24 Oct 2021 17:27:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20211023001832.jvz5lbnj33l4y3jb@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On 10/23/2021 8:18 AM, Martin KaFai Lau wrote:
> On Fri, Oct 22, 2021 at 03:55:09PM +0800, Hou Tao wrote:
>> @@ -1649,6 +1649,33 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
>>  bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>>  		    const struct bpf_prog *prog,
>>  		    struct bpf_insn_access_aux *info);
>> +
>> +/*
>> + * The maximum number of BTF function arguments is MAX_BPF_FUNC_ARGS.
>> + * And only aligned read is allowed.
> It is not always 'BTF' function arguments.  Lets remove this comment.
> The function is short and its intention is clear.
Yes, you are right, BTF is not necessary for BPF_PROG_TYPE_RAW_TRACEPOINT program.
I will remove the inaccurate comments and update commit message accordingly.
> Others lgtm.
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
Thanks for your detailed suggestions and careful review.

Regards,
Tao
