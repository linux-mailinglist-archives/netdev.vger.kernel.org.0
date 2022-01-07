Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09546487A57
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbiAGQ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239628AbiAGQ3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:29:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12FAC061574;
        Fri,  7 Jan 2022 08:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GcFqA5Nnb1zJRXY+qvcog6WAKwd2jF9I/R9PGMCiTkU=; b=Y0CgoumE3veAWuJnfOlez+3TgA
        ivc+AlotRu7VZKVJNLTkjyA82XGfh3gy6albDzXNSxtlNqIlWIMWWCDFHy6io1x05SWnnl45y5/OE
        hOXx2KZyEYjCDl5wkWDlEiqF65jaHiieRGsRxeix3G4m3lRlcYBcYLlJpbkUDCzNuSP3Q7PZS7wU/
        Pkwbmjd8KYoyIOEBpFpQxJyA6tN+sJGvQ91nl5EgMJ8CIFUxZNdjYdmpEZsfVWuUYlseRZ45l1pYj
        zQ+rF5kRM8XiT2gXRvQ2yWgBMyP12v871beu7CO2n7UtozWubUXQZxa+dT5MQE2Klgq6A3wmWGRMM
        wy3Nka8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56616)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n5s7Q-0001ca-Fo; Fri, 07 Jan 2022 16:29:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n5s7P-00023E-Al; Fri, 07 Jan 2022 16:29:31 +0000
Date:   Fri, 7 Jan 2022 16:29:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] of: net: Add helper function of_get_ethdev_label()
Message-ID: <Ydhqa+9ya6nHsvLq@shell.armlinux.org.uk>
References: <20220107161222.14043-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220107161222.14043-1-pali@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 05:12:21PM +0100, Pali Rohár wrote:
> Adds a new helper function of_get_ethdev_label() which sets initial name of
> specified netdev interface based on DT "label" property. It is same what is
> doing DSA function dsa_port_parse_of() for DSA ports.
> 
> This helper function can be useful for drivers to make consistency between
> DSA and netdev interface names.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>

Doesn't this also need a patch to update the DT binding document
Documentation/devicetree/bindings/net/ethernet-controller.yaml ?

Also it needs a covering message for the series, and a well thought
out argument why this is required. Consistency with DSA probably
isn't a good enough reason.

From what I remember, there have been a number of network interface
naming proposals over the years, and as you can see, none of them have
been successful... but who knows what will happen this time.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
