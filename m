Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51B562EA38
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiKRA1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiKRA1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:27:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748CD6BDC4;
        Thu, 17 Nov 2022 16:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AFV+7ApdCBOIGMsVLFPQM1I3SArzUFkwUjMk4P2eK8w=; b=X6077zp2pInx/2693TTYUli8jc
        K1IozKW9lf//AlSauzYixSYibR+yER5K2jUKT2bTBxo/z/UjY4j+bvuYpepGqSpbnHxVQpu3OvnVb
        co/aL/GMA5ywbNuKLFioh+8JWZwAE3MqHB1+Nyq4vlI4oUd/oN3/LtBXudyoi5eHBoIs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovpDr-002kI9-Lp; Fri, 18 Nov 2022 01:27:11 +0100
Date:   Fri, 18 Nov 2022 01:27:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH 0/3] add dt configuration for dp83867 led modes
Message-ID: <Y3bRX1N0Rp7EDJkS@lunn.ch>
References: <20221118001548.635752-1-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118001548.635752-1-tharvey@gateworks.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 04:15:45PM -0800, Tim Harvey wrote:
> This series adds a dt-prop ti,led-modes to configure dp83867 PHY led
> modes, adds the code to implement it, and updates some board dt files
> to use the new property.

Sorry, but NACK.

We need PHY leds to be controlled via /sys/class/leds. Everybody keeps
trying to add there own way to configure these things, rather than
have just one uniform way which all PHYs share.

     Andrew
