Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A76437AB6
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhJVQQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhJVQQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:16:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45999C061764;
        Fri, 22 Oct 2021 09:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=la8pcbXsYCC46ghLgdCYYSCWnzPw+Po8qi4p7EHqCpk=; b=W5aUB+7WgFjgcGqnn/SNtl/vzb
        lTiANEZEIUW5itjcnyer2tOVBrJxIkNJgjNwYaRE+JUlSK4FjvNIF+1GMYYO1WMon1iBSaZNf9+HU
        KUq11N+Dnbx+OGWyOftFwzMnem9ZYYefwfzJCXKTLR37o1SfTO2iMEQMmjQLFzzkT3teqL7v7osYt
        p5H4AVyKNevMcsRZ/I8IgJdOibhSYSQlNyNKIanU6zJZXjSJZgMF6wdHUavCNg3cLvnYLMgLV3CoN
        sooGgueY9zXyOT23nV2xvpYjsv5C1GVQdf2WnHsBxbQC/NvHQ7bjbV0DlqSwEb2LNf9Vgf6zA4ZFe
        p6NnIoLQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55240)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mdxBd-0001vW-KU; Fri, 22 Oct 2021 17:14:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mdxBd-0001Iw-5V; Fri, 22 Oct 2021 17:14:29 +0100
Date:   Fri, 22 Oct 2021 17:14:29 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [net-next PATCH v2 2/3] net: phylink: Convert some users of
 mdiobus_* to mdiodev_*
Message-ID: <YXLjZc/KJt7l3/FN@shell.armlinux.org.uk>
References: <20211022155914.3347672-1-sean.anderson@seco.com>
 <20211022155914.3347672-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022155914.3347672-2-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 11:59:13AM -0400, Sean Anderson wrote:
> This refactors the phylink pcs helper functions to use mdiobus_* instead
> of mdiodev_*.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
