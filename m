Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB1528A92B
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 20:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgJKSIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 14:08:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbgJKSIp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 14:08:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD1BA21655;
        Sun, 11 Oct 2020 18:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602439724;
        bh=BVDafyu+T/Bd4Num8A5AYya5qGweRDbDxFP10+YbmYY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S5wDbtoPuScbj0OeVyi43mXa7p2L7XNTrsHOeGEvFkY0YuVPHZNr986fe4F+h6rq1
         4blh15MVffowbdMosJn2D/0TUNz2o0oRi5ZoGQukTJAq/P7rD4PNyvyDtFej7inUVh
         kY/G70Pb0+StJBMl+WqsFYYyWl0A6njFERGmVLNY=
Date:   Sun, 11 Oct 2020 11:08:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2 0/4] enetc: Migrate to PHYLINK and PCS_LYNX
Message-ID: <20201011110843.6aa79dea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007094823.6960-1-claudiu.manoil@nxp.com>
References: <20201007094823.6960-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 12:48:19 +0300 Claudiu Manoil wrote:
> Transitioning the enetc driver from phylib to phylink.
> Offloading the serdes configuration to the PCS_LYNX
> module is a mandatory part of this transition. Aiming
> for a cleaner, more maintainable design, and better
> code reuse.
> The first 2 patches are clean up prerequisites.
> 
> Tested on a p1028rdb board.
> 
> v2: validate() explicitly rejects now all interface modes not
> supported by the driver instead of relying on the device tree
> to provide only supported interfaces, and dropped redundant
> activation of pcs_poll (addressing Ioana's findings)

Applied, thank you!
