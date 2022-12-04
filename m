Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C3A641E48
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 18:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiLDRuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 12:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiLDRuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 12:50:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2101413F9C;
        Sun,  4 Dec 2022 09:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jnWCmLa07Cboorow/ejMSmqioVuXh5OGUyXFM2GYNr0=; b=Zg2wUo7aShYjqEIwFMO0Y5yuyy
        JEHlwz1SncQIHQ9MbxoXwaA2RPxseYsCOgITQeAXXhR0/wYP1mJ2+BJyrtVoTLJaWU0T/Xwc8wgg8
        cGbTtK8SX874KzL0pxu0I+tl1bLDUwi6hk8nKddVs35hD+QNlZ8IsNCG5+D12EZ3Qmt4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1t7Z-004KlS-8i; Sun, 04 Dec 2022 18:49:45 +0100
Date:   Sun, 4 Dec 2022 18:49:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 1/2] ethtool: update UAPI files
Message-ID: <Y4zduT5aHd4vxQZL@lunn.ch>
References: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
 <0f7042bc6bcd59b37969d10a40e65d705940bee0.1670121214.git.piergiorgio.beruto@gmail.com>
 <Y4zVMj7rOkyA12uA@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zVMj7rOkyA12uA@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 05:13:22PM +0000, Russell King (Oracle) wrote:
> On Sun, Dec 04, 2022 at 03:38:37AM +0100, Piergiorgio Beruto wrote:
> 
> NAK. No description of changes.

Hi Piergiorgio

Look at the previous examples of this:

commit 41fddc0eb01fcd8c5a47b415d3faecd714652513
Author: Michal Kubecek <mkubecek@suse.cz>
Date:   Mon Jun 13 23:50:26 2022 +0200

    update UAPI header copies
    
    Update to kernel v5.18.
    
    Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

> > diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
> > index 944711cfa6f6..5f414deacf23 100644
> > --- a/uapi/linux/ethtool.h
> > +++ b/uapi/linux/ethtool.h
> > @@ -11,14 +11,16 @@
> >   * Portions Copyright (C) Sun Microsystems 2008
> >   */
> >  
> > -#ifndef _LINUX_ETHTOOL_H
> > -#define _LINUX_ETHTOOL_H
> > +#ifndef _UAPI_LINUX_ETHTOOL_H
> > +#define _UAPI_LINUX_ETHTOOL_H

Maybe ask Michal Kubecek how he does this. It does not appear to be a
straight copy of the headers.

	 Andrew
