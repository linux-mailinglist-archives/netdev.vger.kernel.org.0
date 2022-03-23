Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A946B4E591D
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 20:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238924AbiCWT3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 15:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242548AbiCWT3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 15:29:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F076131372;
        Wed, 23 Mar 2022 12:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qYdVN87fI7cxolE1tClOfp7bWWvUcWqI33uDbVepwfo=; b=3annfi6YEaF1or+cu2vm3QExf5
        2vLfWjZ1K3BzOE1/5x160FeQw7fgekNJ+PMIUMxNKg8KE00LpG76WJUfLYgqR9390+o5B5ArSuaxX
        O34b1CvFjELA1OxVOgTxlMMD5I9NhnfOmDtxm7IJqDWVpcV7OXYOGOsON+aV93P4WX2s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nX6e5-00CKeV-6j; Wed, 23 Mar 2022 20:27:49 +0100
Date:   Wed, 23 Mar 2022 20:27:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: phy: mscc-miim: reject clause 45
 register accesses
Message-ID: <Yjt0tQyq3NrEG3EO@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323183419.2278676-2-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 07:34:15PM +0100, Michael Walle wrote:
> The driver doesn't support clause 45 register access yet, but doesn't
> check if the access is a c45 one either. This leads to spurious register
> reads and writes. Add the check.
> 
> Fixes: 542671fe4d86 ("net: phy: mscc-miim: Add MDIO driver")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
