Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDFE644D8
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 12:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfGJKCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 06:02:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38055 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfGJKCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 06:02:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so1772531wrr.5;
        Wed, 10 Jul 2019 03:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i6Bo+HB26VqH9FnLFoi7Kz1iw9L0sl0k/UgsoCrhljo=;
        b=jHZNfrGmGLxti1qytpnzE+zd8Av3wSKbpMqx1uUJACFoYLGjKSAWLGOl+dhNlxTy9q
         hpybGCybE5qlKNVdQdM/O/czhr1GVFHCPkSJHNR50SUAU3bry7G7VdEFQqE4xolfqV9l
         pcEposDPsTFxdqOnoiqBM99JGO4zhLfPnOp71pfptQ0jgrcc48hoXua+YbcZLLExXI03
         yq5RnMRn6yOHoJBBynWi/8sEHz41XwGCz/adtSEP7+NsOYKpTu05sqB8jN5PurptejnG
         WsswonRiMLbKqnxtvcq35QwJUSfXldv8r+6UvYhL1ecbT5gnM8ebQGbtzrDXP/MrRyzL
         A5oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i6Bo+HB26VqH9FnLFoi7Kz1iw9L0sl0k/UgsoCrhljo=;
        b=s8+CyIMyIJu+owM0W1Ca0gd6acE5aqFgKiAZpGOGsPtPKb+h2iopjRc6ZBqWrySmlG
         Ozu1RwVofYTZXCVRvSnhNCGpBJH7SB9SkX4zQtECyillISo3TbERGxTclUZ1pDBrHlji
         a4Ug7thuG504xLvAi4YFFDHrKklTgABcX1n11T559nWAbGi5DU+o6H/S03bqG633RVYJ
         9n2kWYDJo5o3uZ7KjUg7zjAl7AlNafam6ED5YWaf+ikj269bom54tEfG0i7vre7NH9tm
         XcuoHuRiKr6d+Dg82GS6RmtGsJjbSIuu0G3SlSQy4c2+5wN+PVHHho/dJgVO9xGw9PsG
         3rfw==
X-Gm-Message-State: APjAAAVUwSsRZeJmXDLgsgMR3rNOjZAgEOIzSVFJnIXbYaNlUYaOEX7X
        cuKP635oxMLVtB9XuIBXg9o=
X-Google-Smtp-Source: APXvYqx+yrzwKY6jr1rw4+kJTSm6xQasgSnz8Qf2UMJaSRWx9nrgoUVz7RkLe0slZyVgIHOVy5ihyw==
X-Received: by 2002:adf:e446:: with SMTP id t6mr31002849wrm.115.1562752969370;
        Wed, 10 Jul 2019 03:02:49 -0700 (PDT)
Received: from gmail.com (net-5-95-187-49.cust.vodafonedsl.it. [5.95.187.49])
        by smtp.gmail.com with ESMTPSA id w67sm2022820wma.24.2019.07.10.03.02.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 03:02:48 -0700 (PDT)
Date:   Wed, 10 Jul 2019 12:02:48 +0200
From:   Paolo Pisati <p.pisati@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Paolo Pisati <p.pisati@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [RESEND] test_verifier #13 fails on arm64: "retval 65507 != -29"
Message-ID: <20190710100248.GA32281@harukaze>
References: <20190701115414.GA4452@harukaze>
 <68248069-bcf6-69dd-b0a9-f4ec11e50092@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68248069-bcf6-69dd-b0a9-f4ec11e50092@fb.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 09:51:25PM +0000, Yonghong Song wrote:
> 
> Below is the test case.
> {
>          "valid read map access into a read-only array 2",
>          .insns = {
>          BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
>          BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
>          BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
>          BPF_LD_MAP_FD(BPF_REG_1, 0),
>          BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, 
> BPF_FUNC_map_lookup_elem),
>          BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
> 
>          BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
>          BPF_MOV64_IMM(BPF_REG_2, 4),
>          BPF_MOV64_IMM(BPF_REG_3, 0),
>          BPF_MOV64_IMM(BPF_REG_4, 0),
>          BPF_MOV64_IMM(BPF_REG_5, 0),
>          BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
>                       BPF_FUNC_csum_diff),
>          BPF_EXIT_INSN(),
>          },
>          .prog_type = BPF_PROG_TYPE_SCHED_CLS,
>          .fixup_map_array_ro = { 3 },
>          .result = ACCEPT,
>          .retval = -29,
> },
> 
> The issue may be with helper bpf_csum_diff().
> Maybe you can check bpf_csum_diff() helper return value
> to confirm and take a further look at bpf_csum_diff implementations
> between x64 and amd64.

