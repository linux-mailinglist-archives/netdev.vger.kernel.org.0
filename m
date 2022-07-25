Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BBA5804D1
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 21:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiGYTwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 15:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbiGYTwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 15:52:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C071C205FE;
        Mon, 25 Jul 2022 12:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fYbQYlYWjEY657B9Vhq+5o/kSaJ7FUGPlg7BC6QXhc4=; b=Gtgjyjbshce6ruDLFonsn9lE9F
        ixLf1mOEt/aQbEA0EOqZt7HUf7Sy5cHyB0V6lHT07lthfm4Iam2iwqe2MsQn30NjczLVz+3vDs2qL
        GCFqs/ja6lP2O36CphWsi7GtUUnfLxWzWa1GwRmffGnUQUNBxyWSoGcH/tu2KPE6gB/0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oG47e-00BUWw-RJ; Mon, 25 Jul 2022 21:52:10 +0200
Date:   Mon, 25 Jul 2022 21:52:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     alexandru.tachici@analog.com, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        devicetree@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        gerhard@engleder-embedded.com, geert+renesas@glider.be,
        joel@jms.id.au, stefan.wahren@i2se.com, wellslutw@gmail.com,
        geert@linux-m68k.org, robh+dt@kernel.org,
        d.michailidis@fungible.com, stephen@networkplumber.org,
        l.stelmach@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [net-next v2 3/3] dt-bindings: net: adin1110: Add docs
Message-ID: <Yt70avEl443NkbJq@lunn.ch>
References: <20220725165312.59471-1-alexandru.tachici@analog.com>
 <20220725165312.59471-4-alexandru.tachici@analog.com>
 <a7d0f6c7-1943-8bef-71ff-736455609cde@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7d0f6c7-1943-8bef-71ff-736455609cde@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You had phy nodes here, but they were not replaced with the phy-handle.
> No ethernet-ports or mdios with phy?

Since this is integrated silicon, much of that is not required. There
is a fixed relationship between the MAC and the PHY, so phy-handle is
pointless. There is no need to describe the MDIO bus, because nothing
can change.  phy-mode is pointless, since it can only be internal.

ethernet-ports might be useful, if you want to use two different MAC
addresses. However, with Ethernet switches, you generally use the same
MAC address on all ports.

So i don't see a need for any of these properties.

   Andrew
