Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FBA689B7C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjBCOWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbjBCOWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:22:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1883313504;
        Fri,  3 Feb 2023 06:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kkFcGHhiZIFIgfNS9GXXIN0k4DHvw0xImcd/VGxi7iA=; b=zY2k67rXVamTBiUcrlmB/mvPCB
        LH7iv5lXFdIy1FdorNvJgAR+45kkWD70y3tsP4d3fkMBdDcQZ2tuABFwpcgCMJIsZzpBRRT3o/9mb
        5JYvPloXvx9Gb1YdSQtvnROCDAEmAKw2fC2Qz2IX0r0UarFPFQv+glVQ4jcdvb2tGBtc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNwxZ-0040eZ-I7; Fri, 03 Feb 2023 15:22:37 +0100
Date:   Fri, 3 Feb 2023 15:22:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michael@walle.cc
Subject: Re: [PATCH net-next v2] net: micrel: Add support for lan8841 PHY
Message-ID: <Y90YrXHeyR6f26Px@lunn.ch>
References: <20230203122542.436305-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203122542.436305-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +{
> +	char *rx_data_skews[4] = {"rxd0-skew-psec", "rxd1-skew-psec",
> +				  "rxd2-skew-psec", "rxd3-skew-psec"};
> +	char *tx_data_skews[4] = {"txd0-skew-psec", "txd1-skew-psec",
> +				  "txd2-skew-psec", "txd3-skew-psec"};

Please take a read of
Documentation/devicetree/bindings/net/micrel-ksz90x1.txt and then add
a section which describes what these properties mean for this PHY,
since nearly every microchip PHY has a different meaning :-(

      Andrew
