Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCAA60FAA4
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiJ0OnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbiJ0OnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:43:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972FC18980D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IvEDJKb4RkrPLdI/VziTD7PDk36pKFNAvnxH7dSA9vY=; b=nD/SZKYRxO33o/fa/wN+FtLMhY
        jDE5rgGRkB5siqNlF8D84MoPhI6M0eKuNgRP97JBxTuOGwpK50BmFL7Wnf/AfEqcTQrXThBdqGJAY
        lhu38V0l2kuu40ywNqDtJn+jI+2363qGkC9ikulyvoq9Nx+LJzAtA6NgHooCZ4jsREJA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oo466-000inz-EX; Thu, 27 Oct 2022 16:43:06 +0200
Date:   Thu, 27 Oct 2022 16:43:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: sfp: convert register indexes from hex
 to decimal
Message-ID: <Y1qY+nwr4SzmyhhD@lunn.ch>
References: <Y1qFvaDlLVM1fHdG@shell.armlinux.org.uk>
 <E1oo2ou-00HFJg-6q@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1oo2ou-00HFJg-6q@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 02:21:16PM +0100, Russell King (Oracle) wrote:
> The register indexes in the standards are in decimal rather than hex,
> so lets specify them in decimal in the header file so we can easily
> cross-reference without converting between hex and decimal.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Makes sense, but i've not checked for typos. Did you see if the
generated code remains identical?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
