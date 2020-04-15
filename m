Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E941A952C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 09:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635359AbgDOHwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 03:52:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2375 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2635311AbgDOHwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 03:52:19 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9367E530937B7EC367CF;
        Wed, 15 Apr 2020 15:52:13 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.60) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Apr 2020
 15:52:11 +0800
Subject: Re: [PATCH -next] bpf: remove set but not used variable 'dst_known'
To:     Song Liu <songliubraving@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
References: <20200413113703.194287-1-maowenan@huawei.com>
 <C75FACD4-8549-4AD1-BDE6-1F5B47095E4C@fb.com>
 <2b2e0060-ef9b-5541-1108-e28464b47f0a@huawei.com>
 <F68FB33A-1B98-45C1-8056-457EFA52F84F@fb.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <8855e82a-88d0-8d1e-e5e0-47e781f9653c@huawei.com>
Date:   Wed, 15 Apr 2020 15:52:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <F68FB33A-1B98-45C1-8056-457EFA52F84F@fb.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.60]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/15 15:23, Song Liu wrote:
> 
> 
>> On Apr 14, 2020, at 6:37 PM, maowenan <maowenan@huawei.com> wrote:
>>
>> On 2020/4/15 6:05, Song Liu wrote:
>>>
>>>
>>>> On Apr 13, 2020, at 4:37 AM, Mao Wenan <maowenan@huawei.com> wrote:
>>>>
>>>> Fixes gcc '-Wunused-but-set-variable' warning:
>>>>
>>>> kernel/bpf/verifier.c:5603:18: warning: variable ‘dst_known’
>>>> set but not used [-Wunused-but-set-variable]
>>>>
>>>> It is not used since commit f1174f77b50c ("bpf/verifier:
>>>> rework value tracking")
>>>
>>> The fix makes sense. But I think f1174f77b50c introduced dst_known, 
>>> so this statement is not accurate. 
>>>
>> thanks for review, yes, f1174f77b50c introduced dst_known, and below commit
>> doesn't deference variable dst_known. So I send v2 later?
>> 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
> 
> I don't think we need to back port this to stable. So it is OK not to 
> include Fixes tag. We can just remove this statement in the commit log.
> 
> bpf-next is not open yet. Please send v2 when bpf-next is open. 
> 
> Thanks,
> Song
> 
OK, I will do that.

