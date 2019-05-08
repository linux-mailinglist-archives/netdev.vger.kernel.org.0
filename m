Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0623917BDC
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 16:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbfEHOpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 10:45:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38137 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbfEHOpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 10:45:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id f2so3613589wmj.3
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 07:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=p2Hhf9Zkfghsa69t+Pulg/6nRtvK80Zby2amZmhcPWk=;
        b=gYIa22QrMNwrANUfAZG22itrhiYlsgkmL9l3P1gPolatu4ZIsFGHuSuDCdtK60AoaH
         UPiss8BojtFdPdiLu4AykaH8mj97naHUZaNr92yKsWNVQk0iGfBPELEv7hYO2MsjZdwO
         Yzqe8BDV1M8i5e2nkCHCU36gBg0cp7SmlToZz65+cMjJ+uRMjcTKRXnVSGcCwgfKkiub
         Xq2j0GrRUFsdJUxQA81eoFLX3NCXORo7EiCH5/OvybCIXrr5Pv/xqkz+M0HAmNgHjvdL
         wkLRw/WmeYdRmg8DAmNLukbmUfBGPOEIH00t0ZSzahDIFYLtJpmUhvvBYVgeojHOn3BS
         kQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=p2Hhf9Zkfghsa69t+Pulg/6nRtvK80Zby2amZmhcPWk=;
        b=MnIgQKtM0bF6OG4SIKcCNDri6UoNB8/UqatDLxbwjJA89M03esvEjTx39Wm1X1ix+Y
         t0kGwiGH/3cg7bike/ALlg9PFtkfKxlbFsi1WHfx4uMlGopiHJLAyvag/9PYgAn7giR0
         VxjcAoXQGSLcr/HFhTYWr62TZ3RcXeQO+RjHvLrk+NRzNsW6xYhillu7necGTqj1izff
         dinWgIqQuO2xCEzGAqkm1CwKPB38mdJFYLWdDLNEk8WJ8bFwen6kYCxvIDRc+zwbbzuR
         WGvuH2OXV+1DqcWoUFx9G3/BE9+XEc5M1RY5XRV7FTwjyol8B6/Moo5Hj5NOj/HRrWT+
         5v+A==
X-Gm-Message-State: APjAAAX62m4j/QFN9rN3mkG2Uw6fz36nGCI2ESYykA8/NdNvfRzr0CTE
        +bCEo5sN4FUi1bmf4IDBYrSsDg==
X-Google-Smtp-Source: APXvYqxzjpB5HxJaVvg+AxyhmhikiMPKYvEoY+GVU6bdhRwbb/aHSnnGP2pRi5a88DRWwE9Ses/mRg==
X-Received: by 2002:a1c:7613:: with SMTP id r19mr3443585wmc.120.1557326717728;
        Wed, 08 May 2019 07:45:17 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id d16sm12360530wrs.68.2019.05.08.07.45.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 07:45:16 -0700 (PDT)
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com> <1556880164-10689-2-git-send-email-jiong.wang@netronome.com> <20190506155041.ofxsvozqza6xrjep@ast-mbp>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH v6 bpf-next 01/17] bpf: verifier: offer more accurate helper function arg and return type
In-reply-to: <20190506155041.ofxsvozqza6xrjep@ast-mbp>
Date:   Wed, 08 May 2019 15:45:12 +0100
Message-ID: <87mujx6m4n.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Alexei Starovoitov writes:

