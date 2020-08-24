Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B97124FEA0
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgHXNRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHXNQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 09:16:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62C0C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 06:16:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EA9B1281F8E8;
        Mon, 24 Aug 2020 06:00:12 -0700 (PDT)
Date:   Mon, 24 Aug 2020 06:16:57 -0700 (PDT)
Message-Id: <20200824.061657.2168445189551301124.davem@davemloft.net>
To:     sundeep.lkml@gmail.com
Cc:     kuba@kernel.org, richardcochran@gmail.com, netdev@vger.kernel.org,
        sgoutham@marvell.com, sbhatta@marvell.com
Subject: Re: [PATCH v7 net-next 0/3] Add PTP support for Octeontx2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1598255717-32316-1-git-send-email-sundeep.lkml@gmail.com>
References: <1598255717-32316-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 06:00:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sundeep.lkml@gmail.com
Date: Mon, 24 Aug 2020 13:25:14 +0530

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

Series applied, thank you.
