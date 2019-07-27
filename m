Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812AD77C12
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfG0V3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:29:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40482 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfG0V3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:29:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 438921534FD43;
        Sat, 27 Jul 2019 14:29:53 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:29:52 -0700 (PDT)
Message-Id: <20190727.142952.1556540634664828588.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org, berny156@gmx.de
Subject: Re: [PATCH net] Revert ("r8169: remove 1000/Half from supported
 modes")
From:   David Miller <davem@davemloft.net>
In-Reply-To: <56f11453-59fd-3990-7f32-52820fee238e@gmail.com>
References: <56f11453-59fd-3990-7f32-52820fee238e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:29:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 27 Jul 2019 12:32:28 +0200

> This reverts commit a6851c613fd7fccc5d1f28d5d8a0cbe9b0f4e8cc.
> It was reported that RTL8111b successfully finishes 1000/Full autoneg
> but no data flows. Reverting the original patch fixes the issue.
> It seems to be a HW issue with the integrated RTL8211B PHY. This PHY
> version used also e.g. on RTL8168d, so better revert the original patch.
> 
> Reported-by: Bernhard Held <berny156@gmx.de>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
