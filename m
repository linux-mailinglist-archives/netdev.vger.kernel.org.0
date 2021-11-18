Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8302145581F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245217AbhKRJhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245203AbhKRJg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:36:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10564C061570;
        Thu, 18 Nov 2021 01:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bs4zezCjXnurkQfg8TbGNNZzbIUGTAdXsoLcf7WcUzs=; b=TKq5aq7WJDVfV65oa8R3rDyc1t
        TZJ867TyQz8J//oiB4dE/iaK6qtLIY3wNd1PB2IuZC0UIzpEssjL/48ygPmP3KNNr8e/e9tWtxa6J
        /6SiaFkOL0TLUaAXNzCF2frq6W935oMq2AMzP0318R4/42tc6teGn5VvIehiVxu1dZMKXI7RS6R9M
        2zz5xyqARFrQO/EzcKfGF72UBvxKdNtN1EcZB+euD6Rknnwh0KYZVI8uzDJN0QHRL4+VfP9vXPdze
        6LAORZVkvHvN51L5sxunV89ciBojozMsHidUrj3r92UFZCJ2IJEXt+IkNC5BeYObD7dGJlS3eytAM
        F1gLyXAA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55702)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mndnm-0002l7-FX; Thu, 18 Nov 2021 09:33:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mndnm-0003oL-2T; Thu, 18 Nov 2021 09:33:54 +0000
Date:   Thu, 18 Nov 2021 09:33:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 6/8] net: phy: marvell10g: Use generic macro for
 supported interfaces
Message-ID: <YZYeAtfUJ2hHlc2O@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-7-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117225050.18395-7-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:50:48PM +0100, Marek Behún wrote:
> Now that phy.h defines macro DECLARE_PHY_INTERFACE_MASK(), use it
> instead of DECLARE_BITMAP().
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
