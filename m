Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15E146D109
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 11:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhLHKeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 05:34:10 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29102 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbhLHKeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 05:34:05 -0500
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J8CzK3BD0z1DJKQ;
        Wed,  8 Dec 2021 18:27:41 +0800 (CST)
Received: from [10.67.110.112] (10.67.110.112) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 18:30:31 +0800
Subject: Re: [PATCH -next 0/2] Introduce memset_range() helper for wiping
 members
To:     Kees Cook <keescook@chromium.org>
CC:     <akpm@linux-foundation.org>, <laniel_francis@privacyrequired.com>,
        <andriy.shevchenko@linux.intel.com>, <adobriyan@gmail.com>,
        <linux@roeck-us.net>, <andreyknvl@gmail.com>, <dja@axtens.net>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211208030451.219751-1-xiujianfeng@huawei.com>
 <202112072125.AC79323201@keescook>
From:   xiujianfeng <xiujianfeng@huawei.com>
Message-ID: <85904fc5-0c1b-7410-b818-7d0b959ce7af@huawei.com>
Date:   Wed, 8 Dec 2021 18:30:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <202112072125.AC79323201@keescook>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.112]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/12/8 13:27, Kees Cook 写道:
> On Wed, Dec 08, 2021 at 11:04:49AM +0800, Xiu Jianfeng wrote:
>> Xiu Jianfeng (2):
>>    string.h: Introduce memset_range() for wiping members
> For doing a memset range, the preferred method is to use
> a struct_group in the structure itself. This makes the range
> self-documenting, and allows the compile to validate the exact size,
> makes it addressable, etc. The other memset helpers are for "everything
> to the end", which doesn't usually benefit from the struct_group style
> of range declaration.
Do you mean there is no need to introduce this helper,  but to use 
struct_group in the struct directly?
>
>>    bpf: use memset_range helper in __mark_reg_known
> I never saw this patch arrive on the list?
I have send this patch as well, can you please check again?
>
