Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFC4497EBE
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238933AbiAXMNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238451AbiAXMNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:13:22 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDD5C06173D
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 04:13:21 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id f17so13192102wrx.1
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 04:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GhtPulvMMvxVxHkXwmGN5OOcWf+zin1IuANHI429XiA=;
        b=vhUdBa5e5phGf16M7X10ivFsYKMNEs2uEM8QWXX/wJVqAH/4jXakcZHThDNvpiGa9y
         iP1xIcc9pg0yUXT0MxsEMcZNOgLKWLSy+vfNn03zjPA9DGAaDEz1oMth5wKN+SXRFYBm
         Bdsub7CS9NIkvS6KjivyqjTxrqYHzDf03OB7OK06PU0LB2sjdA0QemKbgJZGdDzi2KOV
         q8+DSRcJWgSiP00hfeZQHYLA+FyfTEEAydZwNmBNBo+z4ne27b2gsrLlSWgiOjPeCQPI
         5ZM90M4dyQNf1iVPvX8Wyp0LNIUmtMPDbano943c203sB6Kq2hAiFZSlFoIWCtXPpWIa
         l7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GhtPulvMMvxVxHkXwmGN5OOcWf+zin1IuANHI429XiA=;
        b=h3Gl7xM38qTa9Ejf32MED3Hh7NNSHU7iO4a+bzk9VXPmT39tZIr9VqmOWJ4Yxq7Hai
         pTZ5Uqw0rJ5ZYAKxZpndz1f+8wb8Y1l1ZRfvqEPfFqMowVHFxQoouix0+vMIt/A7LdWT
         BtevvNgXr61lneFZ9iS0TcChTlVUyRBWbDo0lYGuTm4ImKY8/SjTF8Hu5DyqzneHffbP
         O0k0PcHbjCwEAV4kR9Vk2gLobLAlrdCyicYG0BSyuc9Wn0kE5dEgHJEeEEAfi5PknXwk
         g+G40uOZgM55ylFLkO5o4Sw5S1txKQ3+4TeCoQWatsQOiBHpv6R/1F4Epq2PUahM9x0S
         Q0MA==
X-Gm-Message-State: AOAM533UQM/s2ghdOBbWUlQzFAsMUIHE6PDPEyyDkqzS4HM0+2wu5T5H
        Ltl4G1aCYIYC404O0NLYDSKJUH7qy6XhGA==
X-Google-Smtp-Source: ABdhPJwzeVQ7KfAPHIdf5+7iuGzzghyIeHx+bc5IqXQTmjaqrqIAMfEAcZZLqeEcriSQzGWy/ESgcA==
X-Received: by 2002:adf:fc0c:: with SMTP id i12mr5308402wrr.173.1643026400470;
        Mon, 24 Jan 2022 04:13:20 -0800 (PST)
Received: from [192.168.1.8] ([149.86.85.114])
        by smtp.gmail.com with ESMTPSA id v3sm6333055wru.15.2022.01.24.04.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 04:13:19 -0800 (PST)
Message-ID: <127cb5f6-a969-82df-3dff-a5ac288d7043@isovalent.com>
Date:   Mon, 24 Jan 2022 12:13:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Bpftool mirror now available
Content-Language: en-GB
To:     Dave Thaler <dthaler@microsoft.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <267a35a6-a045-c025-c2d9-78afbf6fc325@isovalent.com>
 <CH2PR21MB14640448106792E7197A042CA35A9@CH2PR21MB1464.namprd21.prod.outlook.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CH2PR21MB14640448106792E7197A042CA35A9@CH2PR21MB1464.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-01-20 14:19 UTC+0000 ~ Dave Thaler <dthaler@microsoft.com>
> Quentin Monnet <quentin@isovalent.com> wrote:
>> Hi, I have the pleasure to announce the availability of a mirror for bpftool on GitHub, at the following URL:
>> [...]
>> 3. Another objective was to help other projects build on top of the existing sources for bpftool. I'm thinking in
>> particular of eBPF-for-Windows, which has been working on a proof-of-concept port of the tool for Windows [1]. 
>> Bpftool's mirror keeps the minimal amount of necessary headers, and stripped most of them from the definitions
>> that are not required in our context, which should make it easier to uncouple bpftool from Linux.
>> [...]
>> Just to make it clear, bpftool's mirror does not change the fact that all bpftool development happens on the
>> kernel mailing-lists (in particular, the BPF mailing-list), and that the sources hosted in the kernel repository
>> remain the reference for the tool. At this time the GitHub repository is just a mirror, and will not accept pull
>> requests on bpftool's sources.
> 
> Thanks Quentin, this is a great first step!   I can update the ebpf-for-windows project to use this as a submodule.
> 
> Longer term, is the goal to make the mirror be the authoritative reference, or to make the Linux kernel repository
> not be Linux-only but accept non-Linux patches to bpftool?

Hi Dave, longer term goals have not been established yet, and the
discussion about what happens to bpftool next still needs to happen. I
understand that you have been working on making bpftool cross-OS, and
that this raises the question of how to contribute Windows-related
patches upstream.

Moving bpftool out of the kernel and into its own tree (whether on
GitHub or on kernel.org) would make sense to me, although it comes with
a number of things to sort out. First, bpftool is now being used
directly by a number of components in the kernel, for loading programs
or for its ability to generate BPF skeletons for programs. As far as I
can tell, this concerns the following items:

- The kernel itself, when configured with CONFIG_BPF_PRELOAD, requires
bpftool to build, because BPF pre-loaded iterators rely on BPF skeletons
(see kernel/bpf/preload/iterators/Makefile).

- BPF samples and selftests (samples/bpf/Makefile,
tools/bpf/runqslower/Makefile) use BPF for a number of use cases.

- Other tools hosted in the kernel repository, in particular runqslower
(tools/bpf/runqslower/Makefile) and perf (tools/perf/Makefile.perf), use
bpftool to produce BPF skeletons as well.

As far as I can tell, the above do not rely on cutting-edge bpftool
features, and they could maybe be adjusted to consider bpftool as an
external dependency for BPF, somewhat like pahole or clang/LLVM have
been so far.

Another thing to consider is that keeping bpftool next to the kernel
sources has been useful to help keeping the tool in sync, for example
for adding new type names to bpftool's lists when the kernel get new
program/map types. We have recently introduced some CI checks that could
be adjusted to work with an external repo and mitigate this issue, but
still, it is harder to tell people to submit changes to a second
repository when what they want is just to update the kernel. I fear this
would result in a bit more maintenance on bpftool's side (but then
bpftool's requirements in terms of maintenance are not that big when
compared to bigger tools, and maybe some of it could be automated).

Then the other solution, as you mentioned, would be to take
Windows-related patches for bpftool in the Linux repo. For what it's
worth, I don't have any personal objection to it, but it raises the
problems of testing and ownership (who fixes bugs) for these patches.
I'm also unsure what it would mean in terms of development workflow:
would Windows-related contributions be reviewed and tested beforehand,
and treated somewhat like vendor code, or would all the discussions
(Windows-related bug reports, contributions to Windows support but
external to Microsoft, etc.) happen on the BPF mailing list?

If we want bpftool to become fully cross-OS, my feeling is that it would
be maybe more work, but more sensible to move it outside of the kernel
tree (although this does not have to be immediate, obviously - let's see
how the Windows port is doing first). However, this decision is not mine
alone to take, and the maintainers will surely have their say in it
(this could also be a topic for you to raise at the next BSC meeting, I
guess). I hope the considerations above can help for this discussion.

Best regards,
Quentin
