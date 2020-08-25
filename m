Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47331250E2E
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 03:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgHYBZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 21:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgHYBZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 21:25:58 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26D7C061795;
        Mon, 24 Aug 2020 18:25:57 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id c15so5514374lfi.3;
        Mon, 24 Aug 2020 18:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jpy+rSx3coyHvf0g6hIeypuYpqa8oP10BXDs9xh41qM=;
        b=ryVk9vuPpSwNGdnQNdFbQ3QD9HAT9QzYuB4mGsXCREHyb9TETMffIvJgtHbwJ1D6UP
         KuyibYmYeTsHzqSPwAZ7IM3ImefPvC825bzFijw4oLdQVwxI7Y3gjMwjGDKLJMWy2hgK
         jO6AV4Mh4mQoiR6vyWPwpCWZNQ/zaXpbntgb/Bneml08MUNDPosduafgTksHGiIK0Ztg
         o5gVVQQN/hr5w2mQ/i0M2W5EwHlOf//EBa59DdZViV9/7QlO56/00xXyZtXKARHd0xvd
         ZJt7i6S5/olhJMBMfGBV3G0T62G4Z+NDh+OixQrTnP/B/9noSDO6Le1Hc7DGhZ3lwZDK
         Md6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jpy+rSx3coyHvf0g6hIeypuYpqa8oP10BXDs9xh41qM=;
        b=HSyxJCr7TerAmZlbKAOtBkum94HRlAeNQjtravEGnKKtgqr+uBnafEicP1fCIfAPM+
         /9sAifP0lvak0m4f30wn2b3d2GjXr+TEA8TBs4qZfmQELreC2Z1furEGEf1DhSRX3Z9i
         WoC816JV9a0umgki6/Uh83nAL3IJjvWOHZv3UeQEVIucGC0yNrJI1VmljyIcHBHQdwvY
         Uow4YCLncBsj0wxWhboG7FxlaPyXmPlen8Cq6wLEZtuX8miQJrZN+Kn1cNLKpeQ4Rn9+
         XJHjoVk0tjQ1d1ii5g57xUa9FKn6mDFvPguTs6j5rCjOKMtnmjjspGtmiA/JTpX+gKMV
         6TAA==
X-Gm-Message-State: AOAM532Isi6vhO9qxGn7G6E69AXozy20T4oSmOIy99/Fd7/OHpp0GM0I
        U9OKnIuysR7e5Ke660tIxK2ZBZQve31yNrdb6bKsmKplubQ=
X-Google-Smtp-Source: ABdhPJzK4oIDt75RqWFfSOL5JvMJ4HA7UQVacJrYLltQlmBOgqKplwE7cr9RpNmtLVFeSrI19uLRBrEHbYdf6WLlVI8=
X-Received: by 2002:a05:6512:3610:: with SMTP id f16mr3727857lfs.8.1598318755939;
 Mon, 24 Aug 2020 18:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200821111111.6c04acd6@canb.auug.org.au> <20200825112020.43ce26bb@canb.auug.org.au>
In-Reply-To: <20200825112020.43ce26bb@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Aug 2020 18:25:44 -0700
Message-ID: <CAADnVQLr8dU799ZrUnrBBDCtDxPyybZwrMFs5CAOHHW5pnLHHA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 6:20 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> On Fri, 21 Aug 2020 11:11:11 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi all,
> >
> > After merging the bpf-next tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >
> > Auto-detecting system features:
> > ...                        libelf: [  [31mOFF [m ]
> > ...                          zlib: [  [31mOFF [m ]
> > ...                           bpf: [  [32mon [m  ]
> >
> > No libelf found
> > make[5]: *** [Makefile:284: elfdep] Error 1
> >
> > Caused by commit
> >
> >   d71fa5c9763c ("bpf: Add kernel module with user mode driver that populates bpffs.")
> >
> > [For a start, can we please *not* add this verbose feature detection
> > output to the nrormal build?]
> >
> > This is a PowerPC hosted cross build.
> >
> > I have marked BPF_PRELOAD as BROKEN for now.
>
> Still getting this failure ...

I don't have powerpc with crosscompiler to x86 to reproduce.
What exactly the error?
bpf_preload has:
"depends on CC_CAN_LINK"
which is exactly the same as bpfilter.
You should have seen this issue with bpfilter for years now.