> On Fri, May 03, 2019 at 11:42:28AM +0100, Jiong Wang wrote:
>> BPF helper call transfers execution from eBPF insns to native functions
>> while verifier insn walker only walks eBPF insns. So, verifier can only
>> knows argument and return value types from explicit helper function
>> prototype descriptions.
>> 
>> For 32-bit optimization, it is important to know whether argument (register
>> use from eBPF insn) and return value (register define from external
>> function) is 32-bit or 64-bit, so corresponding registers could be
>> zero-extended correctly.
>> 
>> For arguments, they are register uses, we conservatively treat all of them
>> as 64-bit at default, while the following new bpf_arg_type are added so we
>> could start to mark those frequently used helper functions with more
>> accurate argument type.
>> 
>>   ARG_CONST_SIZE32
>>   ARG_CONST_SIZE32_OR_ZERO
>>   ARG_ANYTHING32
>> 
>> A few helper functions shown up frequently inside Cilium bpf program are
>> updated using these new types.
>> 
>> For return values, they are register defs, we need to know accurate width
>> for correct zero extensions. Given most of the helper functions returning
>> integers return 32-bit value, a new RET_INTEGER64 is added to make those
>> functions return 64-bit value. All related helper functions are updated.
>> 
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> ---
>>  include/linux/bpf.h      |  6 +++++-
>>  kernel/bpf/core.c        |  2 +-
>>  kernel/bpf/helpers.c     | 10 +++++-----
>>  kernel/bpf/verifier.c    | 15 ++++++++++-----
>>  kernel/trace/bpf_trace.c |  4 ++--
>>  net/core/filter.c        | 38 +++++++++++++++++++-------------------
>>  6 files changed, 42 insertions(+), 33 deletions(-)
>> 
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 9a21848..11a5fb9 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -198,9 +198,12 @@ enum bpf_arg_type {
>>  
>>  	ARG_CONST_SIZE,		/* number of bytes accessed from memory */
>>  	ARG_CONST_SIZE_OR_ZERO,	/* number of bytes accessed from memory or 0 */
>> +	ARG_CONST_SIZE32,	/* Likewise, but size fits into 32-bit */
>> +	ARG_CONST_SIZE32_OR_ZERO,	/* Ditto */
>
> these two should not be necessary. The program must pass constant into
> the helper. The verifier is smart enough already to see it through.
> Looks like patch 2 is using it as a band-aid.
>
>>  	ARG_PTR_TO_CTX,		/* pointer to context */
>>  	ARG_ANYTHING,		/* any (initialized) argument is ok */
>> +	ARG_ANYTHING32,		/* Likewise, but it is a 32-bit argument */
>
> Such annotation has subtle semantics that I don't think we've explored
> in the past and I don't see from commit logs of this patch set that
> the necessary analysis was done.
> In particular 'int' in the helper argument does not mean that the verifier
> will reject 64-bit values. It also doesn't mean that the helper
> will reject them at run-time. In most cases it's a silent truncation.
> Like bpf_tail_call will accept 64-bit value, and will cast it to u32
> before doing max_entries bounds check.
> In other cases it could be signed vs unsigned interpretation inside
> the helper.

I might be misunderstanding your points, please just shout if I am wrong.

Suppose the following BPF code:

  unsigned helper(unsigned long long, unsigned long long);
  unsigned long long test(unsigned *a, unsigned int c)
  {
    unsigned int b = *a;
    c += 10;
    return helper(b, c);
  }

We get the following instruction sequence by latest llvm
(-O2 -mattr=+alu32 -mcpu=v3)

  test:
    1: w1 = *(u32 *)(r1 + 0)
    2: w2 += 10
    3: call helper
    4: exit

Argument Types
===
Now instruction 1 and 2 are sub-register defines, and instruction 3, the
call, use them implicitly.

Without the introduction of the new ARG_CONST_SIZE32 and
ARG_CONST_SIZE32_OR_ZERO, we don't know what should be done with w1 and
w2, zero-extend them should be fine for all cases, but could resulting in a
few unnecessary zero-extension inserted.

By introducing the new types, we know both are u64, so should zero-extend
them.

This sort of comes to how high 32-bit zero extension semantics are
exploited by compiler or handle-written assembler.

For LLVM compiler, it will exploit ISA zext semantics for quite a few
cases.

  1. narrow load at are naturally done by instruction combine pattern,
  things like:

  def : Pat<(i64 (zextloadi32 ADDRri:$src)),
              (SUBREG_TO_REG (i64 0), (LDW32 ADDRri:$src), sub_32)>;

  2. For ALUs, there is BPF peephole pass trying to do it, sequence for
  preparing argument 2 would have been:
  
     w2 = 16
     r2 <<= 32
     r2 >>= 32
     
  But, the peephole pass could know the two shifts are shifting value comes
  from sub-register MOV, so safe to remove the redundant two shifts.

So, finally the BPF instruction sequence we get is the one shown early,
without new argument types, verifier doesn't know how to deal with
zext.

Static compiler has header files which contains function prototypes/C-types
to guide code-gen. IMHO, verifier needs the same thing, which is BPF helper
function prototype description.

And that why I introduce these new argument types, without them, there
could be more than 10% extra zext inserted on benchmarks like bpf_lxc.

Return Types
===
If we change the testcase a little bit by introducing one new function
helper1.

  unsigned helper(unsigned long long, unsigned long long);
  unsigned long long helper1(unsigned long long);

  unsigned long long test(unsigned *a, unsigned int c)
  {
    unsigned int b = *a;
    c += 10;
    return helper1(helper(b, c));
  }

Code-gen for -O2 -mattr=+alu32 -mcpu=v3 will be:

  test:
    1: w1 = *(u32 *)(r1 + 0)
    2: w2 += 10
    3: call helper
    4: r1 = r0
    5: call helper1
    6: exit

The return value of "helper" is u32 and is used as u64 arg for helper1
directly. For bpf-to-bpf call, I think it is correct, because the value
define happens inside bpf program, and 32-bit opt pass does pass the
definition information from callee to caller at exit, so the sub-register
define instruction will be marked, and the register will be zero extended,
so no problem to use it directly as 64-bit to helper1.

But for helper functions, they are done by native code which may not follow
this convention. For example, on arm32, calling helper functions are just
jump to and execute native code. And if the helper returns u32, it just set
r0, no clearing of r1 which is the high 32-bit in the register pair
modeling eBPF R0.

Inside verifier, we assume helper return values are all 64-bit, without new
return types, there won't be zero-extension on u32 value if 32-bit JIT
back-ends haven't done correct job to clear high 32-bit of return value if
the helper function is 64-bit type. This requires JIT back-ends check
helper function prototypes and do code-gen accordingly. Maybe is is too
strict to ask JIT backends to do this, we should just let compiler always
generates extra zero extension if the 32-bit return value comes from
external helper functions?

> imo the code base is not ready for semi-automatic remarking of
> helpers with ARG_ANYTHING32 when helper is accepting 32-bit value.
> Definitely not something short term and not a prerequisite for this set.
>
> Longer term... if we introduce ARG_ANYTHING32, what would that mean?

At the moment I am thinking ARG_ANYTHING32 just means the read of the value
is low 32-bit only.

> Would the verifier insert zext before calling the helper automatically
> and we can drop truncation in the helper? May be useful?

Yes, after 32-bit opt enabled, JIT back-ends doesn't need to generate high
32-bit clearance instructions if once instruction is not marked. Verifier
is responsible for inserting zext before calling the helper if the
definition of the arguments is a sub-register define and if the argument
usage if 64-bit.

> What about passing negative value ?
> ld_imm64 r2, -1
> call foo
> is a valid program.

ld_imm64 is a 64-bit define, so 32-bit opt pass won't touch the sequence.

>
>>  	ARG_PTR_TO_SPIN_LOCK,	/* pointer to bpf_spin_lock */
>>  	ARG_PTR_TO_SOCK_COMMON,	/* pointer to sock_common */
>>  	ARG_PTR_TO_INT,		/* pointer to int */
>> @@ -210,7 +213,8 @@ enum bpf_arg_type {
>>  
>>  /* type of values returned from helper functions */
>>  enum bpf_return_type {
>> -	RET_INTEGER,			/* function returns integer */
>> +	RET_INTEGER,			/* function returns 32-bit integer */
>> +	RET_INTEGER64,			/* function returns 64-bit integer */
>
> These type of annotations are dangerous too since they don't consider sign
> of the return value. In BPF ISA all arguments and return values are 64-bit.
> When it's full 64-bit we don't need to specify the sign, since sing-bit
> will be interpreted by the program and the verifier doesn't need to worry.
> If we say that helper returns 32-bit we need state whether it's signed or not
> for the verifier to analyze it properly.

I feel signed or unsigned will just work, for example:

  s32 helper(u64, u64);
  s64 helper1(u64);

  s64 test(u32 *a, u32 c)
  {
    u32 b = *a;
    c += 10;
    return helper1(helper(b, c));
  }

  test:
    w1 = *(u32 *)(r1 + 0)
    w2 += 10
    call helper
    r1 = r0
    r1 <<= 32
    r1 s>>= 32
    call helper1
    exit
    
"helper" is RET_INTEGER which means returning 32-bit, and helper1 is
RET_INTEGER64. LLVM compiler should have generated explicit signed
extension sequence like above to sign extend return value of "helper". And
because is is RET_INTEGER and because there is later 64-bit use in the
following "r1 = r0" move, it is fine to insert zero extension after the
call, the later signed extension sequence will still work.

Regards,
Jiong

> I think it's the best to drop this patch. I don't think the rest of the set
> really needs it. It looks to me as a last minute optimization that I really
> wish wasn't there, because the rest we've discussed in depth and the set
> was practically ready to land, but now bpf-next is closed.
> Please resubmit after it reopens.

