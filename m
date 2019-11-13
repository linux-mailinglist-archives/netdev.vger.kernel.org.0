Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF319FA7AC
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfKMD4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:56:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfKMD4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:56:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 830811550050F;
        Tue, 12 Nov 2019 19:56:04 -0800 (PST)
Date:   Tue, 12 Nov 2019 19:56:03 -0800 (PST)
Message-Id: <20191112.195603.990766606825592151.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] r8169: use rtl821x_modify_extpage
 exported from Realtek PHY driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
References: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 19:56:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 12 Nov 2019 22:22:55 +0100

> Certain Realtek PHY's support a proprietary "extended page" access mode
> that is used in the Realtek PHY driver and in r8169 network driver.
> Let's implement it properly in the Realtek PHY driver and export it for
> use in other drivers like r8169.

Applied, but I really wish these deps worked more nicely.

Now I have to know what PHY drivers my ethernet card uses just to have
the main driver show up as a possible option in the Kconfig.  That's
not nice at all.
