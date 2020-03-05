Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08C317B1EB
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 23:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgCEWyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 17:54:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgCEWyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 17:54:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SkAaNIAj/0cGfBuxoRvmNon8qeyP63ZNXaqI84edisY=; b=pXQtZD0sxI+UajqnekytMz+DPO
        Ggj9e56HftGjZma9pXxNXfzF9iv0xawyUzs/jzOS2vU/DGZVgC2Z4F3JAl8tG84nxpZ2ElTh+ayca
        GW57/KGiGUkMkRkH8yBVcYVA0nbwxjgFKt2xqbc8IND66OGEuDUmLxWnJX1HREXZhwG8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9zNX-0000QQ-Uh; Thu, 05 Mar 2020 23:54:07 +0100
Date:   Thu, 5 Mar 2020 23:54:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200305225407.GD25183@lunn.ch>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305124139.GB25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 12:41:39PM +0000, Russell King - ARM Linux admin wrote:
> Andrew Lunn mentioned that the Serdes PCS found in Marvell DSA switches
> does not automatically update the switch MACs with the link parameters.
> Currently, the DSA code implements a work-around for this.
> 
> This series improves the Serdes integration, making use of the recent
> phylink changes to support split MAC/PCS setups.  One noticable
> improvement for userspace is that ethtool can now report the link
> partner's advertisement.

Hi Russel

I started testing this patchset today. But ran into issues with ZII
scu4-aib and ZII devel c. I think the CPU port is running at the wrong
speed, but i'm not sure yet. Nor do i know if it is this patchset, or
something earlier.

      Andrew
