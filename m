Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A38431035F
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhBEDMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230174AbhBEDMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 22:12:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6B164F58;
        Fri,  5 Feb 2021 03:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612494711;
        bh=EBiogkPNY3volCf0oQEJygh9rKBSazM/x1QQp/4H1+c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IIhFqbklVPk0+z+9afiwkCWWguJwr8UFS1TtQw00xq/XY0YdxmEKK6pr3jBU5E7J4
         MWZ5eQbE+JPmkwvfga93BT6Q2IRpGyqhQgaKhyv69PrcOVt0W5WtzO4NxlXNqkl0TU
         yYg0Fb/ERUbpf4JazdPjnxjCBuJMk/0UKjJh2SERgcKfjP6I91JQvb531AI6PznH9C
         dqQZry6RHOAZDBqxDKDoaa71pzy9+1hZMKMAziMmFWssRhidc6LV9myvOj0i+S6zGV
         OTrXM7WlEMgf0biK7arTiP8Hp9Xzv3juo1QAJ+wAuHC7CVKl5eWYakMAcn9zWHAVy4
         eD0b3jvdmieng==
Date:   Thu, 4 Feb 2021 19:11:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George McCollister <george.mccollister@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: xrs700x: Correctly address device
 over I2C
Message-ID: <20210204191149.2eecf944@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAFSKS=OtcuJRF=8rK-3dUU0=G-k=JciLsdrhS5B9t9oWz1Y2Gw@mail.gmail.com>
References: <20210202191645.439-1-tobias@waldekranz.com>
        <CAFSKS=OtcuJRF=8rK-3dUU0=G-k=JciLsdrhS5B9t9oWz1Y2Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 14:05:20 -0600 George McCollister wrote:
> On Tue, Feb 2, 2021 at 1:17 PM Tobias Waldekranz <tobias@waldekranz.com> wrote:
> [snip]
> >
> > George, have you used the chip in I2C mode with the code that is on
> > net-next now? I was not able to get the driver to even read the ID
> > register correctly.  
> 
> I wrote the i2c driver before I had any hardware in hand thinking I
> was going to get a board with the switch connected via i2c. When the
> board arrived it turned out it was connected via mdio so I wrote that
> driver as well. I looked it over quite carefully but I guess the
> documentation was wrong and I had the register addresses shifted off
> by one. I never ended up with hardware to test the i2c.

> Reviewed-by: George McCollister <george.mccollister@gmail.com>

Applied, thanks!
