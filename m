Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231C16D22F6
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbjCaOun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbjCaOui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:50:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BB61EA18;
        Fri, 31 Mar 2023 07:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A27CAB83013;
        Fri, 31 Mar 2023 14:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E674C433D2;
        Fri, 31 Mar 2023 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680274221;
        bh=ctYNEcc9jCIfUQuOIrh2jlob6lV+dmKLxnBbL3nSjYg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SHW5AP/vlx371qVOYk22Frb70ZD9Wj1Gno8y45bOgYCzo0Cv2pFObv+o8O0Bu4XfP
         C39wOuqpxEKUznIGzVraQwB+oYhliF3FZIxsRfT1UviYEm3qLmcqL6vafdb/wN4IK8
         dlqQjSJYZOTo1/HZWjgeRV31oaXtvvBGUxvkBskdUF6cRJp9kvkbQE8qCbqlbRAjNP
         1hfRGUOAZk3qsJXXLQqJ7QG9EmnrEMEf9WV0Y4xOtFmUy4G7yM8LI7IW4+RRNs/9tJ
         CUaKHDqB2gmuO6i8iceVOsTfSyWDnGxq9NrGGaX1kyXWckAktrSQFIv6P9tLlTRzPE
         qlKTZJurnvOAQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: b43legacy: remove unused freq_r3A_value function
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230324135022.2649735-1-trix@redhat.com>
References: <20230324135022.2649735-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     Larry.Finger@lwfinger.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168027421679.32751.109948738378187350.kvalo@kernel.org>
Date:   Fri, 31 Mar 2023 14:50:18 +0000 (UTC)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:

> clang with W=1 reports
> drivers/net/wireless/broadcom/b43legacy/radio.c:1713:5: error:
>   unused function 'freq_r3A_value' [-Werror,-Wunused-function]
> u16 freq_r3A_value(u16 frequency)
>     ^
> This function is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-next.git, thanks.

4c7f8c237d32 wifi: b43legacy: remove unused freq_r3A_value function

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230324135022.2649735-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

