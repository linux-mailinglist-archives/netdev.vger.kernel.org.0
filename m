Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40A01C7E9A
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEGAi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgEGAi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:38:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C14FC061A0F;
        Wed,  6 May 2020 17:38:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 859191277F50C;
        Wed,  6 May 2020 17:38:26 -0700 (PDT)
Date:   Wed, 06 May 2020 17:38:25 -0700 (PDT)
Message-Id: <20200506.173825.19795483770440259.davem@davemloft.net>
To:     elder@linaro.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: ipa: kill endpoint delay mode
 workaround
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504233713.16954-1-elder@linaro.org>
References: <20200504233713.16954-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:38:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Mon,  4 May 2020 18:37:10 -0500

> A "delay mode" feature was put in place to work around a problem
> where packets could passed to the modem before it was ready to
> handle them.  That problem no longer exists, and we don't need the
> workaround any more so get rid of it.

Series applied.
