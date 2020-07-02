Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3460C212EE2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgGBVbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBVbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:31:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA290C08C5C1;
        Thu,  2 Jul 2020 14:31:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3121128449E2;
        Thu,  2 Jul 2020 14:31:40 -0700 (PDT)
Date:   Thu, 02 Jul 2020 14:31:40 -0700 (PDT)
Message-Id: <20200702.143140.326877658223712499.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net: ipa: simplify endpoint programming
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702112537.347994-1-elder@linaro.org>
References: <20200702112537.347994-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jul 2020 14:31:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Thu,  2 Jul 2020 06:25:33 -0500

> Add tests to functions so they don't update undefined endpoint
> registers, rather than requiring the caller to avoid calling them.
> 
> Move the call to a workaround function required when suspending
> inside the function that puts an endpoint into suspend mode.  This
> requires moving a few functions (which are otherwise unchanged).
> 
> Then simplify ipa_endpoint_program() to call essentially all
> endpoint register update functions unconditionally.

Series applied, thank you.
