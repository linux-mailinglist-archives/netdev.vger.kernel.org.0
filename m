Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5AB1B674B
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 00:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgDWWzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgDWWzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:55:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033DEC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 15:55:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93D0F127E804F;
        Thu, 23 Apr 2020 15:55:53 -0700 (PDT)
Date:   Thu, 23 Apr 2020 15:55:53 -0700 (PDT)
Message-Id: <20200423.155553.83948668210220316.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: bcm84881: clear settings on link down
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jRWju-0007AB-BO@rmk-PC.armlinux.org.uk>
References: <E1jRWju-0007AB-BO@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 15:55:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Thu, 23 Apr 2020 08:57:42 +0100

> Clear the link partner advertisement, speed, duplex and pause when
> the link goes down, as other phylib drivers do.  This avoids the
> stale link partner, speed and duplex settings being reported via
> ethtool.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
