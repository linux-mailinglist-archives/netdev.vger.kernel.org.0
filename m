Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E674E65DB6A
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbjADRoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjADRoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:44:21 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ACF13DCA
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QxwW4XklGX/wvEzLim/bBKYYRDV2jxJ1hv77MMP/V20=; b=FWXgCoGkEpn66XzyUgm06wAPWA
        G/JI7/AnhozyztHXHzlynDFwMgPCmCO3GoBoQ1+IcsDH07WaC2+oVV1gemYwMyFj+B1e3XLX3AVRI
        GQQqPQ88sWz091OxxkfAGJXOln+0y+EJCTqFxxBeRRwnu756lIMiyL22Gt53TMou29lg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pD7o9-0019WO-Al; Wed, 04 Jan 2023 18:44:09 +0100
Date:   Wed, 4 Jan 2023 18:44:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jamie Gloudon <jamie.gloudon@gmx.fr>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 1/1] e1000e: Enable Link Partner Advertised
 Support
Message-ID: <Y7W66ZstaAb9kIDe@lunn.ch>
References: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
 <Y7TMhVy5CdqqysRb@lunn.ch>
 <Y7U/4Q0QKtkuexLu@gmx.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7U/4Q0QKtkuexLu@gmx.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I don't know this driver at all. What i don't see anywhere here is
> > using the results of the pause auto-neg. Is there some code somewhere
> > that looks at the local and link peer advertising values and runs a
> > resolve algorithm to determine what pause should be used, and program
> > it into the MAC?
> > 
> >     Andrew
> This is a old patch i had laying around, If i remember correctly, phy->autoneg_advertised plugs in "Link partner
> advertised pause frame use link" line in ethtool everytime the nic renegotiate.

Hi Jamie

Could you point me at the code which interprets the results of the
auto neg and configures the MAC for the correct pause.

Thanks
	Andrew
