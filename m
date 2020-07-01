Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C0D210165
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 03:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgGABSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 21:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGABST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 21:18:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246F5C061755;
        Tue, 30 Jun 2020 18:18:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AAD2D1280A788;
        Tue, 30 Jun 2020 18:18:18 -0700 (PDT)
Date:   Tue, 30 Jun 2020 18:18:18 -0700 (PDT)
Message-Id: <20200630.181818.960616348417321292.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     kuba@kernel.org, vaibhavgupta40@gmail.com, pcnet32@frontier.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] pcnet32: Mark PM functions as
 __maybe_unused
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630210034.3624587-2-natechancellor@gmail.com>
References: <20200630210034.3624587-1-natechancellor@gmail.com>
        <20200630210034.3624587-2-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 18:18:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Tue, 30 Jun 2020 14:00:34 -0700

> In certain configurations without power management support, the
> following warnings happen:
> 
> ../drivers/net/ethernet/amd/pcnet32.c:2928:12: warning:
> 'pcnet32_pm_resume' defined but not used [-Wunused-function]
>  2928 | static int pcnet32_pm_resume(struct device *device_d)
>       |            ^~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/amd/pcnet32.c:2916:12: warning:
> 'pcnet32_pm_suspend' defined but not used [-Wunused-function]
>  2916 | static int pcnet32_pm_suspend(struct device *device_d)
>       |            ^~~~~~~~~~~~~~~~~~
> 
> Mark these functions as __maybe_unused to make it clear to the compiler
> that this is going to happen based on the configuration, which is the
> standard for these types of functions.
> 
> Fixes: a86688fbef1b ("pcnet32: Convert to generic power management")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied.
