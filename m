Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DA5493C2D
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355271AbiASOrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355276AbiASOrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:47:12 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB60C061746
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 06:47:11 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id c24so10828634edy.4
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 06:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:from
         :subject:cc:to:content-transfer-encoding;
        bh=uLtiCFrnbxLzDBjvVM11q4oTySGFMEXVuR5550fI/pM=;
        b=LB3IACun27DgykUjJrzxIV+DewIIH9Ilo9+6pjkmK0byeG1SDQl3p2rsJcpgbMPq3g
         JTXARlxR8L+NaWWkauKfcTwfSvdBbUEbgoKHa4UFxTQSf/U5XQsW2gXoPNrlhgQj2Wfa
         VWo5nPcB2oT0AqYuGHX/efxF9UmUGZk6/j3xaBKLq82WoGGrlFI9BbYndIo4dKTuZrPS
         2ql6uf1IOyXYJB7CvA+D2sC7OWFgFCBT2CyZWkNhS1si0AkaOCMZbqaBufAhohuJkkxB
         KJl41j6emSCfD1iURZ4tW4GgmJRvmNGUa4XXFxURXLaCtxT5RX6VJCNHlaE4oWfGN2QR
         EbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:subject:cc:to:content-transfer-encoding;
        bh=uLtiCFrnbxLzDBjvVM11q4oTySGFMEXVuR5550fI/pM=;
        b=Xr8iwCp8TpWrnSiCANXRhDtNoyi9jCzwmwy7161f0Qd5mZTnw2bfGpIzFUwkUU++eH
         zqeAIxuyPiwC6uiaI8tJBC0BGekugL0VLiFlFNJxNCepppWm2ispo8O+o4xK9lzlQo8i
         O0RrxLoWl/jNIIEG0bbwpEZNLybYB1gVSRYLy+oZuK872AA2cGjXcye8StUSLhfum+J5
         Dw9v+OaYzE2ssknCixS6bwIzsfyXF1CC7+bWaIQFSpNowB1sYufVi76pKiYmNEkWXijM
         HkNoV8sWt6iPYoN1+LzVeUnTTEBMl3lGuQ4037fFN+Iv2ODgl5cFcOcpAexk6EK55wmu
         wEJA==
X-Gm-Message-State: AOAM531S9i0gsevF71E1HH6HaR+bnMpk0LXcMLBNZpHN/5y7QCWyLFLX
        7RyUVF6WZ5jKPFyYncUMcghn4uuxd7EuvA==
X-Google-Smtp-Source: ABdhPJzOvughuMkcaIv/ad9A8IfV85SDoeVvcQUlH736ZnwEUzqnL21IF2VnWXW6APebqsQhk3eZZA==
X-Received: by 2002:a50:fb09:: with SMTP id d9mr2859541edq.300.1642603629671;
        Wed, 19 Jan 2022 06:47:09 -0800 (PST)
Received: from [192.168.1.8] ([149.86.87.21])
        by smtp.gmail.com with ESMTPSA id nc19sm266257ejc.154.2022.01.19.06.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 06:47:09 -0800 (PST)
Message-ID: <267a35a6-a045-c025-c2d9-78afbf6fc325@isovalent.com>
Date:   Wed, 19 Jan 2022 14:47:07 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-GB
From:   Quentin Monnet <quentin@isovalent.com>
Subject: Bpftool mirror now available
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dave Thaler <dthaler@microsoft.com>
To:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, I have the pleasure to announce the availability of a mirror for
bpftool on GitHub, at the following URL:

    https://github.com/libbpf/bpftool

This mirror is similar in spirit to the one for libbpf [0], and its
creation was lead by the following motivations.

1. The first goal is to provide a simpler way to build bpftool. So far,
building a binary would require downloading the entire kernel
repository. By contrast, the code in the GitHub mirror is mostly
self-sufficient (it still requires libelf and zlib, and uses libbpf from
its mirror as a git submodule), and offers an easy way to just clone and
compile the tool.

2. Because it is easier to compile and ship, this mirror should
hopefully simplify bpftool packaging for distributions.

3. Another objective was to help other projects build on top of the
existing sources for bpftool. I'm thinking in particular of
eBPF-for-Windows, which has been working on a proof-of-concept port of
the tool for Windows [1]. Bpftool's mirror keeps the minimal amount of
necessary headers, and stripped most of them from the definitions that
are not required in our context, which should make it easier to uncouple
bpftool from Linux.

4. At last, GitHub's automation features should help implement CI checks
for bpftool, very much like libbpf is using today. The recent work
conducted on libbpf's CI and turning some of the checks into reusable
GitHub Actions [2] may help for bpftool.

Just to make it clear, bpftool's mirror does not change the fact that
all bpftool development happens on the kernel mailing-lists (in
particular, the BPF mailing-list), and that the sources hosted in the
kernel repository remain the reference for the tool. At this time the
GitHub repository is just a mirror, and will not accept pull requests on
bpftool's sources.

Regarding synchronisation, the repository contains a script which should
help cherry-pick all commits related to bpftool from the kernel
repository. The idea is to regularly align bpftool on the latest version
from libbpf's mirror (that is to say, to cherry-pick all bpftool-related
commits from bpf-next and bpf trees, up to the commit at which libbpf's
mirror stopped), to avoid any discrepancy between the tool and the
library it relies on.

GitHub was the original home of bpftool, before Jakub moved it to
kernel's tools/ with commit 71bb428fe2c1 ("tools: bpf: add bpftool")
back in 2017. More than four years and five hundred commits later, it is
time to have a stand-alone repository again! But over time, the build
system and the header dependencies got somewhat intertwined, and
extracting the tool again required a few careful steps. Some of them
happened upstream: we addressed the licensing of a few bpftool
dependencies, we switched to libbpf's hash map implementation (instead
of kernel's), we fixed the way bpftool picks up the development headers
from libbpf, and so on. Some other changes happened in the mirror, to
adjust bpftool's Makefile and build system. In the end, I'm rather happy
with the result: the main Makefile in bpftool's mirror only has a few
minor changes with the reference one, and the C sources need no change
at all. The tool you get from the mirror is the same as what you can
compile from tools/bpf/bpftool/.

I hope that this mirror will make it easier to work and develop with
bpftool. Thanks to Andrii for his feedback, and to the folks behind
libbpf's mirroring for their work, some of which I was happy to reuse.

Best regards,
Quentin

[0] https://github.com/libbpf/libbpf
[1] https://github.com/dthaler/bpftool
[2] https://github.com/libbpf/ci
