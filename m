Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E791EEDFA
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgFDWwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgFDWwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:52:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC00C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 15:52:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC7F4120477C4;
        Thu,  4 Jun 2020 15:52:41 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:52:41 -0700 (PDT)
Message-Id: <20200604.155241.2183763810929782758.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     kuba@kernel.org, nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] r8169: fix failing WoL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a5dc6fc0-6fa5-662d-22f9-50440b116df9@gmail.com>
References: <a5dc6fc0-6fa5-662d-22f9-50440b116df9@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:52:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 3 Jun 2020 22:29:06 +0200

> Th referenced change added an extra hw reset to rtl8169_net_suspend()
> what makes WoL fail on few chip versions. Therefore skip the extra
> reset if we're going down and WoL is enabled.
> In rtl_shutdown() rtl8169_hw_reset() is called by rtl8169_net_suspend()
> already if needed, therefore avoid issues issue by removing the extra
> call. The fix was tested on a system with RTL8168g.
> 
> Meanwhile rtl8169_hw_reset() does more than a hw reset and should be
> renamed. But that's net-next material.
> 
> Fixes: 8ac8e8c64b53 ("r8169: make rtl8169_down central chip quiesce function")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
