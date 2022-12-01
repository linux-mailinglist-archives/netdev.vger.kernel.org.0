Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B239B63F953
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 21:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiLAUoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 15:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiLAUoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 15:44:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB08BF65B;
        Thu,  1 Dec 2022 12:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=/K45t2IbX9ELXjn0gtlykwAOHftadWn1uInYdvD9i08=; b=a1
        4vfQPJptlCvt6aK6GM/IDuPx6yfeIev/V61fUgTfWiyijiafza1o61fkuCa0/QwN1dCPDn3Fjah1u
        GbH1oxpn8FqUBJ1hxDfU7449x+0FwkvRg7MwNps9IkYh90m4MKrYIVfhExY10C5AgQfasCjr8ZM/Z
        UDC011KEIrByt5Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0qPC-00460t-6T; Thu, 01 Dec 2022 21:43:38 +0100
Date:   Thu, 1 Dec 2022 21:43:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Elad Nachman <enachman@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>
Subject: Re: [PATCH v2] MAINTAINERS: Update maintainer for Marvell Prestera
 Ethernet Switch driver
Message-ID: <Y4kR+qxXCnM/5mde@lunn.ch>
References: <20221128093934.1631570-1-vadym.kochan@plvision.eu>
 <20221129211405.7d6de0d5@kernel.org>
 <96e3d5fc-ab8c-2344-3266-3b73664499f1@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96e3d5fc-ab8c-2344-3266-3b73664499f1@plvision.eu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 10:39:07AM +0200, Taras Chornyi wrote:
> On 30.11.22 07:14, Jakub Kicinski wrote:
> > On Mon, 28 Nov 2022 11:39:34 +0200 Vadym Kochan wrote:
> > > Add Elad Nachman as maintainer for Marvell Prestera Ethernet Switch driver.
> > > 
> > > Change Taras Chornyi mailbox to plvision.
> > This is a patch, so the description needs to explain why...
> > and who these people are. It would seem more natural if you,
> > Oleksandr and Yevhen were the maintainers.
> > 
> > Seriously, this is a community project please act the part.
> The Marvell Prestera Switchdev Kernel Driver's focus and maintenance are
> shifted from PLVision (Marvell Contractors) to the Marvell team in Israel.
> In the last 12 months, the driver's development efforts have been shared
> between the PLVision team and Elad Nachman from the Marvell Israel group.
> 
> Elad Nachman is a veteran with over ten years of experience in Linux kernel
> development.
> He has made many Linux kernel contributions to several community projects,
> including the Linux kernel, DPDK (KNI Linux Kernel driver) and the DENT
> project.
> Elad has done reviews and technical code contributions on Armada 3700,
> Helping Pali Rohár, who is the maintainer of the Armada 3700 PCI sub-system,
> as well as others in the Armada 3700 cpufreq sub-system.
> In the last year and a half, Elad has internally dealt extensively with the
> Marvell Prestera sub-system and has led various upstreaming sub-projects
> related to the Prestera sub-system, Including Prestera sub-system efforts
> related to the Marvell AC5/X SOC drivers upstreaming. This included
> technical review and guidance on the technical aspects and code content of
> the patches sent for review.
> In addition, Elad is a member of the internal review group of code before it
> applies as a PR.

Hi Taras

The problem we have is that all this is totally opaque to us, in
netdev. The name Elad Nachman does not appear on a single patch in
mainline git for the Prestera. All i can find anywhere in mainline is
one patch in 2018 for stmmac.

The community bases a lot of its judgements on trust.  We look at
contributions, be it patches, review comments, or helping others
finding bugs etc, and slowly build up a level of trust. And at the
moment there is nothing to base trust on.

So lets wait until there are a number of merged patchsets, trust has
been established, before adding this entry. It should not take too
long, given his level of experience. As i've said before, you become a
Maintainer by being a Maintainer.

      Andrew