Indeed, the different result comes from csum_partial() or, more precisely,
do_csum().

x86-64 uses an asm optimized version residing in arch/x86/lib/csum-partial_64.c,
while the generic version is in lib/checksum.c.

I replaced the x86-64 csum_partial() / do_csum() code, with the one in
lib/checksum.c and by doing so i reproduced the same error on x86-64 (thus, it's
not an arch dependent issue).

I added some debugging to bpf_csum_diff(), and here are the results with different
checksum implementation code:

http://paste.debian.net/1091037/

lib/checksum.c:
...
[  206.084537] ____bpf_csum_diff from_size: 1 to_size: 0
[  206.085274] ____bpf_csum_diff from[0]: 28
[  206.085276] ____bpf_csum_diff diff[0]: 4294967267
[  206.085277] ____bpf_csum_diff diff_size: 4 seed: 0

After csum_partial() call:

[  206.086059] ____bpf_csum_diff csum: 65507 - 0xffe3

arch/x86/lib/csum-partial_64.c
...
[   40.467308] ____bpf_csum_diff from_size: 1 to_size: 0
[   40.468141] ____bpf_csum_diff from[0]: 28
[   40.468143] ____bpf_csum_diff diff[0]: 4294967267
[   40.468144] ____bpf_csum_diff diff_size: 4 seed: 0

After csum_partial() call:

[   40.468937] ____bpf_csum_diff csum: -29 - 0xffffffe3

One thing that i noticed, x86-64 csum-partial_64.c::do_csum() doesn't reduce the
calculated checksum to 16bit before returning it (unless the input value is
odd - *):

arch/x86/lib/csum-partial_64.c::do_csum()
		...
        if (unlikely(odd)) { 
                result = from32to16(result);
                result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
        }
        return result;
}

contrary to all the other do_csum() implementations (that i could understand):

lib/checksum.c::do_csum()
arch/alpha/lib/checksum.c::do_csum()
arch/parisc/lib/checksum.c::do_csum()

Apparently even ia64 does the folding (arch/ia64/lib/do_csum.S see a comment right
before .do_csum_exit:), and arch/c6x/lib/csum_64plus.S too (see
arch/c6x/lib/csum_64plus.S).

Funnily enough, if i change do_csum() for x86-64, folding the
checksum to 16 bit (following all the other implementations):

--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -112,8 +112,8 @@ static unsigned do_csum(const unsigned char *buff, unsigned
len)
        if (len & 1)
                result += *buff;
        result = add32_with_carry(result>>32, result & 0xffffffff); 
+       result = from32to16(result);
        if (unlikely(odd)) { 
-               result = from32to16(result);
                result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
        }
        return result;

then, the x86-64 result match the others: 65507 or 0xffe3.

As a last attempt, i tried running the bpf test_verifier on an armhf platform,
and i got a completely different number:

[   57.667999] ____bpf_csum_diff from_size: 1 to_size: 0
[   57.668016] ____bpf_csum_diff from[0]: 28
[   57.668028] ____bpf_csum_diff diff[0]: 4294967267
[   57.668039] ____bpf_csum_diff diff_size: 4 seed: 0

After csum_partial() call:

[   57.668052] ____bpf_csum_diff::2002 csum: 131042 - 0x0001ffe2

Not sure what to make of these number, but i have a question: whats is the
correct checksum of the memory chunk passed to csum_partial()? Is it really -29?

Because, at least 2 other implementations i tested (the arm assembly code and
the c implementation in lib/checksum.c) computes a different value, so either
there's a bug in checksum calcution (2 out of 3???), or we are interpreting the
returned value from csum_partial() somehow wrongly.

*: originally, the x86-64 did the 16bit folding, but the logic was changed to
what we have today during a big rewrite - search for:

commit 3ef076bb685a461bbaff37a1f06010fc4d7ce733
Author: Andi Kleen <ak@suse.de>
Date:   Fri Jun 13 04:27:34 2003 -0700

    [PATCH] x86-64 merge

in this historic repo:

https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
-- 
bye,
p.
