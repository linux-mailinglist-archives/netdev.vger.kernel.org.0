Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759B63266B8
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 19:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhBZSJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 13:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhBZSJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 13:09:54 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15B9C061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 10:09:13 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s8so12108058edd.5
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 10:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Prd3+/CUaZYUUbwRde0gLchKlI288B4PXVq50MaG0rA=;
        b=rpd+0jSiUKFH0ymdD80JfGmONXrdncxZqZ/UJB/Wl/zUFRCtkjSYeYTcPnhgcLzpQp
         SvooE+fiL8HS81dQ2+aiJDLHCRgdESGFkjClpLdcYY9q4hgi4PYELPQU+xbopwZWlO9T
         0q0bhIXfaIlxd3aCiUB1WwTjJ7OQWA2YiWVSd2rpAEwinA0DvkNEvtvviboQMgmEj7Ui
         e3ZtAd0DijbsFWNIto+fggRqpMGfwc98WmZupWX4PswI3f9GoACLEszOGY6/iHAn6wF/
         Vdo2k8V5/Et9DbgpVJfvtL8C7WUA3l7ipNqs14Yn9K1Dlr2sdWPOWfKmy4vcc7kwGksD
         jk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Prd3+/CUaZYUUbwRde0gLchKlI288B4PXVq50MaG0rA=;
        b=WhfZp5LloC53S08gml9ACq0xSCSWBeJiHr2jEcscKcI8TFslAiVkMlfxKDEDhQbwY9
         b/DAxzHw042/pu5lWorPTA84db8bTo1iczj0/JkGatn11hiagDQ7X23vh6V6dQDxrmxt
         gYT9sBdZm6RnDULl10YmcpFUh+b9jxf5ROq7qiveLw9PZ0/apwjtb0HFv/B+wALQy3nL
         6Cl526MRWL5Uif+NBotIeXjFs6q7l97kHltDU0doaZkuL2MrV8RJJ1LfMfgQVMgpWWoh
         djhJZAfknSowEkth+tAe3OSeXMG7B/2jxmnc9YDLUxWPuDwdhhE7k9/oJ53VNo3hBuj1
         KsXg==
X-Gm-Message-State: AOAM531xE6Y+3TXQpjORCzQ+VM51R8HFuQG1jOmZldMv18PLubGGpU77
        dmbnIAj/CdrFwkw9pauJwzk=
X-Google-Smtp-Source: ABdhPJzVVqmSIHUwRVYo3LPEkk3KBchT8l3aiht+0xWTVmeaikYOHIhwXjuxl8ha5WeipaSe1VWgPQ==
X-Received: by 2002:a50:d90a:: with SMTP id t10mr4933481edj.162.1614362952639;
        Fri, 26 Feb 2021 10:09:12 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id e22sm6212957edu.61.2021.02.26.10.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 10:09:12 -0800 (PST)
Date:   Fri, 26 Feb 2021 20:09:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 08/12] Documentation: networking: dsa: add
 paragraph for the LAG offload
Message-ID: <20210226180910.mljsg22edc4rwzdq@skbuf>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-9-olteanv@gmail.com>
 <87v9afria3.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9afria3.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 09:42:28PM +0100, Tobias Waldekranz wrote:
> On Sun, Feb 21, 2021 at 23:33, Vladimir Oltean <olteanv@gmail.com> wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Add a short summary of the methods that a driver writer must implement
> > for offloading a link aggregation group, and what is still missing.
> >
> > Cc: Tobias Waldekranz <tobias@waldekranz.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  Documentation/networking/dsa/dsa.rst | 32 ++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> >
> > diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> > index 463b48714fe9..0a5b06cf4d45 100644
> > --- a/Documentation/networking/dsa/dsa.rst
> > +++ b/Documentation/networking/dsa/dsa.rst
> > @@ -698,6 +698,38 @@ Bridge VLAN filtering
> >    function that the driver has to call for each MAC address known to be behind
> >    the given port. A switchdev object is used to carry the VID and MDB info.
> >  
> > +Link aggregation
> > +----------------
> > +
> > +Link aggregation is implemented in the Linux networking stack by the bonding
> > +and team drivers, which are modeled as virtual, stackable network interfaces.
> > +DSA is capable of offloading a link aggregation group (LAG) to hardware that
> > +supports the feature, and supports bridging between physical ports and LAGs,
> > +as well as between LAGs. A bonding/team interface which holds multiple physical
> > +ports constitutes a logical port, although DSA has no explicit concept of a
> > +physical port at the moment. Due to this, events where a LAG joins/leaves a
> 
> s/physical/logical/ right?

Yes, brain fart #1.

> > +bridge are treated as if all individual physical ports that are members of that
> > +LAG join/leave the bridge. Switchdev port attributes (VLAN filtering, STP
> > +state, etc) on a LAG are treated similarly: DSA offloads the same switchdev
> > +port attribute on all members of the LAG. Switchdev objects on a LAG (FDB, MDB)
> > +are not yet supported, since the DSA driver API does not have the concept of a
> > +logical port ID.
> 
> Switchdev objects (MDB entries and VLANs) are supported, and will be
> added to all members of the LAG just like attributes. Static FDB entries
> are not switchdev objects though, and are therefore not supported.

And brain fart #2.
