Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B8EF8EE5
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfKLLsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:48:31 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35353 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfKLLsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:48:31 -0500
Received: by mail-yb1-f196.google.com with SMTP id h23so4319403ybg.2;
        Tue, 12 Nov 2019 03:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yVY9yrb3C1P+zfV8G421Hy75Ta/KGMP7j6KvRcYyDys=;
        b=qQZw6jNzaPPP9u+tV5HeU16nlI49M0EOyys1yW2c6qMfcVibsoAB2owxZ+p06WGWRw
         2xV3qrGrCOH8ZL0L9wv7TXBI/EH6p5fUKWFTJJRKQ5VANn+DktTIGDcHXdCOcM1Nbfty
         kRZtMXq13rN/7QtnSAwpwLZzLcwv2A6TmQuELhc3AMn7ahbwgjn/TDduZMdfgdipPWZB
         1UkpxiCvTLa+SKjzGESRG5RS2gMFCrRm6yyUQ5j/skwE1YoBMBj1gGIKIewh5qcWdPpS
         j9ZyEHSp2/2hzXuIgUkLCn2Z8bZsW7Ceh1AqwOis+SEEc4wUB2Ng95wR7zl6EpP3FIzY
         c+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVY9yrb3C1P+zfV8G421Hy75Ta/KGMP7j6KvRcYyDys=;
        b=sm1/qljbIR4FTSCWLFWNZyP7oApgGOBOyYnpcosWb1hDW3TBCbsSuKuWLZMeqFknru
         ZWcTmhxEm8FtPDmCSPSi8FrZ8/ZRXexZp8lwg7VA8/7poQwLXCFxmHmMQaRZK8cIO7Rr
         Ymu2e9YOf8GobCpVs0AlmqdxUIT/4pnLyW3SGE8yEIPM98LRjn6B8TtXtbRExJ9FjrRu
         mQf0ILTdVfzF+ATYmaztQjcFeSnYubG/hf29Ah5VKxQTn+K3fbFvWMhAwBmLw7FJxE0s
         fxseWHV9v8YioA2TMHnnhwyPb3qBmu2n0HraxdtqqpUIAbntSa6QnE910xOfqga6BMch
         bIug==
X-Gm-Message-State: APjAAAVt6g6zFc5cME+SRw9VJ/ukVAhmOgg17Gm3Z6ugsJrpSRfyTsHL
        bI0e7VQOn8jL8oitgoRwSmccw1tiyXin1QYWgg==
X-Google-Smtp-Source: APXvYqy4CsaKWciD27UD7n+TwdzDOmrkMqH/IyO5j38GtqYufQfFw+SrdzlP6t2L+LVHVxEICICndj6+hIDyOqi7ASw=
X-Received: by 2002:a25:145:: with SMTP id 66mr23306439ybb.180.1573559310302;
 Tue, 12 Nov 2019 03:48:30 -0800 (PST)
MIME-Version: 1.0
References: <20191110081901.20851-1-danieltimlee@gmail.com> <3db9a7b0-c218-693c-98c5-a45b69429b8a@iogearbox.net>
In-Reply-To: <3db9a7b0-c218-693c-98c5-a45b69429b8a@iogearbox.net>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 12 Nov 2019 20:48:15 +0900
Message-ID: <CAEKGpzgaMSFy9p8-j5UXsP6RCEYmqDq5CA0NEC1oSNr1ws=-7A@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: fix outdated README build command
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 10:58 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/10/19 9:19 AM, Daniel T. Lee wrote:
> > Currently, building the bpf samples under samples/bpf directory isn't
> > working. Running make from the directory 'samples/bpf' will just shows
> > following result without compiling any samples.
> >
> >   $ make
> >   make -C ../../ /git/linux/samples/bpf/ BPF_SAMPLES_PATH=/git/linux/samples/bpf
> >   make[1]: Entering directory '/git/linux'
> >     CALL    scripts/checksyscalls.sh
> >     CALL    scripts/atomic/check-atomics.sh
> >     DESCEND  objtool
> >   make[1]: Leaving directory '/git/linux'
> >
> > Due to commit 394053f4a4b3 ("kbuild: make single targets work more
> > correctly"), building samples/bpf without support of samples/Makefile
> > is unavailable. Instead, building the samples with 'make M=samples/bpf'
> > from the root source directory will solve this issue.[1]
> >
> > This commit fixes the outdated README build command with samples/bpf.
> >
> > [0]: https://patchwork.kernel.org/patch/11168393/
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> Thanks for the patch, Daniel! Looks like it's not rebased to the latest bpf-next
> tree and therefore doesn't apply cleanly.
>
> Meanwhile, https://patchwork.ozlabs.org/patch/1192639/ was sent which addresses
> the same issue.
>
> Best,
> Daniel

Thanks for the review.
Seems the issue has been already solved!
