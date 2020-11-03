Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC4D2A4511
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 13:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgKCM1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 07:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgKCM1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 07:27:07 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A457C0613D1;
        Tue,  3 Nov 2020 04:27:07 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id o70so14686287ybc.1;
        Tue, 03 Nov 2020 04:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/oGvFRQbq4HreLrXjHnEtr7tAWzubMYz9Ycf6hG9M6Y=;
        b=PMqrhYu5rRVDsRsmZwdpvhUCtEaGa8UvENFKcH1PBZmbgvyJNsmKrgvE7ljueeMcLg
         NhV1VT1DSTdh4F9yel+w8GHjCDDsjJTY1KplwnQEGMs4G6U8arqlSDGKp0drghJKvM/Y
         9J7nXLfhSGKs0PurizR1TsmriKkZyh/4mDq1gd99YH/QAJO1BR6ZxlqNc+Yj1OE5/0p2
         kOoEY9igKRfbogRgaHq5D1BuiyNv20BI2zgkfsRb+tVnfkZaR1V1VyZXfCxPIDbZmYHb
         wh6cK7UmLZ6Cr0O9sPnwePWvYCO5zAjt62U/t1xswaj6wUNyAZ1lLH+PzH160TyfLQJ9
         tR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/oGvFRQbq4HreLrXjHnEtr7tAWzubMYz9Ycf6hG9M6Y=;
        b=t1iPwoFeHgDkzQXVx4KyoaHQy9vuwMaNBvR0QqlCIKYNnaon5mRaJWoekdanc/QyVi
         ci9QKG573OU3157MIrwssVE9jTy/XcgZSQc2+boRyg6H6t3qTFRRT9P5uFn8EcGBtXE0
         dQwwWeGWJ1OY5dkbGMah9J4a5wy3dbk+UK+M/n+I6lcHUAaH8IfiWNBY7OGRcnDKb2Vc
         wVmFlAbMx4o2QCvRgYmLUV7xR6X2wplFg6oJo7V11zJKxhDfyPMSLMGn5DaFDaFQU7oD
         6llN+TCou1TYQfS9BWDZAzmGVbfjVz8OGvdV3aoVLryO1p2J0l4E5MFsEZuFA/rW+866
         8oCw==
X-Gm-Message-State: AOAM533iEtZWzlpVjortBdjIKt6WEF+L0193zA7TcF9Oze6Tj05igpEV
        z7mrV69gMroJnga1ajF/mREHjUZen4XIFo3fsLA=
X-Google-Smtp-Source: ABdhPJxTjZ0FInF8gzileXbGEcynkRQ7h7V3u+6gpPHTLS21zRCkdqLqLCyaVG7AyYNf3KIkMk4IbzUXax6fobsYOzI=
X-Received: by 2002:a25:4757:: with SMTP id u84mr26255916yba.179.1604406426527;
 Tue, 03 Nov 2020 04:27:06 -0800 (PST)
