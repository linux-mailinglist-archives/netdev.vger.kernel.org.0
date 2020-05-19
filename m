Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CEB1D8C87
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgESAqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgESAqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:46:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B44C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:46:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01ACC12736953;
        Mon, 18 May 2020 17:46:47 -0700 (PDT)
Date:   Mon, 18 May 2020 17:46:47 -0700 (PDT)
Message-Id: <20200518.174647.36183883217230643.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] r8169: work around an irq coalescing
 related tx timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a979ac70-de91-aa66-f401-e61d31d04183@gmail.com>
References: <a979ac70-de91-aa66-f401-e61d31d04183@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 May 2020 17:46:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 18 May 2020 22:47:16 +0200

> In [0] a user reported reproducible tx timeouts on RTL8168f except
> PktCntrDisable is set and irq coalescing is enabled.
> Realtek told me that they are not aware of any related hw issue on
> this chip version, therefore root cause is still unknown. It's not
> clear whether the issue affects one or more chip versions in general,
> or whether issue is specific to reporter's system.
> Due to this level of uncertainty, and due to the fact that I'm aware
> of this one report only, let's apply the workaround on net-next only.
> After this change setting irq coalescing via ethtool can reliably
> avoid the issue on the affected system.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=207205
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> - remove orphaned Reported-by from commit message

Applied.
