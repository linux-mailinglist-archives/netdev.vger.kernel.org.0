Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FB958271A
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiG0Mxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiG0Mxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:53:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766FB23142;
        Wed, 27 Jul 2022 05:53:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E36AB82149;
        Wed, 27 Jul 2022 12:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5E5C433D6;
        Wed, 27 Jul 2022 12:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658926417;
        bh=3RCDpDtQR1Vz/cIwomt6p/0yfoytC9LPqFXeIvarhMU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NbEFoU8nnEVQi7h6uQ51HrNGIYIfL6aKGERBViggvZfbxgys6RhUL68IATnbGYJxV
         3jKhxJCtaFxgMzriKUgIARjZMhUSk/pRIUseqogPIy4Nqd2UnsDtOx/du51mgokNCd
         Cb2Q57NUwVeqJCTKf8sGIfqEH3U0xB2Fh675DsiM47TX/GfgiMTNaW9pir4OYZqBSz
         H+LieArSx4DrU7AkN7wGe5mW7UNiTCnRhHh5BhkYZIzZY8EwOQk2NwN0aaTf/Hs1AU
         l50sT3xB+RtzJcUfUQhV/dfDaVjApqjAxieFCQjU8wF73/JeJNklY2Y3pCOplCnwRZ
         bN2+jbNoMtXrQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [-next,v2] wifi: b43legacy: clean up one inconsistent indenting
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220719075637.111716-1-yang.lee@linux.alibaba.com>
References: <20220719075637.111716-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, johannes@sipsolutions.net,
        Larry.Finger@lwfinger.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165892641335.11639.12371328790924183483.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 12:53:35 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> Eliminate the follow smatch warning:
> drivers/net/wireless/broadcom/b43legacy/main.c:2947 b43legacy_wireless_core_stop() warn: inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Patch applied to wireless-next.git, thanks.

7d13c0ae38a6 wifi: b43legacy: clean up one inconsistent indenting

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220719075637.111716-1-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

