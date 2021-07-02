Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25F23B9AC7
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 05:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbhGBDEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 23:04:04 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6033 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbhGBDED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 23:04:03 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GGKTf5fn4zXmKM;
        Fri,  2 Jul 2021 10:56:06 +0800 (CST)
Received: from dggema761-chm.china.huawei.com (10.1.198.203) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 11:01:28 +0800
Received: from [10.174.178.46] (10.174.178.46) by
 dggema761-chm.china.huawei.com (10.1.198.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 2 Jul 2021 11:01:27 +0800
Subject: Re: [PATCH] perf llvm: Fix error return code in llvm__compile_bpf()
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
CC:     <peterz@infradead.org>, <mingo@redhat.com>, <jolsa@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <nathan@kernel.org>, <ndesaulniers@google.com>,
        <linux-perf-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>, <yukuai3@huawei.com>
References: <20210609115945.2193194-1-chengzhihao1@huawei.com>
 <YN35TYxboEdM5iHc@kernel.org>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <21406430-56f0-c59b-7ece-7fd387bb47e9@huawei.com>
Date:   Fri, 2 Jul 2021 11:01:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <YN35TYxboEdM5iHc@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema761-chm.china.huawei.com (10.1.198.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ÔÚ 2021/7/2 1:20, Arnaldo Carvalho de Melo Ð´µÀ:
> Em Wed, Jun 09, 2021 at 07:59:45PM +0800, Zhihao Cheng escreveu:
>> Fix to return a negative error code from the error handling
>> case instead of 0, as done elsewhere in this function.
> 
> I checked and llvm__compile_bpf() returns -errno, so I'll change this to
> instead set err to -ENOMEM just before the if (asprintf)(), ok?
> 
> - Arnaldo
>   
Glad to accept this change.
>> Fixes: cb76371441d098 ("perf llvm: Allow passing options to llc ...")
>> Fixes: 5eab5a7ee032ac ("perf llvm: Display eBPF compiling command ...")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>


