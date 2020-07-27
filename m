Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA29022F7BF
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbgG0S3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgG0S3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:29:51 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B439C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:29:51 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u185so9556956pfu.1
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SVZ2onwb6xGif/7GdJ422ZBkcOXCp6rrd+ybx4z12xc=;
        b=P4x6sGFT7i5pAQoAhC4NpMQFUUKKKPZH71hNc4GuTI+oDSwarkT1HadtWqLBeQmiSy
         Hyj00F6tyB3hoYeLAsbZ7Tn9IKoQreIh382oqYpUDp0nu42PWdire3EB0XhQ47wSPFSc
         Gll49+sphG7Gw9zv08hCrKCWLhyEZ9Aj2wgD/WPQ3BN4j7qGuGE88JV+kxdiJ6m6nHTh
         m1iC4yL9zGSi3ECYbWEZaMctRHwrOhn5CmFelVcAy5i/yJVmufPcBOhzbz6g9JF12uvD
         MJ7P+f8ft5MQZXaQot0TLPWfkfhrPprtcnmkTqbQai4rdE7YG5MF6j9+ZTZhRAZFC9BM
         sckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SVZ2onwb6xGif/7GdJ422ZBkcOXCp6rrd+ybx4z12xc=;
        b=uEJO39OMtRR71b76wArXzSCv2o8sVY687ZBN7NJOhphcKzpw+yjrcJclpl1f0RjmUe
         PEz8F2gNsmPc0cNwxWJ5pDsMK+eYUwoF3iD2IvlSSEfx7rqZwTypZCqTS5uonRV97lP6
         sMPgcYn87QCJ/kIapvJWrKOkUVA6Qj4G0xMj/LtkCaMEYnBy4MTREZM7yjwDxFFYXUUL
         X66GKi+EH7zf42LKX7y+tQDaVeNxEHYYkrSP+es3gvVjpndUnh5a2YycqlrxK3xPEm/y
         SLy5DM3c5XqDFSyo9IDZ2AwSa1mn7yJ7X4QJFaux42CO5p1VeQXRXc+ERKGDklJXt/sN
         uBBg==
X-Gm-Message-State: AOAM533caZ8oAfcMb9xTSEVBXOeVQRcGBFIWh/a+zPgdWKJK3lFgZRlG
        J47erO+pkCkPyT5t+OcXFjWLrwIX
X-Google-Smtp-Source: ABdhPJwl5P57M354U91MDqtm5XzeQzJ0SEwZV+WE67uZXFAlsviFORQDlHwaedbMHwQNnaqYflkkmQ==
X-Received: by 2002:aa7:9422:: with SMTP id y2mr21827759pfo.211.1595874590766;
        Mon, 27 Jul 2020 11:29:50 -0700 (PDT)
Received: from [10.69.79.32] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 19sm15803129pfy.193.2020.07.27.11.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 11:29:49 -0700 (PDT)
Subject: Re: [PATCH net-next v4 0/5] net: phy: add Lynx PCS MDIO module
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch, linux@armlinux.org.uk,
        olteanv@gmail.com
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <400c65b5-718e-64f5-a2a2-3b26108a93d5@gmail.com>
Date:   Mon, 27 Jul 2020 11:29:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724080143.12909-1-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/2020 1:01 AM, Ioana Ciornei wrote:
> Add support for the Lynx PCS as a separate module in drivers/net/phy/.
> The advantage of this structure is that multiple ethernet or switch
> drivers used on NXP hardware (ENETC, Seville, Felix DSA switch etc) can
> share the same implementation of PCS configuration and runtime
> management.
> 
> The module implements phylink_pcs_ops and exports a phylink_pcs
> (incorporated into a lynx_pcs) which can be directly passed to phylink
> through phylink_pcs_set.
> 
> The first 3 patches add some missing pieces in phylink and the locked
> mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
> standalone module. The majority of the code is extracted from the Felix
> DSA driver. The last patch makes the necessary changes in the Felix and
> Seville drivers in order to use the new common PCS implementation.
> 
> At the moment, USXGMII (only with in-band AN), SGMII, QSGMII (with and
> without in-band AN) and 2500Base-X (only w/o in-band AN) are supported
> by the Lynx PCS MDIO module since these were also supported by Felix and
> no functional change is intended at this time.
> 
> Changes in v2:
>  * got rid of the mdio_lynx_pcs structure and directly exported the
>  functions without the need of an indirection
>  * made the necessary adjustments for this in the Felix DSA driver
>  * solved the broken allmodconfig build test by making the module
>  tristate instead of bool
>  * fixed a memory leakage in the Felix driver (the pcs structure was
>  allocated twice)
> 
> Changes in v3:
>  * added support for PHYLINK PCS ops in DSA (patch 5/9)
>  * cleanup in Felix PHYLINK operations and migrate to
>  phylink_mac_link_up() being the callback of choice for applying MAC
>  configuration (patches 6-8)
> 
> Changes in v4:
>  * use the newly introduced phylink PCS mechanism
>  * install the phylink_pcs in the phylink_mac_config DSA ops
>  * remove the direct implementations of the PCS ops
>  * do no use the SGMII_ prefix when referring to the IF_MORE register
>  * add a phylink helper to decode the USXGMII code word
>  * remove cleanup patches for Felix (these have been already accepted)
>  * Seville (recently introduced) now has PCS support through the same
>  Lynx PCS module
> 
> Ioana Ciornei (5):
>   net: phylink: add helper function to decode USXGMII word
>   net: phylink: consider QSGMII interface mode in
>     phylink_mii_c22_pcs_get_state
>   net: mdiobus: add clause 45 mdiobus write accessor
>   net: phy: add Lynx PCS module
>   net: dsa: ocelot: use the Lynx PCS helpers in Felix and Seville
> 
>  MAINTAINERS                              |   7 +
>  drivers/net/dsa/ocelot/Kconfig           |   1 +
>  drivers/net/dsa/ocelot/felix.c           |  28 +-
>  drivers/net/dsa/ocelot/felix.h           |  20 +-
>  drivers/net/dsa/ocelot/felix_vsc9959.c   | 374 ++---------------------
>  drivers/net/dsa/ocelot/seville_vsc9953.c |  21 +-
>  drivers/net/phy/Kconfig                  |   6 +
>  drivers/net/phy/Makefile                 |   1 +
>  drivers/net/phy/pcs-lynx.c               | 314 +++++++++++++++++++

I believe Andrew had a plan to create a better organization within
drivers/net/phy, while this happens, maybe you can already create
drivers/net/phy/pcs/ regardless of the state of Andrew's work?

>  drivers/net/phy/phylink.c                |  44 +++
>  include/linux/mdio.h                     |   6 +
>  include/linux/pcs-lynx.h                 |  21 ++

And likewise for this header.
-- 
Florian
