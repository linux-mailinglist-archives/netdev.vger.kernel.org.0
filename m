Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9963D62F693
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiKRNvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKRNvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:51:43 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC431BE96;
        Fri, 18 Nov 2022 05:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BI9SdldArhmncLFH70O4J/hpnFzVxZH3XrA9hQ5k3Aw=; b=ysDnTCowTe79OLtvxyo5sxMCMs
        pEjYhuFonAHzBB441fpc8CyzHnnZhAaWxMpdcKlSJGDgzOHozSJXTpIWOZpkm7ER6JdDnLm5merqK
        NmetfTIxoJOe9J0zprtyO8JCp+khsHUuwSRYgGlz3L1HYMjCIYtaMndxzqRib5CDPhz4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ow1mH-002nbf-7w; Fri, 18 Nov 2022 14:51:33 +0100
Date:   Fri, 18 Nov 2022 14:51:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <Y3eN5cdYxPMSJzHL@lunn.ch>
References: <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
 <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
 <20221115145650.gs7crhkidbq5ko6v@skbuf>
 <f229503b98d772c936f1fc8ca826a14f@kapio-technology.com>
 <20221115161846.2st2kjxylfvlncib@skbuf>
 <e05f69915a2522fc1e9854194afcc87b@kapio-technology.com>
 <20221116102406.gg6h7gvkx55f2ojj@skbuf>
 <54b489e65712e50e5ee67b746c0fec74@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54b489e65712e50e5ee67b746c0fec74@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Would it not be appropriate to have a define that specifies the
> value instead of the same value two places as it is now?

Yes.

> And in so case, what would be an appropriate name?

MV88E6XXX_WAIT_TIMEOUT_MS ?

	  Andrew
