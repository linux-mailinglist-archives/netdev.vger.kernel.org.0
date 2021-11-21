Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41007458188
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 03:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbhKUCk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 21:40:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232742AbhKUCk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 21:40:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2370160698;
        Sun, 21 Nov 2021 02:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637462272;
        bh=AIg7BQZM+9GqHp1BCEin8J61OMIiMctzQ1i1ktIqPvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lcaeu6LIka6LUOdS1LWWnNtfIe5pqVV4vwaDukSPMRQzAmCcgx6TyITt1JF1kTiqm
         POoCKJ+FPInqgN8xQZwmsg2ZJ4JYE7id7T77wzLY9OeM6crM1DDE8PypWJ9ChTz0Vu
         rtoKFPh4D59mT9D4St+AOxZa3oZOkwQsPUXRV93NSCzFEi+M5hq7ZV2Gwu6Lou5oOA
         q16O60cxl6oRRyEARDXK9WpNJ/auD+fq6WGxMmxDqnwQwBt2D07Oodn4FIGOrW28My
         s5+Wade0XbAZlhCIf4sNPYQlLrP63wAmtWSSuFBbstGeutLsIIWNBT6AWykTmp+j1A
         VgI+s5pjRbywQ==
Date:   Sun, 21 Nov 2021 10:37:47 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH devicetree 0/3] Update SJA1105 switch RGMII delay bindings
Message-ID: <20211121023746.GH31998@dragon>
References: <20211020113613.815210-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020113613.815210-1-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 02:36:10PM +0300, Vladimir Oltean wrote:
> The sja1105 driver has received a set of new DT bindings for RGMII
> delays, and it warns when the old ones are in use:
> https://patchwork.kernel.org/project/netdevbpf/cover/20211013222313.3767605-1-vladimir.oltean@nxp.com/
> 
> This patch set adds the new bindings to the in-kernel device trees.
> It would be nice if these patches could make it for v5.16, so that we
> don't have warnings in the kernel log.
> 
> Vladimir Oltean (3):
>   ARM: dts: imx6qp-prtwd3: update RGMII delays for sja1105 switch
>   ARM: dts: ls1021a-tsn: update RGMII delays for sja1105 switch
>   arm64: dts: lx2160abluebox3: update RGMII delays for sja1105 switch

Applied for 5.16-rc, thanks!
