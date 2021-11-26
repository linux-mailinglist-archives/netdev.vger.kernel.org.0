Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE9E45F724
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 00:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbhKZXUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 18:20:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245735AbhKZXSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 18:18:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xEbM8Jd5XPAYpOKb3IxikNQS3M5Al0hPKWYJ5xosx9s=; b=LVjB5+09qGHD2fbzENc0dfdonl
        LWTu0pkOjgiGOQ8QEfwtYAbWCEhLVBMEBLMwDPVqlhl6in0IdtL+1HpcwAyoWSk9WdVsLr9NYRK7Z
        YabJ1OaYWGpdBT7PCLuOdKowtWWJiHemVGlnov37lHcW0+DDnOQaptndjI4i6a1S2cA4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqkQb-00EjgO-R6; Sat, 27 Nov 2021 00:14:49 +0100
Date:   Sat, 27 Nov 2021 00:14:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/2] Docs/devicetree: add serdes-output-amplitude to
 marvell.txt
Message-ID: <YaFqafEDK8Fdub9q@lunn.ch>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -46,6 +46,9 @@ Optional properties:
>  - mdio?		: Container of PHYs and devices on the external MDIO
>  			  bus. The node must contains a compatible string of
>  			  "marvell,mv88e6xxx-mdio-external"
> +- serdes-output-amplitude: Configure the output amplitude of the serdes
> +			   interface.
> +    serdes-output-amplitude = <MV88E6352_SERDES_OUT_AMP_210MV>;

I checked a couple of Marvell PHY datasheets. The 1510, 1512, and 1518
have the exact same register/bits. So ideally we want DT property name
which somebody can later reuse in the Marvell PHY
driver. serdes-output-amplitude-mv seems O.K. for that.

	Andrew
