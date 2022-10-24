Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABDB60C028
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJYAwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiJYAwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:52:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20E04B491;
        Mon, 24 Oct 2022 16:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ttAHk6m16gMQdK2347RG+Nxxbk4lheJULg5IJiXA248=; b=GH6OuSxns227qEhkvJEwst/kHc
        xTlzZEFehdb7pNboyUOakMO2zS4KbJ5wjObmCczQOLqsgI7+t6R8EDpqX+aytim/nxKHsdV3dgEdP
        la8ntVeOfpM8TCrfN5RPIerU81X1axh0DrK3ULvX3G3dtj/uel8kJqR5KAz/s2QQE7e8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1omw6n-000NBN-3v; Mon, 24 Oct 2022 13:59:09 +0200
Date:   Mon, 24 Oct 2022 13:59:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        hkallweit1@gmail.com, pabeni@redhat.com, edumazet@google.com,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com,
        Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next V1 2/2] net: phy: micrel: Add PHY Auto/MDI/MDI-X
 set driver for KSZ9131
Message-ID: <Y1Z+DXJ7Ny3/Fgvn@lunn.ch>
References: <20221024082516.661199-1-Raju.Lakkaraju@microchip.com>
 <20221024082516.661199-3-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024082516.661199-3-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 01:55:16PM +0530, Raju Lakkaraju wrote:
> Add support for MDI-X status and configuration for KSZ9131 chips
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
