Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D01C46D48C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 14:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhLHNpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 08:45:01 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28287 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhLHNpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 08:45:00 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J8JGf0PjyzbjKG;
        Wed,  8 Dec 2021 21:41:14 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 21:41:26 +0800
Subject: Re: [PATCH bpf-next 3/5] selftests/bpf: factor out common helpers for
 benchmarks
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20211130142215.1237217-1-houtao1@huawei.com>
 <20211130142215.1237217-4-houtao1@huawei.com>
 <CAEf4BzaODof7fHFLp79Knx4=QGMY0B3ODCnayAgOvOmWG6dr=g@mail.gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <64a20f26-a419-c634-9b6d-3edbe418f03a@huawei.com>
Date:   Wed, 8 Dec 2021 21:41:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaODof7fHFLp79Knx4=QGMY0B3ODCnayAgOvOmWG6dr=g@mail.gmail.com>
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

Hi,

On 12/7/2021 10:55 AM, Andrii Nakryiko wrote:
> On Tue, Nov 30, 2021 at 6:07 AM Hou Tao <houtao1@huawei.com> wrote:
>> Five helpers are factored out to reduce boilerplate for
>> benchmark tests: do_getpgid(), getpgid_loop_producer(),
>> assert_single_consumer(), assert_single_producer() and
>> noop_consumer().
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
> Please drop this patch. All the stuff you are extracting into
> "reusable" helpers is so trivial that it's not worth it. It just makes
> it harder to follow each individual benchmark's setup.
OK. Will do it v2.

