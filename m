Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1369556E64
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfFZQK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:10:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37236 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZQK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:10:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79C12144FF0E7;
        Wed, 26 Jun 2019 09:10:56 -0700 (PDT)
Date:   Wed, 26 Jun 2019 09:10:55 -0700 (PDT)
Message-Id: <20190626.091055.2250153974662071717.davem@davemloft.net>
To:     jonathanh@nvidia.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] net: stmmac: Fix possible deadlock when disabling
 EEE support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190626102322.18821-1-jonathanh@nvidia.com>
References: <20190626102322.18821-1-jonathanh@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 09:10:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>
Date: Wed, 26 Jun 2019 11:23:21 +0100

> When stmmac_eee_init() is called to disable EEE support, then the timer
> for EEE support is stopped and we return from the function. Prior to
> stopping the timer, a mutex was acquired but in this case it is never
> released and so could cause a deadlock. Fix this by releasing the mutex
> prior to returning from stmmax_eee_init() when stopping the EEE timer.
> 
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>

When targetting net-next for a set of changes, make this explicit and clear
by saying "[PATCH net-next ...] ..." in your Subject lines in the future.

Applied.
