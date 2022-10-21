Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FF8607C28
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJUQ0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJUQ0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:26:16 -0400
Received: from vps0.lunn.ch (unknown [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6861926B6EF
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 09:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EYwBg6/U4pxRXCddPKXmGmepWR45xlxE//k8asJf7g0=; b=UXPs5SDO87d2hq+KDX1d8R4xoD
        FeR4pJRipFyFOlb3CgmRVM88fnPddR6K0ezETCMVdx9XNwH/O3OtECMvzg5NyGycDZGq/LjJ43BTJ
        9VCBQcsmWwHDAeZYS5bmI9J5btAIXZXAaIAmvBWYUCcfdKEYZ07W65ksOpKF4zSspajI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oluKK-000FOE-Af; Fri, 21 Oct 2022 17:52:52 +0200
Date:   Fri, 21 Oct 2022 17:52:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] net: sfp: get rid of DM7052 hack when
 enabling high power
Message-ID: <Y1LAVAUSQJrmO+63@lunn.ch>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
 <E1ol98G-00EDT1-Q6@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ol98G-00EDT1-Q6@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NEUTRAL,SPF_NEUTRAL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 02:29:16PM +0100, Russell King (Oracle) wrote:
> Since we no longer mis-detect high-power mode with the DM7052 module,
> we no longer need the hack in sfp_module_enable_high_power(), and can
> now switch this to use sfp_modify_u8().
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
