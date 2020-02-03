Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD781150F10
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgBCSCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:02:23 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42705 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728871AbgBCSCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 13:02:23 -0500
Received: by mail-pf1-f194.google.com with SMTP id 4so7963510pfz.9;
        Mon, 03 Feb 2020 10:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pjL7Y0zp+kMKEMjjA17pY3haLYvj/yXBgXXkYe32lfA=;
        b=C2D54H2OsHe2iRBTF6t711yuQ+Tbku62vjvBSz3+oyUNBhGQgfWRZZva0jQ9993ARU
         9HZVgUC6aO9DK5EOwV1WAQhkqW/idMrkBfNpoHJueCDnRBCeTQ62qkNNbwP8DxnKZ/6H
         5EdK+qVFB1CTrb1PtgPtGwURyMQHHX49Zxj5NZfLHxFhye45zWRu7b3/a8xhi51m/Kbz
         q9Tl9Q2/FJT+jwP09NLKmifD95k+BzTVSpD9+rhq1BYqkvBMZWAAgTh8Ov1p6d3YmrSC
         xqDrla2QU5KbzDU7kOA5ysmeWpHHI5dKYwSOWsjDNttmuwio3aKbheqYc754XCYhdCfY
         yPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pjL7Y0zp+kMKEMjjA17pY3haLYvj/yXBgXXkYe32lfA=;
        b=Oft8nnOIB0bx46qu6d1Orw6S9AkQLk3iIuHNBszXyP9nbVf/Iy+oqvHllVEIU5Ly4S
         ENuhJxG7O7Cjl0zf5iiBTd7m8C1neWn4ljLaD3lK06/3uu6pzVBd6nwUk+eX4C5yogGU
         Z72KdYjmWlVma8KNrh99n2yL2lEonDQPZF7rt39QFITxYB9UgVySeJ8QvBQ7SLY4Utgf
         eKqRKvMPtt4JWu4iCSG459gdG4ST+GkmXPPIwL4cD5T37RQgbSydmaCilDiL6GAE0Dlu
         o49RojAkEVNL95z8WtZiPd99CUtyw5mAbA/uTlP0Wuby4+JBsnxVmMXZojs4QjZqNul/
         8JXw==
X-Gm-Message-State: APjAAAXHSt4An5601NDN8sOUyYTAYTdzLPmLP6IwtyboeEeBT4c1eZQN
        ffaCgmF2HzqqtYIIp7tVqH+TmtKl
X-Google-Smtp-Source: APXvYqw/Ut8koDL4jHa55iaX8aQ5uTKACDlciPK1T1NEMVmRtBrUNslnrgXhUoCx8Q5GIomFHVr2WA==
X-Received: by 2002:a63:e954:: with SMTP id q20mr27773347pgj.204.1580752940401;
        Mon, 03 Feb 2020 10:02:20 -0800 (PST)
Received: from [10.67.50.115] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b21sm21783747pfp.0.2020.02.03.10.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 10:02:19 -0800 (PST)
Subject: Re: [PATCH v1 0/7] ACPI support for xgmac_mdio and dpaa2-mac drivers.
To:     Calvin Johnson <calvin.johnson@nxp.com>, linux.cj@gmail.com,
        Jon Nettleton <jon@solid-run.com>, linux@armlinux.org.uk,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Matteo Croce <mcroce@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <fcda49b6-7a45-cd86-e33e-f8dea07c0684@gmail.com>
Date:   Mon, 3 Feb 2020 10:02:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200131153440.20870-1-calvin.johnson@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/20 7:34 AM, Calvin Johnson wrote:
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> This patch series provides ACPI support for xgmac_mdio and dpaa2-mac
> driver. Most of the DT APIs are replaced with fwnode APIs to handle
> both DT and ACPI nodes.
> 
> Old patch by Marcin Wojtas: (mdio_bus: Introduce fwnode MDIO helpers),
> is reused in this series to get some fwnode mdio helper APIs.

Andrew's comment on your first patch is a good summary of what this
patch series does, instead of consolidating the existing code and making
it less of_* centric and more firmware agnostic, this duplicates the
existing infrastructure almost line for line to create a fwnode specific
implementation. The preference would be for you to move away from that
and use device_* properties as much as possible while making the code
capable of handling all firmware implementations.

Can you also show a few DSDT for the devices that you are working so we
can a feeling of how you represented the various properties and
parent/child devices dependencies?

> 
> 
> Calvin Johnson (6):
>   mdio_bus: modify fwnode phy related functions
>   net/fsl: add ACPI support for mdio bus
>   device property: fwnode_get_phy_mode: Change API to solve int/unit
>     warnings
>   device property: Introduce fwnode_phy_is_fixed_link()
>   net: phylink: Introduce phylink_fwnode_phy_connect()
>   dpaa2-eth: Add ACPI support for DPAA2 MAC driver
> 
> Marcin Wojtas (1):
>   mdio_bus: Introduce fwnode MDIO helpers
> 
>  drivers/base/property.c                       |  43 ++-
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  78 ++++--
>  drivers/net/ethernet/freescale/xgmac_mdio.c   |  63 +++--
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   7 +-
>  drivers/net/phy/mdio_bus.c                    | 244 ++++++++++++++++++
>  drivers/net/phy/phylink.c                     |  64 +++++
>  include/linux/mdio.h                          |   3 +
>  include/linux/phylink.h                       |   2 +
>  include/linux/property.h                      |   5 +-
>  9 files changed, 450 insertions(+), 59 deletions(-)
> 


-- 
Florian
