Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F414198122
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgC3QYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:24:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38950 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbgC3QYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 12:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZG5MreuVFf6aVQx3nE2phyaNZ/JZrv5xnE/dU4sq/6I=; b=1yi/YHbDN3jiMT7YkDPIf3XjnQ
        ZlHLj99p8NFKjJvb75I78Ez7SAJcERpQD09WszQ9JgrPstdJZeEvQcokPS46ZI+VmvssjT0USL5Zg
        dTZsvq2RH3PyecyErXXLyrurM1nQGvzNmkRak8dbaAUOUYxtuKwidw0bSgC93LFdIKDo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIxCw-00063s-G0; Mon, 30 Mar 2020 18:24:14 +0200
Date:   Mon, 30 Mar 2020 18:24:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net
Subject: Re: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Message-ID: <20200330162414.GD23477@lunn.ch>
References: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
 <20200330161740.GC23477@lunn.ch>
 <20200330162130.GF25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330162130.GF25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 05:21:30PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Mar 30, 2020 at 06:17:40PM +0200, Andrew Lunn wrote:
> > On Mon, Mar 30, 2020 at 07:01:36PM +0300, Codrin Ciubotariu wrote:
> > > Some ethernet controllers, such as cadence's macb, have an embedded MDIO.
> > > For this reason, the ethernet PHY nodes are not under an MDIO bus, but
> > > directly under the ethernet node.
> > 
> > Hi Codrin
> > 
> > That is deprecated. It causes all sorts of problems putting PHY nodes
> > in the MAC without a container.
> > 
> > Please fix macb to look for an mdio node, and place your fixed link
> > inside it.
> 
> Seems wrong.

Hi Russell

Gerr. You are right.

> fixed links have never needed to be under a mdio node - see
> Documentation/devicetree/bindings/net/ethernet-controller.yaml

macb does crazy stuff. I will take another look.

     Andrew
