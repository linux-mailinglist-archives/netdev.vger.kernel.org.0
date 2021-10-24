Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D037B438B63
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhJXScJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:32:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhJXScI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KsE8bAKtk3MMk6J9dfIOonF+Rf8RiCJlBGgSXgxzIlU=; b=WFbUCsDJ03cY/aChhnT/Bu7h1E
        WEdDsW8jdGiWJ/pzMSE5cRh/xNYRMn8D7DEeicaaB0kSOesm0nPiy5Y6TDBbW86DuABjznxUcMsBf
        JTCDspANapVIHqqdGwPTww3PzjjJOxpygW2jSjm9cWa5NroAm+sSiB1EmEliLg+F4c2E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiFG-00BZwd-Mu; Sun, 24 Oct 2021 20:29:22 +0200
Date:   Sun, 24 Oct 2021 20:29:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v7 03/14] net: phy: at803x: improve the WOL feature
Message-ID: <YXWmAq1azGmrTVxy@lunn.ch>
References: <20211024082738.849-1-luoj@codeaurora.org>
 <20211024082738.849-4-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024082738.849-4-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 04:27:27PM +0800, Luo Jie wrote:
> The wol feature is controlled by the MMD3.8012 bit5,
> need to set this bit when the wol function is enabled.
> 
> The reg18 bit0 is for enabling WOL interrupt, when wol
> occurs, the wol interrupt status reg19 bit0 is set to 1.
> 
> Call phy_trigger_machine if there are any other interrupt
> pending in the function set_wol.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
