Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB7E27FEE9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 14:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbgJAM00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 08:26:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731888AbgJAM0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 08:26:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601555183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KlgkYX8n4ISnPRnnZPnfjnV+S3Lx6o3gn2MCV8L4mDU=;
        b=UTbh2eNsVqTnarGx8nZfybtybiuMYtieznasKfTgqPb3+lDw1EcOkzj42PKnFuZGdErVCw
        RppxJaC+11u8BjpXAoMCYTyAQjYwceTZq3iMLSDIb6L3h0UfWEbkxPN28Y0+g/R2DdzpBQ
        hoZuEqYIzt5dP/7L6zxrIW2dBvwu8+Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-LNPdzqlPOvaQpYrLYJf10A-1; Thu, 01 Oct 2020 08:26:22 -0400
X-MC-Unique: LNPdzqlPOvaQpYrLYJf10A-1
Received: by mail-wr1-f69.google.com with SMTP id v5so1959598wrs.17
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 05:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KlgkYX8n4ISnPRnnZPnfjnV+S3Lx6o3gn2MCV8L4mDU=;
        b=cdnv83g/kZpGSYuj8v2nyGQ2ah0ivPrarzhkDEAAOlUF3CUJF3EYcw2WB2KjEljP/T
         N4KtOItEzLkj7rRSJYzWO5tf1zffnZ33aHsn7afh0+GZjZVfJ2cWp80mdGnEm9j138gg
         wDt+aw302lrubFFWapT8dy0scfQSNS07GgX546l1IY4Pz7TCisp4lutNwcNlh5SXAraY
         /Q+Gf1aUI/AgISV1SDxjDsBWB5uvfB1rvU7a4c7fBHBhnn4ZyQTHI8o4nvBHs3/+sUIC
         RtNS+ORuR/b77YXd2SRGNTGn2WNYU3svHKDI2yInbErvdvgeDszCC6v655IXWXg7/eda
         i/0Q==
X-Gm-Message-State: AOAM530lH0nOY5aUKiSjkMxR4JRqRASokZL5Xup3CoVzM6eOfJBOWydF
        BovYVmAHATQ7EThb5/fuBOK77HNKX3xiw7RmjjLmuRomWtV7a270IXIb6LiEvYF2TaFJpHjdWd7
        03cSChc39nRlW32l3
X-Received: by 2002:a1c:480a:: with SMTP id v10mr7968170wma.141.1601555180613;
        Thu, 01 Oct 2020 05:26:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyflHFEPSpcyL6d0oRrmaDjF1AI3ZipzXRBd/t6GIAegwvJ0YYUsymw/1wHhbMmOn29iQFkfg==
X-Received: by 2002:a1c:480a:: with SMTP id v10mr7968145wma.141.1601555180288;
        Thu, 01 Oct 2020 05:26:20 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id b64sm8676253wmh.13.2020.10.01.05.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:26:19 -0700 (PDT)
Date:   Thu, 1 Oct 2020 14:26:17 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 0/6] l2tp: add ac/pppoe driver
Message-ID: <20201001122617.GA9528@pc-2.home>
References: <20200930210707.10717-1-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930210707.10717-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:07:01PM +0100, Tom Parkin wrote:
> L2TPv2 tunnels are often used as a part of a home broadband connection,
> using a PPP link to connect the subscriber network into the Internet
> Service Provider's network.
> 
> In this scenario, PPPoE is widely used between the L2TP Access
> Concentrator (LAC) and the subscriber.  The LAC effectively acts as a
> PPPoE server, switching PPP frames from incoming PPPoE packets into an
> L2TP session.  The PPP session is then terminated at the L2TP Network
> Server (LNS) on the edge of the ISP's IP network.
> 
> This patchset adds a driver to the L2TP subsystem to support this mode
> of operation.

Hi Tom,

Nice to see someone working on this use case. However, have you
considered other implementation approaches?

This new module reimplements PPPoE in net/l2tp (ouch!), so we'd now
have two PPPoE implementations with two different packet handlers for
ETH_P_PPP_SES. Also this implementation doesn't take into account other
related use cases, like forwarding PPP frames between two L2TP sessions
(not even talking about PPTP).

A much simpler and more general approach would be to define a new PPP
ioctl, to "bridge" two PPP channels together. I discussed this with
DaveM at netdevconf 2.2 (Seoul, 2017) and we agreed that it was
probably the best way forward.

It's just a matter of extending struct channel (in ppp_generic.c) with
a pointer to another channel, then testing this pointer in ppp_input().
If the pointer is NULL, use the classical path, if not, forward the PPP
frame using the ->start_xmit function of the peer channel. There are a
few details to take into account of course (crossing netns, locking),
but nothing big (I could implement it the following night in my hotel
room before leaving Seoul). This approach should work for forwarding
PPP frames between any type of PPP transport.

I unfortunately didn't propose the code upstream at that time, because
I didn't want to add this kernel feature without having a userspace
implementation making use of it and ready to release (and I finally
left the company before that happened). But I know that this
implementation worked fine as it did receive quite a lot of testing.

Yet another way to implement this feature would to define virtual PPPoE
and L2TP devices, working in external mode. In practice, one PPPoE and
one L2TP network device would be enough for handling all the traffic.
Then TC could be used to pass the PPP frames between PPPoE and L2TP.

Example (assuming flower and tunnel_key were extented to support PPPoE
and L2TP):

# Forward PPPoE frames with Session-ID 5 to L2TP tunnel 1 session 1
$ tc filter add dev pppoe0 ingress flower pppoe_sid 5   \
    action tunnel_key src_ip 192.0.2.1 dst_ip 192.0.2.2 \
                      l2tp_tid 1 l2tp_peertid 1         \
                      l2tp_sid 1 l2tp_peer_sid 1        \
    action mirred egress redirect dev l2tp0

# Reverse path
$ tc filter add dev l2tp0 ingress flower l2tp_tid 1 l2tp_sid 1            \
    action tunnel_key dst_mac 02:00:00:00:00:01 src_mac 02:00:00:00:00:02 \
                      id 5                                                \
    action mirred egress redirect dev pppoe0

Of course the commands would be a bit longer in practice (one would
probably want to match on the src and dst IP addresses in the reverse
path, or set the L2TP version, etc.), but that's the general idea.

Such approach would probably not allow the use of L2TP sequence numbers
though (which might not be a bad thing in the end). It'd also require
more work, but would avoid going through the PPP layer and might even
be offloadable (if a NIC vendor ever wants to support it).

Regards,

Guillaume

