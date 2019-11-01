Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2A8ECAE4
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfKAWKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:10:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:10:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5929151B09AC;
        Fri,  1 Nov 2019 15:10:04 -0700 (PDT)
Date:   Fri, 01 Nov 2019 15:10:04 -0700 (PDT)
Message-Id: <20191101.151004.1466788730845031420.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix wrong PHY ID issue with RTL8168dp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <651a11c7-005b-3b62-61a2-496e91048b9d@gmail.com>
References: <651a11c7-005b-3b62-61a2-496e91048b9d@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 15:10:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 1 Nov 2019 00:10:21 +0100

> As reported in [0] at least one RTL8168dp version has problems
> establishing a link. This chip version has an integrated RTL8211b PHY,
> however the chip seems to report a wrong PHY ID, resulting in a wrong
> PHY driver (for Generic Realtek PHY) being loaded.
> Work around this issue by adding a hook to r8168dp_2_mdio_read()
> for returning the correct PHY ID.
> 
> [0] https://bbs.archlinux.org/viewtopic.php?id=246508
> 
> Fixes: 242cd9b5866a ("r8169: use phy_resume/phy_suspend")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable, thanks.
