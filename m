Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D5A642BDB
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiLEPcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbiLEPc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:32:26 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94878646D;
        Mon,  5 Dec 2022 07:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yaI4qE0EV8RXXGz7LMptqyqSzHKyYM1QhdDb6i2151E=; b=I2P4WMW3lDlAXK7/VB+ngPl/C1
        v7Wrd16l2wTC92m+PPZIcceAMUEpjEZyby6/5o/By74NuDOBtDiEBuIY4Zj7qS2mGXU50SzOxgTL6
        L5bvXnSY+o4jng8vj0vlnU0TuF0X21eMBwDATwzFvktUZMM+N0Yw5DxHkzdfdslCtY/I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2DR1-004PxO-Ez; Mon, 05 Dec 2022 16:31:11 +0100
Date:   Mon, 5 Dec 2022 16:31:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y44Ov+Z7fXukxQNu@lunn.ch>
References: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
 <20221205060057.GA10297@pengutronix.de>
 <Y43CDqAjvlAfLK1v@gvm01>
 <20221205102209.GA17619@pengutronix.de>
 <Y43+z+xJxZiSJpRm@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y43+z+xJxZiSJpRm@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +PLCA_GET_CFG
> +=======

You probably get a warning from this. The === needs to be as long as
what it underlines.

> +
> +Gets PLCA RS attributes.
> +
> +Request contents:
> +
> +  =====================================  ======  ==========================
> +  ``ETHTOOL_A_PLCA_HEADER``              nested  request header
> +  =====================================  ======  ==========================
> +
> +Kernel response contents:
> +
> +  ======================================  ======  =============================
> +  ``ETHTOOL_A_PLCA_HEADER``               nested  reply header
> +  ``ETHTOOL_A_PLCA_VERSION``              u16     Supported PLCA management
> +                                                  interface standard/version
> +  ``ETHTOOL_A_PLCA_ENABLED``              u8      PLCA Admin State
> +  ``ETHTOOL_A_PLCA_NODE_ID``              u8      PLCA unique local node ID
> +  ``ETHTOOL_A_PLCA_NODE_CNT``             u8      Number of PLCA nodes on the
> +                                                  netkork, including the
> +						  coordinator

tabs vs spaces. The indentation needs to be correct here or you will
get warnings when the documentation is built.

You can build the documentation with

make htmldocs

Not looked at the actual contents yet, just the markup.

    Andrew
