Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7015917D85D
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgCIECX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:02:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53878 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgCIECX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:02:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26669158B4DEF;
        Sun,  8 Mar 2020 21:02:22 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:02:19 -0700 (PDT)
Message-Id: <20200308.210219.1558683043142542413.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        antoine.tenart@bootlin.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] net: phy: marvell10g: add mdix control
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200307090740.GH25745@shell.armlinux.org.uk>
References: <20200303195352.GC1092@lunn.ch>
        <20200303.160614.1176351857930966618.davem@davemloft.net>
        <20200307090740.GH25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:02:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Sat, 7 Mar 2020 09:07:41 +0000

> On Tue, Mar 03, 2020 at 04:06:14PM -0800, David Miller wrote:
>> From: Andrew Lunn <andrew@lunn.ch>
>> Date: Tue, 3 Mar 2020 20:53:52 +0100
>> 
>> > It would be nice to have Antoine test this before it get merged, but:
>> > 
>> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>> 
>> Ok, I'll give Antoine a chance to test it out.
> 
> Hi David,
> 
> Antoine has now tested it - do I need to resubmit now?

I am pretty sure I applied this series to net-next. :-)
