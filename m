Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016F3662674
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbjAINER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236533AbjAINDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:03:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8541649D
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=B2HK/pF6A9R9ayW6PczULprhkx/935lJ+O19dnKs9gg=; b=YKAgI0AG7mm4LBizY/KEmgk0gk
        BLodud1Zw0JgSee93dQdmbDDlf/rrc9YgZDIG+IMbHakQTI3xUOBZ389E0M/wgjadEkxJXdo9fzOG
        felw7ZiWfBomSsqiCSxM6KsF6ouyINqwDdayYaXp1fUhZ+FxZ0g3Bz5HeF2rdIf+f1AI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pErmz-001Z9q-Le; Mon, 09 Jan 2023 14:02:09 +0100
Date:   Mon, 9 Jan 2023 14:02:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     Jamie Gloudon <jamie.gloudon@gmx.fr>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, Naama Meir <naamax.meir@linux.intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>
Subject: Re: [PATCH net-next 1/1] e1000e: Enable Link Partner Advertised
 Support
Message-ID: <Y7wQUborYFZ3brPh@lunn.ch>
References: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
 <Y7TMhVy5CdqqysRb@lunn.ch>
 <Y7U/4Q0QKtkuexLu@gmx.fr>
 <Y7W66ZstaAb9kIDe@lunn.ch>
 <e2aca2a1-f472-5fca-c091-7a489a55cc86@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2aca2a1-f472-5fca-c091-7a489a55cc86@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 10:40:47AM +0200, Neftin, Sasha wrote:
> On 1/4/2023 19:44, Andrew Lunn wrote:
> > > > I don't know this driver at all. What i don't see anywhere here is
> > > > using the results of the pause auto-neg. Is there some code somewhere
> > > > that looks at the local and link peer advertising values and runs a
> > > > resolve algorithm to determine what pause should be used, and program
> > > > it into the MAC?
> > > > 
> > > >      Andrew
> > > This is a old patch i had laying around, If i remember correctly, phy->autoneg_advertised plugs in "Link partner
> > > advertised pause frame use link" line in ethtool everytime the nic renegotiate.
> > 
> > Hi Jamie
> > 
> > Could you point me at the code which interprets the results of the
> > auto neg and configures the MAC for the correct pause.
> probably you look at  e1000e_config_fc_after_link_up method
> (this is very legacy code https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/intel/e1000e/mac.c#L1001)

Thanks. That is exactly what i wanted to see.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
