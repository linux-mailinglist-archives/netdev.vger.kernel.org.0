Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D131D520299
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbiEIQmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239130AbiEIQmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:42:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D6D2CA48B;
        Mon,  9 May 2022 09:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OMlL5sJMjzT5uQRcMqiBjPCY3eHb3CrezL2DCRa3GHM=; b=LX6v0B4l2dCWZCYAohU+v4FKmO
        FzwWZPEXm0jIfusbne39tuxb6d5HiYw1ga1u5oXBRwEhd9oWTnETsWrfh/Gw9GG+TgJOZeMCS27Ky
        Sp4gFtHFwhyAdgrebE4RbqdiS3AQQOmntmol1hcB4K624/Zkhk527rv16yCKJ68JTD98=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no6Ob-001yY5-My; Mon, 09 May 2022 18:38:05 +0200
Date:   Mon, 9 May 2022 18:38:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mark Brown <broonie@kernel.org>
Cc:     LABBE Corentin <clabbe@baylibre.com>, alexandre.torgue@foss.st.com,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 3/6] dt-bindings: net: Add documentation for phy-supply
Message-ID: <YnlDbbegQ1IbbaHy@lunn.ch>
References: <20220509074857.195302-1-clabbe@baylibre.com>
 <20220509074857.195302-4-clabbe@baylibre.com>
 <YnkGV8DyTlCuT92R@lunn.ch>
 <YnkWl+xYCX8r9DE7@Red>
 <Ynk7L07VH/RFVzl6@lunn.ch>
 <Ynk9ccoVh32Deg45@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynk9ccoVh32Deg45@sirena.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> No, that's not a thing - the supplies are individual, named properties
> and even if there were a list we'd still want them to be named so it's
> clear what's going on.

So we have a collection of regulators, varying in numbers between
different PHYs, with different vendor names and purposes. In general,
they all should be turned on. Yet we want them named so it is clear
what is going on.

Is there a generic solution here so that the phylib core can somehow
enumerate them and turn them on, without actually knowing what they
are called because they have vendor specific names in order to be
clear what they are?

There must be a solution to this, phylib cannot be the first subsystem
to have this requirement, so if you could point to an example, that
would be great.

Thanks
	Andrew
