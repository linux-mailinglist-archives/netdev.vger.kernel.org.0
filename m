Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907051CE9C3
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgELArV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:47:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54802 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgELArV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 20:47:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jInbP6kYlPTCq1+vMqbRVKyGNRa42MNeIAqbkEwn4fQ=; b=PrKxsBZ/tbGuil0ATUpd74prkq
        PNBUfUHiruhxTE8hc/e8EdaLYAeQajULs1C6F9NkCGkmSFcuOAR56HBHZnMQrfGIuF4TiTuStZr59
        e5Uy4kqOPm+bxb1HxUOIeai8HfhDMA4Zj6jxOMZ1+Ln5ayzeHpy6yH1nnpa3+t2IaSWM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYJ4k-001vAL-5K; Tue, 12 May 2020 02:47:14 +0200
Date:   Tue, 12 May 2020 02:47:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Doug Berger <opendmb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
Message-ID: <20200512004714.GD409897@lunn.ch>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589243050-18217-2-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 05:24:07PM -0700, Doug Berger wrote:
> A comment in uapi/linux/ethtool.h states "Drivers should reject a
> non-zero setting of @autoneg when autoneogotiation is disabled (or
> not supported) for the link".
> 
> That check should be added to phy_validate_pause() to consolidate
> the code where possible.
> 
> Fixes: 22b7d29926b5 ("net: ethernet: Add helper to determine if pause configuration is supported")

Hi Doug

If this is a real fix, please submit this to net, not net-next.

   Andrew
