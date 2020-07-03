Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEECA2140F8
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 23:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgGCViN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 17:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgGCViM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 17:38:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D636AC061794;
        Fri,  3 Jul 2020 14:38:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 254161553106C;
        Fri,  3 Jul 2020 14:38:12 -0700 (PDT)
Date:   Fri, 03 Jul 2020 14:37:48 -0700 (PDT)
Message-Id: <20200703.143748.1707914643708890824.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: ipa: fix HOLB timer register use
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200703212335.465355-1-elder@linaro.org>
References: <20200703212335.465355-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jul 2020 14:38:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Fri,  3 Jul 2020 16:23:33 -0500

> The function ipa_reg_init_hol_block_timer_val() generates the value
> to write into the HOL_BLOCK_TIMER endpoint configuration register,
> to represent a given timeout value (in microseconds).  It only
> supports a timer value of 0 though, in part because that's
> sufficient, but mainly because there was some confusion about
> how the register is formatted in newer hardware.
> 
> I got clarification about the register format, so this series fixes 
> ipa_reg_init_hol_block_timer_val() to work for any supported delay
> value.
> 
> The delay is based on the IPA core clock, so determining the value
> to write for a given period requires access to the current core
> clock rate.  So the first patch just creates a new function to
> provide that.

Series applied, thank you.
