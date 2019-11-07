Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7727DF2372
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 01:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbfKGAo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 19:44:26 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35757 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732771AbfKGAoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 19:44:24 -0500
Received: by mail-yw1-f66.google.com with SMTP id r131so39714ywh.2;
        Wed, 06 Nov 2019 16:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hcG67Ce8h5UfdKDICfDjiYsFK/6mwAJRU+th+1S4+mo=;
        b=pkC1CWcaW9m1YJvPeeEYTzoEBYWPHux/UKkzJtIwqRHGVP5VvM+cldmWRpLGgcpFdK
         VQXq/GddIl/HrIjeMCoSc5XeSpbzHSC2VnoDQj0cFK97P/MHtL9LGLSjqXM+QV34By4s
         81TZZSQFVEZtGnSiUEwhOzXgzW+7IwBZ2Ppb+01yUiwSxvXBOjD3JIt+ZxKRGDbkANPE
         qeZE2YhYtZzULpl39TFmzbo/MtltDbjws5aiqbc7WlQQpTg6tBdVIT8NFdXC4eUG8t+O
         kncbUFpSWZCjoauIbe2dIom2TZla3COjNlj9PV9NskyyVBl+ATVztZHITWS6nTQ96Mqs
         QByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hcG67Ce8h5UfdKDICfDjiYsFK/6mwAJRU+th+1S4+mo=;
        b=Hxc9dX+QCuKddEUVBf123Bcvh/zM3IdHdJw1hbpuu/bjzjAZYc3rceCV3DdRuToTkb
         yEaDnkJO8oqu3p2gs6d3WuvtOBBbL6dr/JfUTA/uuAiSzPTJOiJv7P9ynHlIrF3u+pUC
         OEDfQ8ZyCZ2R2HvXcB3+GruxFPbORzTq2SJQBygf4g95PiwbVSQhcRaQzejWocpkzhp4
         2sLBaB19p7b5q4KW1XzQcSQpuicr9ZMTm0/Pa54y+/525dtrq1OhLtGnh78RJ/rNeKtx
         HkSxV4mT8odwg7P/3UHRcOK1lPcMf83Fwfza1r/vcF55czDMpZ5NnGbfDLnDmXo+pN48
         RRzQ==
X-Gm-Message-State: APjAAAWuJDcW4WevMIzrAsJpUq7GR8hfmqebrOKXeCYPe1bBDflvtunk
        h38dlDedd8b+emyI8UaR5oKq/wZ4y+stZd4n6w==
X-Google-Smtp-Source: APXvYqwcUIydJzVpWqKETG7VKd1OPWdqzMQ0D1SLuIxg/SlZ3S0gYZO5zWbivtyCnymRR1vRpijglyvr34nOVAOlGZ8=
X-Received: by 2002:a0d:e447:: with SMTP id n68mr327247ywe.46.1573087463174;
 Wed, 06 Nov 2019 16:44:23 -0800 (PST)
MIME-Version: 1.0
References: <20191105225111.4940-1-danieltimlee@gmail.com> <20191105225111.4940-3-danieltimlee@gmail.com>
 <CAEf4BzapG=xt57i2jEViydA=R2RpkS2bMB-u28-S2Kj7pxe2GA@mail.gmail.com>
In-Reply-To: <CAEf4BzapG=xt57i2jEViydA=R2RpkS2bMB-u28-S2Kj7pxe2GA@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Thu, 7 Nov 2019 09:44:09 +0900
Message-ID: <CAEKGpzgz4U68ast=OSMFq66OKNipMB_BN9E2_N4PEO_+s+LByQ@mail.gmail.com>
Subject: Re: [PATCH,bpf-next 2/2] samples: bpf: update map definition to new
 syntax BTF-defined map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 11:14 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 5, 2019 at 2:52 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Since, the new syntax of BTF-defined map has been introduced,
