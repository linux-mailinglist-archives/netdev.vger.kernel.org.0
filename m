Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3694E250E1A
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 03:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgHYBQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 21:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgHYBQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 21:16:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19345C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 18:16:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D1FD12957793;
        Mon, 24 Aug 2020 17:59:37 -0700 (PDT)
Date:   Mon, 24 Aug 2020 18:16:22 -0700 (PDT)
Message-Id: <20200824.181622.1928061108742352026.davem@davemloft.net>
To:     sundeep.lkml@gmail.com
Cc:     kuba@kernel.org, richardcochran@gmail.com, netdev@vger.kernel.org,
        sgoutham@marvell.com
Subject: Re: [PATCH v8 net-next 0/3] Add PTP support for Octeontx2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1598284202-19917-1-git-send-email-sundeep.lkml@gmail.com>
References: <1598284202-19917-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:59:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sundeep.lkml@gmail.com
Date: Mon, 24 Aug 2020 21:19:59 +0530

> This patchset adds PTP support for Octeontx2 platform.
> PTP is an independent coprocessor block from which
> CGX block fetches timestamp and prepends it to the
> packet before sending to NIX block. Patches are as
> follows:
> 
> Patch 1: Patch to enable/disable packet timstamping
>          in CGX upon mailbox request. It also adjusts
>          packet parser (NPC) for the 8 bytes timestamp
>          appearing before the packet.
> 
> Patch 2: Patch adding PTP pci driver which configures
>          the PTP block and hooks up to RVU AF driver.
>          It also exposes a mailbox call to adjust PTP
>          hardware clock.
> 
> Patch 3: Patch adding PTP clock driver for PF netdev.
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
 ...

Series applied.
