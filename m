Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E852C3C7437
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhGMQUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhGMQT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:19:59 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97694C0613DD;
        Tue, 13 Jul 2021 09:17:08 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id o139so35619328ybg.9;
        Tue, 13 Jul 2021 09:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mKh8hxnnNX4ICQ6dn6i89iBSBLL0vLdc18PMBvIwanA=;
        b=I3tbdibfE7JpwHDyExDbKRP5EoqnTMzUWVsA7HGxavvZo4PhJRka+vI/IbZ2nqP/eh
         ouQ//gkTMJmZ7cCubCvFmwsqwv/gqqBEBUgU1F0eDs7malWIcKXRB3DXyajBB8v9ws4m
         1Tp0wgKczBIazeZqFXnk5rSLrloZeOiUD6z/OY4NkE7mvNTiUqrbB4CTdoFoRa31P7+m
         C43Bs+1MMwk9tYxbA5vuxZsgCE6uJ3Eg00CGOF4m6//LyQaEr2rapsreMfrBeMZfMZ8p
         pExpJwNUi/SwZVIB1ZAdVsILsFFkSzQVpaR2Dp/P5EJnQRYdsUBdB/jj/fDKfsTZchBD
         dZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mKh8hxnnNX4ICQ6dn6i89iBSBLL0vLdc18PMBvIwanA=;
        b=GUoPpJzmi/8JwE8QdinIkmQSNAQKJ0mUOU7rbcQdbWIMVcuH+aTt4sRFDFQQTu5cC8
         RDZwKaAH89T/oldxFihYoW+5C9FnMEed2OmufiC9FP5Esmi2nm4Q5KM4wAndSn8GlZUd
         y1Q0tuPwVWW4LJz+/2zs8tdsaH7Yi347Hh5+Too4uYqNLCEB8y6uzdyfrX6qv7KKqOql
         tWUBJbPdvhaNQhGtu9djWApC6iC1F47EAy9Y0d3E4MaF2riaA2vU4lUBmStRdGdsA68v
         5OjEgeDxu8/3A9ldJSxprpJC4b0RznHgxO1u2OBmVKnT+GV/gyAujhWJGffLOMhDWBg/
         5IJQ==
X-Gm-Message-State: AOAM532J4gGmF3APC6RCH5dyVBskZ7HjM+F8zVmZSkB0e4cLXdELlLky
        yZrQETj76vQjGYkjyPeAx0EDSBJPnMD8lO38f2o=
X-Google-Smtp-Source: ABdhPJyaLBE2utwiPYeIKxoGBQnpN0gS/ovWYsOG+a2AlWaZi+FSv98S4VSo9iNIvZje0RP11aeM1GdxRxqrCzjmJZE=
X-Received: by 2002:a25:1455:: with SMTP id 82mr6895486ybu.403.1626193027922;
 Tue, 13 Jul 2021 09:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <5aebe6f4-ca0d-4f64-8ee6-b68c58675271@huawei.com>
In-Reply-To: <5aebe6f4-ca0d-4f64-8ee6-b68c58675271@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Jul 2021 09:16:57 -0700
Message-ID: <CAEf4BzZpSo8Kqz8mgPdbWTTVLqJ1AgE429_KHTiXgEVpbT97Yw@mail.gmail.com>
Subject: Re: Ask for help about bpf map
To:     "luwei (O)" <luwei32@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Ahern <dahern@digitalocean.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 11:35 PM luwei (O) <luwei32@huawei.com> wrote:
>
> Hi, List:
>
>        I am a beginner about bpf and working on XDP now. I meet a
> problem and feel difficult to figure it out.
>
>        In my following codes, I use two ways to define my_map: in SEC
> maps and SEC .maps respectively. When I load the xdp_kern.o file,
>
> It has different results. The way I load is: ip link set dev ens3 xdp
> obj xdp1_kern.o sec xdp1.
>
>        when I define my_map using SEC maps, it loads successfully but
> fails to load using SEC .maps, it reports:
>
> "
>
> [12] TYPEDEF __u32 type_id=13
> [13] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
> [14] FUNC_PROTO (anon) return=2 args=(10 ctx)
> [15] FUNC xdp_prog1 type_id=14
> [16] INT char size=1 bits_offset=0 nr_bits=8 encoding=SIGNED
> [17] ARRAY (anon) type_id=16 index_type_id=4 nr_elems=4
> [18] VAR _license type_id=17 linkage=1
> [19] DATASEC .maps size=0 vlen=1 size == 0
>
>
> Prog section 'xdp1' rejected: Permission denied (13)!
>   - Type:         6
>   - Instructions: 9 (0 over limit)
>   - License:      GPL
>
> Verifier analysis:
>
> 0: (b7) r1 = 0
> 1: (63) *(u32 *)(r10 -4) = r1
> last_idx 1 first_idx 0
> regs=2 stack=0 before 0: (b7) r1 = 0
> 2: (bf) r2 = r10
> 3: (07) r2 += -4
> 4: (18) r1 = 0x0

this shouldn't be 0x0.

I suspect you have an old iproute2 which doesn't yet use libbpf to
load BPF programs, so .maps definition is not yet supported. cc'ing
netdev@vger, David and Toke

> 6: (85) call bpf_map_lookup_elem#1
> R1 type=inv expected=map_ptr
> processed 6 insns (limit 1000000) max_states_per_insn 0 total_states 0
> peak_states 0 mark_read 0
>
> Error fetching program/map!
>
> "
>
> I tried to search google, and only found the following page:
>
> https://stackoverflow.com/questions/67553794/what-is-variable-attribute-sec-means
>
> Does anyone meet the same problem or help to explain this or provide me
> some suggestions ? Thanks !
>
>
> === xdp1_kern.c ===
>
> #define KBUILD_MODNAME "foo"
> #include <uapi/linux/bpf.h>
> #include <linux/time.h>
> #include <linux/in.h>
> #include <linux/if_ether.h>
> #include <linux/if_packet.h>
> #include <linux/if_vlan.h>
> #include <linux/ip.h>
> #include <linux/ipv6.h>
> #include <bpf/bpf_helpers.h>
>
> struct {
>      __uint(type, BPF_MAP_TYPE_HASH);
>      __uint(max_entries, 1024);
>      __type(key, int);
>      __type(value, int);
> } my_map SEC(".maps");
>
> #if 0
> #define PIN_GLOBAL_NS           2
> struct bpf_elf_map {
>          __u32 type;
>          __u32 size_key;
>          __u32 size_value;
>          __u32 max_elem;
>          __u32 flags;
>          __u32 id;
>          __u32 pinning;
> };
>
> struct bpf_elf_map SEC("maps") my_map = {
>          .type = BPF_MAP_TYPE_HASH,
>          .size_key = sizeof(int),
>          .size_value = sizeof(int),
>          .pinning        = PIN_GLOBAL_NS,
>          .max_elem = 65535,
> };
> #endif
>
> SEC("xdp1")
> int xdp_prog1(struct xdp_md *ctx)
> {
>      int key = 0;
>      struct map_elem *val;
>
>      val = bpf_map_lookup_elem(&my_map, &key);
>      if (val) {
>          return XDP_PASS;
>      }
>
>      return XDP_PASS;
> }
>
> char _license[] SEC("license") = "GPL";
>
> --
> Best Regards,
> Lu Wei
>