> > the syntax for using maps under samples directory are mixed up.
> > For example, some are already using the new syntax, and some are using
> > existing syntax by calling them as 'legacy'.
> >
> > As stated at commit abd29c931459 ("libbpf: allow specifying map
> > definitions using BTF"), the BTF-defined map has more compatablility
> > with extending supported map definition features.
> >
> > The commit doesn't replace all of the map to new BTF-defined map,
> > because some of the samples still use bpf_load instead of libbpf, which
> > can't properly create BTF-defined map.
> >
> > This will only updates the samples which uses libbpf API for loading bpf
> > program. (ex. bpf_prog_load_xattr)
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
>
>
> Please try to stick to __type() for key/value, where possible (all the
> arrays, hashes, per-cpu arrays definitely work). Some of the special
> CPUMAP, DEVMAP might not work. Not sure about TRIEs, please try.
>

Will apply feedback right away!
Thanks for the review!

> >  samples/bpf/sockex1_kern.c          |  12 ++--
> >  samples/bpf/sockex2_kern.c          |  12 ++--
> >  samples/bpf/xdp1_kern.c             |  12 ++--
> >  samples/bpf/xdp2_kern.c             |  12 ++--
> >  samples/bpf/xdp_adjust_tail_kern.c  |  12 ++--
> >  samples/bpf/xdp_fwd_kern.c          |  13 ++--
> >  samples/bpf/xdp_redirect_cpu_kern.c | 108 ++++++++++++++--------------
> >  samples/bpf/xdp_redirect_kern.c     |  24 +++----
> >  samples/bpf/xdp_redirect_map_kern.c |  24 +++----
> >  samples/bpf/xdp_router_ipv4_kern.c  |  64 ++++++++---------
> >  samples/bpf/xdp_rxq_info_kern.c     |  36 +++++-----
> >  samples/bpf/xdp_tx_iptunnel_kern.c  |  26 +++----
> >  12 files changed, 177 insertions(+), 178 deletions(-)
> >
> > diff --git a/samples/bpf/sockex1_kern.c b/samples/bpf/sockex1_kern.c
> > index f96943f443ab..493f102711c0 100644
> > --- a/samples/bpf/sockex1_kern.c
> > +++ b/samples/bpf/sockex1_kern.c
> > @@ -5,12 +5,12 @@
> >  #include "bpf_helpers.h"
> >  #include "bpf_legacy.h"
> >
> > -struct bpf_map_def SEC("maps") my_map = {
> > -       .type = BPF_MAP_TYPE_ARRAY,
> > -       .key_size = sizeof(u32),
> > -       .value_size = sizeof(long),
> > -       .max_entries = 256,
> > -};
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > +       __uint(key_size, sizeof(u32));
> > +       __uint(value_size, sizeof(long));
> > +       __uint(max_entries, 256);
> > +} my_map SEC(".maps");
> >
> >  SEC("socket1")
> >  int bpf_prog1(struct __sk_buff *skb)
> > diff --git a/samples/bpf/sockex2_kern.c b/samples/bpf/sockex2_kern.c
> > index 5566fa7d92fa..bd756494625b 100644
> > --- a/samples/bpf/sockex2_kern.c
> > +++ b/samples/bpf/sockex2_kern.c
> > @@ -190,12 +190,12 @@ struct pair {
> >         long bytes;
> >  };
> >
> > -struct bpf_map_def SEC("maps") hash_map = {
> > -       .type = BPF_MAP_TYPE_HASH,
> > -       .key_size = sizeof(__be32),
> > -       .value_size = sizeof(struct pair),
> > -       .max_entries = 1024,
> > -};
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_HASH);
> > +       __uint(key_size, sizeof(__be32));
> > +       __uint(value_size, sizeof(struct pair));
>
> let's use __type(key, __be32) and __type(value, struct pair) here and
> in most other places where we have maps supporting BTF
>
> > +       __uint(max_entries, 1024);
> > +} hash_map SEC(".maps");
> >
> >  SEC("socket2")
> >  int bpf_prog2(struct __sk_buff *skb)
> > diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
> > index 219742106bfd..a0a181164087 100644
> > --- a/samples/bpf/xdp1_kern.c
> > +++ b/samples/bpf/xdp1_kern.c
> > @@ -14,12 +14,12 @@
> >  #include <linux/ipv6.h>
> >  #include "bpf_helpers.h"
> >
> > -struct bpf_map_def SEC("maps") rxcnt = {
> > -       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> > -       .key_size = sizeof(u32),
> > -       .value_size = sizeof(long),
> > -       .max_entries = 256,
> > -};
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> > +       __uint(key_size, sizeof(u32));
> > +       __uint(value_size, sizeof(long));
> > +       __uint(max_entries, 256);
> > +} rxcnt SEC(".maps");
> >
> >  static int parse_ipv4(void *data, u64 nh_off, void *data_end)
> >  {
> > diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
> > index e01288867d15..21564a95561b 100644
> > --- a/samples/bpf/xdp2_kern.c
> > +++ b/samples/bpf/xdp2_kern.c
> > @@ -14,12 +14,12 @@
> >  #include <linux/ipv6.h>
> >  #include "bpf_helpers.h"
> >
> > -struct bpf_map_def SEC("maps") rxcnt = {
> > -       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> > -       .key_size = sizeof(u32),
> > -       .value_size = sizeof(long),
> > -       .max_entries = 256,
> > -};
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> > +       __uint(key_size, sizeof(u32));
> > +       __uint(value_size, sizeof(long));
> > +       __uint(max_entries, 256);
> > +} rxcnt SEC(".maps");
> >
> >  static void swap_src_dst_mac(void *data)
> >  {
> > diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> > index c616508befb9..6de45a4a2c3e 100644
> > --- a/samples/bpf/xdp_adjust_tail_kern.c
> > +++ b/samples/bpf/xdp_adjust_tail_kern.c
> > @@ -28,12 +28,12 @@
> >  /* volatile to prevent compiler optimizations */
> >  static volatile __u32 max_pcktsz = MAX_PCKT_SIZE;
> >
> > -struct bpf_map_def SEC("maps") icmpcnt = {
> > -       .type = BPF_MAP_TYPE_ARRAY,
> > -       .key_size = sizeof(__u32),
> > -       .value_size = sizeof(__u64),
> > -       .max_entries = 1,
> > -};
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > +       __uint(key_size, sizeof(__u32));
> > +       __uint(value_size, sizeof(__u64));
> > +       __uint(max_entries, 1);
> > +} icmpcnt SEC(".maps");
> >
> >  static __always_inline void count_icmp(void)
> >  {
> > diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
> > index 701a30f258b1..d013029aeaa2 100644
> > --- a/samples/bpf/xdp_fwd_kern.c
> > +++ b/samples/bpf/xdp_fwd_kern.c
> > @@ -23,13 +23,12 @@
> >
> >  #define IPV6_FLOWINFO_MASK              cpu_to_be32(0x0FFFFFFF)
> >
> > -/* For TX-traffic redirect requires net_device ifindex to be in this devmap */
> > -struct bpf_map_def SEC("maps") xdp_tx_ports = {
> > -       .type = BPF_MAP_TYPE_DEVMAP,
> > -       .key_size = sizeof(int),
> > -       .value_size = sizeof(int),
> > -       .max_entries = 64,
> > -};
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_DEVMAP);
> > +       __uint(key_size, sizeof(int));
> > +       __uint(value_size, sizeof(int));
> > +       __uint(max_entries, 64);
> > +} xdp_tx_ports SEC(".maps");
>
> DEVMAP might be special, I don't remember, so key_size/value_size
> might be necessary

