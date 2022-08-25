Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397FD5A1BDF
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244255AbiHYWE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244215AbiHYWEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:04:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6922DBA158
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YOx0LjkhsdvzduFv7a+lTu01aQT5+odhBTefu99+ESk=; b=AjiqspQ5sPXdr1zjmRySTlokg3
        0QI5YuOZIVCGRNNEgBYlkFIJ4eQZx9oE+xbZ9yQEZOFLYlKcIfTEAqk2sTCYhY/Jjc1JswVneU9BI
        J43GD5aIBLkFVWPSI93s1CEAgpUlUJIeuQM5Gi2UiK7cPvXTbM3i587F0SNr85zICkng=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRKxZ-00Ec2H-7a; Fri, 26 Aug 2022 00:04:21 +0200
Date:   Fri, 26 Aug 2022 00:04:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Romain Naour <romain.naour@smile.fr>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, arun.ramadoss@microchip.com,
        Romain Naour <romain.naour@skf.com>
Subject: Re: [PATCH 1/2] net: dsa: microchip: add KSZ9896 switch support
Message-ID: <Ywfx5ZpqQ3b1GMBn@lunn.ch>
References: <20220825213943.2342050-1-romain.naour@smile.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825213943.2342050-1-romain.naour@smile.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 11:39:42PM +0200, Romain Naour wrote:
> From: Romain Naour <romain.naour@skf.com>
> 
> Add support for the KSZ9896 6-port Gigabit Ethernet Switch to the
> ksz9477 driver.
> 
> Although the KSZ9896 is already listed in the device tree binding
> documentation since a1c0ed24fe9b (dt-bindings: net: dsa: document
> additional Microchip KSZ9477 family switches) the chip id
> (0x00989600) is not recognized by ksz_switch_detect() and rejected
> by the driver.
> 
> The KSZ9896 is similar to KSZ9897 but has only one configurable
> MII/RMII/RGMII/GMII cpu port.
> 
> Signed-off-by: Romain Naour <romain.naour@skf.com>
> Signed-off-by: Romain Naour <romain.naour@smile.fr>

Two signed-off-by from the same person is unusual :-)

> ---
> It seems that the KSZ9896 support has been sent to the kernel netdev
> mailing list a while ago but got lost after initial review:
> https://www.spinics.net/lists/netdev/msg554771.html

I'm not sure saying it got lost is true. It looks more like the issues
pointed out were never addressed.

> The initial testing with the ksz9896 was done on a 5.10 kernel
> but due to recent changes in dsa microchip driver it was required
> to rework this initial version for 6.0-rc2 kernel.

This looks sufficiently different that i don't think we need
Tristram's Signed-off-by as well.

I don't know these chips well enough to do a detailed review.

  Andrew
