Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A03168EFB8
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjBHN3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBHN3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:29:53 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492491F4A9
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 05:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gVnNzRUs4OA2UfcdlTrQFkCI/U2RrCm033aNur/MvyI=; b=UBXikFe+4zXo9C7W98y05ILTAD
        RzecF0fMAcc7v0EI6RlHZcr2B/HoFCP3ooti11GCYt1AzUfTRiSXp4tUiwyvkZRV9UvPx5Xr5AlBa
        txiPhyRrfCr1gpiyljmcraxHYfOlqQzeDfMP0moi6x4SNluRGO6y08+3hCyWxtdbIxsE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPkVx-004PAa-7r; Wed, 08 Feb 2023 14:29:33 +0100
Date:   Wed, 8 Feb 2023 14:29:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Guan Wentao <guanwentao@uniontech.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: get phydev->interface from mac for mdio phy
 init
Message-ID: <Y+OjvfOvqz0s8qDr@lunn.ch>
References: <20230208124025.5828-1-guanwentao@uniontech.com>
 <Y+OfmMeP3Eto3K7t@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+OfmMeP3Eto3K7t@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:11:52PM +0100, Simon Horman wrote:
> On Wed, Feb 08, 2023 at 08:40:25PM +0800, Guan Wentao wrote:
> > The phy->interface from mdiobus_get_phy is default from phy_device_create.
> > In some phy devices like at803x, use phy->interface to init rgmii delay.
> > Use plat->phy_interface to init if know from stmmac_probe_config_dt.
> > 
> > Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
> > Signed-off-by: Guan Wentao <guanwentao@uniontech.com>
> > ---
> 
> This is v2 of this patch, so let me make some comments about that.
> 
> * Firstly, unless asked to repost by a reviewer/maintainer,
>   it's generally bad practice to post a patch(set) more than once within 24h.

Hi Guan

I just showed you why there is this 24 hour rule by replying to your
first version...

      Andrew
