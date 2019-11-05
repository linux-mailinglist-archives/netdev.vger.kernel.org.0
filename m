Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAA1F04B0
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 19:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390644AbfKESE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 13:04:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36426 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389356AbfKESE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 13:04:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A45AC1502450B;
        Tue,  5 Nov 2019 10:04:26 -0800 (PST)
Date:   Tue, 05 Nov 2019 10:04:23 -0800 (PST)
Message-Id: <20191105.100423.1742603284030008698.davem@davemloft.net>
To:     dmitry.torokhov@gmail.com
Cc:     linux@armlinux.org.uk, linus.walleij@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH v2 0/3] net: phy: switch to using fwnode_gpiod_get_index
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAKdAkRQNWXjMdJ9F1Lu=8+rHWFJwoyWu6Lcc+LFesaSTz3wspg@mail.gmail.com>
References: <20191105004016.GT57214@dtor-ws>
        <20191105005541.GP25745@shell.armlinux.org.uk>
        <CAKdAkRQNWXjMdJ9F1Lu=8+rHWFJwoyWu6Lcc+LFesaSTz3wspg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 10:04:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Tue, 5 Nov 2019 09:27:51 -0800

> On Mon, Nov 4, 2019 at 4:55 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
>>
>> On Mon, Nov 04, 2019 at 04:40:16PM -0800, Dmitry Torokhov wrote:
>> > Hi Linus,
>> >
>> > On Mon, Oct 14, 2019 at 10:40:19AM -0700, Dmitry Torokhov wrote:
>> > > This series switches phy drivers form using fwnode_get_named_gpiod() and
>> > > gpiod_get_from_of_node() that are scheduled to be removed in favor
>> > > of fwnode_gpiod_get_index() that behaves more like standard
>> > > gpiod_get_index() and will potentially handle secondary software
>> > > nodes in cases we need to augment platform firmware.
>> > >
>> > > Linus, as David would prefer not to pull in the immutable branch but
>> > > rather route the patches through the tree that has the new API, could
>> > > you please take them with his ACKs?
>> >
>> > Gentle ping on the series...
>>
>> Given that kbuild found a build issue with patch 1, aren't we waiting
>> for you to produce an updated patch 1?
> 
> No: kbuild is unable to parse instructions such as "please pull an
> immutable branch" before applying the series. Linus' tree already has
> needed changes.

This is targetting the networking tree so it doesn't matter what is in
Linus's tree, it has to build against MY tree and that's what Kbuild
tests against.

Resubmit if it builds against my tree, and no sooner.
