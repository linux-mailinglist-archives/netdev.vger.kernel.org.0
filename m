Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863341B586A
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 11:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgDWJl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 05:41:27 -0400
Received: from terminus.zytor.com ([198.137.202.136]:48619 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbgDWJl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 05:41:26 -0400
Received: from carbon-x1.hos.anvin.org ([IPv6:2601:646:8600:3281:e7ea:4585:74bd:2ff0])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 03N9e6l31992151
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 23 Apr 2020 02:40:06 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 03N9e6l31992151
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020032201; t=1587634814;
        bh=Ya1uL1f9lhCFML4o9w+eIvnqDUw43WLYC+xpvJjwcxc=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=PwQVOu7SkPBzOcBtqqwc9ey3h9Egov7y2oIQXhwFP9AbSi/Mrat5wBApUffK219Cq
         b/jQsUkGeyCIF9FZRY30m+cNKCDa7GsCTot7LZtCOjE+oSHmM4Q1HHZLj1+qjJkVtJ
         HMyLpDzklMhvrbaNPtKEPIcqu0pLTmgK+qWm30gmx6aidbBJeNdhPVkQdTKpEyTVDn
         cG28L34nE/4zxiLleGG+lz2woKzJJY2OucAvY4oxA3OxhGiFEBza2z4LhoiEXT8w7M
         RkudI+gfdriBZmzXAsCSwNl2/UuuArJZUbg1NYMEpdZPVzTJBXxUyhHBSj4YVH6svc
         OuvbHJ2Uf8pbw==
Subject: Re: [PATCH] bpf, x32: remove unneeded conversion to bool
To:     Wang YanQing <udknight@gmail.com>, Jason Yan <yanaijie@huawei.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        lukenels@cs.washington.edu, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200420123727.3616-1-yanaijie@huawei.com>
 <dff9a49b-0d00-54b0-0375-cc908289e65a@zytor.com>
 <20200423021021.GA16982@udknight>
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <01cbaffb-dfb3-06e7-d01f-ae583ee0c012@zytor.com>
Date:   Thu, 23 Apr 2020 02:40:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423021021.GA16982@udknight>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-22 19:10, Wang YanQing wrote:
> On Wed, Apr 22, 2020 at 11:43:58AM -0700, H. Peter Anvin wrote:
>> On 2020-04-20 05:37, Jason Yan wrote:
>>> The '==' expression itself is bool, no need to convert it to bool again.
>>> This fixes the following coccicheck warning:
>>>
>>> arch/x86/net/bpf_jit_comp32.c:1478:50-55: WARNING: conversion to bool
>>> not needed here
>>> arch/x86/net/bpf_jit_comp32.c:1479:50-55: WARNING: conversion to bool
>>> not needed here
>>>
>>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>>> ---
>>>  arch/x86/net/bpf_jit_comp32.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>
>> x32 is not i386.
>>
>> 	-hpa
> Hi! H. Peter Anvin and all
> 
> I use the name "x86_32" to describe it in original commit 03f5781be2c7
> ("bpf, x86_32: add eBPF JIT compiler for ia32"), but almost all following
> committers and contributors use the world "x32", I think it is short format
> for x{86_}32.
> 
> Yes, I agree, "x32" isn't the right name here, I think "x32" is well known
> as a ABI, so maybe we should use "x86_32" or ia32 in future communication.
> 
> Which one is the best name here? x86_32 or ia32 or anything other?
> 

x86-32 or i386.

	-hpa


