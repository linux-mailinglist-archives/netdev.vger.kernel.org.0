Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08294BE3E7
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358350AbiBUMxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:53:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358335AbiBUMxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:53:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4609A1C111
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 04:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sayEeBgKtLESYWQZcr3jv6aw2n8vp/mjZE5bR+bQG0o=; b=F4KW8aYyOQXpZk9O1Pf8A9pSHL
        gDXCtdOuegtxbxAV+dN9H88C3Ds47qdwAfr2Jl0b1HesdAeFUfJI7tozz4cgDhsyHh9mIvGZiBBh1
        2Xouei1ZdHBNCDbcdNURryyymI9klN81gEJGzro7uMhZKrAbpKsWx7GVj5ab6AYA+of8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nM8BT-007K51-S4; Mon, 21 Feb 2022 13:52:55 +0100
Date:   Mon, 21 Feb 2022 13:52:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Baruch Siach <baruch.siach@siklu.com>,
        Robert Marko <robert.marko@sartura.hr>,
        Luo Jie <luoj@codeaurora.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] net: mdio-ipq4019: add delay after clock enable
Message-ID: <YhOLJwOB/wkwei4L@lunn.ch>
References: <01c6b6afb00c02a48fa99542c5b4c6a2c69092b0.1645443957.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01c6b6afb00c02a48fa99542c5b4c6a2c69092b0.1645443957.git.baruch@tkos.co.il>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 01:45:57PM +0200, Baruch Siach wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> Experimentation shows that PHY detect might fail when the code attempts
> MDIO bus read immediately after clock enable. Add delay to stabilize the
> clock before bus access.
> 
> PHY detect failure started to show after commit 7590fc6f80ac ("net:
> mdio: Demote probed message to debug print") that removed coincidental
> delay between clock enable and bus access.
> 
> 10ms is meant to match the time it take to send the probed message over
> UART at 115200 bps. This might be a far overshoot.
> 
> Fixes: 23a890d493e3 ("net: mdio: Add the reset function for IPQ MDIO driver")
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
