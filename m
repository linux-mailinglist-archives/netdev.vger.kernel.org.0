Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77B567CB3
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 04:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfGNC2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 22:28:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46482 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbfGNC2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 22:28:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8025140518A2;
        Sat, 13 Jul 2019 19:28:53 -0700 (PDT)
Date:   Sat, 13 Jul 2019 19:28:53 -0700 (PDT)
Message-Id: <20190713.192853.1490228780057302411.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org, ionut.radu@gmail.com
Subject: Re: [PATCH net] r8169: fix issue with confused RX unit after PHY
 power-down on RTL8411b
From:   David Miller <davem@davemloft.net>
In-Reply-To: <dfc533d0-a90e-37fe-2338-483abc9c1177@gmail.com>
References: <dfc533d0-a90e-37fe-2338-483abc9c1177@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Jul 2019 19:28:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 13 Jul 2019 13:45:47 +0200

> On RTL8411b the RX unit gets confused if the PHY is powered-down.
> This was reported in [0] and confirmed by Realtek. Realtek provided
> a sequence to fix the RX unit after PHY wakeup.
> 
> The issue itself seems to have been there longer, the Fixes tag
> refers to where the fix applies properly.
> 
> [0] https://bugzilla.redhat.com/show_bug.cgi?id=1692075
> 
> Fixes: a99790bf5c7f ("r8169: Reinstate ASPM Support")
> Tested-by: Ionut Radu <ionut.radu@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable, thanks.
