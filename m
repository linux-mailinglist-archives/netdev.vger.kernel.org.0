Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2563577F45
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiGRKEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiGRKEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:04:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB73C4E;
        Mon, 18 Jul 2022 03:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE91DB81076;
        Mon, 18 Jul 2022 10:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A181DC341C0;
        Mon, 18 Jul 2022 10:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658138680;
        bh=UF0xmeKmRUD99IsyzGRyFIoX3dT3xoiqrVLR10WnrN8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EXxRv2954oAilgvfwXx32qY1aqyI4Xc6unSLXq1fo2B2xZZS1zmwrqcKMprsNm6Ij
         xdSNnNiV58t3Uat/WFjfCI4hJih4VbHYwfNrBD3y/a4gYdRHwQMJNRnKXVWHowUFrJ
         FXwLJjSp7eH1cMtoEhdF1OlZ3r9dGsVrsk5/pFkg0bef/q5WzBWz7uAIlceiKSr+en
         CkkvrorB1PaQcGk++et2kzogHwUSXXjGVcHYFZzdiNyGAlqjWLdOXyEzHvJ8kewL+o
         mTVO+s4jFxUb5M1g659pL6wzFrWQri9Nb3P0L18bZ8KGTlITjT4lriLrOv39FVdKMJ
         lVS3GvrNlYe0A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath6kl:: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709123208.41736-1-yuanjilin@cdjrlc.com>
References: <20220709123208.41736-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165813867695.12812.13735515913021404756.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 10:04:38 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant words 'the' and 'of'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

6456741f6427 wifi: ath6kl: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709123208.41736-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

