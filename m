Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C12DB76C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503511AbfJQTYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:24:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40876 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393438AbfJQTYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:24:43 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E33AF14047D0C;
        Thu, 17 Oct 2019 12:24:42 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:24:42 -0400 (EDT)
Message-Id: <20191017.152442.339047834113245608.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk, cphealy@gmail.com, joabreu@synopsys.com
Subject: Re: [PATCH net-next 0/2] net: phy: Add ability to debug RGMII
 connections
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191015224953.24199-1-f.fainelli@gmail.com>
References: <20191015224953.24199-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 12:24:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 15 Oct 2019 15:49:51 -0700

> This patch series is primarily intended to reduce the amount of support
> involved with bringing up RGMII connections with the PHY library (or
> PHYLINK) for that matter. The idea consists in looping back a packet we
> just crafted and check whether it did came back correctly, if that is
> the case, we are good, else we must try configuring the PHY for
> different delays until it either works or we bail out.
> 
> As indicated in the commit message, future improvements could probably
> be done in order to converge faster on the appropriate configuration.
> This is intended to be PHY centric, and we are not playing with delays
> on the MAC side other than through the parsing of the phydev->interface.
> 
> The typical output would look like this:
> 
> [   62.668701] bcmgenet 8f00000.ethernet eth0: Trying "rgmii-txid" PHY interface
> [   62.676094] bcmgenet 8f00000.ethernet eth0: Determined "rgmii-txid" to be correct
> 
> Feedback highly welcome on this!

Looks like there was some feedback, please address.

Thank you.
