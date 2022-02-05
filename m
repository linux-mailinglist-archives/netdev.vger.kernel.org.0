Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465F64AA66D
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379299AbiBEEXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiBEEXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:23:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F03BC061346;
        Fri,  4 Feb 2022 20:23:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A291B60C09;
        Sat,  5 Feb 2022 04:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5F1C340E8;
        Sat,  5 Feb 2022 04:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644035018;
        bh=Km4Gf2o96xkrOTnzGLNM3TPm20MY3a75gjtczbbLqlA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U+lYCxLzGNllz10pLju7aE3TQ8Xq2fkvReNEIrLGG5xC16999lXowFW3kVlq3mPwT
         snQojXnzbhCxx43NSpXFeSlramgC1IoENbTzsZ+qxbudjBgoBvU/rJiS+izl4OQgwS
         PL7eDIMZbNYpoZE+dkW2eajWUk5eAKQdSp+WgUzOSdysfEVk4iSVDDYnT7iGy9FqkA
         64LoAZ110Mm3Da10FKyKAkbl7BjTlaFBOA/szd7GILgUANLDnNVvv4k773kMET5qWJ
         F6irxMM15TkZ/o+V+mUnY6CSiZLCktJ6b58YX3Hvp7rLkms2Ber0ehPJicy34/1mNS
         v9EkBJgOzyM5w==
Date:   Fri, 4 Feb 2022 20:23:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, djakov@kernel.org, bjorn.andersson@linaro.org,
        mka@chromium.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] net: ipa: use interconnect bulk
 enable/disable operations
Message-ID: <20220204202336.67c95e15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204195044.1082026-4-elder@linaro.org>
References: <20220204195044.1082026-1-elder@linaro.org>
        <20220204195044.1082026-4-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Feb 2022 13:50:40 -0600 Alex Elder wrote:
> The power interconnect array is now an array of icc_bulk_data
> structures, which is what the interconnect bulk enable and disable
> functions require.
> 
> Get rid of ipa_interconnect_enable() and ipa_interconnect_disable(),
> and just call icc_bulk_enable() and icc_bulk_disable() instead.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

We got a kbuild bot complaint here, for some reason off-list.
Let me drop it from PW for now.
