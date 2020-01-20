Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5CA14277F
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgATJmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:42:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55176 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgATJmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:42:43 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01527153D7D1C;
        Mon, 20 Jan 2020 01:42:41 -0800 (PST)
Date:   Mon, 20 Jan 2020 10:42:40 +0100 (CET)
Message-Id: <20200120.104240.2135592083053328499.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     hkallweit1@gmail.com, f.fainelli@gmail.com, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl
 handler phy_do_ioctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200119175109.GB17720@lunn.ch>
References: <20200119161240.GA17720@lunn.ch>
        <97389eb0-fc7f-793b-6f84-730e583c00e9@googlemail.com>
        <20200119175109.GB17720@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 01:42:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 19 Jan 2020 18:51:09 +0100

> Hi Heiner
> 
>> Not yet ;) Question would be whether one patch would be sufficient
>> or whether we need one patch per driver that needs to be ACKed by
>> the respective maintainer.
> 
> For this sort of mechanical change, i would do one patch for all
> without running, and another with running. If any driver needs more
> than a mechanical change, then do a patch per driver, and get the
> maintainer involved.

Agreed.
