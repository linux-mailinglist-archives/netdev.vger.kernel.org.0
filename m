Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176F44A4FF2
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 21:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378220AbiAaUN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 15:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378229AbiAaUNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 15:13:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0E1C061714;
        Mon, 31 Jan 2022 12:13:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1E5EB81094;
        Mon, 31 Jan 2022 20:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDD0C340E8;
        Mon, 31 Jan 2022 20:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643660002;
        bh=Os6IW0OAKjHC1VaySzPG97IjzNmCrjzC2B04Red2uX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nPHh3JWOKGLFoW+E2lZC3MLyHiniXo8ocJfq9IcXAfKcWKvSOxk5cwkBw9pr3JPTx
         HnT16b6Ozbt7NaCu519EGQzqulO2huG0WtaTaKyIqBn1xKW3Gvo2b/DrTs75J6lOlQ
         m7BgoXEWwi4xM0MY2SqilreAaARD8A6Uox2zt3WDZHM5Bo80cwN0F5P9vxtDykJa+T
         FVWPseC4Yl7cgLOEm1GCaaxBhnFSKpZ1OhWC8TJW3VABj+xxxdFXPXLev0DMoxcqCK
         bJKoMcG32RXdbDMEr8dD8GlEE17lP8rsQ+wpnBUrkcsQ+Fx3aVXaWuYxG9bcpL35CT
         uF4Hah69+3ALA==
Date:   Mon, 31 Jan 2022 12:13:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v4 net-next 0/2] use bulk reads for ocelot statistics
Message-ID: <20220131121321.74feaa73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220131200604.orl7da2oyljh626c@skbuf>
References: <20220128200549.1634446-1-colin.foster@in-advantage.com>
        <20220131115621.50296adf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220131200604.orl7da2oyljh626c@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022 20:06:05 +0000 Vladimir Oltean wrote:
> On Mon, Jan 31, 2022 at 11:56:21AM -0800, Jakub Kicinski wrote:
> > This got into Changes Requested state in patchwork, I'm not sure why.
> > 
> > I revived it and will apply it by the end of the day PST if nobody
> > raises comments.  
> 
> Maybe this is the reason?
> https://patchwork.kernel.org/project/netdevbpf/patch/20220125071531.1181948-3-colin.foster@in-advantage.com/#24717872

Thanks a lot! Back to CR it goes.
