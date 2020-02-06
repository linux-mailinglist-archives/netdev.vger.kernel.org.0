Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 335AF154AFD
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 19:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgBFSWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 13:22:32 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46824 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727788AbgBFSWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 13:22:32 -0500
Received: by mail-qt1-f194.google.com with SMTP id e25so5215340qtr.13
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 10:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J7BdrAMT8Cnbb8uJ2iXxM261FItPlowAirwsTdOU+o4=;
        b=LG2mm9GLI8dAo9vajqgnCi0ZgtwQC3hksGt0TglXNSIqMU9vyu/ouS19PkPaPrhNws
         t+Z0sl3/QX7L9QVB7u1iLznmX1nzBYC4CdpJv+j9JWegnIc59etHh3i8p31zcgQqoKp1
         Gscu35coJZi3M9VG2qGw+rHbY69N+V5tElA1qayXPPp9dHWotZwF8JUPf4bmZ5splKDt
         aCm80QQzci1/LB2TBe5ZJUY9GhTnx8vyVmOU2T+59zV7r0O5kFUtQoyTvx+TKUcaUBaQ
         1pOT5GZe+3JcWbw4hfUQ+n+tDfgvktmuBAPBJG/1c0m2RtjWhidJkEqtNEvNuYkcQJi0
         jMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J7BdrAMT8Cnbb8uJ2iXxM261FItPlowAirwsTdOU+o4=;
        b=JFbl9DQyH9SXhFXOe9AsL4t98aBmVbrOsPXF/hDk0lvRpaCnkvhCkrMU+poAaMoD+a
         S6328TPzdjyM2EejJXa2LVNpheLexyXe8n+IY4tg/TFgljKEja5RovsVelqS8Z0VYWcA
         dtvpFD+eCZemnw5i70TybFSm0FhJ9HLfjj1FgbcvUuHffmpg106CtKLLCb+U4FSb82ER
         E+GAc9wcLwOP+reS8HbQVyH6J+iKdiQqpCW+LQXX/8D4wroUSSaSxy7DSZfaPEE8wChG
         5Aee6OJB+LHFJWp0Tvx/HdrNjdtfD5JbNTOQEsXc3Ynxe6aCdc8j2YlRp80K4F1xO49U
         ypPg==
X-Gm-Message-State: APjAAAXgUiG8M4ML5JbqgbS4C2iIfqdYyg3LuV1ULkMlYGjbJcysqJXS
        YyJCZfrSD/o0XK7r9H0n7IMXiKsM
X-Google-Smtp-Source: APXvYqwJ5W3aMwQQYFnZu0XJOgp/XKBSrtblrljvJn8OFKbUkhfcDD0qoJUlWmji3AN1vaqbFc2Vdw==
X-Received: by 2002:aed:234a:: with SMTP id i10mr3816602qtc.155.1581013351275;
        Thu, 06 Feb 2020 10:22:31 -0800 (PST)
Received: from ryzen (104-222-125-163.cpe.teksavvy.com. [104.222.125.163])
        by smtp.gmail.com with ESMTPSA id h13sm40954qtu.23.2020.02.06.10.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 10:22:30 -0800 (PST)
Date:   Thu, 6 Feb 2020 13:22:28 -0500
From:   Alexander Aring <alex.aring@gmail.com>
To:     Michael Richardson <mcr@sandelman.ca>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        dav.lebrun@gmail.com
Subject: Re: [PATCH net 0/2] net: ipv6: seg6: headroom fixes
Message-ID: <20200206182228.24ahn5n6fvaivtj6@ryzen>
References: <20200204173019.4437-1-alex.aring@gmail.com>
 <26689.1580905297@dooku.sandelman.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <26689.1580905297@dooku.sandelman.ca>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Cc: Roopa Prabhu <roopa@cumulusnetworks.com>

as she introduced the mentioned patch about the headroom value in
lwtunnel.

