Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A08115E61
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 21:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfLGUCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 15:02:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfLGUCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 15:02:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C15D515422CF5;
        Sat,  7 Dec 2019 12:02:35 -0800 (PST)
Date:   Sat, 07 Dec 2019 12:02:35 -0800 (PST)
Message-Id: <20191207.120235.27105623470022386.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] r8169: add missing RX enabling for WoL on
 RTL8125
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fa53c5df-61ef-9e35-a3a3-406e5ef59d2e@gmail.com>
References: <fa53c5df-61ef-9e35-a3a3-406e5ef59d2e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 12:02:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 6 Dec 2019 23:27:15 +0100

> RTL8125 also requires to enable RX for WoL.
> 
> v2: add missing Fixes tag
> 
> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> This fix won't apply cleanly to 5.4 because RTL_GIGA_MAC_VER_52
> was added for 5.5.

Applied and queued up for -stable.
