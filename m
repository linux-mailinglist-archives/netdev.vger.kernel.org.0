Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3919D35A5E2
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbhDISf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhDISfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:35:55 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A87C061762;
        Fri,  9 Apr 2021 11:35:42 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id g17so7382347ejp.8;
        Fri, 09 Apr 2021 11:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wCzL0kRpul2aIZagRqoaFybMwk+kbvcnmS45HwsEuWI=;
        b=DV1Xmm5Px/RNyljSLJjH5arF+1c/arFd/CaUqvTo5pPDVKKqG//3MpVcGbh61+cXPP
         nHSBhUK37n24QFyLplMkMT67/QFUCe+2g/y566qSj/d7XhPhRLYmkT09FdCxv3EtnCku
         pePPl7SE0pcfimaFI9IoDz66x2vddhHMK0BWYFpBOhFOHmgZToANfjt2TX4/kHYyXxrB
         EqLy2nMoDQCf8fJGUmHTTf11+8pcUS3D5yninSFaNoO9TtdZ+7xKiC1RXRN4bed/XPJW
         33lQUsxsrk/qi2ikf9wUE6vrm3+W9evEiJDDnIOfxOVeSpTvi91FT8aG4Mr3wJUrQUcl
         j6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wCzL0kRpul2aIZagRqoaFybMwk+kbvcnmS45HwsEuWI=;
        b=nfvqL2VoknT3WBqiRZyZ3YQqwJcIIEPWAWvLURugvxdpfc93fWZy7t87zyyg/1IwWH
         F14Io2Ih/ffvbEINmYS5uFShoB7Pqi6sVhF52YEqIt2N+9h97gscvFK6UzKw1vgb+7kA
         wZjNj66yEw7qmnK8eljGmkP4NR4vTE6kfl4Up5eKVNGF9/m44guuFVOW03LUs4QMGUg2
         5xr0/NXi+wmOdXGg6Tk1jLW1MBp9M36G2OcNExl3+LSHtUSqM37nbYXfA8hNsjANiVqA
         4n4hMPCiOyrtdN6LVAhSXAzse9BefpciOQ+10rbTXntOKmBNq95WoOPh7xZTFrWv6x8Q
         QdJQ==
X-Gm-Message-State: AOAM530RxzRy15NkYfOrRsGaLge26JzhVlTw/fzGT9fUCIlU6Q2YPA9w
        ayQfSf99eHpP3T0nCGRdUyU=
X-Google-Smtp-Source: ABdhPJxGvq1X7eRZmuwdi00jojf2a93AtAAyUZMzN/mIf+0TNZg6cEByhX5c+ossghWE34SgLjxSeA==
X-Received: by 2002:a17:907:2069:: with SMTP id qp9mr17818476ejb.175.1617993340743;
        Fri, 09 Apr 2021 11:35:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-79-34-220-97.business.telecomitalia.it. [79.34.220.97])
        by smtp.gmail.com with ESMTPSA id w22sm1889362edl.92.2021.04.09.11.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:35:40 -0700 (PDT)
Date:   Fri, 9 Apr 2021 12:25:29 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] drivers: net: dsa: qca8k: add support for
 multiple cpu port
Message-ID: <YHArmTHe4k6/9yzy@Ansuel-xps.localdomain>
References: <20210406045041.16283-1-ansuelsmth@gmail.com>
 <20210406045041.16283-2-ansuelsmth@gmail.com>
 <YGz/nu117LDEhsou@lunn.ch>
 <YGvumGtEJYYvTlc9@Ansuel-xps.localdomain>
 <b8182434-b7b0-ef59-ef15-f84687df94df@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8182434-b7b0-ef59-ef15-f84687df94df@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 11:15:37AM -0700, Florian Fainelli wrote:
> 
> 
> On 4/5/2021 10:16 PM, Ansuel Smith wrote:
> > On Wed, Apr 07, 2021 at 02:41:02AM +0200, Andrew Lunn wrote:
> >> On Tue, Apr 06, 2021 at 06:50:40AM +0200, Ansuel Smith wrote:
> >>> qca8k 83xx switch have 2 cpu ports. Rework the driver to support
> >>> multiple cpu port. All ports can access both cpu ports by default as
> >>> they support the same features.
> >>
> >> Do you have more information about how this actually works. How does
> >> the switch decide which port to use when sending a frame towards the
> >> CPU? Is there some sort of load balancing?
> >>
> >> How does Linux decide which CPU port to use towards the switch?
> >>
> >>     Andrew
> > 
> > I could be very wrong, but in the current dsa code, only the very first
> > cpu port is used and linux use only that to send data.
> 
> That is correct, the first CPU port that is detected by the parsing
> logic gets used.
> 
> > In theory the switch send the frame to both CPU, I'm currently testing a
> > multi-cpu patch for dsa and I can confirm that with the proposed code
> > the packets are transmitted correctly and the 2 cpu ports are used.
> > (The original code has one cpu dedicated to LAN ports and one cpu
> > dedicated to the unique WAN port.) Anyway in the current implementation
> > nothing will change. DSA code still supports one cpu and this change
> > would only allow packet to be received and trasmitted from the second
> > cpu.
> 
> That use case seems to be the most common which makes sense since it
> allows for true Gigabit routing between WAN and LAN by utilizing both
> CPUs's Ethernet controllers.
> 
> How do you currently assign a port of a switch with a particular CPU
> port this is presumably done through a separate patch that you have not
> submitted?
> -- 
> Florian

I reworked an old patch that added multi-cpu support to dsa.
CPUs are assigned in a round-robin way and they can be set with an
additional iproute command. (I read some of the comments in that RFC
series and I'm planning to introduce some type of function where the
switch driver can declare a preferred CPU port). Anyway this series is
just to try to upstream the changes that doesn't require major revision,
since they can be included even without the multi-cpu patch.

