Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0FD217B1A
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgGGWle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgGGWle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:41:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31228C061755;
        Tue,  7 Jul 2020 15:41:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F15F120F19EC;
        Tue,  7 Jul 2020 15:41:33 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:41:32 -0700 (PDT)
Message-Id: <20200707.154132.1774969731747787399.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, mkubecek@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: ethtool: Untangle PHYLIB
 dependency
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706042758.168819-1-f.fainelli@gmail.com>
References: <20200706042758.168819-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:41:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sun,  5 Jul 2020 21:27:55 -0700

> This patch series untangles the ethtool netlink dependency with PHYLIB
> which exists because the cable test feature calls directly into PHY
> library functions. The approach taken here is to introduce
> ethtool_phy_ops function pointers which can be dynamically registered
> when PHYLIB loads.

Series applied, thanks for doing this work Florian.
