Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7421A4240
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 07:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgDJFeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 01:34:44 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:42629 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgDJFeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 01:34:44 -0400
Received: by mail-yb1-f194.google.com with SMTP id c13so649468ybp.9;
        Thu, 09 Apr 2020 22:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r7WVbVXkZUUgRb9qZ1L6gI7tsmu7BPZuljwnlAA4LGE=;
        b=UF6FYribBFezMdfvvEEdsT8m59ILjlwg8pexPnicQdLRGZPNmPkel6HwxWvwzxxS2i
         gAPlPnpe4E7bLf2C/vBqyqgNISlMfdscdBUybYUSqrQRtURVCqd4rakDpnsxrZMPxYLU
         R2d5NnfCBaMBmgNs2LqBR1EZC/JP63zW+mVazEu5RSCLd87LFM7f+ljelvaON+/zgpsx
         RAt7wH6UXAb8JK0BwxyQPczLz5JG4H0aDp19h8ZY73MuCxPtQ7No4kwe6AIcGIJHDsYX
         cewikqRUwx1T5vTWtPQTLX7burGwm1TfF9AKoLAIDGIsAOO1FpBRC1ZXF0TAZSkDS8Uq
         X0qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r7WVbVXkZUUgRb9qZ1L6gI7tsmu7BPZuljwnlAA4LGE=;
        b=HuhrTsrM4L9jGjtvQs4pnsi0QnQjxqiVKRgz/jh34Y5dWmDO4Uqp6J/HIa7peToQFu
         im4craCmgBIxfREbFhJm/GRdjL/A5mxN6mH51mloaazgR0FGLj8OkHg7UOmtdob4SByY
         fz5MZCcjN2HYvHBhkbWT2ZOuMDhfq8pJ/hG5AL5cZPTELgXmMHQTYSIs6i7sLOe54+/3
         rlYMslbnzu1iow6SxyReyjgCecAFQ8vDY+Q1atpehhgB2h5wVjfa2IIzZKYr4jrxUwML
         MXLyt+evpSwcpMGgcwgg9Fxqm/JtU8TfATY0t5mLVEfJfN7EkW5GJ4WjhTuqoMI0mUzO
         tbkg==
X-Gm-Message-State: AGi0PubIAeUHVbMZMMxHr9lk25cNOdVuxcs6kyIc6EvKP+pbMbWxuPD1
        JTR2rdLYw+Skqo7tLDvmOXTYDFvA7vygL7X+dA==
X-Google-Smtp-Source: APiQypLeHKl6uqXHg6PZjXC0mxcqvbxInetHMef7MUal1RpTHnVAvPx/ZLLaDrbndVdVwww/5F0z3WtfnSMSv68ELdQ=
X-Received: by 2002:a25:9d12:: with SMTP id i18mr5041676ybp.306.1586496883465;
 Thu, 09 Apr 2020 22:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200410020612.2930667-1-danieltimlee@gmail.com> <20200410050333.qshidymodw3oyn6k@kafai-mbp>
In-Reply-To: <20200410050333.qshidymodw3oyn6k@kafai-mbp>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 10 Apr 2020 14:34:27 +0900
Message-ID: <CAEKGpzgJces1DVrmKu2fXds1tVfthdFVz-xVbpLn89jHparV0g@mail.gmail.com>
Subject: Re: [PATCH] tools: bpftool: fix struct_ops command invalid pointer free
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will do, thanks for letting me know.
Thank you for your time and effort for the review.

Best,
Daniel

On Fri, Apr 10, 2020 at 2:03 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Apr 10, 2020 at 11:06:12AM +0900, Daniel T. Lee wrote:
> > From commit 65c93628599d ("bpftool: Add struct_ops support"),
> > a new type of command struct_ops has been added.
> >
> > This command requires kernel CONFIG_DEBUG_INFO_BTF=y, and for retrieving
> > btf info, get_btf_vmlinux() is used.
> >
> > When running this command on kernel without BTF debug info, this will
> > lead to 'btf_vmlinux' variable contains invalid(error) pointer. And by
> > this, btf_free() causes a segfault when executing 'bpftool struct_ops'.
> >
> > This commit adds pointer validation with IS_ERR not to free invalid
> > pointer, and this will fix the segfault issue.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> Fixes: 65c93628599d ("bpftool: Add struct_ops support")
> Acked-by: Martin KaFai Lau
>
> Thanks for the fix!  Please add the Fixes tag in the future.
