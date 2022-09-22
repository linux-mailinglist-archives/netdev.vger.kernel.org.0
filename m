Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945B25E5C35
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiIVHUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiIVHUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:20:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3317B72879;
        Thu, 22 Sep 2022 00:20:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 157EEB834DB;
        Thu, 22 Sep 2022 07:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B9BC433D6;
        Thu, 22 Sep 2022 07:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663831200;
        bh=zxzYj5mlDqzaq0nOcgSF728ZPS1FFMPmRhm6jfyyUKE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=a6jBUhg3ZKEukMKQPA9mJwCSO31qT3PCwh9+VVvmJsDoqEAcdQ9RrOAwdOZTrgz2A
         UhalyqV+AGsXjCc3AfIIT8vc5TGgqkFh8XY+R00cGitJ+qiXIfLWkBR79kZBPxszFV
         1GFvdyYCn7iewqNoDxNR6sVAWEYqnYuep7yH4x8osPwo5oiQqsv7u35VeozPEHGl1a
         yMievXAvPidX2IN+TuuX9SvOc3I6uYw80BeknqkGnfxPAuE34J/Lws1ddg9yIle+5J
         vt6XpTr6tHnkNBRvUZzdBL0UYliHTvORYGC0F35ZP0is8BFYueayslugHHabsHtBb3
         Q/GJfQUvXnlWQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220915030559.42371-1-yuanjilin@cdjrlc.com>
References: <20220915030559.42371-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     toke@toke.dk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166383119616.28267.3193737136745129397.kvalo@kernel.org>
Date:   Thu, 22 Sep 2022 07:19:58 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'to'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

02be97c7b2de wifi: ath9k: fix repeated to words in a comment

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220915030559.42371-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

