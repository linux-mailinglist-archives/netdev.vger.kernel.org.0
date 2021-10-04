Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF5C420A84
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhJDMCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:02:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhJDMCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:02:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Fo3YuHsiPTwegNjZ8M/960dQysR1TpnzpwWdeuOysAo=; b=T3rzxFzuyL+OMPjrq1ecKvff67
        Pn966GNYJuPk3EBq1yeRtHtoYbIcyYSwU1uzXn1NP9VaUnr7N5JBBXS4l/7kT3rMAT9sWmggohwQE
        b/tzE1aDyReFnqFfg8vSTwJ6KkvZQtVIAQMvE1M24r+7wwAkKghtbh+qSiur1wMNB2kM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXMdk-009X7D-NC; Mon, 04 Oct 2021 14:00:16 +0200
Date:   Mon, 4 Oct 2021 14:00:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFT net-next] net: phylib: ensure phy device drivers do
 not match by DT
Message-ID: <YVrs0BoVPf8gZcqX@lunn.ch>
References: <E1mVxST-000aHI-T5@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mVxST-000aHI-T5@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 03:54:49PM +0100, Russell King (Oracle) wrote:
> PHYLIB device drivers must match by either numerical PHY ID or by their
> .match_phy_device method. Matching by DT is not permitted.
> 
> Link: https://lore.kernel.org/r/2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Tested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
