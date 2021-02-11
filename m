Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40F931860F
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 09:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhBKIEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 03:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhBKIDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 03:03:55 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563FDC061574;
        Thu, 11 Feb 2021 00:03:58 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id k13so3203191pfh.13;
        Thu, 11 Feb 2021 00:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ef/vgaDh7SV+KEY2BjoxfMR0OstqvLzTBvFrn95BsqU=;
        b=L1mRLpOXIs34YdnDMWovT0RZU3jPUATHTp1N2kTrirEeZvWILq6YF0BU9yNl1+tTSB
         O7quX1ONTjbZx5r7suaMW003mgWQ4AUVn+fnQQbaaCamgW3yrK+sNVRrVMG3355V9rGN
         twD1FI4rY4/E680WnhZUA9GrSUSGcbpIb4LKFDSTlOLmm7kQi0Kix3D8A0XQ8SP0Q5AD
         NXxzlMqk/37wSj4LtwwcSlZZ1lp8vGfqnzfvvhsqvqWttd+kTWlJOVOL+X9xbq0k5boD
         u9r2q6U3GDH3ZAOOrG8112LQrcsvCaezbaggRgsWCfiN3OypXivOgjqarWPeGGNIpd9W
         sfpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ef/vgaDh7SV+KEY2BjoxfMR0OstqvLzTBvFrn95BsqU=;
        b=JJHwaHxW/vzG/ErbCjkwzZyB3Ev8rLMlAFiZ/NWwkJTJMf9hjtqP3G15IbcX+OeUA1
         ZXSLSJe4Y+INlDqwy+RIOQ8HnZvmADU7iXMcdCxiNR8vRmep7KpBEhCtik1xg8x8ZZnR
         qYgqfj2VzamzAVl6es4i+aDg4Nvefou05d8p2DQMwEA0nn/kkPIc5/ZCQl+lanbg0xw+
         TA3udyDXJ/BnnO7eN8znMH+rq7quE203Eppgj1v5Oxj6JjAA5RHjHOuPizWiwUg4XizJ
         GNb17ibH0LZ3maF+1aYtcDyiskL7HFRBdQ0UC/8s/+p5Wf6ffxt9heGFERYuzn17LL8B
         /Rsg==
X-Gm-Message-State: AOAM532D5loFE8dhw7N2uLmbs6++ObC82N+gAUBEm+c4+iQ0jmcMba4w
        HyQVy5imSK/LMus9IJo4w5RnocsjqEHAXEy1ckE=
X-Google-Smtp-Source: ABdhPJwcmt3W1WJKAOOQCK0gCiQ5rWzMs1un0fVK9Hv+X0QnHERY57uhF790LkOi4sxAmgj/Ej3XWjil2zWH8Und4wI=
X-Received: by 2002:a65:450d:: with SMTP id n13mr7104740pgq.208.1613030637843;
 Thu, 11 Feb 2021 00:03:57 -0800 (PST)
MIME-Version: 1.0
References: <20210208090530.5032-1-ciara.loftus@intel.com>
In-Reply-To: <20210208090530.5032-1-ciara.loftus@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 11 Feb 2021 09:03:46 +0100
Message-ID: <CAJ8uoz3xr=SRjvKKhxuoRDSvQ_s4DYPHYT5V0ZOZ7zGWV95=SA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/6] AF_XDP Packet Drop Tracing
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>, song@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 10:39 AM Ciara Loftus <ciara.loftus@intel.com> wrote=
:
>
> This series introduces tracing infrastructure for AF_XDP sockets (xsk).
> A trace event 'xsk_packet_drop' is created which can be enabled by toggli=
ng
>
> /sys/kernel/debug/tracing/events/xsk/xsk_packet_drop/enable
>
> When enabled and packets or empty packet buffers are dropped in the kerne=
l,
> traces are generated which describe the reason for the packet drop, the n=
etdev
> and qid information of the xsk which encountered the drop, and some more
> information depending on what type of drop was encountered that will tell
> the user why the packet was dropped.  This information should help a user
> troubleshoot packet drops by providing an extra level of detail which is =
not
> available through use of simple counters
>
> Example traces:
> xsk_packet_drop: netdev: ve3213 qid 0 reason: packet too big: len 3000 ma=
x 2048 not_used 0
> xsk_packet_drop: netdev: ve3213 qid 0 reason: invalid fill addr: addr 520=
192 not_used 0 not_used 0
> xsk_packet_drop: netdev: ve9266 qid 0 reason: invalid tx desc: addr 0 len=
 4097 options 0
