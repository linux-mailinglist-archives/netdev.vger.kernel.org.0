Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E9FDDD43
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 10:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfJTIOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 04:14:02 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43218 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJTIOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 04:14:01 -0400
Received: by mail-ot1-f67.google.com with SMTP id o44so8480490ota.10;
        Sun, 20 Oct 2019 01:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HpUJVWaqyr08ZCxugzApAFgoYaCw9VplNEWkq3ounSQ=;
        b=h3KSuO5I6Q4YtqGnxsuuWQCnpAp2/7m4Whj0spUjXefNFr450rV51MPPFDJhqqQeto
         2UyBVKqIsMWCHPJJXQLC584qBqg1tzJLzPvRiuBudj+HTJNfqHaXMxQ1WrEOPsVzZ/Re
         CGk2UyvtOXOdu5qWq/A9OSySQ30J2qntUxQKsuyX4sXi/pymZ1HgKrvt4EYVD1raNrXO
         P2c6exvAuOXqALrqL1ja02f4GYcpV2xOT+Q6Osutwq1nTxQmfX9O0VmqLD+Y9rBFF2VY
         Hf0cP2AxZEMu1VdasOVQ39e2IyCIhe7pLnhUQ+i8i5bv5WrDX/5fAk3a8EObILuc4gp6
         njWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HpUJVWaqyr08ZCxugzApAFgoYaCw9VplNEWkq3ounSQ=;
        b=J+9MEM73NlnrUsNjIhJAnq15qXc5e8ocsLse7w5H4QC16KPHIziDKjfvJ0u2NJd5AP
         ZWuSyKGz/gehZnaxbyROuKM0f9RbmbCNrVSyV2qlg6gkT0ddrp5xqSKiazImzMnF652Y
         pVz6vT7o6qPHH3QHklll+j8m68dkhvaBtNYEn01SXKw2sRgy2Rt6rGhoRwYFp9DKUd11
         X8ZtpvJBY/H2oSrXZhTWvdxbXiflm7AlcPV013z97NY7rMg9PZr+N2D4uFIkgwSFX7Gf
         8EajMaNhNJwHqxsZO7+lLuMiqUgx0nsCNGzmNxtHzKUYjuwgLmMDxKYvx6FGh3VsfyPe
         U53A==
X-Gm-Message-State: APjAAAXsblcvFELNr5CWQRbK4Qhc3OnGF8NkGN0uwHaz73l7XW7tqNOM
        y22NrJlcRDuMUDDOOb8oNjfx8zrfI/xQVlNdv2PZI7JFk9hZFQ==
X-Google-Smtp-Source: APXvYqxSRXNV3xq2Yj2t3CLZGyXdvMVnlRan+Nss2scChXmvU8RNwm1INgaKOiQoXhkvM4fymXKK2ua7UINTkF8xbdI=
X-Received: by 2002:a9d:286:: with SMTP id 6mr14288527otl.192.1571559240753;
 Sun, 20 Oct 2019 01:14:00 -0700 (PDT)
MIME-Version: 1.0
References: <1571391220-22835-1-git-send-email-magnus.karlsson@intel.com> <20191018232756.akn4yvyxmi63dl5b@ast-mbp>
In-Reply-To: <20191018232756.akn4yvyxmi63dl5b@ast-mbp>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Sun, 20 Oct 2019 10:13:49 +0200
Message-ID: <CAJ8uoz292vhqb=L0khWeUs89HF42d+UAgzb1z1tf8my1PaU5Fg@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xsk: improve documentation for AF_XDP
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

On Sat, Oct 19, 2019 at 11:48 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Oct 18, 2019 at 11:33:40AM +0200, Magnus Karlsson wrote:
> > +
> > +   #include <linux/bpf.h>
> > +   #include "bpf_helpers.h"
> > +
> > +   #define MAX_SOCKS 16
> > +
> > +   struct {
> > +        __uint(type, BPF_MAP_TYPE_XSKMAP);
> > +        __uint(max_entries, MAX_SOCKS);
> > +        __uint(key_size, sizeof(int));
> > +        __uint(value_size, sizeof(int));
> > +   } xsks_map SEC(".maps");
> > +
> > +   struct {
> > +        __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> > +        __uint(max_entries, 1);
> > +        __type(key, int);
> > +        __type(value, unsigned int);
> > +   } rr_map SEC(".maps");
>
> hmm. does xsks_map compile?

Yes. Actually, I wrote a new sample to demonstrate this feature and to
test the code above. I will send that patch set (contains some small
additions to libbpf also to be able to support this) to bpf-next.
Though, if I used the __type declarations of the rr_map PERCPU_ARRAY I
got this warning: "pr_warning("Error in
bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n")", so I had
to change it to the type above that is also used for SOCKMAP. Some
enablement that is missing for XSKMAP? Have not dug into it.

> > +
> > +   SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> > +   {
> > +     int key = 0, idx;
> > +     unsigned int *rr;
> > +
> > +     rr = bpf_map_lookup_elem(&rr_map, &key);
> > +     if (!rr)
> > +        return XDP_ABORTED;
>
> could you please use global data and avoid lookup?
> The run-time will be much faster.

Good idea. Will do and change the new sample app too.
