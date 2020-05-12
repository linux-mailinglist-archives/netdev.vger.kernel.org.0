Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8701D01EA
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbgELWVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728351AbgELWVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:21:53 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCAFC061A0C;
        Tue, 12 May 2020 15:21:52 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id j2so12293242qtr.12;
        Tue, 12 May 2020 15:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IIhsxSwnBOc+KhhUmRUJvO8c9D0rX7TNXk0Cd+X/A/0=;
        b=Q8jPo5rMcRTg0GiJfYQxPUa4I/GeZFO0/aijEdXZK/LjckRAg1xjv9UbJlpEBjra4R
         w9TUyLGe31pYkEbCKqHX5FmaEQofn/2IMvX8YKbaujs3VAkosMJggpdovIKLbU05bfW5
         8nWqoAxs/NyiM1o3tdj2/DYU60Erjcx86FzEo/O7NSXJ8059GVX5oGjrNV3+doEuvQRT
         vRO3iGR1sdqURgXHmEWUijUnbpa9/QzcKYLdCp+6q+5hb00BA57/EvzQXS7RD7itgTbD
         VMDW5l8QBaGfIFjCJvilaH8vzT8tIlKL+1J25DpcXptwQEYdm9361p8siuHNo6oSGYDT
         bTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IIhsxSwnBOc+KhhUmRUJvO8c9D0rX7TNXk0Cd+X/A/0=;
        b=WrfTuNXBSli7qYMID2FcfGeeBPPf0kj1uPnF5DVgKY1YtvuCMJdXAELLb8ZzathZBf
         f58yvdJN4ORp0eWaXQSk9arMZEGtKB35MIXab5fqApJo1IMxKx9ufUn1Oe+aeRahk+WC
         KiaQAJDyqzJ7U637x/bs2NpGkN5jqJspC0hdmrTXu960uFZE0gR5g/0k1XUkM8yKICG7
         U7VzFao2VnDZpCmeUa5k5CF+GTgP4xVGnZhJbkYoQt3R0Ej0HJEE3TmenuTZliK64776
         /ScuLjN9fYu3MoZalFUbel8zcapIHUfrN85AZ4txYarEvR94egRgV8QPC6JWPNxJpknN
         x+jQ==
X-Gm-Message-State: AGi0PuYP0bx/KPMXDtH1cG03iQD+gtmh+pfb7TtyxuNzi14LgWf2WFxF
        QPet+TdbfUUAcY2IrEUc0TV9e9kLoepU56Wryxpd4Ive
X-Google-Smtp-Source: APiQypIzv7bPc0qYuVORSiLF03EM6wgfarozrQ4Uol70knAvhwwVm0ZVtlJNT3vhmniLBkhfVwUPHscnqyvG09wQ68M=
X-Received: by 2002:aed:24a1:: with SMTP id t30mr10586233qtc.93.1589322112109;
 Tue, 12 May 2020 15:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200512155232.1080167-1-yhs@fb.com> <20200512155234.1080379-1-yhs@fb.com>
In-Reply-To: <20200512155234.1080379-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 May 2020 15:21:41 -0700
Message-ID: <CAEf4BzbX77FFcSRR70GVKEViM3eD6zznFP5_tg_cVp5oN=JwAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/8] bpf: add comments to interpret bpf_prog
 return values
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 8:53 AM Yonghong Song <yhs@fb.com> wrote:
>
> Add a short comment in bpf_iter_run_prog() function to
> explain how bpf_prog return value is converted to
> seq_ops->show() return value:
>   bpf_prog return           seq_ops()->show() return
>      0                         0
>      1                         -EAGAIN
>
> When show() return value is -EAGAIN, the current
> bpf_seq_read() will end. If the current seq_file buffer
> is empty, -EAGAIN will return to user space. Otherwise,
> the buffer will be copied to user space.
> In both cases, the next bpf_seq_read() call will
> try to show the same object which returned -EAGAIN
> previously.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
