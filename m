Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C961246334F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhK3Lwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:52:36 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28195 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbhK3LwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:52:01 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J3L6752Jnz8vY6;
        Tue, 30 Nov 2021 19:46:39 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 19:48:36 +0800
Subject: Re: [PATCH bpf-next v3 0/2] clean-up for BPF_LOG_KERNEL log level
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211102101536.2958763-1-houtao1@huawei.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <915a9acd-1831-2470-1490-ec8af4770e28@huawei.com>
Date:   Tue, 30 Nov 2021 19:48:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20211102101536.2958763-1-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

Could you please pick the patchset for v5.16 ?

On 11/2/2021 6:15 PM, Hou Tao wrote:
> Hi,
>
> There are just two clean-up patches for BPF_LOG_KERNEL log level:
> patch #1 fixes the possible extra newline for bpf_log() and removes
> the unnecessary calculation and truncation, and patch #2 disallows
> BPF_LOG_KERNEL log level for bpf_btf_load().
>
> Comments are welcome.
>
> Regards,
> Tao
>
> Change Log:
> v3:
>   * rebased on bpf-next
>   * address comments from Daniel Borkmann:
>     patch #1: add prefix "BPF: " instead of "BPF:" for error message
>     patch #2: remove uncessary parenthesis, keep the max buffer length
>               setting of btf verifier, and add Fixes tag.
>
> v2: https://www.spinics.net/lists/bpf/msg48809.html
>   * rebased on bpf-next
>   * patch #1: add a trailing newline if needed (suggested by Martin)
>   * add patch #2
>  
> v1: https://www.spinics.net/lists/bpf/msg48550.html
>
> Hou Tao (2):
>   bpf: clean-up bpf_verifier_vlog() for BPF_LOG_KERNEL log level
>   bpf: disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)
>
>  include/linux/bpf_verifier.h |  7 +++++++
>  kernel/bpf/btf.c             |  3 +--
>  kernel/bpf/verifier.c        | 16 +++++++++-------
>  3 files changed, 17 insertions(+), 9 deletions(-)
>

