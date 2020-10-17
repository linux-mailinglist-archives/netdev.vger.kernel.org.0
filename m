Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CFF291505
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 01:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439872AbgJQXHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 19:07:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33026 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439711AbgJQXHz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 19:07:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTvIm-002CsL-HR; Sun, 18 Oct 2020 01:07:52 +0200
Date:   Sun, 18 Oct 2020 01:07:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 00/13] Generic TX reallocation for DSA
Message-ID: <20201017230752.GW456889@lunn.ch>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir

> For example, the tail tagging driver for Marvell 88E6060 currently
> reallocates _every_single_frame_ on TX. Is that an obvious
> indication that nobody is using it?

We have had very few patches for that driver, so i would agree with
you, it is probably not used any more. It could even be something we
consider moving to staging and then out of the kernel.

> DSA has all the information it needs in order to simplify the job of a
> tagger on TX. It knows whether it's a normal or a tail tagger, and what
> is the protocol overhead it incurs. So why not just perform the
> reallocation centrally, which also has the benefit of being able to
> introduce a common ethtool statistics counter for number of TX reallocs.
> With the latter, performance issues due to this particular reason are
> easy to track down.

All sounds good to me, in principle. But the devil is in the details.

    Andrew
