Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E123F64297C
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbiLENhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLENhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:37:03 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A3210FC9;
        Mon,  5 Dec 2022 05:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3gJmi591VPp5upAo2O2bz3rgl8F9lLrslQZMAOkQWVA=; b=np2Ys350SVVeaKbPqISmaFrdIz
        hN5srezmNHKHjf1wmcEsHVEzBexO665fBaOdRzdZX6al3p7sdGFkCx9fUEg7QC7EhVs+otmWpzRUs
        UHCJD3vnJcFnaBJAyx0vb3za99YX5AKwxtGYUB11KNZs9SxvZppy2Pwhk9pMG+OrMNTM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2BeN-004PMY-1p; Mon, 05 Dec 2022 14:36:51 +0100
Date:   Mon, 5 Dec 2022 14:36:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com
Subject: Re: [PATCH v4 net-next 1/2] net: phy: micrel: Fixed error related to
 uninitialized symbol ret
Message-ID: <Y43z8+grm/TM3ype@lunn.ch>
References: <20221205103550.24944-1-Divya.Koppera@microchip.com>
 <20221205103550.24944-2-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205103550.24944-2-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 04:05:49PM +0530, Divya Koppera wrote:
> Initialized return variable
> 
> Fixes Old smatch warnings:
> drivers/net/phy/micrel.c:1750 ksz886x_cable_test_get_status() error:
> uninitialized symbol 'ret'.

I guess this patch has been rebased without the smatch warning being
changed because line 1750 in net-next/main is a blank line between two
functions.

> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 21b688dabecb ("net: phy: micrel: Cable Diag feature for lan8814 phy")
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>

So once i looked in the correct place:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
