Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35CF4ED857
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 13:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbiCaLYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 07:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiCaLYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 07:24:06 -0400
X-Greylist: delayed 6697 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 31 Mar 2022 04:22:19 PDT
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ef0:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DFF206ED0
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 04:22:19 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 1611228056819;
        Thu, 31 Mar 2022 13:22:18 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 09B7316CA4; Thu, 31 Mar 2022 13:22:18 +0200 (CEST)
Date:   Thu, 31 Mar 2022 13:22:18 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220331112218.GA10673@wunner.de>
References: <YjCUgCNHw6BUqJxr@lunn.ch>
 <20220321100226.GA19177@wunner.de>
 <Yjh5Qz8XX1ltiRUM@lunn.ch>
 <20220326123929.GB31022@wunner.de>
 <Yj8L2Jl0yyHIyW1m@lunn.ch>
 <20220326130430.GD31022@wunner.de>
 <20220327083702.GC27264@pengutronix.de>
 <37ff78db-8de5-56c0-3da2-9effc17b4e41@suse.com>
 <20220331093040.GA20035@wunner.de>
 <8f59f82c-e1eb-f8f5-a646-189c0eac94cf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f59f82c-e1eb-f8f5-a646-189c0eac94cf@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 11:59:44AM +0200, Oliver Neukum wrote:
> On 31.03.22 11:30, Lukas Wunner wrote:
> > I propose the below patch.  If you could provide more details on the
> > regressions you've reported (+ ideally bugzilla links), I'll be happy
> > to include them in the commit message.  Thanks!
> 
> There is no bugzilla, but the report can be found:
> https://lore.kernel.org/netdev/CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com/

Excellent, thanks.

That's a different driver (ax88179_178a.c) than the one Oleksij saw the
linkwatch splat on (ax88172a.c).  I need to analyze Jann's findings
before I can say more about this.

Thanks,

Lukas
