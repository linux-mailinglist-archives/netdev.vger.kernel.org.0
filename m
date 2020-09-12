Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B96C2676CB
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgILA3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgILA3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:29:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7290EC061757;
        Fri, 11 Sep 2020 17:29:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D56531216DC6C;
        Fri, 11 Sep 2020 17:12:46 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:29:32 -0700 (PDT)
Message-Id: <20200911.172932.404393416760806051.davem@davemloft.net>
To:     vadym.kochan@plvision.eu
Cc:     elder@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ipa: fix u32_replace_bits by u32p_xxx version
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910154152.24499-1-vadym.kochan@plvision.eu>
References: <20200910154152.24499-1-vadym.kochan@plvision.eu>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:12:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>
Date: Thu, 10 Sep 2020 18:41:52 +0300

> Looks like u32p_replace_bits() should be used instead of
> u32_replace_bits() which does not modifies the value but returns the
> modified version.
> 
> Fixes: 2b9feef2b6c2 ("soc: qcom: ipa: filter and routing tables")
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> Reviewed-by: Alex Elder <elder@linaro.org>

Applied and queued up for -stable, thank you.