>
> It was decided to use a single event 'xsk_packet_drop' to capture these t=
hree
> drop types. This means that for some of them, there is some redundant inf=
ormation
> in the trace marked as 'not_used'. An alternative to this would be to int=
roduce 3
> separate event types under xsk, each with their own appropriate trace for=
mat.
> Suggestions are welcome on which approach would be better to take.
>
> The event can be monitored using perf:
> perf stat -a -e xsk:xsk_packet_drop
>
> A selftest is added for each drop type. These tests provide the condition=
s to
> trigger the traces and ensure that the appropriate traces are generated.

So what you have done now is to remove all the trace points that
provided no added information on top of the stats counters. The ones
you have left, provide extra information. The two  XSK_TRACE_INVALID_*
points provide the reason why the descriptor was dropped and
XSK_TRACE_DROP_PKT_TOO_BIG provides the size of the packet that was
dropped.

However, the XSK_TRACE_INVALID checks could be performed from user
space and the same data could be printed out from there. A developer
could add this, or we could have a verification mode in the ring
access functions in libbpf that could be turned on by the developer if
he sees the error counters in the kernel being increased. That only
leaves us with XSK_TRACE_DROP_PKT_TOO_BIG which cannot be tested by
user space since the ingress packet is being dropped by the kernel.
But this is unfortunately not enough to warrant this trace
infrastructure on its own, so I think we should drop this patch set.

But I would really like to salvage all your tests, because they are
needed. Instead of verifying the trace, could you please verify the
stats counters that are already there? A lot of your code will be
applicable for that case too. So my suggestion is that you drop this
patch set and  produce a new one that only focuses on selftests for
the XDP_STATISTICS getsockopt. You can add some of the tests you had
in your v2. What do you think?

Thank you.

> v4->v5:
> * Removed whitespace and renamed struct name in if_xdp.h as suggested by =
Song.
>
> v3->v4:
> * Fixed selftest commits with correct logs
> * Fixed warnings reported by W=3D1 build: trace argument types and print =
formatting
>
> v2->v3:
> * Removed some traces which traced events which were not technically drop=
s eg.
> when the rxq is full.
> * Introduced traces for descriptor validation on RX and TX and selftests =
for both
>
> v1->v2:
> * Rebase on top of Bj=C3=B6rn's cleanup series.
> * Fixed packet count for trace tests which don't need EOT frame.
>
> This series applies on commit 23a2d70c7a2f28eb1a8f6bc19d68d23968cad0ce
>
> Ciara Loftus (6):
>   xsk: add tracepoints for packet drops
>   selftests/bpf: restructure setting the packet count
>   selftests/bpf: add framework for xsk selftests
>   selftests/bpf: XSK_TRACE_DROP_PKT_TOO_BIG test
>   selftests/bpf: XSK_TRACE_INVALID_FILLADDR test
>   selftests/bpf: XSK_TRACE_INVALID_DESC_TX test
>
>  MAINTAINERS                                |   1 +
>  include/linux/bpf_trace.h                  |   1 +
>  include/trace/events/xsk.h                 |  71 +++++++
>  include/uapi/linux/if_xdp.h                |   6 +
>  kernel/bpf/core.c                          |   1 +
>  net/xdp/xsk.c                              |   7 +-
>  net/xdp/xsk_buff_pool.c                    |   3 +
>  net/xdp/xsk_queue.h                        |   4 +
>  tools/include/uapi/linux/if_xdp.h          |   6 +
>  tools/testing/selftests/bpf/test_xsk.sh    |  90 ++++++++-
>  tools/testing/selftests/bpf/xdpxceiver.c   | 206 +++++++++++++++++++--
>  tools/testing/selftests/bpf/xdpxceiver.h   |   9 +
>  tools/testing/selftests/bpf/xsk_prereqs.sh |   3 +-
>  13 files changed, 379 insertions(+), 29 deletions(-)
>  create mode 100644 include/trace/events/xsk.h
>
> --
> 2.17.1
>
