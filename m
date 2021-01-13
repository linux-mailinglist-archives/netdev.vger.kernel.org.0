Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67172F57C0
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbhANCF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729315AbhAMW3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 17:29:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 279D42339F
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 22:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610576945;
        bh=srLRPLK5YXTuhUWWEHIPjYvPj65Ukrwxe3nwgOVQ1H4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BDH1F9rcJtI4Q0+49LL11CWjXcM8SruYfVwIiIGJerbKhGRLAxcKLSAt+qK2b9KFF
         NwxaKjgnukIfeo109QKruQRNc66yXVrNVI1iY6hiWeIMR3u67hPoV7GA6VwA/jbk0J
         7Y0ypCT/Z8AeZT1DJvGC7jd60dKJb9CtD/9GuYhTRypi/ZkLv3wW7QEe0XXvAQwSzj
         GnNkrxSGKKlriE3ld8VSioPb8/BnIyB2ZNRXYYdxhYoZ3PCFcs/0szGB4aYVK7LstN
         fpftl9LRQ3A+HKOKdQywPy+0zOSWRtlBJZxEtTeMVTa/5G/OGeiFpAL3FfK6XBiku5
         6OrGLIfG73Q9g==
Received: by mail-lj1-f181.google.com with SMTP id u11so4320572ljo.13
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 14:29:05 -0800 (PST)
X-Gm-Message-State: AOAM533kj2wsnfVPkQWWX5ijPCaeda3FFO/+asP8ziNWF67z/f2fQ/Rd
        U0p4yaTC0VKCNAtygKmmEqAmdM5hk4Gpdor1kjO6fw==
X-Google-Smtp-Source: ABdhPJy1Ii5PE8b9neNCZi8w33t2B6xijbS6dW3x4eYy87VeFjivFp9gmChTGHBx06NwCCVvvuQ6Zbm2DUJmVRc5QZM=
X-Received: by 2002:a2e:9b1a:: with SMTP id u26mr1828558lji.187.1610576943394;
 Wed, 13 Jan 2021 14:29:03 -0800 (PST)
MIME-Version: 1.0
References: <20210113053810.13518-1-gilad.reti@gmail.com> <20210113053810.13518-2-gilad.reti@gmail.com>
 <c245e747-85e6-e9be-2dff-064f64555fd7@fb.com>
In-Reply-To: <c245e747-85e6-e9be-2dff-064f64555fd7@fb.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Wed, 13 Jan 2021 23:28:53 +0100
X-Gmail-Original-Message-ID: <CACYkzJ5_6Tux12V5hSigmLRYLg8qzM_kbOypeYx3rXPad3ZMiw@mail.gmail.com>
Message-ID: <CACYkzJ5_6Tux12V5hSigmLRYLg8qzM_kbOypeYx3rXPad3ZMiw@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/2] selftests/bpf: add verifier test for
 PTR_TO_MEM spill
To:     Yonghong Song <yhs@fb.com>
Cc:     Gilad Reti <gilad.reti@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 5:05 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/12/21 9:38 PM, Gilad Reti wrote:
> > Add a test to check that the verifier is able to recognize spilling of
> > PTR_TO_MEM registers, by reserving a ringbuf buffer, forcing the spill
> > of a pointer holding the buffer address to the stack, filling it back
> > in from the stack and writing to the memory area pointed by it.
> >
> > The patch was partially contributed by CyberArk Software, Inc.
> >
> > Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
>
> I didn't verify result_unpriv = ACCEPT part. I think it is correct
> by checking code.
>
> Acked-by: Yonghong Song <yhs@fb.com>

Thanks for the description!

Acked-by: KP Singh <kpsingh@kernel.org>
