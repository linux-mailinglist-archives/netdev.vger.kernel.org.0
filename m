Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884541F4728
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389275AbgFITjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgFITjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 15:39:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AACAC05BD1E;
        Tue,  9 Jun 2020 12:39:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6FADD1276E0BB;
        Tue,  9 Jun 2020 12:38:59 -0700 (PDT)
Date:   Tue, 09 Jun 2020 12:38:58 -0700 (PDT)
Message-Id: <20200609.123858.466960203090925019.davem@davemloft.net>
To:     dan.j.williams@intel.com
Cc:     stephen@networkplumber.org, corbet@lwn.net, andrew@lunn.ch,
        amitc@mellanox.com, david@protonic.nl, linville@tuxdriver.com,
        marex@denx.de, linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        petrm@mellanox.com, hkallweit1@gmail.com, kernel@pengutronix.de,
        christian.herber@nxp.com, mkubecek@suse.cz, kuba@kernel.org,
        o.rempel@pengutronix.de, netdev@vger.kernel.org,
        mkl@pengutronix.de, f.fainelli@gmail.com
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4d664ff641dbf3aeab1ecd5eacda220dab9d7d17.camel@intel.com>
References: <20200609101935.5716b3bd@hermes.lan>
        <20200609.113633.1866761141966326637.davem@davemloft.net>
        <4d664ff641dbf3aeab1ecd5eacda220dab9d7d17.camel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jun 2020 12:39:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Williams, Dan J" <dan.j.williams@intel.com>
Date: Tue, 9 Jun 2020 19:30:50 +0000

> On Tue, 2020-06-09 at 11:36 -0700, David Miller wrote:
>> From: Stephen Hemminger <stephen@networkplumber.org>
>> Date: Tue, 9 Jun 2020 10:19:35 -0700
>> 
>> > Yes, words do matter and convey a lot of implied connotation and
>> > meaning.
>> 
>> What is your long term plan?  Will you change all of the UAPI for
>> bonding for example?
> 
> The long term plan in my view includes talking with standards bodies to
> move new content to, for example, master/subordinate. In other words,
> practical forward steps, not retroactively changing interfaces.

When that knowledge is established legitimately in standards and
transferred into common knowledge of these technologies, yes then
please come present your proposals.

But right now using different words will create confusion.

I also find master/subordinate an interesting proposal, what if master
is a triggering term?  Why only slave?

I know people feel something needs to change, but do that moving
forward for the technologies themselves.  Not how we implement support
for a technology which is established already.

Plant the seed, don't chop the tree down.
