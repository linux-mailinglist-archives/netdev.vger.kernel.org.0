Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898ED552463
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 21:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245254AbiFTTIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 15:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244329AbiFTTIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 15:08:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08AB63CB;
        Mon, 20 Jun 2022 12:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I9JnMjmAl+wncDy9zdMXbHRNZeq3DoxfwmauEBSTDeE=; b=GOD56Y9zHryF7WAzDRI2QyaXi0
        8Cl1YZtE109vd3tf4jUQK7fuLgZ8IBznPOW0z3bIqxY5jr+ILsIL5U3+ii8Wy7FGP4CDFNpRsyhf6
        EYlTuP+VVQwBeIR4nwoeQfb3FifwOoyapKabT1f19gAhtYmPoFyleuzIZ/tO6Tw8Y+jE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3Mku-007dzr-0I; Mon, 20 Jun 2022 21:08:12 +0200
Date:   Mon, 20 Jun 2022 21:08:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, lenb@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH 08/12] ACPI: scan: prevent double enumeration
 of MDIO bus children
Message-ID: <YrDFmw4rziGQJCAu@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-9-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-9-mw@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:21PM +0200, Marcin Wojtas wrote:
> The MDIO bus is responsible for probing and registering its respective
> children, such as PHYs or other kind of devices.
> 
> It is required that ACPI scan code should not enumerate such
> devices, leaving this task for the generic MDIO bus routines,
> which are initiated by the controller driver.

I suppose the question is, should you ignore the ACPI way of doing
things, or embrace the ACPI way?

At least please add a comment why the ACPI way is wrong, despite this
being an ACPI binding.

      Andrew
