Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E2B41EEEC
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhJANxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbhJANxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:53:11 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DC8C06177D
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:51:26 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id r4so20672567ybp.4
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5OYmL8JsTh62JE1sZQP92Eb1+8ePanIs7P1lJmaXQ50=;
        b=Zv5e0gqChaS9QuJ0veasmSAsT16UyrrpHwt6/VrYPjNAvUnUOu8R6T5cWeVbLb2DtV
         DGBlh/SbBS51eOTIuQy+RdYE2TX7sI0OOUM0MJ9+aLqGmEq+Oajo5xbJXCmnSvvO4lOU
         cVwN2IoNHLDFj3S1dFhaVv35on+R7IYDpoCbNrwvK6p8lLDI27S3lZFqhqkDX65WPpSD
         ZuZfH8sCTOOa2UXVO+CuxsNnVRDd7hi6Mp5q+LuHnr8KwDU9aQmNnu77fe1BmpOWD5j9
         G2bPwmq6kvE98m3VsiWfZFcQgyvHd3DfBL3hX3J2iIhEHGXIN2q7aFG075kVo1Qhm1Rz
         JVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5OYmL8JsTh62JE1sZQP92Eb1+8ePanIs7P1lJmaXQ50=;
        b=uttSFfsNk5sZsp/zNvVxQnZ/DcnmNaivR/dE/WJUt6y0Djv5TwQax+PD5e/aProP3Y
         dgMBhM8nYFMVAuCfmYepS5KpFiLLQJVUxKl1PfSRd5f73XFD/2cnGpgQFORnb7Ka9GmE
         f0X2nF/QDZ1AhAzZbcflHdEMIGgYguOfgPWTkZE2JhPoj2UNu4Wyr2r/9SGtRsjSJB/U
         WI5fKnoDgrR/wRM1pGcHShcHt1Cof8eND9TESSgJqjnmgnt2u5ZhUdmuATQwAKms1+ZN
         uSjSFhAgbu0OrhywfM/7tpNuuIhVi/swG7ySXIj10SsSLJ4un8ifw8n//uRPlKykeMWG
         0Mcg==
X-Gm-Message-State: AOAM531gIYBRJDk6WsGhLwj00gBVh/GqyE7eiUe+/L7aOe/QXTOdWXST
        gZ88KAsZTucxo0y/Nh54J9yqxjuVRA//Ia06yR8IhA==
X-Google-Smtp-Source: ABdhPJw/rtObxCo4kCza2w+WXFPHdxDNPvacsTKgpBXEOsdZ16FZLh7lUgjNTJm3pnvPFqq5B2vddCVwkR1kDSSeqQs=
X-Received: by 2002:a25:520b:: with SMTP id g11mr6485423ybb.268.1633096286107;
 Fri, 01 Oct 2021 06:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <1632999672-10757-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1632999672-10757-1-git-send-email-yangtiezhu@loongson.cn>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Fri, 1 Oct 2021 15:51:14 +0200
Message-ID: <CAM1=_QTb8zejZTqnAaobhTErkowBm=p-fuiLYwDFtWYoUuNGXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] test_bpf: add module parameter test_type
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tiezhu,

Your v2 is base64-encoded. Please use plain-text for patch submissions.

On Thu, Sep 30, 2021 at 1:01 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> After commit 9298e63eafea ("bpf/tests: Add exhaustive tests of ALU
> operand magnitudes"), when modprobe test_bpf.ko with jit on mips64,
> there exists segment fault due to fhe following reason:
>
> test_bpf: #616 ALU64_MOV_X: all register value magnitudes jited:1
> Break instruction in kernel code[#1]
>
> It seems that the related jit implementations of some test cases
> in test_bpf() have problems. At this moment, I do not care about
> the segment fault while I just want to verify the test cases of
> tail calls.

Don't put too much effort into the current MIPS64 JIT. I have been
working on a significant upgrade of the MIPS JIT, which adds MIPS32
support and full eBPF ISA support, among other things. All the new JIT
tests in test_bpf.ko I submitted are essentially a side effect of that
work.

I am currently testing the new JIT on different setups, and I hope to
be able to submit the patch set next week. A side note, as you seem to
work at Loongson. It would be great if you could verify the CPU errata
workarounds I implemented for Loongson-2F and 3, once I get the patch
set out for review.

>
> Based on the above background and motivation, add the following
> module parameter test_type to the test_bpf.ko:
> test_type=<string>: only the specified type will be run, the string
> can be "test_bpf", "test_tail_calls" or "test_skb_segment".
>
> This is useful to only test the corresponding test type when specify
> the valid test_type string.

I agree that it is good to be able to choose a particular test suite
to run. There are also the test_id and test_range parameters. If we
add a test suite selector, it would be nice if the test range/id
selection applied to that test suite, instead of being ignored for all
suites except test_bpf.

>
> Any invalid test type will result in -EINVAL being returned and no
> tests being run. If the test_type is not specified or specified as
> empty string, it does not change the current logic, all of the test
> cases will be run.
>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  lib/test_bpf.c | 48 +++++++++++++++++++++++++++++++++---------------
>  1 file changed, 33 insertions(+), 15 deletions(-)
>
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index 21ea1ab..9428fec 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -11866,6 +11866,9 @@ module_param(test_id, int, 0);
>  static int test_range[2] = { 0, ARRAY_SIZE(tests) - 1 };
>  module_param_array(test_range, int, NULL, 0);
>
> +static char test_type[32];
> +module_param_string(test_type, test_type, sizeof(test_type), 0);
> +
>  static __init int find_test_index(const char *test_name)
>  {
>         int i;
> @@ -12518,24 +12521,39 @@ static int __init test_bpf_init(void)
>         struct bpf_array *progs = NULL;
>         int ret;
>
> -       ret = prepare_bpf_tests();
> -       if (ret < 0)
> -               return ret;
> +       if (strlen(test_type) &&
> +           strcmp(test_type, "test_bpf") &&
> +           strcmp(test_type, "test_tail_calls") &&
> +           strcmp(test_type, "test_skb_segment")) {
> +               pr_err("test_bpf: invalid test_type '%s' specified.\n", test_type);
> +               return -EINVAL;
> +       }
> +
> +       if (!strlen(test_type) || !strcmp(test_type, "test_bpf")) {
> +               ret = prepare_bpf_tests();
> +               if (ret < 0)
> +                       return ret;
> +
> +               ret = test_bpf();
> +               destroy_bpf_tests();
> +               if (ret)
> +                       return ret;
> +       }
>
> -       ret = test_bpf();
> -       destroy_bpf_tests();
> -       if (ret)
> -               return ret;
> +       if (!strlen(test_type) || !strcmp(test_type, "test_tail_calls")) {
> +               ret = prepare_tail_call_tests(&progs);
> +               if (ret)
> +                       return ret;
> +               ret = test_tail_calls(progs);
> +               destroy_tail_call_tests(progs);
> +               if (ret)
> +                       return ret;
> +       }
>
> -       ret = prepare_tail_call_tests(&progs);
> -       if (ret)
> -               return ret;
> -       ret = test_tail_calls(progs);
> -       destroy_tail_call_tests(progs);
> -       if (ret)
> -               return ret;
> +       if (!strlen(test_type) || !strcmp(test_type, "test_skb_segment"))
> +               return test_skb_segment();
>
> -       return test_skb_segment();
> +       return 0;
>  }
>
>  static void __exit test_bpf_exit(void)
> --
> 2.1.0
>
