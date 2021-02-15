Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A93231C2E8
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhBOUX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhBOUX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 15:23:26 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714CEC061574;
        Mon, 15 Feb 2021 12:22:46 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id e1so6539452ilu.0;
        Mon, 15 Feb 2021 12:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=TDrNw5iS82/NIghjTpHN2HoqllYta5pTc5HeZuX337A=;
        b=loeB2Jhe8UrvKDyUjgex03/SWH5USjIuU5NjZtG46GfNA+G1O7cXhijLTYYzo29USF
         16xcMP3eAdlEgI8IS0MAJPfnNN0HUc3d+yY9dQnZlQ5X34M2DiZwQFtEtLLmefa+cxd9
         PyNDwawaauZL6Q9GbhUjK3nKMNrCxWOGtRlsNiIchwz+oeIYE54TrIJVwZwjU2MwGrrx
         a4ztjrw8f6CMVtPkWux8LaJfVNAfXmoTwWEFN6yl+lroJ0gUZCsDgxoxwaEVE5vwUCt6
         Y+4UpD7RqVCUmTYgtmzN5OwfW4IEw3KBbGIEJhnOTpOHSWQTfgNSTN/VOYUdHsP9Ff2g
         meSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=TDrNw5iS82/NIghjTpHN2HoqllYta5pTc5HeZuX337A=;
        b=o4TDtV5DEUDnjbrBAcdeGw/49YKU2LfRdxcFlscmZ9fCM0JEppuWb0wCTRsP4d0z9r
         GBQFaN2AV5kvgNfr/hNibDbB9ZGt1frplSVERLu+vu07Xf+Fnhg2btJ6vwRNHrn4Ryif
         yL3m/yNgbB28rTuzXt/LP++PllK/gkZLjgpmAZsqJ09cw+BBllaoX2CzYnV+im2e5ybv
         Qz3Ax+lyGrBkM/HOpgHf6e+Zbl3NyZdtCeY4NoR56LU8zzPuHBar5XuJH2TqZbbsHJHX
         a9XYIwrEelICWiwthastW1vXYjrzIhXOcBuIP3V624EAIbqTJx0MqgNG9dA/EbMIIs1O
         Q2lQ==
X-Gm-Message-State: AOAM5330ktmzS0SvrhWujwn4xNWbU21KTvRJWGLeiQExOmth6wny64AL
        CySqVQxP/jmPAp5kOwVmdNQ=
X-Google-Smtp-Source: ABdhPJyq6i19Hn0C0rFf9Ksh1qBLc+3GNGW5Gvoc88g3JVjQDL/3nUcGUQNE4JL+7OinAWxANtxJCw==
X-Received: by 2002:a05:6e02:483:: with SMTP id b3mr157094ils.152.1613420565572;
        Mon, 15 Feb 2021 12:22:45 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id v16sm9907913ilj.20.2021.02.15.12.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 12:22:44 -0800 (PST)
Date:   Mon, 15 Feb 2021 12:22:36 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Message-ID: <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
In-Reply-To: <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> On 2021-02-15 18:07, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> > =

> >> Currently, if there are multiple xdpsock instances running on a sing=
le
> >> interface and in case one of the instances is terminated, the rest o=
f
> >> them are left in an inoperable state due to the fact of unloaded XDP=

> >> prog from interface.

I'm a bit confused by the above. This is only the case if the instance
that terminated is the one that loaded the XDP program and it also didn't=

pin the program correct? If so lets make the commit message a bit more
clear about the exact case we are solving.

> >>
> >> To address that, step away from setting bpf prog in favour of bpf_li=
nk.
> >> This means that refcounting of BPF resources will be done automatica=
lly
> >> by bpf_link itself.

+1

> >>
> >> When setting up BPF resources during xsk socket creation, check whet=
her
> >> bpf_link for a given ifindex already exists via set of calls to
> >> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by=
_fd
> >> and comparing the ifindexes from bpf_link and xsk socket.
> > =

> > One consideration here is that bpf_link_get_fd_by_id() is a privilege=
d
> > operation (privileged as in CAP_SYS_ADMIN), so this has the side effe=
ct
> > of making AF_XDP privileged as well. Is that the intention?
> >
> =

> We're already using, e.g., bpf_map_get_fd_by_id() which has that
> as well. So we're assuming that for XDP setup already!
> =

> > Another is that the AF_XDP code is in the process of moving to libxdp=

> > (see in-progress PR [0]), and this approach won't carry over as-is to=

> > that model, because libxdp has to pin the bpf_link fds.
> >
> =

> I was assuming there were two modes of operations for AF_XDP in libxdp.=

> One which is with the multi-program support (which AFAIK is why the
> pinning is required), and one "like the current libbpf" one. For the
> latter Maciej's series would be a good fit, no?
> =

> > However, in libxdp we can solve the original problem in a different w=
ay,
> > and in fact I already suggested to Magnus that we should do this (see=

> > [1]); so one way forward could be to address it during the merge in
> > libxdp? It should be possible to address the original issue (two
> > instances of xdpsock breaking each other when they exit), but
> > applications will still need to do an explicit unload operation befor=
e
> > exiting (i.e., the automatic detach on bpf_link fd closure will take
> > more work, and likely require extending the bpf_link kernel support).=
..
> >
> =

> I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
> we're months ahead, then I'd really like to see this in libbpf until th=
e
> merge. However, I'll leave that for Magnus/you to decide!

Did I miss some thread? What does this mean libbpf 1.0/libxdp merge? From=

my side libbpf should support the basic operations: load, attach, pin,
and link for all my BPF objects. I view libxdp as providing 'extra'
goodness on top of that. Everyone agree?

> =

> Bottom line; I'd *really* like bpf_link behavior (process scoped) for
> AF_XDP sooner than later! ;-)

Because I use libbpf as my base management for BPF objects I want it
to support the basic ops for all objects so link ops should land there.

> =

> =

> Thanks for the input!
> Bj=C3=B6rn
> =

> =

> > -Toke
> > =

> > [0] https://github.com/xdp-project/xdp-tools/pull/92
> > [1] https://github.com/xdp-project/xdp-tools/pull/92#discussion_r5762=
04719
> > =



