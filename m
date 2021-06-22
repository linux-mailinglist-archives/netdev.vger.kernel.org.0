Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0023B07D1
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhFVOsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:48:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49920 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230047AbhFVOsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 10:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=q4u6Ka7Ccy+su35CUuUUUAOO0X3N/5b6fTLgnaTXVSM=; b=NxBhF2v0dxBcEriZbSX7MLbD1Z
        XA3GL4dmPoBWU+KOTLBNJz3uDBlv3z9gKNHWBh5xzwbeqZwbyMt2NOOFp17KKumnHGF7aYluQDrqR
        RXWa124Dcw3ebe+1GPuFKbkTlX6QqECYaAF05dYyrSGAEMHzVvH8ozX7HOwZrY/BF6FU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvher-00AiST-1j; Tue, 22 Jun 2021 16:45:45 +0200
Date:   Tue, 22 Jun 2021 16:45:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@lists.infradead.org
Subject: Re: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Message-ID: <YNH3mb9fyBjLf0fj@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
 <20210622144111.19647-2-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622144111.19647-2-lukma@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 04:41:09PM +0200, Lukasz Majewski wrote:
> The 'eth_switch' node is now extendfed to enable support for L2
> switch.
> 
> Moreover, the mac[01] nodes are defined as well and linked to the
> former with 'phy-handle' property.

A phy-handle points to a phy, not a MAC! Don't abuse a well known DT
property like this.

  Andrew

