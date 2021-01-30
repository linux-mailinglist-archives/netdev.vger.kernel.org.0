Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DAC309470
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbhA3KX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:23:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232343AbhA3A0n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 19:26:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1646A6146D;
        Sat, 30 Jan 2021 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611966321;
        bh=7yWa+1YRbpnURv2rpdWXI6DOdKfQQloz7Yzb/Q+MgMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G6V/npoin42tsBE/V0/VbvWcc+JgH9lqyK+8hNxUbN8/sHXPP2LR+N4aeudKwUjip
         A1kHsR0neDXzKG9d90znKmgsyDiLo6kgVLMb0uDhVTTF1cd5Z4jey2PxDOJGY6OrAm
         VvOpDsnjPoWRhONq/sbeH60/QgFzYCvkmg12YQfzqdye9RQB805RUQ4Pw/ROs6ciWz
         Dx1CYRhzG7e/kzcSlaBD7UCKLNE0tP+QVvR0+NrnJrQbO1Zz0tHQkHq8qbNMO8hvFC
         RmEu3O3S4DhtS+ByD/XKqJRnE6+SsLg2I6jHzl4UquaC/i2GWA9uloR310hfOMI8Bm
         W3q3ediGaSFpw==
Date:   Fri, 29 Jan 2021 16:25:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v8 net-next 08/11] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
Message-ID: <20210129162520.3f4af029@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129234304.heqjkkngqri5hjoc@skbuf>
References: <20210129010009.3959398-1-olteanv@gmail.com>
        <20210129010009.3959398-9-olteanv@gmail.com>
        <20210129234304.heqjkkngqri5hjoc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Jan 2021 01:43:04 +0200 Vladimir Oltean wrote:
> Jakub, I was stupid and I pasted the ping command output into the commit
> message, so git will trim anything past the dotted line as not part of
> the commit message, which makes your netdev/verify_signedoff test fail.
> If by some sort of miracle I don't need to resend a v9, do you think you
> could just delete this and the next 2 lines?

Yeah, I noticed, I'll fix it up.
