Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D710024E9B8
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 22:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgHVUQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 16:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgHVUQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 16:16:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF8EC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 13:16:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D231B15D6B9E5;
        Sat, 22 Aug 2020 12:59:20 -0700 (PDT)
Date:   Sat, 22 Aug 2020 13:16:04 -0700 (PDT)
Message-Id: <20200822.131604.2154905344041600633.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        rmk+kernel@armlinux.org.uk, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v3 0/5] Move MDIO drivers into there own
 directory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200822195144.GA2588906@lunn.ch>
References: <20200822180611.2576807-1-andrew@lunn.ch>
        <20200822.125054.873139694261192353.davem@davemloft.net>
        <20200822195144.GA2588906@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Aug 2020 12:59:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sat, 22 Aug 2020 21:51:44 +0200

> I just got a 0-day warning. I will send a fixup soon.

I also get this when I simply type make after your changes:

WARNING: unmet direct dependencies detected for PCS_XPCS
  Depends on [n]: NETDEVICES [=y] && PCS_DEVICE [=n]
  Selected by [m]:
  - STMMAC_ETH [=m] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_STMICRO [=y] && HAS_IOMEM [=y] && HAS_DMA [=y]

And then it prompts me for:

PCS device drivers (PCS_DEVICE) [N/m/y/?] (NEW)

This is on a tree that had an allmodconfig config before your changes.

I really don't think users should get prompted for things like this just because
the source files were rearranged into different directories.

Why don't you submit a full v4 once you've resolved all of these items?

Thanks!
