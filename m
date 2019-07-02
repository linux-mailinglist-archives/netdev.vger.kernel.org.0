Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED3335C663
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 02:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfGBAkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 20:40:36 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38734 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfGBAkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 20:40:36 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so33086141ioa.5;
        Mon, 01 Jul 2019 17:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eo7305l0P+Yvey2/1vlgr954N7VrVL+HsQ4pqJhOoeE=;
        b=s+yjbQ1RGfDduquAPwm9RgCAXal3yTZax5B3CADLn5e7BuaGseE3UnXZEIKhET4fmO
         ypRuigh+d9d2jX/exEm9LBJak0xCbf/pQUCBQY2uoR+DlkIK0WmPh0HfyMTs+uXpaSO2
         6HcU1W5VOdfxQNa2NgMuw1dtuYMlIUEUZICE2fgp3wsYz4EJ1hLy974B7KB1hsWBZMAo
         dOAnCtHfjH6dZMAQINrtTD8NYDhGMJRV5HTDmEV4kiiva1XNXQ/sEA/tNjIYiMoeB1n9
         VJo6AXB1f9X/3ABTephncd54ZEfGrZIsBYtugmpyFFJCiSlFCHDO3XGrpDeQ0AGMihVp
         FKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eo7305l0P+Yvey2/1vlgr954N7VrVL+HsQ4pqJhOoeE=;
        b=lu3g+CZ/K2IpTTS3Flwuk/uRI3Yb3er/i8MKjHw+r56rlky4kQh0yCIyTwUpGqbWKR
         Ia/tpW9dQgsoX4ltjdLuohLk6IX29HoyTiU7b+Bem0MYkQCazn5J1EN3Sa1/DXRdd0+v
         Y03LexJFHyOQl5LtXJqkZC2HxD3eJQkUqm80Geno7ALr8fMKVrr8/Kj2ThphtliALECl
         EphiFPfkZ9WaQN7N/KCmMtqZXVJCiS6daXo37jy/xMEO2ssgXlEeVXVoLtOq8a1GW50o
         zkYpVtvd8ir+ruo+Ndm3jjFmXSuMmsUHAD/d24IRVr7HIcDCKBy43kSqDqubP4jyxlwh
         HJvg==
X-Gm-Message-State: APjAAAW9FDgjsXIbINcza5D+IRfNQhXzpKkPu+cmX+uUwrflOvKEcQhq
        QccdefOcdnT1vStt9WTk4zbFBRYRe6kVrgRgFrI=
X-Google-Smtp-Source: APXvYqzQvzQUUQr9huzvwemKAyrkS9tZfadxSAIT3YWa3sJRGRUJsYKE3rJGsF1QY7SrFy8u4c5tyB3bdg+NRNdcxuA=
X-Received: by 2002:a5e:aa15:: with SMTP id s21mr28078832ioe.221.1562028035323;
 Mon, 01 Jul 2019 17:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190701204821.44230-1-sdf@google.com> <20190701204821.44230-8-sdf@google.com>
 <CAH3MdRX+utr3w1gC537ui7nLOZ+b8yrSKeO3CMuszXG5sGg3NA@mail.gmail.com> <20190702003156.GI6757@mini-arch>
In-Reply-To: <20190702003156.GI6757@mini-arch>
From:   Y Song <ys114321@gmail.com>
Date:   Mon, 1 Jul 2019 17:39:59 -0700
Message-ID: <CAH3MdRX44djTKOgkz3+-9pemW=NjEN2mueDyoKkb=PsyH9WSWg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/8] samples/bpf: add sample program that
 periodically dumps TCP stats
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 5:31 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/01, Y Song wrote:
> > On Mon, Jul 1, 2019 at 1:49 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Uses new RTT callback to dump stats every second.
> > >
> > > $ mkdir -p /tmp/cgroupv2
> > > $ mount -t cgroup2 none /tmp/cgroupv2
> > > $ mkdir -p /tmp/cgroupv2/foo
> > > $ echo $$ >> /tmp/cgroupv2/foo/cgroup.procs
> > > $ bpftool prog load ./tcp_dumpstats_kern.o /sys/fs/bpf/tcp_prog
> > > $ bpftool cgroup attach /tmp/cgroupv2/foo sock_ops pinned /sys/fs/bpf/tcp_prog
> > > $ bpftool prog tracelog
> > > $ # run neper/netperf/etc
> > >
> > > Used neper to compare performance with and without this program attached
> > > and didn't see any noticeable performance impact.
> > >
> > > Sample output:
> > >   <idle>-0     [015] ..s.  2074.128800: 0: dsack_dups=0 delivered=242526
> > >   <idle>-0     [015] ..s.  2074.128808: 0: delivered_ce=0 icsk_retransmits=0
> > >   <idle>-0     [015] ..s.  2075.130133: 0: dsack_dups=0 delivered=323599
> > >   <idle>-0     [015] ..s.  2075.130138: 0: delivered_ce=0 icsk_retransmits=0
> > >   <idle>-0     [005] .Ns.  2076.131440: 0: dsack_dups=0 delivered=404648
> > >   <idle>-0     [005] .Ns.  2076.131447: 0: delivered_ce=0 icsk_retransmits=0
> > >
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Priyaranjan Jha <priyarjha@google.com>
> > > Cc: Yuchung Cheng <ycheng@google.com>
> > > Cc: Soheil Hassas Yeganeh <soheil@google.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  samples/bpf/Makefile             |  1 +
> > >  samples/bpf/tcp_dumpstats_kern.c | 65 ++++++++++++++++++++++++++++++++
> > >  2 files changed, 66 insertions(+)
> > >  create mode 100644 samples/bpf/tcp_dumpstats_kern.c
> >
> > Currently, the bpf program into the repo. If we do not have another
> > script to use
> > this program for testing, the instructions in the commit message should be
> > added to the bpf program as comments so people know what to do with this file
> > without going through git commit message.
> >
> > Is it possible to create a script to run with this bpf program?
> There is a general instruction in samples/bpf/tcp_bpf.readme
> with bpftool examples/etc. Should I just a comment at the top
> of the BPF program to point people to that .readme file instead?

Referring to tcp_bpf.readme should work. Even simpler :-)

>
> > >
> > > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > > index 0917f8cf4fab..eaebbeead42f 100644
> > > --- a/samples/bpf/Makefile
> > > +++ b/samples/bpf/Makefile
> > > @@ -154,6 +154,7 @@ always += tcp_iw_kern.o
> > >  always += tcp_clamp_kern.o
> > >  always += tcp_basertt_kern.o
> > >  always += tcp_tos_reflect_kern.o
> > > +always += tcp_dumpstats_kern.o
> > >  always += xdp_redirect_kern.o
> > >  always += xdp_redirect_map_kern.o
> > >  always += xdp_redirect_cpu_kern.o
> > > diff --git a/samples/bpf/tcp_dumpstats_kern.c b/samples/bpf/tcp_dumpstats_kern.c
> > > new file mode 100644
> > > index 000000000000..5d22bf61db65
> > > --- /dev/null
> > > +++ b/samples/bpf/tcp_dumpstats_kern.c
> > > @@ -0,0 +1,65 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <linux/bpf.h>
> > > +
> > > +#include "bpf_helpers.h"
> > > +#include "bpf_endian.h"
> > > +
> > > +#define INTERVAL                       1000000000ULL
> > > +
> > > +int _version SEC("version") = 1;
> > > +char _license[] SEC("license") = "GPL";
[...]
