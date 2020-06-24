Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878CA206C22
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 08:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389003AbgFXGEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 02:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388164AbgFXGEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 02:04:46 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657C6C061573;
        Tue, 23 Jun 2020 23:04:46 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id w9so972939ilk.13;
        Tue, 23 Jun 2020 23:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OIank4+rnOmnlQ1RvShvgHCzW0goS35nSXJDirD6hHQ=;
        b=FO40C8ZHL8hMfehCXjYu6qhTPBeA2C/t9F/MRa2y8OGET3CcX0ExDzGCDWu3E2Ze3M
         ZhmoyBSXjznfZMentPlVfvUwV0se4KZis6Mr1+oC0NgZ8oLQuEVINndrQRUX/CUbzl37
         VDOo1c5WshW1wJtQApT3lQBpNDqfH3k+WLWauQCCrququ31Iibz9EhroeKXPdvtQZ0Kh
         AEhrMcAF0kMALmqzwpSSsG6LIVYcCVBS20KyPdCvGomiNGpEzqr7V3Oe1qBfs4CfHOvU
         10FPT7cb98p1oCSxd5C4EQLEnJgMlb1Zg2vriqPTMrJ8S9ckbwrF+jIKCFfCSuU82Jg5
         YLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OIank4+rnOmnlQ1RvShvgHCzW0goS35nSXJDirD6hHQ=;
        b=iGzQ9OpgLVROClwGqufVvCuNX7u+GLUiXMajSYAF3dn94VeTDw4ym3NzU4J0fMw8nn
         nUx0+3LGUZSOKYSAU93xfDKocyGApvWU8v8644LG1j8u53zwd+9WVLrdcTOv1XsGDHlv
         xZkaOoFRuL5vQ+rH/w+eWNTHgKLZxNcdXxl0EA6T0KQiRGpe4kOTSdM5jsbKM72WesYn
         KAwL9+m93XPZ/m5hSfv6ftldVdPMjfZfPgynYbmIuBfVfL23DdiZomkKXhIh0DC3oX4V
         ifo9W968ykM1U47ZRUksQh7Mdm37cSjse9ivMH31NR3HWkZGsSBohjpe8G9KKL8JkSNN
         36Ag==
X-Gm-Message-State: AOAM532J4uzSbotQJTw/BtCK3OfsLa0xmbQgCmvoF6cDKG0mertodGlq
        OYSKsvnJA3UjYGfjN7SY0dSEvOI8ndg=
X-Google-Smtp-Source: ABdhPJxrHa2QnVBXMhHWPz++MnU2+7SnI6XIpMmLVWhzwJ/UIBP0pyl08QSt7pebc9DcM06cAIhWaA==
X-Received: by 2002:a92:4919:: with SMTP id w25mr2289289ila.198.1592978685516;
        Tue, 23 Jun 2020 23:04:45 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c20sm11190935iot.33.2020.06.23.23.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 23:04:44 -0700 (PDT)
Date:   Tue, 23 Jun 2020 23:04:36 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <5ef2ecf4b7bd9_37452b132c4de5bcc@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzZTWyii7k6MjdygJP+VfAHnnr8jbxjG1Ge96ioKq5ZEeQ@mail.gmail.com>
References: <20200623032224.4020118-1-andriin@fb.com>
 <20200623032224.4020118-2-andriin@fb.com>
 <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net>
 <CAEf4BzbsRyt5Y4-oMaKTUNu_ijnRD09+WW3iA+bfGLZcLpd77w@mail.gmail.com>
 <ee6df475-b7d4-b8ed-dc91-560e42d2e7fc@iogearbox.net>
 <20200623232503.yzm4g24rwx7khudf@ast-mbp.dhcp.thefacebook.com>
 <f1ec2d3b-4897-1a40-e373-51bed4fd3b87@fb.com>
 <CAEf4BzZTWyii7k6MjdygJP+VfAHnnr8jbxjG1Ge96ioKq5ZEeQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] selftests/bpf: add variable-length data
 concatenation pattern test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Tue, Jun 23, 2020 at 5:25 PM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 6/23/20 4:25 PM, Alexei Starovoitov wrote:
