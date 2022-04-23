Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE94D50CC18
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 17:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiDWQCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 12:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbiDWQCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 12:02:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935711EEF8;
        Sat, 23 Apr 2022 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GDz5FwMiO1UAQs/JrLExze1jv+jR46ds8LXVCkUt9Yo=; b=4/XnqKQ9k5HGw2JOZ83OABIC8X
        BDpxMBGsc0jLWBQJyNlUa56+p97rbSQQgwxMzw3XzqyEakf6+OgawKf2QqE1p4VmzZcWQkISKBDf9
        G36REpcP6Z3l6poFkJdw6rCU1XHZ8HDFirJszP8JN2iQinnmI2H9qDBhkF/ysn6ctCrw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1niIA9-00HAHw-58; Sat, 23 Apr 2022 17:59:09 +0200
Date:   Sat, 23 Apr 2022 17:59:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [Patch net-next] net: phy: LAN937x: add interrupt support for
 link detection
Message-ID: <YmQiTcGF5okWZD5u@lunn.ch>
References: <20220423154727.29052-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423154727.29052-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 09:17:27PM +0530, Arun Ramadoss wrote:
> Added the config_intr and handle_interrupt for the LAN937x phy which is
> same as the LAN87xx phy.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

While looking at the code, i noticed LAN87XX has PHY_POLL_CABLE_TEST
where as LAN937X does not. Is this correct?

    Andrew
