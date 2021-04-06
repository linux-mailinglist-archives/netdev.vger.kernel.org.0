Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41101355523
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 15:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344473AbhDFNa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 09:30:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35790 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232505AbhDFNaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 09:30:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTlmW-00F7eX-Cy; Tue, 06 Apr 2021 15:30:12 +0200
Date:   Tue, 6 Apr 2021 15:30:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <YGxiZIDgXQjaYziE@lunn.ch>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-2-tobias@waldekranz.com>
 <YGCfvDhRFcfESYKx@lunn.ch>
 <87eefnlr1p.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eefnlr1p.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Since DSA is supported on all devices, perhaps we should just have:
> 
> enum mv88e6xxx_edsa_support {
>      MV88E6XXX_EDSA_UNSUPPORTED,
>      MV88E6XXX_EDSA_UNDOCUMENTED,
>      MV88E6XXX_EDSA_SUPPORTED,
> };

Yes, that is O.K.
 
> Do we also want to default to DSA on all devices unless there is a
> DT-property saying something else? Using EDSA does not really give you
> anything over bare tags anymore. You have fixed the tcpdump-issue, and
> the tagger drivers have been unified so there should be no risk of any
> regressions there either.

The regressions with be exactly what you are trying to fix here. A MAC
which does not understand the DSA tag and does the wrong thing, where
as currently it is using EDSA and working.

So i would keep things as they are by default.

   Andrew
