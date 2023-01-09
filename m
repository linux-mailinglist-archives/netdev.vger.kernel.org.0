Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918F7662770
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbjAINmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjAINlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:41:32 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EB918392;
        Mon,  9 Jan 2023 05:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ifIB3dNwnPPnFbmMS+HAKUlWANjT7VzKeYwTu28sxu0=; b=GJWXnakSfedyINXSjDa+JnLhbj
        3thVKKm5O50IqUtq3CgggCdZjudsGoo6KKaf8OFzznqZSprgi3l574f2+xjyuvUz5BOv00ADWJg4R
        xCA+3BxY5jgANFWhSFpCkb6M70awUK7Ib9Pe4l0haC0i/4cnF9oxYqy7wxIZpkRhTv6E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pEsOw-001ZUC-G2; Mon, 09 Jan 2023 14:41:22 +0100
Date:   Mon, 9 Jan 2023 14:41:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] net: phy: mxl-gpy: disable interrupts on
 GPY215 by default
Message-ID: <Y7wZgvqhBgqdOF46@lunn.ch>
References: <20230109123013.3094144-1-michael@walle.cc>
 <20230109123013.3094144-5-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109123013.3094144-5-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 01:30:13PM +0100, Michael Walle wrote:
> The interrupts on the GPY215B and GPY215C are broken and the only viable
> fix is to disable them altogether. There is still the possibilty to
> opt-in via the device tree.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
