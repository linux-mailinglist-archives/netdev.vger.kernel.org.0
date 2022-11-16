Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4E262BFA1
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiKPNhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiKPNhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:37:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4BD193EF;
        Wed, 16 Nov 2022 05:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=b6+mt7ZYQQYW9FOtS0XYWuJNCn6C9uQNfFV/pHbuB74=; b=Vjwq2uFZe2c5uk9/JO75O2MWsn
        RwUKezSDTIESlPWd+jrOnj5dHT3lqNNF/XQH4L8VqLZbyZ3f1By2TijzZkOufQ4UnATspHrFu/JCg
        vu0BhI4sPMZfu/ODhy9DtZJnV97j7IOUouYOpeaCds2IliYT8uzUxFTfTao8WCzvcg7M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovIbC-002ZRF-DC; Wed, 16 Nov 2022 14:37:06 +0100
Date:   Wed, 16 Nov 2022 14:37:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@kapio-technology.com, Ido Schimmel <idosch@idosch.org>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <Y3TngreziFgbeTfy@lunn.ch>
References: <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
 <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
 <20221115145650.gs7crhkidbq5ko6v@skbuf>
 <f229503b98d772c936f1fc8ca826a14f@kapio-technology.com>
 <20221115161846.2st2kjxylfvlncib@skbuf>
 <e05f69915a2522fc1e9854194afcc87b@kapio-technology.com>
 <20221116102406.gg6h7gvkx55f2ojj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116102406.gg6h7gvkx55f2ojj@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Pick a value that is high enough to be reliable and submit a patch to
> "net" where you present the evidence for it (top-level MDIO controller,
> SoC, switch, kernel). I don't believe there's much to read into. A large
> timeout shouldn't have a negative effect on the MDIO performance,
> because it just determines how long it takes until the kernel declares
> it dead, rather than how long it takes for transactions to actually take
> place.

Yes, please do that.

It is interesting that you found this. I'm just curious, so no need to
investigate if you don't have time. Is there a pattern, is it the same
register which always times out?

	 Andrew
