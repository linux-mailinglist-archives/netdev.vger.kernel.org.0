Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFE45E70D9
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 02:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiIWAsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 20:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiIWAsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 20:48:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8F1113B53;
        Thu, 22 Sep 2022 17:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xA1yXueL8mz4Jl6ZcltBOxMZS6GpdhbCkxuTLfFcelA=; b=dDTJx+M4JRIli/N0owNXSmKAhk
        tNUTidL5VaK/F0uCJiFGRyDlyUkut2MtQpbTjb7dLsddqn5aOi6U3o18UwnfnzAYmwvVoQIrqVkDw
        3minFmp6h2wdFjKyoN9nfYvNC0eoIdfC2FzF2nN4oovctrCLh9jLwN6cZfhVbr/uLadk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obWr4-00HaD9-K8; Fri, 23 Sep 2022 02:47:46 +0200
Date:   Fri, 23 Sep 2022 02:47:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        kernel test robot <lkp@intel.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v6 5/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <Yy0CMpqZcsnoxTwp@lunn.ch>
References: <20220921124748.73495-1-o.rempel@pengutronix.de>
 <20220921124748.73495-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921124748.73495-6-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Power Sourcing Equipment */
> +enum {
> +	ETHTOOL_A_PSE_UNSPEC,
> +	ETHTOOL_A_PSE_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_PODL_PSE_ADMIN_STATE,		/* u8 */
> +	ETHTOOL_A_PODL_PSE_ADMIN_CONTROL,	/* u8 */
> +	ETHTOOL_A_PODL_PSE_PW_D_STATUS,		/* u8 */

I thought these changed to being u32?

Otherwise this looks good to. You can add a reviewed-by on your next
version.

	Andrew
