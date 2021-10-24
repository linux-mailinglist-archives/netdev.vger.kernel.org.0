Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C511438852
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 12:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhJXKfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 06:35:08 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26116 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhJXKfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 06:35:08 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HcZ9p3ZJsz1DHBw;
        Sun, 24 Oct 2021 18:30:54 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 18:32:13 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 18:32:12 +0800
Subject: Re: [PATCH bpf-next v3 3/4] bpf: add dummy BPF STRUCT_OPS for test
 purpose
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211022075511.1682588-1-houtao1@huawei.com>
 <20211022075511.1682588-4-houtao1@huawei.com>
 <20211023003530.c2sfy6ogic7gdvzs@kafai-mbp.dhcp.thefacebook.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <7f727cb6-61d8-e626-041d-b85155c8e72a@huawei.com>
Date:   Sun, 24 Oct 2021 18:32:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20211023003530.c2sfy6ogic7gdvzs@kafai-mbp.dhcp.thefacebook.com>
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

On 10/23/2021 8:35 AM, Martin KaFai Lau wrote:
> On Fri, Oct 22, 2021 at 03:55:10PM +0800, Hou Tao wrote:
>
> +static struct bpf_dummy_ops_test_args *
> +dummy_ops_init_args(const union bpf_attr *kattr, unsigned int nr)
> +{
> +	__u32 size_in;
> +	struct bpf_dummy_ops_test_args *args;
> +	void __user *ctx_in;
> +	void __user *u_state;
> +
> +	if (!nr || nr > MAX_BPF_FUNC_ARGS)
> These checks are unnecessary and can be removed.  They had already been
> checked by the verifier during the bpf prog load time.
Yes. The check is done in bpf_struct_ops_init(). Will remove it in v4.
> Others lgtm.
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
Thanks again for your review.

Regards,
Tao
