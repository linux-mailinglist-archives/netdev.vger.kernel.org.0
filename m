Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6551B602BEC
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJRMmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJRMmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:42:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D2EC1D9F;
        Tue, 18 Oct 2022 05:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+I5oX8SdnQ5MzFuzdC1mLnoGjN40SD771TTXIPFK0IQ=; b=YimiiokNL9hV5Aj1NkqCqTGNJC
        zsMpausPhAr2TS1/Bj3P3N3owwk0k+RidWNmC3Wf7FUaz4RhyFDTzfjX0ZYq+szC5uV2jrh10Gxv6
        47siDsU7grShWghoD1QDL0/COxYaruVKC/9aVfWEXtVrz8ASeJPcqo+N2tHRk2Kmaegk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oklv9-002LNo-6Y; Tue, 18 Oct 2022 14:42:11 +0200
Date:   Tue, 18 Oct 2022 14:42:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Felix Riemann <felix.riemann@sma.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: dp83822: disable MDI crossover status
 change interrupt
Message-ID: <Y06fI9OSvRjPe0Cd@lunn.ch>
References: <20221018104755.30025-1-svc.sw.rte.linux@sma.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018104755.30025-1-svc.sw.rte.linux@sma.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 12:47:54PM +0200, Felix Riemann wrote:
> From: Felix Riemann <felix.riemann@sma.de>
> 
> If the cable is disconnected the PHY seems to toggle between MDI and
> MDI-X modes. With the MDI crossover status interrupt active this causes
> roughly 10 interrupts per second.

Make sense, it is trying to find the RX pair...

> 
> As the crossover status isn't checked by the driver, the interrupt can
> be disabled to reduce the interrupt load.
> 
> Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
> Signed-off-by: Felix Riemann <felix.riemann@sma.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
