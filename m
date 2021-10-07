Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6837D424B20
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239997AbhJGAbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:31:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232148AbhJGAbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Kr5a559GWXvMPzAaPvJODDmMO1o4wRUGfLOYm2MvMqk=; b=DfWnGH+9Jx7LHn/lsnTLfmXHBS
        RUpSYmDpXyF8nB/6QpGXVDzUXD6XAmJSYghyjwzbqGfUQ+2nPTVKT000HM2Zd4unk+44QguCUCOcY
        dyH8MsySfTBvCl77IMYTxcfgXqui7T5LbVXqr0wqednLcyAncThLRbrrakQI9zaOkLe4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYHIA-009tGN-Tl; Thu, 07 Oct 2021 02:29:46 +0200
Date:   Thu, 7 Oct 2021 02:29:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 10/13] net: dsa: qca8k: add explicit SGMII PLL
 enable
Message-ID: <YV4/ehy9aYJyozvy@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-11-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:36:00AM +0200, Ansuel Smith wrote:
> Support enabling PLL on the SGMII CPU port. Some device require this
> special configuration or no traffic is transmitted and the switch
> doesn't work at all. A dedicated binding is added to the CPU node
> port to apply the correct reg on mac config.

Why not just enable this all the time when the CPU port is in SGMII
mode?

Is it also needed for 1000BaseX?

DT properties like this are hard to use. It would be better if the
switch can decide for itself if it needs the PLL enabled.

       Andrew
