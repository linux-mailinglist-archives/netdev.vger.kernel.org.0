Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF40B330F18
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCHN0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhCHN0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 08:26:06 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902C2C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 05:26:06 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id e19so20398435ejt.3
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 05:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7lidwafJ6VNSpmbehmWeJrASkBhdq44CYh/f8KaJY4E=;
        b=GN0WVnr+axmECz3b6Vs6uCDUn/Tx2pqIqmRYcK0cTEZ4X5ge9RW/RmMagSHOx698NL
         Yl+4NLHIy8p+/8f3XQryYIgdJrvlO79kHd6rFJ1FggpYYnafkYjo5Guqc6DQ0W9VgQPX
         SNICUxRpyA9eQ5nl0Dwg9fO5Rv9XD7t7W+dLXMvrggpR4lSSwFSUPNEz1ofUTac11Uyg
         Scpp3/+ykyTRa0R5NxZrNfs3Zs4ZhcTbn0/ZDtqt0QjFrXhdkNwiArI3GnkhC7+1j+2C
         I7gWk2vPyTCB+P/V+WE/nu3WGEfbuYbkYL7q1mPcfZkTkvHPPZ9Smh3yL1oq1n8cg7W/
         P7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7lidwafJ6VNSpmbehmWeJrASkBhdq44CYh/f8KaJY4E=;
        b=j87m0729FMUELeHm2WvK5hEsfU+2td+E0E/IlnEg4rhp+ZsB/wPkaUGfBJhZ16eCvZ
         djRz8rJwqBYsFpXeT1xhnyMbUBuco7RuTKD28G9Oh8GN4/DkXLBunzUYud1tDiVqXG9y
         OscsY3ndnrBPRgXoZYve1apLGq+WwRDSTjKqZeIMUxEfq1oma/qLWtosF81oMeWXWsLP
         4jNVINE7gcsnpJ1lzN6Fja7b5pRPD0GMTj0s4Od6Cq/2ROrA7BuGOyZqQAq39tqdeydq
         68XiTLs5wVoTnplOiQoC6Wa6HickiBgeqm8pmG8m7kMNUEbx+mVXZj0SoLhbYWjNy7co
         1csw==
X-Gm-Message-State: AOAM531UzlLv6JO/txTat46CWpy9ItYmhH+0EdY7GXI/xiTXTRAPJUyn
        dIxIAPmG/cR2KdVCs7IUNJm+ZzMT5REAqedAwNk=
X-Google-Smtp-Source: ABdhPJygSRLBsEcfoKabSxLrlL4J0BVyjMkjuPbbb88dECsPnTF/fh+1qoTuqQeAsr9GxHcRUyCduV2JU4ZP4UuncaQ=
X-Received: by 2002:a17:906:3ac3:: with SMTP id z3mr15292827ejd.106.1615209965398;
 Mon, 08 Mar 2021 05:26:05 -0800 (PST)
MIME-Version: 1.0
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
 <20210305150702.1c652fe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YELKIZzkU9LxpEE9@lunn.ch> <CA+sq2CfAsyFHEj=w3=ewTKk-qbF60FcCQNtk9e7_1wxf=tB7QA@mail.gmail.com>
 <20210306131814.h4u323smlihpf3ds@skbuf>
In-Reply-To: <20210306131814.h4u323smlihpf3ds@skbuf>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Mon, 8 Mar 2021 18:55:54 +0530
Message-ID: <CA+sq2Cdx4X7HBjdE8bU6OcS6g+yzx1Xj7n1VmPh_a+AoGPyvsg@mail.gmail.com>
Subject: Re: Query on new ethtool RSS hashing options
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 6, 2021 at 6:48 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Sat, Mar 06, 2021 at 06:04:14PM +0530, Sunil Kovvuri wrote:
> > On Sat, Mar 6, 2021 at 5:47 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Fri, Mar 05, 2021 at 03:07:02PM -0800, Jakub Kicinski wrote:
> > > > On Fri, 5 Mar 2021 16:15:51 +0530 Sunil Kovvuri wrote:
> > > > > Hi,
> > > > >
> > > > > We have a requirement where in we want RSS hashing to be done on packet fields
> > > > > which are not currently supported by the ethtool.
> > > > >
> > > > > Current options:
> > > > > ehtool -n <dev> rx-flow-hash
> > > > > tcp4|udp4|ah4|esp4|sctp4|tcp6|udp6|ah6|esp6|sctp6 m|v|t|s|d|f|n|r
> > > > >
> > > > > Specifically our requirement is to calculate hash with DSA tag (which
> > > > > is inserted by switch) plus the TCP/UDP 4-tuple as input.
> > > >
> > > > Can you share the format of the DSA tag? Is there a driver for it
> > > > upstream? Do we need to represent it in union ethtool_flow_union?
> > >
> > > Sorry, i missed the original question, there was no hint in the
> > > subject line that DSA was involved.
> > >
> > > Why do you want to include DSA tag in the hash? What normally happens
> > > with DSA tag drivers is we detect the frame has been received from a
> > > switch, and modify where the core flow dissect code looks in the frame
> > > to skip over the DSA header and parse the IP header etc as normal.
> >
> > I understand your point.
> > The requirement to add DSA tag into RSS hashing is coming from one of
> > our customer.
> >
> > >
> > > Take a look at net/core/flow_dissect.c:__skb_flow_dissect()
> > >
> > > This fits with the core ideas of the network stack and offloads. Hide
> > > the fact an offload is being used, it should just look like a normal
> > > interface.
> > >
> > >         Andrew
> >
> > Yes, the pkt will look like a normal packet itself.
> > In our case HW strips the DSA tag from the packet and forwards it to a VF.
>
> DSA-aware SR-IOV on master, very interesting. I expect that the reverse
> is true as well: on xmit, the VF will automatically insert a FWD tag
> into the packet too, which encodes a 'virtual' source port and switch id.

Yes, HW inserts the tag on the transmit side automatically.

>
> What Marvell controller is this? How is the SR-IOV implemented in the
> kernel, is it modeled as switchdev, with host representors for the VFs?

This is Marvell OcteonTx2/CN10K RVU controller
drivers/net/ethernet/marvell/octeontx2.
And no the controller doesn't have a internal switch and hence
currently there is no switchdev support.
The switch I referred to is an external one whose CPU port is
connected to this controller.

> Does it support VEPA mode or VEB too? If it supports VEB, does it learn
> (more like 'steal') addresses from the DSA switch's FDB? Does it also
> push addresses into the DSA switch's FDB?
>
> To your question: why stop at hashing? What about flow steering?
> What does your hardware actually support? It is obvious that it has deep
> parsing of Marvell DSA tags specifically, so the generic 'masked u32 key'
> matching may not be the best way to model this. Can your DSA master even
> perform masked matching on generic u32 keys, or are you planning to just
> look for the particular pattern of a Marvell DSA tag in the ethtool
> rxnfc callbacks, and reject anything that doesn't match?

The parser in the HW is configurable and can parse any header with a mask.

Thanks,
Sunil.
