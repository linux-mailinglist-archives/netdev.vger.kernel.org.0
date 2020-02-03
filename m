Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0EF150262
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 09:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgBCIQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 03:16:52 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:39146 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727540AbgBCIQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 03:16:51 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 71800479F7C0A6080A88;
        Mon,  3 Feb 2020 16:16:48 +0800 (CST)
Received: from [127.0.0.1] (10.57.71.8) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 3 Feb 2020
 16:16:38 +0800
Subject: Re: [PATCH -next] bpf: make btf_check_func_type_match() static
To:     Yonghong Song <yhs@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <chenzhou10@huawei.com>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
References: <20200203020220.117152-1-yaohongbo@huawei.com>
 <a29bf101-81b0-68ef-356c-dfdc9c53d899@fb.com>
From:   Yao HongBo <yaohongbo@huawei.com>
Message-ID: <f82e64c5-9299-b1a2-41b6-0f3630793d2b@huawei.com>
Date:   Mon, 3 Feb 2020 16:16:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <a29bf101-81b0-68ef-356c-dfdc9c53d899@fb.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.57.71.8]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/2020 2:20 PM, Yonghong Song wrote:
> 
> 
> On 2/2/20 6:02 PM, Hongbo Yao wrote:
>> Fix sparse warning:
>> kernel/bpf/btf.c:4131:5: warning: symbol 'btf_check_func_type_match' was
>> not declared. Should it be static?
> 
> Yes, static is better since the function is only used in one file.
> 
> Please use the tag "[PATCH bpf-next]" instead of "[PATCH -next]".
> Since this is to fix a sparse warning, I think it should be okay
> to target bpf-next. Please resubmit after bpf-next reopens in
> about a week.

OK.

>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
>> ---
>>   kernel/bpf/btf.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> index 8c9d8f266bef..83d3d92023af 100644
>> --- a/kernel/bpf/btf.c
>> +++ b/kernel/bpf/btf.c
>> @@ -4144,7 +4144,7 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
>>    * EFAULT - verifier bug
>>    * 0 - 99% match. The last 1% is validated by the verifier.
>>    */
>> -int btf_check_func_type_match(struct bpf_verifier_log *log,
>> +static int btf_check_func_type_match(struct bpf_verifier_log *log,
>>                     struct btf *btf1, const struct btf_type *t1,
>>                     struct btf *btf2, const struct btf_type *t2)
> 
> Please also align
>   struct btf *btf1, const struct btf_type *t1,
>   struct btf *btf2, const struct btf_type *t2)
> properly after you added 'static' before the function declaration.

I'll fix it, thanks.

>>   {
>>
> 
> .
> 

