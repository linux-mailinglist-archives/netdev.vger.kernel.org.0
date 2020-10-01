Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8B12807DA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732864AbgJATi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729993AbgJATi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 15:38:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6441C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 12:38:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC6B71443FFAB;
        Thu,  1 Oct 2020 12:21:38 -0700 (PDT)
Date:   Thu, 01 Oct 2020 12:38:25 -0700 (PDT)
Message-Id: <20201001.123825.1055916571334326788.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     kuba@kernel.org, nic_swsd@realtek.com, netdev@vger.kernel.org,
        ptesarik@suse.cz
Subject: Re: [PATCH net] r8169: fix data corruption issue on RTL8402
From:   David Miller <davem@davemloft.net>
In-Reply-To: <41cca6ed-088c-da5d-94bd-4269b2071a9c@gmail.com>
References: <41cca6ed-088c-da5d-94bd-4269b2071a9c@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 12:21:38 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 1 Oct 2020 09:23:02 +0200

> Petr reported that after resume from suspend RTL8402 partially
> truncates incoming packets, and re-initializing register RxConfig
> before the actual chip re-initialization sequence is needed to avoid
> the issue.
> 
> Reported-by: Petr Tesarik <ptesarik@suse.cz>
> Proposed-by: Petr Tesarik <ptesarik@suse.cz>
> Tested-by: Petr Tesarik <ptesarik@suse.cz>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> Hard to provide a Fixes tag because it seems the issue has been
> always there. Due to frequent changes in function rtl8169_resume()
> we would need a number of different fixes for the stable kernel
> versions. That the issue was reported only now indicates that chip
> version RTL8402 is rare. Therefore treat this change mainly as an
> improvement. This fix version applies from 5.9 after just submitted
> fix "r8169: fix handling ether_clk".

Applied and queued up for -stable.

In the future you can use a Fixes: tag using the root commit of the
entire Linux git tree in situations like this.

Thanks.
