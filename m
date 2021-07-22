Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B832D3D2605
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhGVOC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbhGVOC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 10:02:26 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75049C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 07:43:01 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id oz7so8756358ejc.2
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 07:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C/VSU7KXkWOC+MDPCbXJR+JKuXKFc+nH2Aa84MMmfs4=;
        b=rOVXi/BDuJY1S9kAKZFrSSIMXCe9N7Qo4ZJ8L+5ik4HcNFfWgyP/cAxHoiEsAP8jsT
         XrSnM92CkSGA/eB2hA5iRKsFpYq7aHD3a+yh0tAjAU+Fg5u2/XyJNamCHN18n7IMRoUz
         l5GWYb44xCUyilYByA+Mdj9iH8acAizs893TaFNNk+9uX3JHYckEChzoWwye07TuI27P
         SGNucXuGtTt5Enqpl3Z6mVAKgLLO6/kL+F9upY9GoslxhFNeAhw7Mo2XfB40j7pXlJjC
         9E84iNtrl8o6SlvLXL8YAMwLWfM38V+MAFdJygo0/r8pAhoJT0AZ9oVU4gtBm8XT1IYG
         tcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C/VSU7KXkWOC+MDPCbXJR+JKuXKFc+nH2Aa84MMmfs4=;
        b=HwtmpPl6j/Mj7q0xjkLpN7Glp4DOR0WEfRW/ElyZnNFhKFOpBR+qlg4sezqZJTFF4H
         QLhHLX8goZQSUZvEUCHGTiW1kuHZ2nPF38tP0V3acZsG/2AoP6QUfpceFuMLEE/f6/mV
         XFnppVtNvdRkKv5kOnKaKXnjGfwWwpVyC52iYyir58qPAj5QCPbLicJRGpiaGoMwkt9Q
         L1kS9uJFyOTkz7EOS1LuIF67VBPqyLnGdHZvUXu+PP97TMzHB0ko4pgndmsWeMYiRTp3
         0e+XBSvT+sC6U7hlRnZW5hsxfbcri8EftMIFJwr2wpHJvAgBsaM35eHW2Qb3hxf0NPS3
         7Pnw==
X-Gm-Message-State: AOAM533qlpw154+8u7IzTrzat9rKBUk0cebCLXVaVjvc8Aodtz8Ps4Y+
        o8g4XcjwmcFnBFVP0rmNhQ4=
X-Google-Smtp-Source: ABdhPJw630p0/hE7MiagjJvMyh8LjKorpgegzf3tlu58x9dChOqdGK9+O2naOaH7s0EUxqiQO6+HzA==
X-Received: by 2002:a17:906:13d4:: with SMTP id g20mr218116ejc.337.1626964979992;
        Thu, 22 Jul 2021 07:42:59 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id gx11sm9622171ejc.33.2021.07.22.07.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 07:42:59 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 22 Jul 2021 17:42:58 +0300
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, corbet@lwn.net,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] docs: networking: dpaa2: add documentation for
 the switch driver
Message-ID: <20210722144258.iir7cgowfplwzjlq@skbuf>
References: <20210722132735.685606-1-ciorneiioana@gmail.com>
 <YPmASiX46tOjUOe/@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPmASiX46tOjUOe/@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 04:27:22PM +0200, Andrew Lunn wrote:
> > +At the moment, the dpaa2-switch driver imposes the following restrictions on
> > +the DPSW object that it will probe:
> > +
> > + * The maximum number of FDBs should be at least equal to the number of switch
> > +   interfaces.
> 
> Should maximum actually be minimum?
> 

Uhh, it should have been minimum indeed. Will fix. Thanks!

> This is necessary so that separation of switch ports can be
> > +   done, ie when not under a bridge, each switch port will have its own FDB.
> > +
> > + * Both the broadcast and flooding configuration should be per FDB. This
> > +   enables the driver to restrict the broadcast and flooding domains of each
> > +   FDB depending on the switch ports that are sharing it (aka are under the
> > +   same bridge).
> > +
> > + * The control interface of the switch should not be disabled
> > +   (DPSW_OPT_CTRL_IF_DIS not passed as a create time option). Without the
> > +   control interface, the driver is not capable to provide proper Rx/Tx traffic
> > +   support on the switch port netdevices.
> > +
> > +Besides the configuration of the actual DPSW object, the dpaa2-switch driver
> > +will need the following DPAA2 objects:
> > +
> > + * 1 DPMCP - A Management Command Portal object is needed for any interraction
> > +   with the MC firmware.
> > +
> > + * 1 DPBP - A Buffer Pool is used for seeding buffers intended for the Rx path
> > +   on the control interface.
> > +
> > + * Access to at least one DPIO object (Software Portal) is needed for any
> > +   enqueue/dequeue operation to be performed on the control interface queues.
> > +   The DPIO object will be shared, no need for a private one.
> 
> Are these requirements tested? Will the driver fail probe if they are
> not met?

Yes, they are tested.

If the DPSW object configuration does not meet the requirements, the
driver will error out on probe with a message explictly saying what
is happening.

> 
> > +Routing actions (redirect, trap, drop)
> > +--------------------------------------
> > +
> > +The DPAA2 switch is able to offload flow-based redirection of packets making
> > +use of ACL tables. Shared filter blocks are supported by sharing a single ACL
> > +table between multiple ports.
> > +
> > +The following flow keys are supported:
> > +
> > + * Ethernet: dst_mac/src_mac
> > + * IPv4: dst_ip/src_ip/ip_proto/tos
> > + * VLAN: vlan_id/vlan_prio/vlan_tpid/vlan_dei
> > + * L4: dst_port/src_port
> > +
> > +Also, the matchall filter can be used to redirect the entire traffic received
> > +on a port.
> > +
> > +As per flow actions, the following are supported:
> > +
> > + * drop
> > + * mirred egress redirect
> > + * trap
> > +
> > +Each ACL entry (filter) can be setup with only one of the listed
> > +actions.
> > +
> > +A sorted single linked list is used to keep the ACL entries by their
> > +order of priority. When adding a new filter, this enables us to quickly
> > +ascertain if the new entry has the highest priority of the entire block
> > +or if we should make some space in the ACL table by increasing the
> > +priority of the filters already in the table.
> 
> It would be nice to have an example which shows priority in action,
> since i don't understand what you are saying here.
> 

Sure, will add an example.

On the other hand, I think this section might give too much details on
the actual implementation (I took it from the commit message of the
patch adding the support). Might as well just remove it and add the
example.

All that I was trying to say is that the filters will not be added in
the ACL table with the explicit priority specified by the user but
rather with one determined based on all the rules currently present in
the table.
Nothing is unusual in the usage, the order in which the rules are
executed will be respected.

Ioana
