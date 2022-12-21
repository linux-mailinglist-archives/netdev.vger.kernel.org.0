Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9B36536A9
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbiLUSwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiLUSw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:52:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F28D4;
        Wed, 21 Dec 2022 10:52:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AD3CB81C02;
        Wed, 21 Dec 2022 18:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3730C433EF;
        Wed, 21 Dec 2022 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671648745;
        bh=294I+nc1Z178iGlV8q6cr6b/T9AZgrivgxACLPTLhsE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=acMuHG+mj1CIE0qfvAYuyyOJJ/sef3xzophyp4Ot1fvuM6MQAE0m7jPfYE28YA5f0
         kn/QWX1gCkZ7KIZPt3+BNSyW8wk8/u87nLDTQ0F4sZteH+JPiSEUZAR2LeVTYRETcw
         5RPvJTe/bgWo9/DIT/suwyfO+M4mVo2sgxMsT7htwH7eYAwzkPqn/9fjQ+g9PXJgC/
         ry4frdr3D3vZslCz8Zv8eW5CxxI1XZDHmdjxNjq0lQjneQAKLGWdV+fnimPtOLk8Kz
         vVzzx/CAN/1Uc61GpTwTbzk0Yb0Cdlk4suygNOauLCJXjGQoR+a2e8DjqUZkhWV49i
         g1HL0B2t4ctHQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
References: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
To:     Jun ASAKA <JunASAKA@zzy040330.moe>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jun ASAKA <JunASAKA@zzy040330.moe>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167164874162.5196.4709849135082513449.kvalo@kernel.org>
Date:   Wed, 21 Dec 2022 18:52:23 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jun ASAKA <JunASAKA@zzy040330.moe> wrote:

> Fixing transmission failure which results in
> "authentication with ... timed out". This can be
> fixed by disable the REG_TXPAUSE.
> 
> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

c6015bf3ff1f wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221217030659.12577-1-JunASAKA@zzy040330.moe/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

