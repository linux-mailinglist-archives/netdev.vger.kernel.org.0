Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157112ACA98
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgKJBlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:41:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgKJBlr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 20:41:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54A152065D;
        Tue, 10 Nov 2020 01:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604972506;
        bh=DdNDkC1zyUDmV0VvGjYD9xPcxiipqhzX0rr6mtoMTcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W/IWdvo15kwJJi+uCCtq/MbRQ9c7uQ/HspXfETkivOp6ourv+a6g971E59t28bj2X
         IrzCFZR3GX85PVBsKP2UjQ7OwGceN7qkhRnRFkiIl/cF1qciX1ejXwJQbkBGKC3IL5
         nVWyf+iy8PAvBzh0qRm8413rGclCp15JoT+jjwgU=
Date:   Mon, 9 Nov 2020 17:41:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: microchip_t1: Don't set .config_aneg
Message-ID: <20201109174145.70243122@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109173622.GC1456319@lunn.ch>
References: <20201109091605.3951c969@xhacker.debian>
        <20201109173622.GC1456319@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 18:36:22 +0100 Andrew Lunn wrote:
> On Mon, Nov 09, 2020 at 09:16:05AM +0800, Jisheng Zhang wrote:
> > The .config_aneg in microchip_t1 is genphy_config_aneg, so it's not
> > needed, because the phy core will call genphy_config_aneg() if the
> > .config_aneg is NULL.
> > 
> > Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
