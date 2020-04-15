Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7321A9087
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 03:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392644AbgDOBhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 21:37:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:41814 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733236AbgDOBhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 21:37:16 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 80AE34BA1B1AFC66BAA2;
        Wed, 15 Apr 2020 09:37:13 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.60) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Apr 2020
 09:37:09 +0800
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
From:   maowenan <maowenan@huawei.com>
Message-ID: <2b2e0060-ef9b-5541-1108-e28464b47f0a@huawei.com>
Date:   Wed, 15 Apr 2020 09:37:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <C75FACD4-8549-4AD1-BDE6-1F5B47095E4C@fb.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.60]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/15 6:05, Song Liu wrote:
> 
> 
>> On Apr 13, 2020, at 4:37 AM, Mao Wenan <maowenan@huawei.com> wrote:
>>
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> kernel/bpf/verifier.c:5603:18: warning: variable ‘dst_known’
>> set but not used [-Wunused-but-set-variable]
>>
>> It is not used since commit f1174f77b50c ("bpf/verifier:
>> rework value tracking")
> 
> The fix makes sense. But I think f1174f77b50c introduced dst_known, 
> so this statement is not accurate. 
> 
thanks for review, yes, f1174f77b50c introduced dst_known, and below commit
doesn't deference variable dst_known. So I send v2 later?
3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")

>>
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> 


