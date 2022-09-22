Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526D35E5C3C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiIVHUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiIVHU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:20:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2999E885;
        Thu, 22 Sep 2022 00:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F190FB8121A;
        Thu, 22 Sep 2022 07:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556D2C433C1;
        Thu, 22 Sep 2022 07:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663831222;
        bh=u9Bp3bqGdZlLLuGXD1du6yfpdjQYW5Nnh9/fnq4kOfs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GBTJaboA6BIW0AudBq1+bnH98My8yQmetP8JvFp/Suh0CiCpbTUpmbKyvTJKpmJ+I
         80dtBiclx73xEKxuOlk6GGPyy5w8u/4SNgLjol12PuyQKkbAgGd9/bPMG/FCAyRhYn
         gDpff5OmpJMuQ+4xCN7jI0J/RiuR+4FLwtp6i0zuuGOPkECM+S5s7FbQc9i01aiw6i
         Ss7h/wAeMBEV8Vi84pzeUls3DrzL4eHRcYLznPyEpr0lM1sWvCz+xrKPFh4S//k5t4
         c4JiOagQ4wlCC13uRMSDNPkJIfUmA2DVRoZ+o1JE7YN0FcHpFWjGBhL/A1mwtw+9RV
         rbd6MBPn2XLfA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220915030859.45384-1-yuanjilin@cdjrlc.com>
References: <20220915030859.45384-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     toke@toke.dk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166383121843.28267.6007123847146495303.kvalo@kernel.org>
Date:   Thu, 22 Sep 2022 07:20:20 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'the'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

1035deb32391 wifi: ath9k: fix repeated the words in a comment

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220915030859.45384-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

