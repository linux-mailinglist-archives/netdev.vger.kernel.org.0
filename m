Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F1546E0EA
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhLICjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:39:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhLICjI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 21:39:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xvjfcGkDo5VKLzCtT1tmROpEHad8dy2GmeskSllniN4=; b=gW4WZIqWMbpj955cV83NA8iEfR
        7T2MZwvT6IeoEzguqVxPY5YjN/oznYmJtOzS2f4ZGDmAVdtOWxVF5xKc3801GsN2gO63idHkcW7KG
        mrhlE+eXWj0liULRX2xxlzxmcEFuKUY8uVDEBAr4SYsmPcZzT9FrG59JO+m+LWNrMQ2c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mv9HO-00FwZI-GN; Thu, 09 Dec 2021 03:35:30 +0100
Date:   Thu, 9 Dec 2021 03:35:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        wells.lu@sunplus.com, vincent.shih@sunplus.com
Subject: Re: [PATCH net-next v4 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <YbFrcjO8p5ii1zCG@lunn.ch>
References: <1638864419-17501-1-git-send-email-wellslutw@gmail.com>
 <1638864419-17501-3-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638864419-17501-3-git-send-email-wellslutw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 04:06:59PM +0800, Wells Lu wrote:
> Add driver for Sunplus SP7021 SoC.

I reviewed phy, mdio, ethtool. That all looks good.

I did not look at any of the packet transfer etc.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
