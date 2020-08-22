Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2EB24E97E
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgHVTu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 15:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgHVTu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 15:50:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20ADC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:50:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5291C15D3C298;
        Sat, 22 Aug 2020 12:34:09 -0700 (PDT)
Date:   Sat, 22 Aug 2020 12:50:54 -0700 (PDT)
Message-Id: <20200822.125054.873139694261192353.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        rmk+kernel@armlinux.org.uk, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v3 0/5] Move MDIO drivers into there own
 directory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200822180611.2576807-1-andrew@lunn.ch>
References: <20200822180611.2576807-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Aug 2020 12:34:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sat, 22 Aug 2020 20:06:06 +0200

> The phy subdirectory is getting cluttered. It has both PHY drivers and
> MDIO drivers, plus a stray switch driver. Soon more PCS drivers are
> likely to appear.
> 
> Move MDIO and PCS drivers into new directories. This requires fixing
> up the xgene driver which uses a relative include path.
> 
> v2:
> Move the subdirs to drivers/net, rather than drivers/net/phy.
> 
> v3:
> Add subdirectories under include/linux for mdio and pcs

Series applied with "there" --> "their" fixed up as needed :-)

Thanks Andrew!
