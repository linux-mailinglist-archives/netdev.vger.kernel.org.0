Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74751C7EA0
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgEGAmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgEGAmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:42:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F6FC061A0F;
        Wed,  6 May 2020 17:42:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53E8D127806C0;
        Wed,  6 May 2020 17:42:02 -0700 (PDT)
Date:   Wed, 06 May 2020 17:42:01 -0700 (PDT)
Message-Id: <20200506.174201.1083889819367294107.davem@davemloft.net>
To:     elder@linaro.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: ipa: kill endpoint stop workaround
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504235345.17118-1-elder@linaro.org>
References: <20200504235345.17118-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:42:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Mon,  4 May 2020 18:53:40 -0500

> It turns out that a workaround that performs a small DMA operation
> between retried attempts to stop a GSI channel is not needed for any
> supported hardware.  The hardware quirk that required the extra DMA
> operation was fixed after IPA v3.1.  So this series gets rid of that
> workaround code, along with some other code that was only present to
> support it.
> 
> NOTE:  This series depends on (and includes/duplicates) another patch
>        that has already been committed in the net tree:
>          713b6ebb4c37 net: ipa: fix a bug in ipa_endpoint_stop()

Series applied.
