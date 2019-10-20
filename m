Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76255DDFB2
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 19:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfJTRZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 13:25:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36645 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfJTRZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 13:25:10 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so6841033pfr.3;
        Sun, 20 Oct 2019 10:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bfdCbxekAsldwt8m5pwg+qcM6L4Gc2Nz/dBiQdkpxT4=;
        b=PHl01K37HlDkd3UgvSZjOWWJatkA2fo2yhPQp4UdQb4kbxo1sq/ljBLWQfKCr7SRgT
         4OfvaGk9f6kGFv3G4p7hb8tS8zs4EmWblG6uZiYdvxDGEfFvDqPswjiEeyuuixSZc69t
         Q9uI1Nyz1tJJR/DzT+Jjr4Ficf9C8aavKMD3K1VJ1jEUNFrb6KcViG4pj6fvnkNmQnDB
         oiE9CTudGFTd+URAN0gwrSX4nMciqI+qed4kf80Hp2TC+Bsq3xpTo/x+t6wgd/yMXaps
         RI6lmD8vRzafYvV/ft0ANoZPg4h0Ekn28O4v23BoYwfOMT5hWGddanSQobUIMAYy8NMZ
         kYTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bfdCbxekAsldwt8m5pwg+qcM6L4Gc2Nz/dBiQdkpxT4=;
        b=r7qvUU+kqymPIoTayOBR+l0MNUyIDA9WlttWjOviH+HoiUTvjyYcmpxz1C99lsThHI
         SHkVK5uM76QKwGSN1ce1H0TX1jLjdrVdUuS1132qeSX0oS84DMAw6k1ppCtEjBB3XF/v
         Swe0OgXbNW8NEdiN22o3l5u9QtFvtS+rbbz/oyI7gFsBJhKKQ/4CQjsWwiXoe1R4sSEV
         IPjRHjlwIHgYn2WELWv2VJ/iPIrgQjiHnoBiHP+NyV8LK4/VyWmrRN03z6Zdzx5Lmtzx
         uYkEUVWCzSdWfbBM1t7l9N9ZnZXil7sEZNlid0W1gWkJgE4eDGw8e9DoYW4GIPK2Iu2p
         UtVw==
X-Gm-Message-State: APjAAAXe/B6UpEroK036A8ki5+7cc+8dhHKRYdnuAnZoQ5zSfX7yKHxi
        rpxZ+9SNW8hgMeMDPXHsI0k=
X-Google-Smtp-Source: APXvYqxe+eXydeDD7Rlvl4Gux1bcp9C4lbIrbHlqNHXEp9Ykn1NBoiaoiF4CPg2ene8PgXS7sLjeyw==
X-Received: by 2002:a63:7405:: with SMTP id p5mr8956730pgc.264.1571592308594;
        Sun, 20 Oct 2019 10:25:08 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::421e])
        by smtp.gmail.com with ESMTPSA id w25sm12048831pfi.60.2019.10.20.10.25.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Oct 2019 10:25:07 -0700 (PDT)
Date:   Sun, 20 Oct 2019 10:25:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf v2] xsk: improve documentation for AF_XDP
Message-ID: <20191020172503.qeee2olqxxnynm6v@ast-mbp.dhcp.thefacebook.com>
References: <1571391220-22835-1-git-send-email-magnus.karlsson@intel.com>
 <20191018232756.akn4yvyxmi63dl5b@ast-mbp>
 <CAJ8uoz292vhqb=L0khWeUs89HF42d+UAgzb1z1tf8my1PaU5Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz292vhqb=L0khWeUs89HF42d+UAgzb1z1tf8my1PaU5Fg@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 10:13:49AM +0200, Magnus Karlsson wrote:
> On Sat, Oct 19, 2019 at 11:48 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Oct 18, 2019 at 11:33:40AM +0200, Magnus Karlsson wrote:
> > > +
> > > +   #include <linux/bpf.h>
> > > +   #include "bpf_helpers.h"
> > > +
> > > +   #define MAX_SOCKS 16
> > > +
> > > +   struct {
> > > +        __uint(type, BPF_MAP_TYPE_XSKMAP);
> > > +        __uint(max_entries, MAX_SOCKS);
> > > +        __uint(key_size, sizeof(int));
> > > +        __uint(value_size, sizeof(int));
> > > +   } xsks_map SEC(".maps");
> > > +
> > > +   struct {
> > > +        __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> > > +        __uint(max_entries, 1);
> > > +        __type(key, int);
> > > +        __type(value, unsigned int);
> > > +   } rr_map SEC(".maps");
> >
> > hmm. does xsks_map compile?
> 
> Yes. Actually, I wrote a new sample to demonstrate this feature and to
> test the code above. I will send that patch set (contains some small
> additions to libbpf also to be able to support this) to bpf-next.
> Though, if I used the __type declarations of the rr_map PERCPU_ARRAY I
> got this warning: "pr_warning("Error in
> bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n")", so I had
> to change it to the type above that is also used for SOCKMAP. Some
> enablement that is missing for XSKMAP? Have not dug into it.

Ahh. Right. xskmap explicitly prohibits BTF for key/value.
const struct bpf_map_ops xsk_map_ops = {
        ...
        .map_check_btf = map_check_no_btf,
};
I guess it's time to add support for it.

