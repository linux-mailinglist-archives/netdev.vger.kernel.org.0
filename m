Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A8A270982
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 02:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgISArY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 20:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgISArY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 20:47:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B08CC0613CE;
        Fri, 18 Sep 2020 17:47:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2388015B390E9;
        Fri, 18 Sep 2020 17:30:36 -0700 (PDT)
Date:   Fri, 18 Sep 2020 17:47:22 -0700 (PDT)
Message-Id: <20200918.174722.265410769241773832.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/7] net: ipa: wake up system on RX
 available
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917173926.24266-1-elder@linaro.org>
References: <20200917173926.24266-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 17:30:36 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Thu, 17 Sep 2020 12:39:19 -0500

> This series arranges for the IPA driver to wake up a suspended
> system if the IPA hardware has a packet to deliver to the AP.
> 
> Version 2 replaced the first patch from version 1 with three
> patches, in response to David Miller's feedback.  And based on
> Bjorn Andersson's feedback on version 2, this version reworks
> the tracking of IPA clock references.  As a result, we no
> longer need a flag to determine whether a "don't' suspend" clock
> reference is held (though an bit in a bitmask is still used for
> a different purpose).
 ...

Series applied, thanks.
