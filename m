Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0118C115F05
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 23:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfLGWYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 17:24:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44186 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfLGWYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 17:24:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDB5015436C62;
        Sat,  7 Dec 2019 14:24:50 -0800 (PST)
Date:   Sat, 07 Dec 2019 14:24:47 -0800 (PST)
Message-Id: <20191207.142447.1400658765795779871.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] r8169: fix rtl_hw_jumbo_disable for RTL8168evl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <32cb0ca8-3a90-1b95-b928-af00c603876f@gmail.com>
References: <32cb0ca8-3a90-1b95-b928-af00c603876f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 14:24:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 7 Dec 2019 22:21:52 +0100

> In referenced fix we removed the RTL8168e-specific jumbo config for
> RTL8168evl in rtl_hw_jumbo_enable(). We have to do the same in
> rtl_hw_jumbo_disable().
> 
> v2: fix referenced commit id
> 
> Fixes: 14012c9f3bb9 ("r8169: fix jumbo configuration for RTL8168evl")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.

Again, another fun chain of fixes to fixes:

[davem@localhost net]$ git describe 14012c9f3bb9
v5.4-8858-g14012c9f3bb9
[davem@localhost net]$ git show 14012c9f3bb9 | grep Fixes
    Fixes: 4ebcb113edcc ("r8169: fix jumbo packet handling on resume from suspend")
[davem@localhost net]$ gdc 4ebcb113edcc
v5.4-rc4~6^2~55
[davem@localhost net]$ git show 4ebcb113edcc | grep Fixes
    Fixes: 7366016d2d4c ("r8169: read common register for PCI commit")
[davem@localhost net]$ gdc 7366016d2d4c
v5.4-rc1~131^2~119^2~4
