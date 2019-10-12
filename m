Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8FE0D5122
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 18:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfJLQt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 12:49:27 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37850 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbfJLQr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 12:47:27 -0400
Received: by mail-lj1-f194.google.com with SMTP id l21so12721503lje.4;
        Sat, 12 Oct 2019 09:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kTdwaQRFbVDfnq6Vp7P5rNxyn+Gdc8czzlvvQmZ0VSI=;
        b=DJXe9U+AGX38FLHtt6vYKdx7ASWCzQtyiU6n+qy+eeO6ja8n9vNSRfVXDzvJHI+URJ
         I1mvYPkx3nqQ1SwJ6v7JvK5fHg+sLGyPsU+EaZrH5Wf6PeSuy0XKMTis+7jno5azoyzx
         dQ8R8LOMxZ1BOWdgLCknISPJ+peJ8Z1pliG+o4AfE0DUUa3I2LZE8nWVJLsp/Rnfw6zY
         BqD5JIqV1q1fRPPT4yoaIiXiHF5tD7b5pucZf7ZsrE6naBDPJ4qsHlIHsTXoFLSlgYJ5
         Pg1SAUDz3pIObEkY9bZ+vA9fPxk4WM3jZCkI3k+izF5GtpTkqUQNb5iQiKHXMonUy7cT
         llyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kTdwaQRFbVDfnq6Vp7P5rNxyn+Gdc8czzlvvQmZ0VSI=;
        b=dl+yj2kRjqmXK7OhD9TL63vVE4HY8pwuyQhWIkA2PhYd4b6+rPBbM+2YMN3IMpNunE
         luI6MgRU1TpgT/mD5XUnwG0ZomndEWUcR+2cWf0tmXfqZQwZqAHgj70NpC1E+/OYEShJ
         klaqPqdeUevHzqboTKDgL1NmzyREO61UIVaZC3m2sKTPLIlz4F284d3qsGuTE57qUaip
         LU55RQyvjC+NhMkSwdZ/c1XRO7SDQ56zIhvQaTCSUevOQNF8ZLb99OgB2dU4G0E889dS
         dgpJ+kznhfoOdqnwJ4QKakUO6B1x9ngCiCayZQXNvl7NDTT9abDmbfajlJJnDfQ3li6u
         GTEQ==
X-Gm-Message-State: APjAAAWuXdTbaagipIRLcdefwi8cSu1vjzQDvgbiDGvbXxRBuq24V7R3
        c2oaHestCwaCV64D5lLFsK/z3w04t4e69PTrG0o=
X-Google-Smtp-Source: APXvYqytWqgymdiivUJ/+B+1mAYTxE7q3PWRAwhgIxF95zAF6rIFK+7ARiU54oWtrOMIA/CM4BpCPDsftWyf+ZabdXY=
X-Received: by 2002:a2e:b17b:: with SMTP id a27mr12563632ljm.243.1570898844575;
 Sat, 12 Oct 2019 09:47:24 -0700 (PDT)
MIME-Version: 1.0
References: <1570695134-660-1-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1570695134-660-1-git-send-email-magnus.karlsson@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 12 Oct 2019 09:47:12 -0700
Message-ID: <CAADnVQ+R3S1OpRahy78hR2hDfxaWX=peSwturK9hCeP_+9yBbQ@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: improve documentation for AF_XDP
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
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

On Thu, Oct 10, 2019 at 1:12 AM Magnus Karlsson
<magnus.karlsson@intel.com> wrote:
>
> Added sections on all the bind flags, libbpf, all the setsockopts and
> all the getsockopts. Also updated the document to reflect the latest
> features and to correct some spelling errors.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

thanks for the update. Overall looks good.
Few nits below:

> +What socket will then a packet arrive on? This is decided by the XDP
> +program. Put all the sockets in the XSK_MAP and just indicate which
> +index in the array you would like to send each packet to. A simple
> +round-robin example of distributing packets is shown below:
> +
> +.. code-block:: c
> +
> +   #define KBUILD_MODNAME "af_xdp_example"

what is this for?
It's not a kernel module.

> +   #include <uapi/linux/bpf.h>

why 'uapi' ? It should use only user space headers.

> +   #include "bpf_helpers.h"
> +
> +   #define MAX_SOCKS 16
> +
> +   struct bpf_map_def SEC("maps") xsks_map = {
> +         .type = BPF_MAP_TYPE_XSKMAP,
> +         .key_size = sizeof(int),
> +         .value_size = sizeof(int),
> +         .max_entries = MAX_SOCKS,
> +   };

Could you switch to BTF defined maps?
libbpf will forever support old style as well,
but documentation should point to the latest.

> +
> +   struct bpf_map_def SEC("maps") rr_map = {
> +         .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> +         .key_size = sizeof(int),
> +         .value_size = sizeof(unsigned int),
> +         .max_entries = 1,
> +   };
> +
> +   SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> +   {
> +       int key = 0, idx;
> +       unsigned int *rr;
> +
> +       rr = bpf_map_lookup_elem(&rr_map, &key);
> +       if (!rr)
> +          return XDP_ABORTED;
> +
> +       *rr = (*rr + 1) & (MAX_SOCKS - 1);
> +       idx = *rr;
> +
> +       return bpf_redirect_map(&xsks_map, idx, 0);
> +   }
> +
> +   char _license[] SEC("license") = "GPL";

Above sample doesn't use gpl-only helpers. Why add above line?

> +.. code-block:: c
> +
> +   if (xsk_ring_prod__needs_wakeup(&my_tx_ring))
> +      sendto(xsk_socket__fd(xsk_handle), NULL, 0, MSG_DONTWAIT, NULL, 0);
> +
> +I.e., only use the syscall if the flag is set.
> +
> +We recommend that you always enable this mode as it can lead to
> +magnitudes better performance if you run the application and the
> +driver on the same core and somewhat better performance even if you
> +use different cores for the application and the kernel driver, as it
> +reduces the number of syscalls needed for the TX path.

"magnitudes better performance"? Is it really at least 20 times better?

> -Naive ring dequeue and enqueue could look like this::
> +Naive ring dequeue and enqueue could look like this:

lol. That's a good typo.