As you've mentioned, DEVMAP does not work with __type.

>
> >
> >  /* from include/net/ip.h */
> >  static __always_inline int ip_decrease_ttl(struct iphdr *iph)
> > diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
> > index a306d1c75622..1f472506aa54 100644
> > --- a/samples/bpf/xdp_redirect_cpu_kern.c
> > +++ b/samples/bpf/xdp_redirect_cpu_kern.c
> > @@ -18,12 +18,12 @@
> >  #define MAX_CPUS 64 /* WARNING - sync with _user.c */
> >
> >  /* Special map type that can XDP_REDIRECT frames to another CPU */
> > -struct bpf_map_def SEC("maps") cpu_map = {
> > -       .type           = BPF_MAP_TYPE_CPUMAP,
> > -       .key_size       = sizeof(u32),
> > -       .value_size     = sizeof(u32),
> > -       .max_entries    = MAX_CPUS,
> > -};
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_CPUMAP);
> > +       __uint(key_size, sizeof(u32));
> > +       __uint(value_size, sizeof(u32));
> > +       __uint(max_entries, MAX_CPUS);
> > +} cpu_map SEC(".maps");
> >
>
> same for CPUMAP, but would be nice to double-check.
>

Same for the CPUMAP. Just checked.
Seems TRIE doesn't work either. it uses __uint(key_size, 8);
and __type(key, 8); is not acceptable.

[...]

Thank you for your time and effort for the review.

Thanks,
Daniel
