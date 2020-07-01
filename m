Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240FE21160F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgGAWas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAWas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:30:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754A3C08C5C1;
        Wed,  1 Jul 2020 15:30:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0886114959EAB;
        Wed,  1 Jul 2020 15:30:47 -0700 (PDT)
Date:   Wed, 01 Jul 2020 15:30:47 -0700 (PDT)
Message-Id: <20200701.153047.1752708672711318364.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] net: ipa: endpoint configuration
 updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630133304.1331058-1-elder@linaro.org>
References: <20200630133304.1331058-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 15:30:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Tue, 30 Jun 2020 08:32:59 -0500

> This series updates code that configures IPA endpoints.  The changes
> made mainly affect access to registers that are valid only for RX, or
> only for TX endpoints.
> 
> The first three patches avoid writing endpoint registers if they are
> not defined to be valid.  The fourth patch slightly modifies the
> parameters for the offset macros used for these endpoint registers,
> to make it explicit when only some endpoints are valid.
> 
> The last patch just tweaks one line of code so it uses a convention
> used everywhere else in the driver.
> 
> Version 2 of this series eliminates some of the "assert()" comments
> that Jakub inquired about.  The ones removed will actually go away
> in an upcoming (not-yet-posted) patch series anyway.

Series applied, thanks.
