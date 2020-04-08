Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B531A196E
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgDHBKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:10:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgDHBKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:10:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A677D1210A3E3;
        Tue,  7 Apr 2020 18:10:35 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:10:35 -0700 (PDT)
Message-Id: <20200407.181035.2185782266176950814.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH 5.4 net] net: phy: realtek: fix handling of
 RTL8105e-integrated PHY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <71c9463f-9f4c-b3da-91c6-a216a819208d@gmail.com>
References: <71c9463f-9f4c-b3da-91c6-a216a819208d@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:10:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 8 Apr 2020 00:01:42 +0200

> After the referenced fix it turned out that one particular RTL8168
> chip version (RTL8105e) does not work on 5.4 because no dedicated PHY
> driver exists. Adding this PHY driver was done for fixing a different
> issue for versions from 5.5 already. I re-send the same change for 5.4
> because the commit message differs.
> 
> Fixes: 2e8c339b4946 ("r8169: fix PHY driver check on platforms w/o module softdeps")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> Please apply on 5.4 only.

I'll queue this up, thanks.
