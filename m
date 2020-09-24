Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1499427730F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 15:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgIXNs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 09:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbgIXNs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 09:48:57 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7B5C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 06:48:56 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id n133so3241143qkn.11
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 06:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OZuoxi4EqplAFCHk3ahbjllhqfwDqYp3LSNyZOe3ca4=;
        b=n9Axtkm0l142PghTMs5nXqMaBF/Pyo+UCcNLUfOEvsNAfzt4Z1lfxk/ZDxo7Shx4Fv
         oKUJxk/hUeaNtit+t6/76Nu/O/VUMVfYnaXP+QJ6LzjH8XcErSepzrBQibWHF9ph0zq+
         bHMFtBrIPHgjtygfXh58zm8wsvaEN1LPMkVpruW8HMpTyi8esHjuVGR270lxdLjpcutb
         5IUFlqjQ4hKar7yn8ZdN6U5NO+O/6P7Kd97aLxQPca3sudkRBLyTlDLWFHr9wcRlA4oh
         SSL4KXrwSP/Iy55Q9S5v/xan4lNovRB1Nra+bl5rxRQU5tmzvCHXL8VNgF9/qOByKneI
         TuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OZuoxi4EqplAFCHk3ahbjllhqfwDqYp3LSNyZOe3ca4=;
        b=Tyfgf3sMLm1KGyPvIXokZBXzLuOcCxfS+GZu5DPMBWaOehNziKALUvjD4BRSNBCQrd
         hVCWll5LK1Odtiews/atmQJSrJeqPBrRyk5e2vBevu3SiA7qK5SXrM5eitD/Ocjy712i
         ZMXuDZf3AoTputiLkVuqnJaV+CGTpwA8UuoGiQW1FXfgCjnsNEC0JNTh9/UOliP2vQwR
         bYRXKB+JEkh3oPQjY2ONuLDQt03CHtsLUUCuRuNvgxYOoxpoNVSaW3Z6YUTa7oEf3QgP
         GJbT6OOA1QKgxI/k0VRFwGnNsTTF7sVUhFCKc/curLY2REn95AtXsddpm7Bw1XrsAfUZ
         wURQ==
X-Gm-Message-State: AOAM533+2Q1mjlVCT7KT8VLHN4fv2CWDKD1PGWMpxsAK/sYVvlZUHHnV
        Z+6V9OlOkEycZPFhPhXC5YA28UMpUa6s
X-Google-Smtp-Source: ABdhPJwEdUdPq3PHEVQhQxPe+1D1P1q4rKbQ8d2opskmeXa7JBvDNOkbsB1OlrBOHfFaUFbFl1oGRg==
X-Received: by 2002:a05:620a:2055:: with SMTP id d21mr5035481qka.202.1600955335338;
        Thu, 24 Sep 2020 06:48:55 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id z37sm2354030qtz.67.2020.09.24.06.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 06:48:54 -0700 (PDT)
Date:   Thu, 24 Sep 2020 09:48:45 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: ip rule iif oif and vrf
Message-ID: <20200924134845.GA3688@ICIPI.localdomain>
References: <20200922131122.GB1601@ICIPI.localdomain>
 <2bea9311-e6b6-91ea-574a-4aa7838d53ea@gmail.com>
 <20200923235002.GA25818@ICIPI.localdomain>
 <ccba2d59-58ad-40ca-0a09-b55c90e9145e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccba2d59-58ad-40ca-0a09-b55c90e9145e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 07:47:16PM -0600, David Ahern wrote:
> If I remove the fib rules and add VRF route leaking from core to tenant
> it works. Why is that not an option? Overlapping tenant addresses?

Exactly.

> One thought to get around it is adding support for a new FIB rule type
> -- say l3mdev_port. That rule can look at the real ingress device which
> is saved in the skb->cb as IPCB(skb)->iif.

OK. Just to ensure that the existing ip rule behavior isn't considered a
bug.

We have multiple options on the table right now. One that can be done
without writing any code is to use an nft prerouting rule to mark
the packet with iif equals the tunnel and use ip rule fwmark to lookup
the right table.

ip netns exec r0 nft add table ip c2t
ip netns exec r0 nft add chain ip c2t prerouting '{ type filter hook prerouting priority 0; policy accept; }'
ip netns exec r0 nft rule ip c2t prerouting iif gre01 mark set 101 counter
ip netns exec r0 ip rule add fwmark 101 table 10 pref 999

ip netns exec r1 nft add table ip c2t
ip netns exec r1 nft add chain ip c2t prerouting '{ type filter hook prerouting priority 0; policy accept; }'
ip netns exec r1 nft rule ip c2t prerouting iif gre10 mark set 101 counter
ip netns exec r1 ip rule add fwmark 101 table 10 pref 999

But this doesn't seem to work on my Ubuntu VM with the namespaces
script, i.e. pinging from h0 to h1. The packet doesn't egress r1_v11. It
does work on our target, based on 4.14 kernel.

We also notice though in on the target platform that the ip rule fwmark
doesn't seem to change the skb->dev to the vrf of the lookup table.
E.g., ping from 10.0.0.1 to 11.0.0.1. With net.ipv4.fwmark_reflect set,
the reply is generated but the originating ping application doesn't get
the packet.  I suspect it is caused by the socket is bound to the tenant
vrf. I haven't been able to repro this because of the problem with the
nft approach above.

Thanks,
Stephen.
