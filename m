Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FBD1E341B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 02:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgE0AgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 20:36:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50832 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbgE0AgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 20:36:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dHwdo0GBFJtq7Bz0Rhb/SapfT7fvYk4CTg+ymutxVpQ=; b=TUUkzmgkWSxlZnA0ka88IWknt6
        yYjzhKpB6bCIb4NRI3d28kgi0UnCHROMEyK26chd5Tit/Dfur09rLSd1ihLrODCWFNIhmy3fmquI5
        EgSJuvH4Wp/ZP96lBhrNvm9hvZiWYB51ibMDMy3OPF6n5fWXGua4/RAiiIWD0pDnoSPo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdk3G-003L9Y-7X; Wed, 27 May 2020 02:36:10 +0200
Date:   Wed, 27 May 2020 02:36:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH net-next v2 0/2] net: enetc: remove bootloader dependency
Message-ID: <20200527003610.GD782807@lunn.ch>
References: <20200526225050.5997-1-michael@walle.cc>
 <8b6054895d6d843a22cf046966645f5b@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b6054895d6d843a22cf046966645f5b@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 12:52:18AM +0200, Michael Walle wrote:
> > These patches were picked from the following series:
> > https://lore.kernel.org/netdev/1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com/
> > They have never been resent. I've picked them up, addressed Andrews
> > comments, fixed some more bugs and asked Claudiu if I can keep their SOB
> > tags; he agreed. I've tested this on our board which happens to have a
> > bootloader which doesn't do the enetc setup in all cases.
> 
> If my SOB is wrong in the patches, please let me know.

Hi Michael

Everybody in the path of the patch needs to add their SOB. So this is
correct.

	Andrew
