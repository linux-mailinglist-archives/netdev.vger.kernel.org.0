Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3545B2A11DE
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgJaAOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgJaAOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:14:04 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EEFB208B6;
        Sat, 31 Oct 2020 00:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604103243;
        bh=+8WAod8heZAKyyM54los6V/Xeg3qhJJFsUXsdvzKNC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U/RXP5UacnsAVOODRTOGmcryWy8SUEj2fp6G+CMWjHfPzQQ6Wlf/9DEnwlG44oOKd
         xDtZnO9oV+8A4NizFL922UArPH2fedKGY4i4upo47CXsNatVQmfHBSDmtY7L8yJCdg
         +fc9i7XyXuNJnfPbAFEZzW+Nv5/o0bNP/+bJrfzk=
Date:   Fri, 30 Oct 2020 17:14:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5] net: phy: marvell: add special handling of
 Finisar modules with 88E1111
Message-ID: <20201030171402.2adf62f4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028171540.1700032-1-robert.hancock@calian.com>
References: <20201028171540.1700032-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 11:15:40 -0600 Robert Hancock wrote:
> The Finisar FCLF8520P2BTL 1000BaseT SFP module uses a Marvel 88E1111 PHY
> with a modified PHY ID. Add support for this ID using the 88E1111
> methods.
> 
> By default these modules do not have 1000BaseX auto-negotiation enabled,
> which is not generally desirable with Linux networking drivers. Add
> handling to enable 1000BaseX auto-negotiation when these modules are
> used in 1000BaseX mode. Also, some special handling is required to ensure
> that 1000BaseT auto-negotiation is enabled properly when desired.
> 
> Based on existing handling in the AMD xgbe driver and the information in
> the Finisar FAQ:
> https://www.finisar.com/sites/default/files/resources/an-2036_1000base-t_sfp_faqreve1.pdf
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thanks!
