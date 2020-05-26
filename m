Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363321D6476
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgEPWQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726550AbgEPWQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:16:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B6CC061A0C;
        Sat, 16 May 2020 15:16:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 901B91193CFDE;
        Sat, 16 May 2020 15:16:30 -0700 (PDT)
Date:   Sat, 16 May 2020 15:16:27 -0700 (PDT)
Message-Id: <20200516.151627.580828572368812179.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sharathv@codeaurora.com
Subject: Re: [PATCH net 1/1] net: ipa: don't be a hog in gsi_channel_poll()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515195203.24947-1-elder@linaro.org>
References: <20200515195203.24947-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 15:16:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Fri, 15 May 2020 14:52:03 -0500

> The iteration count value used in gsi_channel_poll() is intended to
> limit poll iterations to the budget supplied as an argument.  But
> it's never updated.
> 
> Fix this bug by incrementing the count each time through the loop.
> 
> Reported-by: Sharath Chandra Vurukala <sharathv@codeaurora.com>
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied, thanks.
