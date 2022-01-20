Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A155495498
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 20:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377392AbiATTIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 14:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346936AbiATTIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 14:08:11 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B300C061574;
        Thu, 20 Jan 2022 11:08:10 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id s11so8083627ioe.12;
        Thu, 20 Jan 2022 11:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c+32A77SAS8JOBp65RSQcGqcTi5g/XrAgKrbyrEwA5I=;
        b=Uv70c5YW2JjG4J4DNfh9EeK8tvUNkxWKiW4sdE7oYBjKMYy6TWL6QZXR5eCwNvJJPK
         iWGRx5YrkZZpxBPsTxe60ab+ggAWITdDuUZKJ0vPv8qL1zfe2jNvwFD7CGwN4sxcBbA3
         ROVn1WK7RHKrXvBMtT1ZBbE+D0+5w+cFUoPuOjbkld0R+ztSDsEijQ7YnYymg0Azaqzy
         R8FwosuiujRomBG8sP6atdX26mHieVUIiQxcXEEHPO2vshyRSSNbZlhJubIecAq1t4BQ
         LXMvEgTsKuNVIERFfUN84KoCv9To7i+OgbTxPEFV2+calssgF8hOKToC38z8E+zpTAqe
         ptoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c+32A77SAS8JOBp65RSQcGqcTi5g/XrAgKrbyrEwA5I=;
        b=FBH64kFbaMlpUv4tocJCnPRfEko6nBc/rP1bgbAM2SWDxO/YQ4H9Hx9WPFVIu1pGeJ
         +lYcWRgJ6ArOzABg2iUNFbjyPf3XUXNxtltsO4Q7RUFSBB7+fvoksEAE99TveGdx587v
         ceRRxCCbhnmjfPWTWGj7kd7sAuVdOKqJIvB3wX16N6hpkud+OZ5Qreu9XoLynKt9if/C
         FFIdunZ8qtR94y6TNeymYFInJ9vtDyjVSj96ZyHxcV1B0aElHfwdMTkSsSmutEeL4Igj
         ugGgncF5+efq9cEuXzUoD1vxvrmintae6qCx2tyY9X0j4aOMg12co4O/WbRXFMbGtnrt
         p1lA==
X-Gm-Message-State: AOAM532kDaVYVXR7uO/Besb8ujBMA8s86DXbyzJrIgJDTo1+8FMgjL1t
        GP4ViC9HyyHOjD9OmjpjRJoHMDz4Xv4URIW2Ww4=
X-Google-Smtp-Source: ABdhPJzuNrj9j8UouuqH6KAxX9EkTLqxtyRrMoq4dxPLpQ26fKRNa3K/g5iPIica6P9Bxi4f+TI7qq7UUx/ZM3MQ0ec=
X-Received: by 2002:a02:bb8d:: with SMTP id g13mr88386jan.103.1642705689957;
 Thu, 20 Jan 2022 11:08:09 -0800 (PST)
MIME-Version: 1.0
References: <267a35a6-a045-c025-c2d9-78afbf6fc325@isovalent.com>
 <CAEf4Bzbu4wc9anr19yG1AtFEcnxFsBrznynkrVZajQT1x_o6cA@mail.gmail.com> <ac3f95ed-bead-e8ea-b477-edcbd809452c@isovalent.com>
In-Reply-To: <ac3f95ed-bead-e8ea-b477-edcbd809452c@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Jan 2022 11:07:58 -0800
Message-ID: <CAEf4BzaiUbAT4hBKTVYadGdygccA3c6jgPsu8VW9sLo+4Ofsvw@mail.gmail.com>
Subject: Re: Bpftool mirror now available
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dave Thaler <dthaler@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 4:35 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2022-01-19 22:25 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Wed, Jan 19, 2022 at 6:47 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> [...]
>
> >> 2. Because it is easier to compile and ship, this mirror should
> >> hopefully simplify bpftool packaging for distributions.
> >
> > Right, I hope disto packagers will be quick to adopt the new mirror
> > repo for packaging bpftool. Let's figure out bpftool versioning schema
> > as a next step. Given bpftool heavily relies on libbpf and isn't
> > really coupled to kernel versions, it makes sense for bpftool to
> > reflect libbpf version rather than kernel's. WDYT?
>
> Personally, I don't mind finding another scheme, as long as we keep it
> consistent between the reference sources in the kernel repo and the mirror.
>
> I also agree that it would make sense to align it to libbpf, but that
> would mean going backward on the numbers (current version is 5.16.0,
> libbpf's is 0.7.0) and this will mess up with every script trying to
> compare versions. We could maybe add a prefix to indicate that the
> scheme has changed ('l_0.7.0), but similarly, it would break a good
> number of tools that expect semantic versioning, I don't think this is
> any better.
>
> The other alternative I see would be to pick a different major version
> number and arbitrarily declare that bpftool's version is aligned on
> libbpf's, but with a difference of 6 for the version number. So we would
> start at 6.7.0 and reach 7.0.0 when libbpf 1.0.0 is released. This is
> not ideal, but we would keep some consistency, and we can always add the
> version of libbpf used for the build to "bpftool version"'s output. How
> would you feel about it? Did you have something else in mind?

Yeah, this off-by-6 major version difference seems ok-ish to me, I
don't mind that. Another alternative is to have a completely
independent versioning (and report used libbpf version in bpftool
--version output  separately). But I think divorcing it from kernel
version is a must, too much confusion.

>
> Quentin
