Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5CEEFF5BC
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfKPVLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:11:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:11:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A125514E057CE;
        Sat, 16 Nov 2019 13:11:51 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:11:51 -0800 (PST)
Message-Id: <20191116.131151.1790997056766131161.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve conditional firmware loading
 for RTL8168d
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e825e699-9397-663c-4863-d6e4e8e1fc92@gmail.com>
References: <e825e699-9397-663c-4863-d6e4e8e1fc92@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:11:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 15 Nov 2019 21:35:22 +0100

> Using constant MII_EXPANSION is misleading here because register 0x06
> has a different meaning on page 0x0005. Here a proprietary PHY
> parameter is read by writing the parameter id to register 0x05 on page
> 0x0005, followed by reading the parameter value from register 0x06.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
