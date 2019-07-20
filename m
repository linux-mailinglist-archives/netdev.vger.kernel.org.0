Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7326F070
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 21:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfGTTSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 15:18:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51286 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfGTTSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 15:18:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35F0D153B099C;
        Sat, 20 Jul 2019 12:18:13 -0700 (PDT)
Date:   Sat, 20 Jul 2019 12:18:09 -0700 (PDT)
Message-Id: <20190720.121809.108455857425792197.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org, tv@lio96.de
Subject: Re: [PATCH net] r8169: fix RTL8168g PHY init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <eeb20312-1418-24c3-6482-09c051075b9e@gmail.com>
References: <eeb20312-1418-24c3-6482-09c051075b9e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jul 2019 12:18:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 20 Jul 2019 19:01:22 +0200

> From: Thomas Voegtle <tv@lio96.de>
> This fixes a copy&paste error in the original patch. Setting the wrong
> register resulted in massive packet loss on some systems.
> 
> Fixes: a2928d28643e ("r8169: use paged versions of phylib MDIO access functions")
> Tested-by: Thomas Voegtle <tv@lio96.de>
> Signed-off-by: Thomas Voegtle <tv@lio96.de>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
