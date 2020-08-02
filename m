Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E29235950
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 18:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgHBQro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 12:47:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39098 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgHBQro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 12:47:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2H9C-007wDP-Ja; Sun, 02 Aug 2020 18:47:42 +0200
Date:   Sun, 2 Aug 2020 18:47:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bruno Thomsen <bruno.thomsen@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Subject: Re: [PATCH v2 3/4 net-next] net: mdiobus: add reset-post-delay-us
 handling
Message-ID: <20200802164742.GG1862409@lunn.ch>
References: <20200730195749.4922-1-bruno.thomsen@gmail.com>
 <20200730195749.4922-4-bruno.thomsen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730195749.4922-4-bruno.thomsen@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 09:57:48PM +0200, Bruno Thomsen wrote:
> Load new "reset-post-delay-us" value from MDIO properties,
> and if configured to a greater then zero delay do a
> flexible sleeping delay after MDIO bus reset deassert.
> This allows devices to exit reset state before start
> bus communication.
> 
> Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