MIME-Version: 1.0
References: <20201030121347.26984-1-weqaar.a.janjua@intel.com> <0fef6ce4-86cd-ae3a-0a29-953d87402afe@iogearbox.net>
In-Reply-To: <0fef6ce4-86cd-ae3a-0a29-953d87402afe@iogearbox.net>
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
Date:   Tue, 3 Nov 2020 12:26:40 +0000
Message-ID: <CAPLEeBa3PL03mW4STe_avwK8wr-KKu_epJ1uAM07OgMzUFJw1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/5] selftests/xsk: xsk selftests
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        jonathan.lemon@gmail.com, andrii.nakryiko@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 at 23:08, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/30/20 1:13 PM, Weqaar Janjua wrote:
> > This patch set adds AF_XDP selftests based on veth to selftests/xsk/.
> >
> > # Topology:
> > # ---------
> > #                 -----------
> > #               _ | Process | _
> > #              /  -----------  \
> > #             /        |        \
> > #            /         |         \
> > #      -----------     |     -----------
> > #      | Thread1 |     |     | Thread2 |
> > #      -----------     |     -----------
> > #           |          |          |
> > #      -----------     |     -----------
> > #      |  xskX   |     |     |  xskY   |
> > #      -----------     |     -----------
> > #           |          |          |
> > #      -----------     |     ----------
> > #      |  vethX  | --------- |  vethY |
> > #      -----------   peer    ----------
> > #           |          |          |
> > #      namespaceX      |     namespaceY
> >
> > These selftests test AF_XDP SKB and Native/DRV modes using veth Virtual
> > Ethernet interfaces.
> >
> > The test program contains two threads, each thread is single socket with
> > a unique UMEM. It validates in-order packet delivery and packet content
> > by sending packets to each other.
> >
> > Prerequisites setup by script TEST_PREREQUISITES.sh:
> >
> >     Set up veth interfaces as per the topology shown ^^:
> >     * setup two veth interfaces and one namespace
> >     ** veth<xxxx> in root namespace
> >     ** veth<yyyy> in af_xdp<xxxx> namespace
> >     ** namespace af_xdp<xxxx>
> >     * create a spec file veth.spec that includes this run-time configuration
> >       that is read by test scripts - filenames prefixed with TEST_XSK
> >     *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
> >         conflict with any existing interface.
> >
> > The following tests are provided:
> >
> > 1. AF_XDP SKB mode
> >     Generic mode XDP is driver independent, used when the driver does
> >     not have support for XDP. Works on any netdevice using sockets and
> >     generic XDP path. XDP hook from netif_receive_skb().
> >     a. nopoll - soft-irq processing
> >     b. poll - using poll() syscall
> >     c. Socket Teardown
> >        Create a Tx and a Rx socket, Tx from one socket, Rx on another.
> >        Destroy both sockets, then repeat multiple times. Only nopoll mode
> >         is used
> >     d. Bi-directional Sockets
> >        Configure sockets as bi-directional tx/rx sockets, sets up fill
> >         and completion rings on each socket, tx/rx in both directions.
> >         Only nopoll mode is used
> >
> > 2. AF_XDP DRV/Native mode
> >     Works on any netdevice with XDP_REDIRECT support, driver dependent.
> >     Processes packets before SKB allocation. Provides better performance
> >     than SKB. Driver hook available just after DMA of buffer descriptor.
> >     a. nopoll
> >     b. poll
> >     c. Socket Teardown
> >     d. Bi-directional Sockets
> >     * Only copy mode is supported because veth does not currently support
> >       zero-copy mode
> >
> > Total tests: 8.
> >
> > Flow:
> > * Single process spawns two threads: Tx and Rx
> > * Each of these two threads attach to a veth interface within their
> >    assigned namespaces
> > * Each thread creates one AF_XDP socket connected to a unique umem
> >    for each veth interface
> > * Tx thread transmits 10k packets from veth<xxxx> to veth<yyyy>
> > * Rx thread verifies if all 10k packets were received and delivered
> >    in-order, and have the right content
> >
> > Structure of the patch set:
> >
> > Patch 1: This patch adds XSK Selftests framework under
> >           tools/testing/selftests/xsk, and README
> > Patch 2: Adds tests: SKB poll and nopoll mode, mac-ip-udp debug,
> >           and README updates
> > Patch 3: Adds tests: DRV poll and nopoll mode, and README updates
> > Patch 4: Adds tests: SKB and DRV Socket Teardown, and README updates
> > Patch 5: Adds tests: SKB and DRV Bi-directional Sockets, and README
> >           updates
> >
> > Thanks: Weqaar
> >
> > Weqaar Janjua (5):
> >    selftests/xsk: xsk selftests framework
> >    selftests/xsk: xsk selftests - SKB POLL, NOPOLL
> >    selftests/xsk: xsk selftests - DRV POLL, NOPOLL
> >    selftests/xsk: xsk selftests - Socket Teardown - SKB, DRV
> >    selftests/xsk: xsk selftests - Bi-directional Sockets - SKB, DRV
>
> Thanks a lot for adding the selftests, Weqaar! Given this needs to copy quite
> a bit of BPF selftest base infra e.g. from Makefiles I'd prefer if you could
> place these under selftests/bpf/ instead to avoid duplicating changes into two
> locations. I understand that these tests don't integrate well into test_progs,
> but for example see test_tc_redirect.sh or test_tc_edt.sh for stand-alone tests
> which could be done similarly with the xsk ones. Would be great if you could
> integrate them and spin a v2 with that.
>
> Thanks,
> Daniel

Hi Daniel,

Appreciate the pointers and suggestions which I will re-evaluate
against merging of selftests/xsk into selftests/bpf, let me explain a
bit to get your opinion re-evaluated on this - perhaps selftests/xsk
could still work (as per my clarifications below) or we somehow have
selftests/bpf/Makefile trigger selftests/bpf/test_xsk/Makefile<or
whatever>.

I had a look at selftests/bpf earlier, the problem was the same as you
indicated - xsk tests do not integrate well into selftests/bpf as the
semantics in the top level Makefile for both do no merge well - the
way xsk tests are designed is systematically different.

If you look closely into the patch set patches -> 2/5 - 5/5, that is
where the major difference shows up, xsk/xdpprogs/xdpxceiver.* is a
self-contained binary utilized for testing and it is a major piece of
code:
tools/testing/selftests/xsk/xdpprogs/Makefile |   64 ++
 .../selftests/xsk/xdpprogs/Makefile.target    |   68 ++
 .../selftests/xsk/xdpprogs/xdpxceiver.c       | 1000 +++++++++++++++++
 .../selftests/xsk/xdpprogs/xdpxceiver.h       |  159 +++
...
 21 files changed, 1833 insertions(+)

Bits that -> copy quite a bit of BPF selftest base infra isn't the
top-level selftests/xsk/Makefile|*, it is these (patches -> 2/5 -
5/5):
tools/testing/selftests/xsk/xdpprogs/Makefile |   64 ++
 .../selftests/xsk/xdpprogs/Makefile.target    |   68 ++

This is 132++ of 1833++ or ~7% of similarity.

I had a look at these today, and some other tests earlier:
- test_tc_redirect.sh -> test_xdp_redirect.sh (perhaps you meant this?)
- test_tc_edt.sh

Patch 1/5 might look similar to these^^ as that sets up the base xsk
test framework, but the xsk tests really start with patches -> 2/5 -
5/5 which will give you a better picture, please let me know if this
clarifies my intent for selftests/xsk/, or otherwise if you insist
merging into selftests/bpf, I will then go ahead and work it out
accordingly.

Thanks,

/Weqaar
