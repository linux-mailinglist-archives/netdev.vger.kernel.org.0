Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8923F170324
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgBZPv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:51:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgBZPv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 10:51:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=L8Q+XFSMVN4lxVVcXk74V3MM82FvN2d6yw5BFbk+5U0=; b=erkkPR07RtQwpP+VPCUn694ITw
        D+263YHog6pASJWlyCjCbpNW9FAfKcB3irDOPmtFqyFVIvuZkfFucM7zUcyZ6tQ3WfCLA5kTqerqv
        eXGf1sSCTNX8wLY1E6K6DJXS+PzUYIcM6AcwCX8a1s/XfoXPnxYBmXo7jLFLbVg1NG7U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6yyW-0006kB-U8; Wed, 26 Feb 2020 16:51:52 +0100
Date:   Wed, 26 Feb 2020 16:51:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sudheesh Mavila <sudheesh.mavila@amd.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH =?iso-8859-1?B?djKgXSBuZXQ6IHBo?=
 =?iso-8859-1?Q?y=3A_corrected_the_return_value_for_genphy=5Fcheck=5Fand?=
 =?iso-8859-1?Q?=5Frestart=5Faneg?= ?and  genphy_c45_check_and_restart_aneg
Message-ID: <20200226155152.GL7663@lunn.ch>
References: <20200226071045.79090-1-sudheesh.mavila@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226071045.79090-1-sudheesh.mavila@amd.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 12:40:45PM +0530, Sudheesh Mavila wrote:
> When auto-negotiation is not required, return value should be zero.
> 
> Changes v1->v2:
> - improved comments and code as Andrew Lunn and Heiner Kallweit suggestion
> - fixed issue in genphy_c45_check_and_restart_aneg as Russell King
>   suggestion.
> 
> Fixes: 2a10ab043ac5 ("net: phy: add genphy_check_and_restart_aneg()")
> Fixes: 1af9f16840e9 ("net: phy: add genphy_c45_check_and_restart_aneg()")
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
