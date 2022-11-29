Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC6063C13E
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiK2NkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiK2NkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:40:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD3D5A6DC;
        Tue, 29 Nov 2022 05:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l7SnxiJShzPG3HavT5y0PQZqcm0ae5jDRJd4wXIQYgk=; b=L7WJzUZkrxxfARIAPVEitmoyqh
        z10vnWusaolLRzfqHp/2aeGlCeRU8HPFpQV+MjrZVlEa1uhnxGQJqQTsPbY4ogHf09pM0l0EQS83e
        T4vRhCm81ff5MvQFcQxFI8Kp/ydQg5bsWCfXfCRWReQP2md66i5h8apR19nmgtrad5HY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p00q7-003s9O-GD; Tue, 29 Nov 2022 14:39:59 +0100
Date:   Tue, 29 Nov 2022 14:39:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v2 2/2] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y4YLryZE6TXCCTbH@lunn.ch>
References: <20221128195409.100873-1-sean.anderson@seco.com>
 <20221128195409.100873-2-sean.anderson@seco.com>
 <Y4VCz2i+kkK0z+XY@shell.armlinux.org.uk>
 <b25b1d9b-35dd-a645-a5f4-05eb0dbc6039@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b25b1d9b-35dd-a645-a5f4-05eb0dbc6039@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> This commit should not get backported until it soaks in master for a
> >> while.
> > 
> > You will have to monitor the emails from stable to achieve that - as you
> > have a Fixes tag, that will trigger it to be picked up fairly quicky.
> 
> I know; this is a rather vain attempt :)
> 
> If I had not added the fixes tag, someone would have asked me to add it.

Hi Sean

If you had put a comment under the --- that you deliberately did not
add a Fixes tag because you wanted it to soak for a while, you
probably would not be asked.

I think the bot also looks at the subject to decide if it is a fix. So
you need to word the subject so it sounds like continuing development,
not a fix.

	 Andrew
