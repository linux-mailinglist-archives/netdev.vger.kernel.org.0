Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8610F1CA034
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgEHBmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgEHBmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:42:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8914C05BD43;
        Thu,  7 May 2020 18:42:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 47096119376EF;
        Thu,  7 May 2020 18:42:19 -0700 (PDT)
Date:   Thu, 07 May 2020 18:42:18 -0700 (PDT)
Message-Id: <20200507.184218.1566941439994191513.davem@davemloft.net>
To:     elder@linaro.org
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: ipa: fix cleanup after modem crash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507191404.31626-1-elder@linaro.org>
References: <20200507191404.31626-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 18:42:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Thu,  7 May 2020 14:14:02 -0500

> The first patch in this series fixes a bug where the size of a data
> transfer request was never set, meaning it was 0.  The consequence
> of this was that such a transfer request would never complete if
> attempted, and led to a hung task timeout.
> 
> This data transfer is required for cleaning up IPA hardware state
> when recovering from a modem crash.  The code to implement this
> cleanup is already present, but its use was commented out because
> it hit the bug described above.  So the second patch in this series
> enables the use of that "tag process" cleanup code.

Series applied, thanks.
