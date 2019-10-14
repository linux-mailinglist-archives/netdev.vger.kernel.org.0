Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E77ED5D0E
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbfJNIDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:03:41 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33778 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfJNIDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 04:03:41 -0400
Received: by mail-ot1-f67.google.com with SMTP id 60so13055621otu.0;
        Mon, 14 Oct 2019 01:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CqA9RAEVuVLsdEpceBeXbSUIMHQCBuVjHd5ibwK3CzM=;
        b=qFbdfxfy0p1Uj5xKvEbwtoM8Rd33WV66/Iv+kOa0Ttj1wkXfT7IPrBBZz7GgMFags2
         gSN5cpYXZ/0hUeG722VXfqdcqSlvTSM4yTorti0UPYDoXMGFmcfvXsbGjTF55+c+osUn
         RCkiNRbkPm2J/tF9KNRBLeoE0mQTTHwkhX88lfNPbRuVS+2QFr8ebsWcZ3Ylz2v4kHGQ
         viTkoMbrU/M3M4OqhSR9gBve/iITqguloNEwmn5GJB4GRFeAVbo4GdDSz56yfSXnzjh+
         iCqzmH42W88tTNeGcLDIUaSszr4btz1jv6E/GVWgR7RVJB2I6jG8Y28BBnOpsQbZtWqO
         kLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CqA9RAEVuVLsdEpceBeXbSUIMHQCBuVjHd5ibwK3CzM=;
        b=VrtYpT9cq4zjn0OTa3sUJErq1lo1L/oy4TQLajSFgN18xptRp6NmNO5Ym4JNadhv8x
         JHxRrDgcGStNS7gyMTLN29vg5aSiVp9b9XYgxP27856/GTF9U26zSY5M/YX4BrpiMhWY
         VZ5ctr9/VGd8Cx8EF9S1WrQ9Jc9vd/DgdVglK0M5Ki+WnnQN9RIkToO4iC5PNQRkOvAg
         M29oOH4LF5K3izOC96WrWeVKOJm3UJe/3poUSqbje18PADkDDnX072qavqwQOouz4q4C
         ZIXficwM9qTAF8Ce9XHujX186yCpZmnX/S/TfPjeF+Tm32o0REs/xj9/Ij4b6dWkOdVL
         u3Iw==
X-Gm-Message-State: APjAAAWal7iP64uGpUN1EnnoRy/t+/lZjHnQQVexiQEFCLRKxSh7kRRx
        SEFgto4+xIEWgQNIymOgo9VpxAqdqp0g5pp4lMU=
X-Google-Smtp-Source: APXvYqypMsxN6WghIfZlyczYMDjh8ptI+MFPHgBxm31fPpsW+fNxLk8mCsXHQ72kBvnj4uuYu1c6D7/LqMeM2lEOtS0=
X-Received: by 2002:a9d:286:: with SMTP id 6mr9438950otl.192.1571040220554;
 Mon, 14 Oct 2019 01:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <1570695134-660-1-git-send-email-magnus.karlsson@intel.com> <CAADnVQ+R3S1OpRahy78hR2hDfxaWX=peSwturK9hCeP_+9yBbQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+R3S1OpRahy78hR2hDfxaWX=peSwturK9hCeP_+9yBbQ@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 14 Oct 2019 10:03:29 +0200
Message-ID: <CAJ8uoz0CWRavNXTrEhbS3tv1mkQD+VF7t=b-0VppO4c6Am_x8Q@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: improve documentation for AF_XDP
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 6:52 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Oct 10, 2019 at 1:12 AM Magnus Karlsson
> <magnus.karlsson@intel.com> wrote:
> >
> > Added sections on all the bind flags, libbpf, all the setsockopts and
> > all the getsockopts. Also updated the document to reflect the latest
> > features and to correct some spelling errors.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> thanks for the update. Overall looks good.
> Few nits below:

Will fix all your comments and send out a v2.

Thanks: Magnus

> > +What socket will then a packet arrive on? This is decided by the XDP
> > +program. Put all the sockets in the XSK_MAP and just indicate which
> > +index in the array you would like to send each packet to. A simple
> > +round-robin example of distributing packets is shown below:
> > +
> > +.. code-block:: c
> > +
> > +   #define KBUILD_MODNAME "af_xdp_example"
>
> what is this for?
> It's not a kernel module.
>
> > +   #include <uapi/linux/bpf.h>
>
> why 'uapi' ? It should use only user space headers.
>
> > +   #include "bpf_helpers.h"
> > +
> > +   #define MAX_SOCKS 16
> > +
> > +   struct bpf_map_def SEC("maps") xsks_map = {
> > +         .type = BPF_MAP_TYPE_XSKMAP,
> > +         .key_size = sizeof(int),
> > +         .value_size = sizeof(int),
> > +         .max_entries = MAX_SOCKS,
> > +   };
>
> Could you switch to BTF defined maps?
> libbpf will forever support old style as well,
> but documentation should point to the latest.
>
> > +
> > +   struct bpf_map_def SEC("maps") rr_map = {
> > +         .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> > +         .key_size = sizeof(int),
> > +         .value_size = sizeof(unsigned int),
> > +         .max_entries = 1,
> > +   };
> > +
> > +   SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> > +   {
> > +       int key = 0, idx;
> > +       unsigned int *rr;
> > +
> > +       rr = bpf_map_lookup_elem(&rr_map, &key);
> > +       if (!rr)
> > +          return XDP_ABORTED;
> > +
> > +       *rr = (*rr + 1) & (MAX_SOCKS - 1);
> > +       idx = *rr;
> > +
> > +       return bpf_redirect_map(&xsks_map, idx, 0);
> > +   }
> > +
> > +   char _license[] SEC("license") = "GPL";
>
> Above sample doesn't use gpl-only helpers. Why add above line?
>
> > +.. code-block:: c
> > +
> > +   if (xsk_ring_prod__needs_wakeup(&my_tx_ring))
> > +      sendto(xsk_socket__fd(xsk_handle), NULL, 0, MSG_DONTWAIT, NULL, 0);
> > +
> > +I.e., only use the syscall if the flag is set.
> > +
> > +We recommend that you always enable this mode as it can lead to
> > +magnitudes better performance if you run the application and the
> > +driver on the same core and somewhat better performance even if you
> > +use different cores for the application and the kernel driver, as it
> > +reduces the number of syscalls needed for the TX path.
>
> "magnitudes better performance"? Is it really at least 20 times better?
>
> > -Naive ring dequeue and enqueue could look like this::
> > +Naive ring dequeue and enqueue could look like this:
>
> lol. That's a good typo.
