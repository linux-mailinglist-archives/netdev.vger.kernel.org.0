Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962AA1C7E97
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgEGAgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgEGAgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:36:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69893C061A0F;
        Wed,  6 May 2020 17:36:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0BFB1277CEC7;
        Wed,  6 May 2020 17:36:18 -0700 (PDT)
Date:   Wed, 06 May 2020 17:36:17 -0700 (PDT)
Message-Id: <20200506.173617.567778477472167051.davem@davemloft.net>
To:     elder@linaro.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: ipa: limit special reset handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504233003.16670-1-elder@linaro.org>
References: <20200504233003.16670-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:36:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Mon,  4 May 2020 18:30:01 -0500

> Some special handling done during channel reset should only be done
> for IPA hardare version 3.5.1.  This series generalizes the meaning
> of a flag passed to indicate special behavior, then has the special
> handling be used only when appropriate.

Series applied.
