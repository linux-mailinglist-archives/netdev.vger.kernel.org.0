Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC74465BFC4
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 13:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbjACMU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 07:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjACMUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 07:20:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5B4EE1E;
        Tue,  3 Jan 2023 04:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vdw8XV6gw/6GAfYGi4UosMiMOdmmelDcSCZ0N+VAs4k=; b=a3I/6+968g6B8CsIdOnAhRbqbc
        ocT4j2PpEJlketOeiktlatSvqeXnZbNwzxTziEtwakMbbSzY9rUGkl/5Rgs8dV0SJJRZcoUTjvAk/
        X/tNb2J6dRpNcS5F84mlWCsL1C1ft/iY0BjQeumHYwo04FmGUNJKrr1dTkXaOobc+OewNSSbU+H5l
        98rONTI+0mt3ycgZP6D0OaAjc+k8hke5yZm1nPIlp/nLgicDk5rMQpK0DGhPsl/SqjMBzlXOaZjId
        Z+XrZ1HPq5wyOBtfJixMGwfAS60J5tA6ekAdQ98qwb5nIXyuyCEGwrzVNlJ5XI3j85THmavStgCsf
        LVK0cu5Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35926)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCgHa-0005Hf-RM; Tue, 03 Jan 2023 12:20:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCgHW-00023d-23; Tue, 03 Jan 2023 12:20:38 +0000
Date:   Tue, 3 Jan 2023 12:20:38 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/2] Add I2C fwnode lookup/get interfaces
Message-ID: <Y7QdlkLcN73f1Drh@shell.armlinux.org.uk>
References: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram, David, Eric, Paolo,

How would you like to handle merging these patches? I'm not expecting
any changes during this cycle which would conflict with the sfp.c
changes in this series, so the series could be merged through the i2c
tree. However, I am intending to send additional sfp.c changes which
are independent of this.

Thanks.

On Mon, Dec 19, 2022 at 09:50:19AM +0000, Russell King (Oracle) wrote:
> Hi,
> 
> This RFC series is intended for the next merge window, but we will need
> to decide how to merge it as it is split across two subsystems. These
> patches have been generated against the net-next, since patch 2 depends
> on a recently merged patch in that tree (which is now in mainline.)
> 
> Currently, the SFP code attempts to work out what kind of fwnode we
> found when looking up the I2C bus for the SFP cage, converts the fwnode
> to the appropriate firmware specific representation to then call the
> appropriate I2C layer function. This is inefficient, since the device
> model provides a way to locate items on a bus_type by fwnode.
> 
> In order to reduce this complexity, this series adds fwnode interfaces
> to the I2C subsystem to allow I2C adapters to be looked up. I also
> accidentally also converted the I2C clients to also be looked up, so
> I've left that in patch 1 if people think that could be useful - if
> not, I'll remove it.
> 
> We could also convert the of_* functions to be inline in i2c.h and
> remove the stub of_* functions and exports.
> 
> Do we want these to live in i2c-core-fwnode.c ? I don't see a Kconfig
> symbol that indicates whether we want fwnode support, and I know there
> are people looking to use software nodes to lookup the SFP I2C bus
> (which is why the manual firmware-specific code in sfp.c is a problem.)
> 
> Thanks!
> 
> v2: updated patch 1 with docbook comments.
> 
>  drivers/i2c/i2c-core-acpi.c | 13 +-----
>  drivers/i2c/i2c-core-base.c | 98 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/i2c/i2c-core-of.c   | 51 ++---------------------
>  drivers/net/phy/sfp.c       | 13 +-----
>  include/linux/i2c.h         |  9 +++++
>  5 files changed, 112 insertions(+), 72 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
