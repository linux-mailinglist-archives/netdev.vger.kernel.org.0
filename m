Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34586698292
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjBORph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjBORpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:45:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C787D3C2AF;
        Wed, 15 Feb 2023 09:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=h0r7hxkzhY+da8GfoRi/jQe/q6IhS5ISJQToD13Ow24=; b=Hdfh19LS9PuNF18yjynUbgvuQA
        FC2SLGGoQcV1/NqlyQ75iRMu/iz0zm7YgcdbdK5kMHhvKxIIdR66K3XMOiQCvzAYyNgYrWdaBX0IF
        Dzzwi3rQFQAdOP58vllUYsCACpB4A4UMV4d3oubB9xPruc4l92onSdcVEzs7BB9mI73c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSLqC-0054lp-Ag; Wed, 15 Feb 2023 18:45:12 +0100
Date:   Wed, 15 Feb 2023 18:45:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: c45:
 genphy_c45_an_config_aneg(): fix uninitialized symbol error
Message-ID: <Y+0aKHBMSmjYGHN2@lunn.ch>
References: <20230215050453.2251360-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215050453.2251360-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 06:04:53AM +0100, Oleksij Rempel wrote:
> Fix warning:
> drivers/net/phy/phy-c45.c:712 genphy_c45_write_eee_adv() error: uninitialized symbol 'changed'
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://lore.kernel.org/r/202302150232.q6idsV8s-lkp@intel.com/
> Fixes: 022c3f87f88e ("net: phy: add genphy_c45_ethtool_get/set_eee() support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
