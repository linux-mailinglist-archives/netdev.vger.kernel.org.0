Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35D61F0902
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 00:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgFFWyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 18:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgFFWyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 18:54:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365DFC03E96A;
        Sat,  6 Jun 2020 15:54:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AAA91274F71C;
        Sat,  6 Jun 2020 15:54:31 -0700 (PDT)
Date:   Sat, 06 Jun 2020 15:54:30 -0700 (PDT)
Message-Id: <20200606.155430.1385564814743796746.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dp83869: Reset return variable if PHY strap
 is read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200605205103.29663-1-dmurphy@ti.com>
References: <20200605205103.29663-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 06 Jun 2020 15:54:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Fri, 5 Jun 2020 15:51:03 -0500

> When the PHY's strap register is read to determine if lane swapping is
> needed the phy_read_mmd returns the value back into the ret variable.
> 
> If the call to read the strap fails the failed value is returned.  If
> the call to read the strap is successful then ret is possibly set to a
> non-zero positive number. Without reseting the ret value to 0 this will
> cause the parse DT function to return a failure.
> 
> Fixes: c4566aec6e808 ("net: phy: dp83869: Update port-mirroring to read straps")
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Applied, thank you.
