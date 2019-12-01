Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB1110E398
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 22:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfLAVQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 16:16:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55064 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfLAVQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 16:16:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B65BE14F99026;
        Sun,  1 Dec 2019 13:16:27 -0800 (PST)
Date:   Sun, 01 Dec 2019 13:16:27 -0800 (PST)
Message-Id: <20191201.131627.1677553428219259260.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org, alan@wylie.me.uk
Subject: Re: [PATCH net] r8169: fix jumbo configuration for RTL8168evl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a5348ef4-24be-ece0-c9b2-27c8dc7e0c06@gmail.com>
References: <a5348ef4-24be-ece0-c9b2-27c8dc7e0c06@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Dec 2019 13:16:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 1 Dec 2019 10:27:14 +0100

> Alan reported [0] that network is broken since the referenced commit
> when using jumbo frames. This commit isn't wrong, it just revealed
> another issue that has been existing before. According to the vendor
> driver the RTL8168e-specific jumbo config doesn't apply for RTL8168evl.
> 
> [0] https://lkml.org/lkml/2019/11/30/119
> 
> Fixes: 4ebcb113edcc ("r8169: fix jumbo packet handling on resume from suspend")
> Reported-by: Alan J. Wylie <alan@wylie.me.uk>
> Tested-by: Alan J. Wylie <alan@wylie.me.uk>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable.
