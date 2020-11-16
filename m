Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5D92B3D7A
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 08:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgKPHG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 02:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727204AbgKPHG7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 02:06:59 -0500
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14D0A20DD4;
        Mon, 16 Nov 2020 07:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605510418;
        bh=JuV7U3bOtW9yCKwQ2YRwqRwM0gsqsHl+TVzuGuy6faQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZS427FLfJu4VL7NCuBLxRB4JYpMVaPTM5MXvJ8Bz4krlcMSqIxgQPWI19y/Gt33h1
         Emc4YDAGD22mG/nLbaCEEWJdWQFF2PoRuJD+FphF2RLxlgNsWAUgcMnxn6o9nyUJSN
         x4XiMuXoVcJGABvJnmFJJJLuPTyyAEd3t9rhld7A=
Date:   Mon, 16 Nov 2020 15:06:53 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: dts: fsl: DPAA FMan DMA operations are coherent
Message-ID: <20201116070652.GA5849@dragon>
References: <1601901999-28280-1-git-send-email-madalin.bucur@oss.nxp.com>
 <20201030073956.GH28755@dragon>
 <AM6PR04MB3976F19056A613AC92118A2FECE80@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR04MB3976F19056A613AC92118A2FECE80@AM6PR04MB3976.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 03:33:19PM +0000, Madalin Bucur wrote:
> > -----Original Message-----
> > From: linux-arm-kernel <linux-arm-kernel-bounces@lists.infradead.org> On
> > Behalf Of Shawn Guo
> > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > Subject: Re: [PATCH] arm64: dts: fsl: DPAA FMan DMA operations are
> > coherent
> > 
> > On Mon, Oct 05, 2020 at 03:46:39PM +0300, Madalin Bucur wrote:
> > > Although the DPAA 1 FMan operations are coherent, the device tree
> > > node for the FMan does not indicate that, resulting in a needless
> > > loss of performance. Adding the missing dma-coherent property.
> > >
> > > Fixes: 1ffbecdd8321 ("arm64: dts: add DPAA FMan nodes")
> > >
> > > Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > > Tested-by: Camelia Groza <camelia.groza@oss.nxp.com>
> > 
> > Applied, thanks.
> 
> Hi, Shawn,
> 
> will this fix for the device trees be picked up in the stable trees as well?
> Do I need to do something about it?

When it's landed in Linus' tree, stable kernel will pick it up due to
the Fixes: tag there.  So you do not need to do anything about it.

> 
> Thanks
> Madalin
> 
> PS: will this make it into v5.10 or v5.11?

I'm sending it to arm-soc folks as a material for v5.10-rc.  So if
everything goes well, it will get into v5.10.

Shawn
