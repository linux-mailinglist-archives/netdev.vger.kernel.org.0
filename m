Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1D9D7B59
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 18:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfJOQZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 12:25:47 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36895 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfJOQZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 12:25:47 -0400
Received: by mail-pg1-f193.google.com with SMTP id p1so12452412pgi.4
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 09:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jGRGii0EwhWRFCDQASuAI4tbHutZUz3noX0o+KwqWEM=;
        b=GEXKYWXDDDjJJp6WGhPHgKcL9Ja3O4JI5DOeVCoVUDfDNABb8WBn8P6sQdl5q9JkJE
         8k5RjtsLy0jxuO/l5wxp3LtOWqO2FUyfxkvDcB2jOhegLQiC4ReJVJYi1ngZe+/4AieB
         T5fF+WkxiU5sLXC02sPFsGC1MIycF/De6vBDugCYQyqpo8O76peAlE2AKJy3JeFLni20
         K5ZmcK1gEnc/nHxYALtM+X8O0NvYEoqLVCt6UTeauvDvon3jMAL51dOKwFfYByDDwwPd
         rS5xBEs9agft0NzLlYhcjZ6NFqrZJu+S7UMUPmAF9hxeqxgOJZA3rKTx0ZmDxdURCZhQ
         lteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jGRGii0EwhWRFCDQASuAI4tbHutZUz3noX0o+KwqWEM=;
        b=GmqHWoH53Yy6D3ICVaG4r8voEwHSNycoHbbfPABQZHqHJVJstRUqdeT146u0dKD0G7
         wGRC546yIxmfR0bnmg5+Pq4T5VJtK5QbLfCCat8tcL2qIxL56cc7pVUQreBm+S/FnSad
         ObFz4lMEDE+eQIQ7ndHP+OPC6G1Ly7I8CL5EkXzxNRkLhJKQLALFZa9INAsQLHqRvSOT
         ki5a1v7ontxCGfU/13oMQ1vLDHjjdeR6ka5P93geloZgof5CXDvcUHv6AiMdpBTO2Jn4
         RRbGvkTSEEzVIAPpNqhfM9yHNZYjxA1neS8Cj4z/Gxpxz/TWkxDaQy11nYfpxUI7HMSk
         YkEA==
X-Gm-Message-State: APjAAAUV8q3jxzfYVeXcVDuDaCeuBGF1TlIhy3sTCECFKo1MWAIWkrU5
        C0Hs7HGKxp8+c6E52wxsCx/EaQ==
X-Google-Smtp-Source: APXvYqx9eUEdkcy2Kf02OrVdhq51jTsGaEw2NdDtKtuXCmUkIqOH4Nuj7Nh5TbCI8CiLOz+geBKPwg==
X-Received: by 2002:a62:8209:: with SMTP id w9mr39553815pfd.5.1571156745800;
        Tue, 15 Oct 2019 09:25:45 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z25sm21647618pfn.7.2019.10.15.09.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 09:25:45 -0700 (PDT)
Date:   Tue, 15 Oct 2019 09:25:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Petr Oros <poros@redhat.com>
Subject: Re: [PATCH iproute2] ipnetns: enable to dump nsid conversion table
Message-ID: <20191015092537.24115f5e@hermes.lan>
In-Reply-To: <0983aadc-7375-75c7-e8ed-b2f8213e1bca@6wind.com>
References: <20191007134447.20077-1-nicolas.dichtel@6wind.com>
        <20191014131500.7dd2b1a8@hermes.lan>
        <0983aadc-7375-75c7-e8ed-b2f8213e1bca@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 09:33:24 +0200
Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> Le 14/10/2019 =C3=A0 22:15, Stephen Hemminger a =C3=A9crit=C2=A0:
> > On Mon,  7 Oct 2019 15:44:47 +0200
> > Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> >  =20
> >> This patch enables to dump/get nsid from a netns into another netns.
> >>
> >> Example:
> >> $ ./test.sh
> >> + ip netns add foo
> >> + ip netns add bar
> >> + touch /var/run/netns/init_net
> >> + mount --bind /proc/1/ns/net /var/run/netns/init_net
> >> + ip netns set init_net 11
> >> + ip netns set foo 12
> >> + ip netns set bar 13
> >> + ip netns
> >> init_net (id: 11)
> >> bar (id: 13)
> >> foo (id: 12)
> >> + ip -n foo netns set init_net 21
> >> + ip -n foo netns set foo 22
> >> + ip -n foo netns set bar 23
> >> + ip -n foo netns
> >> init_net (id: 21)
> >> bar (id: 23)
> >> foo (id: 22)
> >> + ip -n bar netns set init_net 31
> >> + ip -n bar netns set foo 32
> >> + ip -n bar netns set bar 33
> >> + ip -n bar netns
> >> init_net (id: 31)
> >> bar (id: 33)
> >> foo (id: 32)
> >> + ip netns list-id target-nsid 12
> >> nsid 21 current-nsid 11 (iproute2 netns name: init_net)
> >> nsid 22 current-nsid 12 (iproute2 netns name: foo)
> >> nsid 23 current-nsid 13 (iproute2 netns name: bar)
> >> + ip -n foo netns list-id target-nsid 21
> >> nsid 11 current-nsid 21 (iproute2 netns name: init_net)
> >> nsid 12 current-nsid 22 (iproute2 netns name: foo)
> >> nsid 13 current-nsid 23 (iproute2 netns name: bar)
> >> + ip -n bar netns list-id target-nsid 33 nsid 32
> >> nsid 32 current-nsid 32 (iproute2 netns name: foo)
> >> + ip -n bar netns list-id target-nsid 31 nsid 32
> >> nsid 12 current-nsid 32 (iproute2 netns name: foo)
> >> + ip netns list-id nsid 13
> >> nsid 13 (iproute2 netns name: bar)
> >>
> >> CC: Petr Oros <poros@redhat.com>
> >> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> >> ---
> >>  include/libnetlink.h |   5 +-
> >>  ip/ip_common.h       |   1 +
> >>  ip/ipnetns.c         | 115 +++++++++++++++++++++++++++++++++++++++++--
> >>  lib/libnetlink.c     |  15 ++++--
> >>  4 files changed, 126 insertions(+), 10 deletions(-)
> >> =20
> >=20
> > Applied. Please send another patch to update man page.
> >  =20
> Yes, I will do.
> I don't see the patch on kernel.org, am I missing something?

Just pushed, was running a bunch of other stuff
