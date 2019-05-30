Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8B0301A1
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfE3SQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:16:17 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43901 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfE3SQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:16:17 -0400
Received: by mail-qk1-f194.google.com with SMTP id m14so4503791qka.10;
        Thu, 30 May 2019 11:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HXX4EV/8xNoU9Sdh27c4Np9iv/07yW+jWe7HUpYM8MU=;
        b=gNJ5gKkejhZZwHb37QvMpiRNfbPBNK+sECH4rO87bFg4f+BncL0TcRQu4lJoAn2ZIg
         zne+t8QSbAxpfUrDqncR8c4AZTx3FCTD1KnTe5ejtdn8e3evs7QAu0lgBlH0TFYZL3KH
         MaoCJS+FuWwDDEaxkv49u7YBr+UuU/MQm7bg0KXmZqH8dHn+bmOgMxpogO9j2ppnToeh
         kVUeMo2NWIuoM898FsPAjv39ZlcsU11WDraAMnuGK8j2g8zWedgO7XbV2mZlzPG+n91e
         qAg49cDJa9HfxqhPVa+bwR5HDSY300oC0v+w4L3tcQnJKt1ymZz83d+yW0sGEfvHup7Y
         wxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HXX4EV/8xNoU9Sdh27c4Np9iv/07yW+jWe7HUpYM8MU=;
        b=KGX2zE4qM8ue63VjCBb3k/IEaCbY2LChTeuG6HDiRV4SNyto0MpmxqXQ9PS9NdFEnX
         9eSWuSwqaYb+dwEhcTvzSKIPAy4sVYlrfWP8dpsFE0rQM7H0ww8m8JdPPsqFBCeslBRO
         +ptIWlDRzvP+zCrnjcQZkN2Utg2CYVA9dDzFxVQZE9Jh3ghPhDk3iW1IVTEQlO5arMny
         QONxHYj0TJm7opXzHnyZVvOcD6/wUONgeMF72n++2QGs+dsttAZ5h53DWc3+4ajUZQQO
         nOysOa3RXbmNU3PrTcCK/TaqGWIH4L0lKYcP4NeTv4n07gOseIZ3lMdfzRKjxSRFiP4T
         DUcQ==
X-Gm-Message-State: APjAAAWuVKQVWgX3d+buXubSc70SK51QJa+Yb775iEL7EOrt83pRdJgz
        DSa7+6yk180tuRJakM7M/FE8xAbGnWpgYHrHk+4=
X-Google-Smtp-Source: APXvYqyiywQfVs1X2jbbr3hG7cR8I0d2CJVhb+OpCTeKdzIChJFJ/PwFcpDoUzAGk2idaTiRB0DgeVp1fJRN5HD1u+w=
X-Received: by 2002:ae9:ee0b:: with SMTP id i11mr4080848qkg.96.1559240176366;
 Thu, 30 May 2019 11:16:16 -0700 (PDT)
MIME-Version: 1.0
References: <1559202287-15553-1-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1559202287-15553-1-git-send-email-jiong.wang@netronome.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 30 May 2019 11:16:04 -0700
Message-ID: <CAPhsuW4cFacLYAF1=8sG3gxu-g+Rzz6ySaFeBmL-sttxLZZLHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: doc: update answer for 32-bit subregister question
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 12:46 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>
> There has been quite a few progress around the two steps mentioned in the
> answer to the following question:
>
>   Q: BPF 32-bit subregister requirements
>
> This patch updates the answer to reflect what has been done.
>
> v1:
>  - Integrated rephrase from Quentin and Jakub.
>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> ---
>  Documentation/bpf/bpf_design_QA.rst | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
> index cb402c5..5092a2a 100644
> --- a/Documentation/bpf/bpf_design_QA.rst
> +++ b/Documentation/bpf/bpf_design_QA.rst
> @@ -172,11 +172,31 @@ registers which makes BPF inefficient virtual machine for 32-bit
>  CPU architectures and 32-bit HW accelerators. Can true 32-bit registers
>  be added to BPF in the future?
>
> -A: NO. The first thing to improve performance on 32-bit archs is to teach
> -LLVM to generate code that uses 32-bit subregisters. Then second step
> -is to teach verifier to mark operations where zero-ing upper bits
> -is unnecessary. Then JITs can take advantage of those markings and
> -drastically reduce size of generated code and improve performance.
> +A: NO

Add period "."?

> +
> +But some optimizations on zero-ing the upper 32 bits for BPF registers are
> +available, and can be leveraged to improve the performance of JIT compilers
> +for 32-bit architectures.

I guess it should be "improve the performance of JITed BPF programs for 32-bit
architectures"?

Thanks,
Song

> +
> +Starting with version 7, LLVM is able to generate instructions that operate
> +on 32-bit subregisters, provided the option -mattr=+alu32 is passed for
> +compiling a program. Furthermore, the verifier can now mark the
> +instructions for which zero-ing the upper bits of the destination register
> +is required, and insert an explicit zero-extension (zext) instruction
> +(a mov32 variant). This means that for architectures without zext hardware
> +support, the JIT back-ends do not need to clear the upper bits for
> +subregisters written by alu32 instructions or narrow loads. Instead, the
> +back-ends simply need to support code generation for that mov32 variant,
> +and to overwrite bpf_jit_needs_zext() to make it return "true" (in order to
> +enable zext insertion in the verifier).
> +
> +Note that it is possible for a JIT back-end to have partial hardware
> +support for zext. In that case, if verifier zext insertion is enabled,
> +it could lead to the insertion of unnecessary zext instructions. Such
> +instructions could be removed by creating a simple peephole inside the JIT
> +back-end: if one instruction has hardware support for zext and if the next
> +instruction is an explicit zext, then the latter can be skipped when doing
> +the code generation.
>
>  Q: Does BPF have a stable ABI?
>  ------------------------------
> --
> 2.7.4
>
