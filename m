Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23AAB189D1
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 14:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfEIMcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 08:32:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46887 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfEIMce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 08:32:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id r7so2178804wrr.13
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 05:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=1d8zXSY+AZq9wDDVDSlQy1dBUW/l/obQzBtjFOwR/O4=;
        b=TZ4wpBf8jH0WoGpFl8+03hhNlUmkk84X6pGihYt3RrL6U6IG5P7IxQOrrqGvTrzdN/
         ZYcZu9CKwDin9PE/wR4ZFRY3PCJuC7JYMOLI4XjiR5vXSOqK7CYyvjXyRQEokDACzqET
         +OeMYQXGkVO4DErXshiDvf65LSft43g/bDz/rNyr4y/Q7exghNLGHsqmvIGRbAkgFHLX
         0igTYS2GKAjnB2TA1flfgwkmCMRX1MbYFveaGCOJbIjEtyWGwNdFp0LjtHcQb63Iwvwg
         NJRJB5G1wUWvVUo8ItA0wQiOVezeoRBS/QeKWJ80oXOkm3MprCD4FOWT7bNWI8eZNeJF
         n9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=1d8zXSY+AZq9wDDVDSlQy1dBUW/l/obQzBtjFOwR/O4=;
        b=QwJFCJ7IVrgpF7WXgMHvaAh5wh6ip2M3gtny+XvpYNhnfWcBuvZbTh+y9fY1nRlD4V
         Y4O6Tc2MOFTr8dKEHrYZYXQicasQ37r8cr0AzT+PtfRAw7nLImiv0Jnn8chBmMfDK7XL
         RCGXk9O1gQnCBu8zPc4NIptdytDMt6gTGYiGicK0NQ0PJ6XYDO3vudPHFU5pXiPNSEh6
         W5Glx/TF97J+tK8vHk/+X56uL76OjISINq4p0Dzx71IxmIyLMQbchaIDk2CalmdxgGfK
         dBVMtve+rD43AzAHaMbWQ/4s7l9yvqCfzFTdxu9ginF4SxhqQRz0nyVueXYSyJchhSCk
         ZY2A==
X-Gm-Message-State: APjAAAV1J85EcqH/HTUKoDHq5Rfi5TBb7DU+y/m9XXQt5FVYLPjsaBDQ
        vENz/aTj1VabY3oUaMn7mZN6Pg==
X-Google-Smtp-Source: APXvYqzqCmytXr95C7x7aoThg0NjaW4CzIEUltDwkfHqJ5lD0dpt2rKClwUL1zloQ0h8nwVhI1bVRQ==
X-Received: by 2002:adf:d081:: with SMTP id y1mr2905745wrh.283.1557405153076;
        Thu, 09 May 2019 05:32:33 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y7sm6836661wrg.45.2019.05.09.05.32.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 May 2019 05:32:32 -0700 (PDT)
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com> <1556880164-10689-2-git-send-email-jiong.wang@netronome.com> <20190506155041.ofxsvozqza6xrjep@ast-mbp> <87mujx6m4n.fsf@netronome.com> <20190508175111.hcbufw22mbksbpca@ast-mbp>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH v6 bpf-next 01/17] bpf: verifier: offer more accurate helper function arg and return type
In-reply-to: <20190508175111.hcbufw22mbksbpca@ast-mbp>
Date:   Thu, 09 May 2019 13:32:30 +0100
Message-ID: <87ef5795b5.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Alexei Starovoitov writes:

> On Wed, May 08, 2019 at 03:45:12PM +0100, Jiong Wang wrote:
>> 
>> I might be misunderstanding your points, please just shout if I am wrong.
>> 
>> Suppose the following BPF code:
>> 
>>   unsigned helper(unsigned long long, unsigned long long);
>>   unsigned long long test(unsigned *a, unsigned int c)
>>   {
>>     unsigned int b = *a;
>>     c += 10;
>>     return helper(b, c);
>>   }
>> 
>> We get the following instruction sequence by latest llvm
>> (-O2 -mattr=+alu32 -mcpu=v3)
>> 
>>   test:
>>     1: w1 = *(u32 *)(r1 + 0)
>>     2: w2 += 10
>>     3: call helper
>>     4: exit
>> 
>> Argument Types
>> ===
>> Now instruction 1 and 2 are sub-register defines, and instruction 3, the
>> call, use them implicitly.
>> 
>> Without the introduction of the new ARG_CONST_SIZE32 and
>> ARG_CONST_SIZE32_OR_ZERO, we don't know what should be done with w1 and
>> w2, zero-extend them should be fine for all cases, but could resulting in a
>> few unnecessary zero-extension inserted.
>
> I don't think we're on the same page.
> The argument type is _const_.
> In the example above they are not _const_.

Right, have read check_func_arg + check_helper_mem_access again.

Looks like ARG_CONST_SIZE* are designed for describing memory access size
for things like bounds checking. It must be a constant for stack access,
otherwise prog will be rejected, but it looks to me variables are allowed
for pkt/map access.

But pkt/map has extra range info. So, indeed, ARG_CONST_SIZE32* are
unnecessary, the width could be figured out through the range.

Will just drop this patch in next version.

And sorry for repeating it again, I am still concerned on the issue
described at https://www.spinics.net/lists/netdev/msg568678.html.

To be simple, zext insertion is based on eBPF ISA and assumes all
sub-register defines from alu32 or narrow loads need it if the underlying
hardware arches don't do it. However, some arches support hardware zext
partially. For example, PowerPC, SPARC etc are 64-bit arches, while they
don't do hardware zext on alu32, they do it for narrow loads. And RISCV is
even more special, some alu32 has hardware zext, some don't.

At the moment we have single backend hook "bpf_jit_hardware_zext", once a
backend enable it, verifier just insert zero extension for all identified
alu32 and narrow loads.

Given verifier analysis info is not pushed down to JIT back-ends, verifier
needs more back-end info pushed up from back-ends. Do you think make sense
to introduce another hook "bpf_jit_hardware_zext_narrow_load" to at least
prevent unnecessary zext inserted for narrowed loads for arches like
PowerPC, SPARC?

The hooks to control verifier zext insertion then becomes two:

  bpf_jit_hardware_zext_alu32
  bpf_jit_hardware_zext_narrow_load

>> And that why I introduce these new argument types, without them, there
>> could be more than 10% extra zext inserted on benchmarks like bpf_lxc.
>
> 10% extra ? so be it.
> We're talking past each other here.
> I agree with your optimization goal, but I think you're missing
> the safety concerns I'm trying to explain.
>> But for helper functions, they are done by native code which may not follow
>> this convention. For example, on arm32, calling helper functions are just
>> jump to and execute native code. And if the helper returns u32, it just set
>> r0, no clearing of r1 which is the high 32-bit in the register pair
>> modeling eBPF R0.
>
> it's arm32 bug then. All helpers _must_ return 64-bit back to bpf prog
> and _must_ accept 64-bit from bpf prog.
