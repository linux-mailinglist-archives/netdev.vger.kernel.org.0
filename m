Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8936E6C53ED
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCVSmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjCVSmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:42:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D285F537;
        Wed, 22 Mar 2023 11:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gxpVDH1mh+/A/+t56LjQUDaqRiV8r9sVqml3AJRAo4Y=; b=rg10SCteP+Kstm7Upq85BHo0vz
        BDp8OfA1PLgJCn2+lYnsCtF3sQ0su7PFyNsVRkVAiLP+o9st6THYYw01TyixGMKJTWbHgdNE+9iO8
        nnuKpRjaxYEhuW8CgPmBd4QI21Ws1paKccdzTu/JEBNHXbS7Ye5CWkJPtMzKBoonaxnY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pf3Pg-0085t1-Oa; Wed, 22 Mar 2023 19:42:20 +0100
Date:   Wed, 22 Mar 2023 19:42:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 3/7] net: dsa: use fwnode_get_phy_mode() to
 get phy interface mode
Message-ID: <1394b96f-ee3c-43c9-bc26-a991980d6c09@lunn.ch>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 12:00:06PM +0000, Russell King (Oracle) wrote:
> In preparation for supporting the use of software nodes to setup
> phylink, switch DSA to use fwnode_get_phy_mode() to retrieve the
> phy interface mode, rather than using of_get_phy_mode() which is
> DT specific.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
