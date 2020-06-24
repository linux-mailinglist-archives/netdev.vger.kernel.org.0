Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E321B206ACF
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388795AbgFXDyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388393AbgFXDyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:54:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57591C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 20:54:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE392129880F1;
        Tue, 23 Jun 2020 20:54:19 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:54:19 -0700 (PDT)
Message-Id: <20200623.205419.1592926599123116117.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] Two phylink pause fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623164642.GV1551@shell.armlinux.org.uk>
References: <20200623164642.GV1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:54:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Tue, 23 Jun 2020 17:46:42 +0100

> While testing, I discovered two issues with ethtool -A with phylink.
> First, if there is a PHY bound to the network device, we hit a
> deadlock when phylib tries to notify us of the link changing as a
> result of triggering a renegotiation.
> 
> Second, when we are manually forcing the pause settings, and there
> is no renegotiation triggered, we do not update the MAC via the new
> mac_link_up approach.
> 
> These two patches solve both problems, and will need to be backported
> to v5.7; they do not apply cleanly there due to the introduction of
> PCS in the v5.8 merge window.

Series applied, thank you.
