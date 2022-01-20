Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88D0494744
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358705AbiATGZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiATGZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:25:30 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FC6C061574;
        Wed, 19 Jan 2022 22:25:30 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id v6so5769469iom.6;
        Wed, 19 Jan 2022 22:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+zqNsAToOm3edWbN/VwOAWMIUe2p5xGELgx3epyGqaE=;
        b=IA7LhGtJV02NhGf7gkRp+RIL7xVKQvFXg8HnFLsJp2mBsypzdj2oi4vAFwDrT6bvnF
         5kkV/JpAtx2QYSoz3TxHPtinXKSlc2qBUfK7YH/V18ACtlc7pIn05tf0QNDulJZQvG4K
         gTk8JAwf/SfITLoZAzfcUS0cJMD7SwIr1J6rE3wm6EYvTJLoTHJgzemhkrIWHWoKIdX9
         29IhTyAvXGlQ93BRvz4eCQarC+Wd1FeiDnA88bAfGzBmVAKezpdcm9da6KtmmD6O7a6s
         Ucrrj87MX9QWED8Yd3x8eqlTMYf5EMb9pvGidPfE57ggOy1dre2M3DYuzhUacXwmev8E
         SvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+zqNsAToOm3edWbN/VwOAWMIUe2p5xGELgx3epyGqaE=;
        b=sEFxkR/g74+E2YrpdXAEB+OZuSIjEXgbNth9YU2AqWShjASd84VPtbUWKmB8UukMMh
         A7aysfHgDmHMo9+2Oz25agF3AwJjA331pEzPvXVrju5Auvl4UZUbZkXLyAhCvjn3w5+z
         06Ey5jGEZcEGgqGDyhV5/0Idfw5DtPNgFkX3kANLepzg8wYnB8alxya3tYSoGoK68YnM
         xjUIEituaJww42JdWvdLX7KfNG8mnLx8WHUsp3JOXHaM9OcInOIOGUsyFHxcwvfYf4G/
         89q5ucM/Qb2mwTVehgaTWI3bDnGuAJc+kd471N7sx3P/kPbWmDQuVrbAQG9LRwWsOQYT
         LpWA==
X-Gm-Message-State: AOAM531uyljv/ir8zwYsYxngCm0URZNHq7gdPYOVK1XR7AbfDAIhsHVs
        5GvNChS3QlP9Hmuyin1fX4pRJix2dHzl7xlLBlnjrFAB
X-Google-Smtp-Source: ABdhPJy0COYGofV3Aehej3NMBdFvpBNoC+yMASkHst30WCGrsXkQucYBED2s6cNKAOEANRvEDGv/miU2mvcLlFpJPBw=
X-Received: by 2002:a6b:c891:: with SMTP id y139mr17453664iof.63.1642659929838;
 Wed, 19 Jan 2022 22:25:29 -0800 (PST)
MIME-Version: 1.0
References: <267a35a6-a045-c025-c2d9-78afbf6fc325@isovalent.com>
In-Reply-To: <267a35a6-a045-c025-c2d9-78afbf6fc325@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Jan 2022 22:25:18 -0800
Message-ID: <CAEf4Bzbu4wc9anr19yG1AtFEcnxFsBrznynkrVZajQT1x_o6cA@mail.gmail.com>
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

On Wed, Jan 19, 2022 at 6:47 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Hi, I have the pleasure to announce the availability of a mirror for
> bpftool on GitHub, at the following URL:
>
>     https://github.com/libbpf/bpftool
>

This is great! Thanks a lot for all the clean ups, fixes, and
improvements to make it possible to mirror bpftool to Github repo!

> This mirror is similar in spirit to the one for libbpf [0], and its
> creation was lead by the following motivations.
>
> 1. The first goal is to provide a simpler way to build bpftool. So far,
> building a binary would require downloading the entire kernel
> repository. By contrast, the code in the GitHub mirror is mostly
> self-sufficient (it still requires libelf and zlib, and uses libbpf from
> its mirror as a git submodule), and offers an easy way to just clone and
> compile the tool.

Yep, libbpf-bootstrap will benefit from this a lot. A bunch of people
already asked about multi-platform support there and the need to
precompile bpftool for each architecture was a big blocker. Now this
blocker is gone as we can just compile bpftool from sources easily.

Same story with libbpf-tools in BCC repo, btw.

>
> 2. Because it is easier to compile and ship, this mirror should
> hopefully simplify bpftool packaging for distributions.

Right, I hope disto packagers will be quick to adopt the new mirror
repo for packaging bpftool. Let's figure out bpftool versioning schema
as a next step. Given bpftool heavily relies on libbpf and isn't
really coupled to kernel versions, it makes sense for bpftool to
reflect libbpf version rather than kernel's. WDYT?

>
> 3. Another objective was to help other projects build on top of the
> existing sources for bpftool. I'm thinking in particular of
> eBPF-for-Windows, which has been working on a proof-of-concept port of
> the tool for Windows [1]. Bpftool's mirror keeps the minimal amount of
> necessary headers, and stripped most of them from the definitions that
> are not required in our context, which should make it easier to uncouple
> bpftool from Linux.
>
> 4. At last, GitHub's automation features should help implement CI checks
> for bpftool, very much like libbpf is using today. The recent work
> conducted on libbpf's CI and turning some of the checks into reusable
> GitHub Actions [2] may help for bpftool.
>
> Just to make it clear, bpftool's mirror does not change the fact that
> all bpftool development happens on the kernel mailing-lists (in
> particular, the BPF mailing-list), and that the sources hosted in the
> kernel repository remain the reference for the tool. At this time the
> GitHub repository is just a mirror, and will not accept pull requests on
> bpftool's sources.
>
> Regarding synchronisation, the repository contains a script which should
> help cherry-pick all commits related to bpftool from the kernel
> repository. The idea is to regularly align bpftool on the latest version
> from libbpf's mirror (that is to say, to cherry-pick all bpftool-related
> commits from bpf-next and bpf trees, up to the commit at which libbpf's
> mirror stopped), to avoid any discrepancy between the tool and the
> library it relies on.
>
> GitHub was the original home of bpftool, before Jakub moved it to
> kernel's tools/ with commit 71bb428fe2c1 ("tools: bpf: add bpftool")
> back in 2017. More than four years and five hundred commits later, it is
> time to have a stand-alone repository again! But over time, the build
> system and the header dependencies got somewhat intertwined, and
> extracting the tool again required a few careful steps. Some of them
> happened upstream: we addressed the licensing of a few bpftool
> dependencies, we switched to libbpf's hash map implementation (instead
> of kernel's), we fixed the way bpftool picks up the development headers
> from libbpf, and so on. Some other changes happened in the mirror, to
> adjust bpftool's Makefile and build system. In the end, I'm rather happy
> with the result: the main Makefile in bpftool's mirror only has a few
> minor changes with the reference one, and the C sources need no change
> at all. The tool you get from the mirror is the same as what you can
> compile from tools/bpf/bpftool/.
>
> I hope that this mirror will make it easier to work and develop with
> bpftool. Thanks to Andrii for his feedback, and to the folks behind
> libbpf's mirroring for their work, some of which I was happy to reuse.
>
> Best regards,
> Quentin
>
> [0] https://github.com/libbpf/libbpf
> [1] https://github.com/dthaler/bpftool
> [2] https://github.com/libbpf/ci
