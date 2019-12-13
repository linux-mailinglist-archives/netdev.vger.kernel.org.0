Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C4211DB5C
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 01:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfLMA53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 19:57:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46704 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbfLMA53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 19:57:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A4D7715420D00;
        Thu, 12 Dec 2019 16:57:28 -0800 (PST)
Date:   Thu, 12 Dec 2019 16:57:26 -0800 (PST)
Message-Id: <20191212.165726.700898279205561499.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: fix interface passed to mac_link_up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191213000323.GN25745@shell.armlinux.org.uk>
References: <E1ifLlX-0004U8-Of@rmk-PC.armlinux.org.uk>
        <20191212.105544.1239200588810264031.davem@davemloft.net>
        <20191213000323.GN25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 16:57:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Fri, 13 Dec 2019 00:03:23 +0000

> On Thu, Dec 12, 2019 at 10:55:44AM -0800, David Miller wrote:
>> From: Russell King <rmk+kernel@armlinux.org.uk>
>> Date: Thu, 12 Dec 2019 10:32:15 +0000
>> 
>> > A mismerge between the following two commits:
>> > 
>> > c678726305b9 ("net: phylink: ensure consistent phy interface mode")
>> > 27755ff88c0e ("net: phylink: Add phylink_mac_link_{up, down} wrapper functions")
>> > 
>> > resulted in the wrong interface being passed to the mac_link_up()
>> > function. Fix this up.
>> > 
>> > Fixes: b4b12b0d2f02 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net")
>> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>> 
>> Does not apply to the 'net' tree.
> 
> The reason it doesn't apply is the change from link_an_mode to
> cur_link_an_mode on the preceeding line that is in net-next.
> Fixing this in net is going to create another merge conflict.
> 
> Would it be better to apply this one to net-next and a similar
> fix to the net tree?

I can handle such trivial merge conflicts when I merge net into net-next.
Especially if you let me know about it like you did here.

Please respin this for 'net'
