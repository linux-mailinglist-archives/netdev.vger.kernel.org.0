Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E301D1FC8
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390815AbgEMUAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733135AbgEMUAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 16:00:24 -0400
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BAFDC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 13:00:24 -0700 (PDT)
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1jYxY3-00022Y-AP; Wed, 13 May 2020 16:00:11 -0400
Received: from linville-x1.hq.tuxdriver.com (localhost.localdomain [127.0.0.1])
        by linville-x1.hq.tuxdriver.com (8.15.2/8.14.6) with ESMTP id 04DJvZkY668275;
        Wed, 13 May 2020 15:57:36 -0400
Received: (from linville@localhost)
        by linville-x1.hq.tuxdriver.com (8.15.2/8.15.2/Submit) id 04DJvYfP668274;
        Wed, 13 May 2020 15:57:34 -0400
Date:   Wed, 13 May 2020 15:57:34 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, davem@davemloft.net,
        andrew@lunn.ch, vivien.didelot@gmail.com
Subject: Re: [PATCH] ethtool.c: Report transceiver correctly
Message-ID: <20200513195734.GF650568@tuxdriver.com>
References: <1585959695-26523-1-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585959695-26523-1-git-send-email-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 05:21:35PM -0700, Florian Fainelli wrote:
> After the transition to the extended link settings ioctl API, the
> kernel, up until commit 9b3004953503462a4fab31b85e44ae446d48f0bd
> ("ethtool: drop get_settings and set_settings callbacks") would support
> the legacy link settings operation and report the transceiver type.
> After this commit, we lost that information although the Linux PHY
> library populates it correctly even with get_link_ksettings() method.
> 
> Ensure that we report the transceiver type correctly for such cases.
> 
> Fixes: 33133abf3b77 ("ethtool.c: add support for ETHTOOL_xLINKSETTINGS ioctls")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks (belatedly) -- queued for next release!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
