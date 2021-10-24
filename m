Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7F7438B71
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhJXSgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:36:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55802 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230016AbhJXSgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TnwcxR3A+SHFpksQlLLxvj344am54IyNCV5ZvLrxiwQ=; b=53zx8NUdJKhIOraiG9M2uKOigI
        IwqnpPIRzGXPSKR6iEfAFN1Jb8FDz6ualBPjWBGXJEZ4Dl5V78RddvxbZGkPZgYumNBk87cYlrptm
        X3onWUFhc9mS45HgqAhN0rSQo+VB/dPEbqVOpFHAORrm5nsxHtUpZRg7IbE0cl53dM2k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiJd-00Ba0X-Nq; Sun, 24 Oct 2021 20:33:53 +0200
Date:   Sun, 24 Oct 2021 20:33:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v7 10/14] net: phy: add genphy_c45_fast_retrain
Message-ID: <YXWnERpKTQDPZGic@lunn.ch>
References: <20211024082738.849-1-luoj@codeaurora.org>
 <20211024082738.849-11-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024082738.849-11-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 04:27:34PM +0800, Luo Jie wrote:
> Add generic fast retrain auto-negotiation function for C45 PHYs.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