On Wed, Feb 05, 2020 at 01:21:37PM +0100, Michael Richardson wrote:
> 
> Alexander Aring <alex.aring@gmail.com> wrote:
>     > This patch series fixes issues which I discovered while implementing RPL
>     > source routing for 6LoWPAN interfaces. 6LoWPAN interfaces are using a MTU
>     > of 1280 which is the IPv6 minimum MTU. I suppose this is the right fix to
>     > do that according to my explanation that tunnels which acting before L3
>     > need to set this headroom. So far I see only segmentation route is affected
>     > to it. Maybe BPF tunnels, but it depends on the case... Maybe a comment
>     > need to be added there as well to not getting confused. If wanted I can
>     > send another patch for a comment for net-next or even net? May the
>     > variable should be renamed to l2_headroom?
> 
> I had discussed this with Alex over the past few days.
> I had not looked closely at the code during that discussion, and maybe my
> comments in chat were wrong.  So these patches don't look right to me.
> 
> I think that the issue we have here is that things are big vague when it
> comes to layer-2.5's, and fatter layer-3s.  Maybe this is well established in
> lore...
> 

Yes, we know:

MPLS: Before Layer 3
SEG6: In Layer 3

To also keep in mind that the Linux interface MTU is a Layer 3 MTU.

Now what I think is going on here is that the ip6_route.c implementation
keeps track of "per destination MTU" [0] some lines below we will hit
the -EINVAL case [1] of sendmsg() because it doesn't fit into IPv6 min MTU
anymore (May EMSGSIZE) would be more correct here? Man pages says:

If  the  message  is too long to pass atomically through the underlying
protocol, the error EMSGSIZE is returned, and the message is not transmitted.

The whole _interface_ mtu per destination will be calculated during
runtime by a callback in ip_route.c [2]. The patch I mentioned in 1/2 by
commit 14972cbd34ff ("net: lwtunnel: Handle fragmentation") changed the
line so that the tunnel headroom value get respected for the tunnel
destination whatever you specified for:

return mtu - lwtunnel_headroom(dst->lwtstate, mtu);

As I see this MTU is the same considered as the interface MTU which is
Layer 3. It is correct to respected the size for tunnels before Layer 3
but not in Layer 3 or afterwards.

> My understanding is that headroom is a general offset, usually set by the L2
> which tells the L3/L4 how much to offset in the SKB before the ULP header is
> inserted.   TCP/UDP/SCTP/ESP need to know this.
> 

I am not sure if I understand that correctly. In receive path the skb is
handeld to the next layer to layer and even set some offset like
mac_header, network_header and transport_header. Each tunnel can/must?
need to set these offsets again after parsing.

In transmit, the skb will be framented at the lower layer if necessary.

So _far_ I see the headroom value takes only place in [2] but this gets
somehow hidden in some callback. That it is in route.c smells for me
it's only used in this context.

I could be wrong here because this callback is hard to track. But the
check of [1] and getting this value by [0] which invokes the callback of
[2] it is wrong to calculate the MTU by doing:

$INTERFACE_L3_MTU - $ROUTE_HEADER_IN_L3

but it is correct by doing (which is MPLS):

$INTERFACE_L3_MTU - $ROUTE_HEADER_BEFORE_L3

I am sure this is wrong, may there could be more additional side
effects which I have not tracked yet and to fix that the original
authors should mention why they set the headroom value.

> MPLS is a layer-2.5, and so it quite weird, because it creates a new L2
> which lives upon other L2 and also other L3s.
> 
> Segment routing, and RPL RH3 headers involve a fatter L3 header.
> 
> Of course, one could mix all of these things together!
>

As I see the headroom value for tunnels in Layer 3 should always be
zero. It's getting complicated when you have a tunnel before Layer 3 and
the length is determined during runtime... the whole code can only
handle "for this route this length" and the length need to be set at
build time. I don't see issues here for RPL RH3 (I think) except we need
to set the headroom value where in our case the length of it is really
determined during runtime because destination address.

- Alex

[0] https://elixir.bootlin.com/linux/v5.5.1/source/net/ipv6/ip6_output.c#L1285
[1] https://elixir.bootlin.com/linux/v5.5.1/source/net/ipv6/ip6_output.c#L1295
[2] https://elixir.bootlin.com/linux/v5.5.1/source/net/ipv6/route.c#L3063
