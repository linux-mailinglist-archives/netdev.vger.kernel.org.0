Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBE75305B6
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 22:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241232AbiEVUA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 16:00:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51468 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237078AbiEVUA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 16:00:56 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id ED680841F18A;
        Sun, 22 May 2022 13:00:52 -0700 (PDT)
Date:   Sun, 22 May 2022 21:00:42 +0100 (BST)
Message-Id: <20220522.210042.1263046454071210446.davem@davemloft.net>
To:     elder@linaro.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: ipa: fix page free in two spots
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20220522005959.1175181-1-elder@linaro.org>
References: <20220522005959.1175181-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 22 May 2022 13:00:56 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Sat, 21 May 2022 19:59:57 -0500

> When a receive buffer is not wrapped in an SKB and passed to the
> network stack, the (compound) page gets freed within the IPA driver.
> This is currently quite rare.
> 
> The pages are freed using __free_pages(), but they should instead be
> freed using page_put().  This series fixes this, in two spots.
> 
> These patches work for Linux v5.18-rc7 and v5.17.y, but won't apply
> cleanly to earlier stable branches.  (Nevertheless, the fix is
> trivial.)

This does not apply to the current net tree, please respin.

Thank you.
