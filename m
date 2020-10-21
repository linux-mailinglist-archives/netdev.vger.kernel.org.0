Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A0E2951A3
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503644AbgJURh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 13:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404935AbgJURh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 13:37:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D77D12224E;
        Wed, 21 Oct 2020 17:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603301876;
        bh=AU2WWTZLeOPXrJnVOiU2PDxnqjAp7Nah1T+sONloXPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a99OjhcE0mtCaXoqk5HGESUDmptJ54AUGC8m2+bEP4Iv+2pvvWPkBK7+H+JYodFjg
         FfGPIkx2WSKFSUoRUBJ3B8eK3A4/f/o+g5bbTPAXZTnBenW91QQD+4Q7DhRCRcokl1
         Iysuc7D/dGK4qG8/L81HaCnFfyZGNydCziUERwVQ=
Date:   Wed, 21 Oct 2020 10:37:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Robert Hancock <robert.hancock@calian.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: disable BMCR_ISOLATE in
 phylink_mii_c22_pcs_config
Message-ID: <20201021103754.6db8db3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201021092736.GI1551@shell.armlinux.org.uk>
References: <20201020191249.756832-1-robert.hancock@calian.com>
        <20201021092736.GI1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 10:27:36 +0100 Russell King - ARM Linux admin wrote:
> On Tue, Oct 20, 2020 at 01:12:49PM -0600, Robert Hancock wrote:
> > The Xilinx PCS/PMA PHY requires that BMCR_ISOLATE be disabled for proper
> > operation in 1000BaseX mode. It should be safe to ensure this bit is
> > disabled in phylink_mii_c22_pcs_config in all cases.
> > 
> > Signed-off-by: Robert Hancock <robert.hancock@calian.com>  
> 
> Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Please re-send when netdev is open, thanks.

And please mark it as [PATCH net-next] when you resend next week -
just to be sure I don't get confused and apply this as a fix.
