Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA7660FAAF
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbiJ0OoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbiJ0OoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:44:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0779B18B491
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BtPVeOVu7qf5xq2cHQrx0kzBV99DDRGmI8DF8fU37fk=; b=a0co88tESZFKx0pKakokFUV70Q
        Msb9jobYPPAq/1+B9AOc3cdVTlNpSqp+Fz58CvOJTuoROQfKggLHu4dJ0dgDshd/BE01xlJnALaAs
        R0KEH8pyuMN8/YJByEWfNnPst3PK5dB4BFEiYp4r1YAJrLw8GQhuvPjpXvK5haV+v9CE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oo46d-000ip5-La; Thu, 27 Oct 2022 16:43:39 +0200
Date:   Thu, 27 Oct 2022 16:43:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sfp: move field definitions along side
 register index
Message-ID: <Y1qZG+uAn6p/JRo2@lunn.ch>
References: <Y1qFvaDlLVM1fHdG@shell.armlinux.org.uk>
 <E1oo2oz-00HFJm-AF@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1oo2oz-00HFJm-AF@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 02:21:21PM +0100, Russell King (Oracle) wrote:
> Just as we do for the A2h enum, arrange the A0h enum to have the
> field definitions next to their corresponding register index.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
