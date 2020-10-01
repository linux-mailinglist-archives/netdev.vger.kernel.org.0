Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12352807D3
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbgJATgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbgJATgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 15:36:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8C9C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 12:36:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E45DD144B9374;
        Thu,  1 Oct 2020 12:19:28 -0700 (PDT)
Date:   Thu, 01 Oct 2020 12:36:15 -0700 (PDT)
Message-Id: <20201001.123615.1591963639987173277.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     kuba@kernel.org, nic_swsd@realtek.com, netdev@vger.kernel.org,
        ptesarik@suse.cz, hdegoede@redhat.com
Subject: Re: [PATCH net] r8169: fix handling ether_clk
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9893d089-9668-258e-d2de-21a93b0486aa@gmail.com>
References: <9893d089-9668-258e-d2de-21a93b0486aa@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 12:19:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 1 Oct 2020 08:44:19 +0200

> Petr reported that system freezes on r8169 driver load on a system
> using ether_clk. The original change was done under the assumption
> that the clock isn't needed for basic operations like chip register
> access. But obviously that was wrong.
> Therefore effectively revert the original change, and in addition
> leave the clock active when suspending and WoL is enabled. Chip may
> not be able to process incoming packets otherwise.
> 
> Fixes: 9f0b54cd1672 ("r8169: move switching optional clock on/off to pll power functions")
> Reported-by: Petr Tesarik <ptesarik@suse.cz>
> Tested-by: Petr Tesarik <ptesarik@suse.cz>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
