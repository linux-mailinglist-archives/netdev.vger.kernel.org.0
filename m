Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBEE3641914
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 21:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiLCUlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 15:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLCUlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 15:41:20 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472F017E06;
        Sat,  3 Dec 2022 12:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=60r8YpbkOuzEXEP5VyIYCCQKpHMp4yih9AnSIby136o=; b=aPuSXns5VH8swSTGtWTusVyUNL
        vjsFDzmt8Io2EJICqThxpPq/RlKl80+Gul5BiuI4808G0LMjBSVgmv5FxM6Q/t8wam8O4/evdtVY3
        FRSktbtqSuK6aT3ArByC3VCddWz38b+w8QCehA/y8XIXqzU4ATWIvB5DidGrEAZsLEqo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1ZJv-004Hpd-VB; Sat, 03 Dec 2022 21:41:11 +0100
Date:   Sat, 3 Dec 2022 21:41:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/4] net: phy: mxl-gpy: broken interrupt fixes
Message-ID: <Y4u0Z/25/Yierh0H@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202151204.3318592-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 04:12:00PM +0100, Michael Walle wrote:
> The GPY215 has a broken interrupt pin. This patch series tries to
> workaround that and because in general that is not possible, disables the
> interrupts by default and falls back to polling mode. There is an opt-in
> via the devicetree.
> 
> net vs net-next: I'm not sure. No one seems to have noticed it so far.

I guess you could fail to notice 2ms of interrupt storm, if it only
happens on link down. But we should probably fix it. So please post
the first patch to net with a Fixes: tag. The rest to net-next.

    Andrew
