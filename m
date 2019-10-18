Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA6EDCC89
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410584AbfJRRW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:22:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55318 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405964AbfJRRW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:22:57 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3029911F5F50E;
        Fri, 18 Oct 2019 10:22:57 -0700 (PDT)
Date:   Fri, 18 Oct 2019 13:22:56 -0400 (EDT)
Message-Id: <20191018.132256.1969438286879618581.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, dwagner@suse.de, wahrenst@gmx.net
Subject: Re: [PATCH net] net: usb: lan78xx: Connect PHY before registering
 MAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191017192926.24232-1-andrew@lunn.ch>
References: <20191017192926.24232-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 18 Oct 2019 10:22:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 17 Oct 2019 21:29:26 +0200

> As soon as the netdev is registers, the kernel can start using the
> interface. If the driver connects the MAC to the PHY after the netdev
> is registered, there is a race condition where the interface can be
> opened without having the PHY connected.
> 
> Change the order to close this race condition.
> 
> Fixes: 92571a1aae40 ("lan78xx: Connect phy early")
> Reported-by: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied and queued up for -stable, thanks.
