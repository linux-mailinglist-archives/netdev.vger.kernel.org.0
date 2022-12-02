Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E17D63FC75
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiLBAFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiLBAFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:05:46 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFE3BFCF4
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XX3vMTTyAJcppCgbZuI8zM3rbMsqK0h1uaxU+kHBT1Y=; b=d+vjecPfz6bI1f1JRe4QrSrldu
        +oASaYA21InixHub6S1Fkdc9cF9cxkfNMojabScbnUM0N3eSSTXrtTIicAx4dCIhPGEy+UljQ+TBf
        q3pIr9qAfTdkuSibVXjZ7/3s0DloF0F7ba/bCgajOArslJ38mRC6UW7mhnx9jeSM9GxM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0tYd-00477l-2f; Fri, 02 Dec 2022 01:05:35 +0100
Date:   Fri, 2 Dec 2022 01:05:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: Re: GPY215 PHY interrupt issue
Message-ID: <Y4lBT6FMCuUH1b6p@lunn.ch>
References: <fd1352e543c9d815a7a327653baacda7@walle.cc>
 <Y4DcoTmU3nWqMHIp@lunn.ch>
 <baa468f15c6e00c0f29a31253c54383c@walle.cc>
 <Y4S4EfChuo0wmX2k@lunn.ch>
 <c69e1d1d897dd7500b59c49f0873e7dd@walle.cc>
 <Y4jOMocoLneO8xoD@lunn.ch>
 <158870dd20a5e30cda9f17009aa0c6c8@walle.cc>
 <Y4klbgDIuxHXaWrC@lunn.ch>
 <1d186774cfa4173955c89e7262b1d1b7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d186774cfa4173955c89e7262b1d1b7@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I don't even dare to ask, but wouldn't a device tree property
> maxlinear,use-broken-interrupts make more sense than a compile time
> option? I'm fine with both.

Maybe. But it limits it to DT based systems. It gets messy making it
work for PCI devices, USB devices, ACPI etc.

But i guess we can have it disabled by default, and leave it to
whoever wants it enabled to figure out how to enable i for whatever
configuration system they use.

So yes, maxlinear,use-broken-interrupts.

   Andrew
