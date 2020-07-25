Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C2122D351
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGYAd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgGYAd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:33:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C9FC0619D3;
        Fri, 24 Jul 2020 17:33:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 391CC12763AEF;
        Fri, 24 Jul 2020 17:16:42 -0700 (PDT)
Date:   Fri, 24 Jul 2020 17:33:26 -0700 (PDT)
Message-Id: <20200724.173326.1059196015231014544.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ipa: new notification infrastructure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724181142.13581-2-elder@linaro.org>
References: <20200724181142.13581-1-elder@linaro.org>
        <20200724181142.13581-2-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 17:16:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Fri, 24 Jul 2020 13:11:41 -0500

> Use the new SSR notifier infrastructure to request notifications of
> modem events, rather than the remoteproc IPA notification system.
> The latter was put in place temporarily with the knowledge that the
> new mechanism would become available.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> David:  If you approve, please only ACK; Bjorn will merge.

Acked-by: David S. Miller <davem@davemloft.net>
