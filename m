Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF25422281
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 11:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhJEJld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 05:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhJEJlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 05:41:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2E7C061745;
        Tue,  5 Oct 2021 02:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mP8SE6PYbA6eukRG5PcP85FllcxoPD5k3unsb67nCcQ=; b=dep6hnBXc/2z4bKbJKxlnT2dmi
        lRDGPHZoHYEiXUzkY6zRwlksYbM9/sVYUoltpKhS9AgjOZ1GByGTv8Eknt9wBdI0NTbciP3jn0gG0
        BojX//rXH1mGt51PPAb4U1pBafNj1qOB9J2+a5Z6+GNTyR8sOwVUSXhtKGTrueqUAENOYlcRsLkx8
        pwSXq3k4COgz8QUaaAyIDBA/HuNu3obOcpt6u1z6kJ6AC7pmEshAqndY2f1ILqfXNpnrmsi+ej+XE
        Vr/t5HjbzFbl+Jkl1IF+jNvHaz4aEgHqTDsVZb2IEnp/0JXTJUhHYB+hAi9b80l1+tY+LKKJNNDS7
        Bu8EF6mw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54942)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXgvC-00005N-Qh; Tue, 05 Oct 2021 10:39:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXgvA-0008Mf-Rx; Tue, 05 Oct 2021 10:39:36 +0100
Date:   Tue, 5 Oct 2021 10:39:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC net-next PATCH 01/16] dt-bindings: net: Add pcs property
Message-ID: <YVwdWIJiV1nkJ4A3@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-2-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:12PM -0400, Sean Anderson wrote:
> Add a property for associating PCS devices with ethernet controllers.
> Because PCS has no generic analogue like PHY, I have left off the
> -handle suffix.

For PHYs, we used to have phy and phy-device as property names, but the
modern name is "phy-handle". I think we should do the same here, so I
would suggest using "pcs-handle".

We actually already have LX2160A platforms using "pcs-handle", (see
Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml) so we're
in danger of ending up with multiple property names describing the same
thing.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
