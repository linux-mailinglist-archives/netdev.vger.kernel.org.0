Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805E02316A6
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbgG2AMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730284AbgG2AMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:12:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6C4C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:12:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C9E1128CF78B;
        Tue, 28 Jul 2020 16:55:29 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:12:13 -0700 (PDT)
Message-Id: <20200728.171213.1437000169108879721.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        ogerlitz@mellanox.com, yishaih@mellanox.com, saeedm@mellanox.com,
        lawja@fb.com
Subject: Re: [PATCH net] mlx4: disable device on shutdown
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724231543.3295117-1-kuba@kernel.org>
References: <20200724231543.3295117-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 16:55:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 24 Jul 2020 16:15:43 -0700

> It appears that not disabling a PCI device on .shutdown may lead to
> a Hardware Error with particular (perhaps buggy) BIOS versions:
 ...
> Fix the mlx4 driver.
> 
> This is a very similar problem to what had been fixed in:
> commit 0d98ba8d70b0 ("scsi: hpsa: disable device during shutdown")
> to address https://bugzilla.kernel.org/show_bug.cgi?id=199779.
> 
> Fixes: 2ba5fbd62b25 ("net/mlx4_core: Handle AER flow properly")
> Reported-by: Jake Lawrence <lawja@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied and queued up for -stable, thanks.