> > > On Tue, Jun 23, 2020 at 11:15:58PM +0200, Daniel Borkmann wrote:
> > >> On 6/23/20 10:52 PM, Andrii Nakryiko wrote:
> > >>> On Tue, Jun 23, 2020 at 1:39 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >>>> On 6/23/20 5:22 AM, Andrii Nakryiko wrote:
> > >>>>> Add selftest that validates variable-length data reading and concatentation
> > >>>>> with one big shared data array. This is a common pattern in production use for
> > >>>>> monitoring and tracing applications, that potentially can read a lot of data,
> > >>>>> but overall read much less. Such pattern allows to determine precisely what
> > >>>>> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> > >>>>>
> > >>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > >>>>
> > >>>> Currently getting the below errors on these tests. My last clang/llvm git build
> > >>>> is on 4676cf444ea2 ("[Clang] Skip adding begin source location for PragmaLoopHint'd
> > >>>> loop when[...]"):
> > >>>
> > >>> Yeah, you need 02553b91da5d ("bpf: bpf_probe_read_kernel_str() has to
> > >>> return amount of data read on success") from bpf tree.
> > >>
> > >> Fair point, it's in net- but not yet in net-next tree, so bpf-next sync needs
> > >> to wait.
> > >>
> > >>> I'm eagerly awaiting bpf being merged into bpf-next :)
> > >>
> > >> I'll cherry-pick 02553b91da5d locally for testing and if it passes I'll push
> > >> these out.
> > >
> > > I've merged the bpf_probe_read_kernel_str() fix into bpf-next and 3 extra commits
> > > prior to that one so that sha of the bpf_probe_read_kernel_str() fix (02553b91da5de)
> > > is exactly the same in bpf/net/linus/bpf-next. I think that shouldn't cause
> > > issue during bpf-next pull into net-next and later merge with Linus's tree.
> > > Crossing fingers, since we're doing this experiment for the first time.
> > >
> > > Daniel pushed these 3 commits as well.
> > > Now varlen and kernel_reloc tests are good, but we have a different issue :(
> > > ./test_progs-no_alu32 -t get_stack_raw_tp
> > > is now failing, but for a different reason.
> > >
> > > 52: (85) call bpf_get_stack#67
> > > 53: (bf) r8 = r0
> > > 54: (bf) r1 = r8
> > > 55: (67) r1 <<= 32
> > > 56: (c7) r1 s>>= 32
> > > ; if (usize < 0)
> > > 57: (c5) if r1 s< 0x0 goto pc+26
> > >   R0=inv(id=0,smax_value=800) R1_w=inv(id=0,umax_value=800,var_off=(0x0; 0x3ff)) R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=4,vs=1600,imm=0) R8_w=inv(id=0,smax_value=800) R9=inv800 R10=fp0 fp-8=mmmm????
> > > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > 58: (1f) r9 -= r8
> > > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > 59: (bf) r2 = r7
> > > 60: (0f) r2 += r1
> > > regs=1 stack=0 before 52: (85) call bpf_get_stack#67
> > > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > 61: (bf) r1 = r6
> > > 62: (bf) r3 = r9
> > > 63: (b7) r4 = 0
> > > 64: (85) call bpf_get_stack#67
> > >   R0=inv(id=0,smax_value=800) R1_w=ctx(id=0,off=0,imm=0) R2_w=map_value(id=0,off=0,ks=4,vs=1600,umax_value=800,var_off=(0x0; 0x3ff),s32_max_value=1023,u32_max_value=1023) R3_w=inv(id=0,umax_value=9223372036854776608) R4_w=inv0 R6=ctx(id=0?
> > > R3 unbounded memory access, use 'var &= const' or 'if (var < const)'
> > >
> > > In the C code it was this:
> > >          usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
> > >          if (usize < 0)
> > >                  return 0;
> > >
> > >          ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > >          if (ksize < 0)
> > >                  return 0;
> > >
> > > We used to have problem with pointer arith in R2.
> > > Now it's a problem with two integers in R3.
> > > 'if (usize < 0)' is comparing R1 and makes it [0,800], but R8 stays [-inf,800].
> > > Both registers represent the same 'usize' variable.
> > > Then R9 -= R8 is doing 800 - [-inf, 800]
> > > so the result of "max_len - usize" looks unbounded to the verifier while
> > > it's obvious in C code that "max_len - usize" should be [0, 800].
> > >
> > > The following diff 'fixes' the issue for no_alu32:
> > > diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > > index 29817a703984..93058136d608 100644
> > > --- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > > +++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > > @@ -2,6 +2,7 @@
> > >
> > >   #include <linux/bpf.h>
> > >   #include <bpf/bpf_helpers.h>
> > > +#define var_barrier(a) asm volatile ("" : "=r"(a) : "0"(a))
> > >
> > >   /* Permit pretty deep stack traces */
> > >   #define MAX_STACK_RAWTP 100
> > > @@ -84,10 +85,12 @@ int bpf_prog1(void *ctx)
> > >                  return 0;
> > >
> > >          usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
> > > +       var_barrier(usize);
> > >          if (usize < 0)
> > >                  return 0;
> > >
> > >          ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > +       var_barrier(ksize);
> > >          if (ksize < 0)
> > >                  return 0;
> > >
> > > But it breaks alu32 case.
> > >
> > > I'm using llvm 11 fwiw.
> > >
> > > Long term Yonghong is working on llvm support to emit this kind
> > > of workarounds automatically.
> > > I'm still thinking what to do next. Ideas?
> >
> 
> Funny enough, Alexei's fix didn't fix even no_alu32 case for me. Also
> have one of the latest clang 11...
> 
> > The following source change will make both alu32 and non-alu32 happy:
> >
> >   SEC("raw_tracepoint/sys_enter")
> >   int bpf_prog1(void *ctx)
> >   {
> > -       int max_len, max_buildid_len, usize, ksize, total_size;
> > +       int max_len, max_buildid_len, total_size;
> > +       long usize, ksize;
> 
> This does fix it, both alu32 and no-alu32 pass.
> 
> >          struct stack_trace_t *data;
> >          void *raw_data;
> >          __u32 key = 0;
> >
> > I have not checked the reason why it works. Mostly this confirms to
> > the function signature so compiler generates more friendly code.
> 
> Yes, it's due to the compiler not doing all the casting/bit shifting.
> Just straightforward use of a single register consistently across
> conditional jump and offset calculations.

Another option is to drop the int->long uapi conversion and write the
varlen test using >=0 tests. The below diff works for me also using
recent clang-11, but maybe doesn't resolve Andrii's original issue.
My concern is if we break existing code in selftests is there a risk
users will get breaking code as well? Seems like without a few
additional clang improvements its going to be hard to get all
combinations working by just fiddling with the types.

diff --git a/tools/testing/selftests/bpf/progs/test_varlen.c b/tools/testing/selftests/bpf/progs/test_varlen.c
index 0969185..01c992c 100644
--- a/tools/testing/selftests/bpf/progs/test_varlen.c
+++ b/tools/testing/selftests/bpf/progs/test_varlen.c
@@ -31,20 +31,20 @@ int handler64(void *regs)
 {
 	int pid = bpf_get_current_pid_tgid() >> 32;
 	void *payload = payload1;
-	u64 len;
+	int len;
 
 	/* ignore irrelevant invocations */
 	if (test_pid != pid || !capture)
 		return 0;
 
 	len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
-	if (len <= MAX_LEN) {
+	if (len >= 0) {
 		payload += len;
 		payload1_len1 = len;
 	}
 
 	len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
-	if (len <= MAX_LEN) {
+	if (len >= 0) {
 		payload += len;
 		payload1_len2 = len;
 	}
@@ -59,20 +59,20 @@ int handler32(void *regs)
 {
 	int pid = bpf_get_current_pid_tgid() >> 32;
 	void *payload = payload2;
-	u32 len;
+	int len;
 
 	/* ignore irrelevant invocations */
 	if (test_pid != pid || !capture)
 		return 0;
 
 	len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
-	if (len <= MAX_LEN) {
+	if (len >= 0) {
 		payload += len;
 		payload2_len1 = len;
 	}
 
 	len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
-	if (len <= MAX_LEN) {
+	if (len >= 0) {
 		payload += len;
 		payload2_len2 = len;
 	}
