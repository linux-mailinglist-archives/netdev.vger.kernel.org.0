Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C8C3318E9
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhCHUyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:54:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46428 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCHUyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 15:54:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lJMtA-009sfj-TY; Mon, 08 Mar 2021 21:54:04 +0100
Date:   Mon, 8 Mar 2021 21:54:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     jonas.gorski@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: Add bcm6368-mdio-mux bindings
Message-ID: <YEaO7GT7NgL30LXN@lunn.ch>
References: <20210308184102.3921-1-noltari@gmail.com>
 <20210308184102.3921-2-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210308184102.3921-2-noltari@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 07:41:01PM +0100, Álvaro Fernández Rojas wrote:
> +  clocks:
> +    maxItems: 1

Hi Álvaro

The driver does not make use of this clocks property. Is it really
needed?

	Andrew
