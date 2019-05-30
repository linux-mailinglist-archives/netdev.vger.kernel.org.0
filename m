Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2FC30366
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 22:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfE3Umc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 16:42:32 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38835 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Umb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 16:42:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id l3so8728145qtj.5;
        Thu, 30 May 2019 13:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/bCRFrux5pdwM/eQQyMv7GDdYYyVvQy7m6pFv34PkSY=;
        b=F5ssoZwtzysXIDBPCSZplmgGEgEdxTreD3mjUqR/tk8jifXUNxqOH7nqNoImBps+et
         w/pDreTA38EdIofSxVKXDPW5kM16497mLEzsPa+B2lLY9gbwpqVzFxQE8r4I2iYhq0iw
         7oNYOS/5/sR4w2WsBREIvSnLRfC6ON0eSm3BCvoBY22+eYF7hzdLuE5y8S2qf8bIfp/5
         SqYjpDvu2lqJcVfqKTiDEHNXGuQuYBoIutSGlyQVNpLouNBLL1w411E+mlLmgV0ioxCq
         +qIWlDK1ITMIwKn/EZF45CaNCZVSLTtji12r2udJbifJ7uvKn2LItFU3zZNYR8M8PUbC
         O5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/bCRFrux5pdwM/eQQyMv7GDdYYyVvQy7m6pFv34PkSY=;
        b=HRKbhmqM8gcS0b8kYivdO2Coho8GoYwpcYp+z0CsRn5MYUnhZBw1ldkgM7b1zpIC2p
         4ioZxKRrUx7JauhYlaC3OhAieziNq0SsKWv0KOIghW43is1mUUzkCc2i3YTD4eZn2mPx
         uEx6Zq+RkkDKglT3poL0Ufzb5j+HTkJfalfiEvqgI6XPNYGNJZ0RUj2gMitn1o+zSv1K
         y05xCx4cYaGrZ8AIcOhGNJwzFe+IxYqRS48EHK6UxxwJHWvrG1IEHUhZFMXfPZAmYUeZ
         DTGFUc21rHjL4n2D5YSlrvcpaXNqhq5t/z4oPrWhJKfK8y35JMZWeniJRu3IPj8/VChU
         wTVg==
X-Gm-Message-State: APjAAAUcAroYEH0kkiCuCtY7+dAcjv6qBF8yPWO3PSx918lpU4GdEVMa
        Y+3VfU3F8NM0GKgN5eRliq3qvHLZlqGDqbiRZgw=
X-Google-Smtp-Source: APXvYqwk8NCHl5RAh/VcYRlRcCqByVC90TiGWVR+pLTcOv+xInn2XgmLBt0pJePEan8OwWJ1+eeopkhVzX40HfFE6Ns=
X-Received: by 2002:ac8:152:: with SMTP id f18mr5265664qtg.84.1559248950884;
 Thu, 30 May 2019 13:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <1559247798-4670-1-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1559247798-4670-1-git-send-email-jiong.wang@netronome.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 30 May 2019 13:42:19 -0700
Message-ID: <CAPhsuW7ycQWP3C-DSDznSLw6G9KY1iNq5Ms8AbvdF8Vk1TjVGQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: doc: update answer for 32-bit
 subregister question
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

On Thu, May 30, 2019 at 1:23 PM Jiong Wang <jiong.wang@netronome.com> wrote:
>
> There has been quite a few progress around the two steps mentioned in the
> answer to the following question:
>
>   Q: BPF 32-bit subregister requirements
>
> This patch updates the answer to reflect what has been done.
>
> v2:
>  - Add missing full stop. (Song Liu)
>  - Minor tweak on one sentence. (Song Liu)
>
> v1:
>  - Integrated rephrase from Quentin and Jakub
>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  Documentation/bpf/bpf_design_QA.rst | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
> index cb402c5..12a246f 100644
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
> +A: NO.
> +
> +But some optimizations on zero-ing the upper 32 bits for BPF registers are
> +available, and can be leveraged to improve the performance of JITed BPF
> +programs for 32-bit architectures.
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
