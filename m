Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594466C805E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjCXOxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjCXOxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:53:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477E02728;
        Fri, 24 Mar 2023 07:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3406B82498;
        Fri, 24 Mar 2023 14:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4DBC433EF;
        Fri, 24 Mar 2023 14:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679669590;
        bh=9Bzy8ntyyYlzsjNmc78UfhexZSZPRHrJSAQutSdB5D8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=tfkXgJpaG5VCC/Jf8RDQRSZg7Yiq04dsHBrN4FVubuiMfby8e3MORukt5N28Az1Zv
         U//O96cq547CPg5LppNQFcUfxoHtYfPHQu7aVbpqykYd2m1d1z5p1HGwT52A2jUNOi
         4ULJB8zU645n7Nu/bGuq1gU4SXG/LJfFYzyJAdJzlKKYODinyhX1PBRPwKNSR+WaxT
         YtbtKAFHJuejoWh+3rXDv9brQU1lxbf0yKkeV9sW+huOawP3IbAL72hlznajQoIBJ4
         SKYeD6hcgaBELO62PLdrRqJaGSDkA7Cr37oRkWrIw2t/mnvh0keGm5QIk9hmu6aArS
         mhiho7aAPGkkA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: remove unused ath10k_get_ring_byte function
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230322122855.2570417-1-trix@redhat.com>
References: <20230322122855.2570417-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167966958590.27260.15660698872917271448.kvalo@kernel.org>
Date:   Fri, 24 Mar 2023 14:53:07 +0000 (UTC)
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:

> clang with W=1 reports:
> 
> drivers/net/wireless/ath/ath10k/ce.c:88:1: error:
>   unused function 'ath10k_get_ring_byte' [-Werror,-Wunused-function]
> ath10k_get_ring_byte(unsigned int offset,
> ^
> This function is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

9fc093b756f6 wifi: ath10k: remove unused ath10k_get_ring_byte function

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230322122855.2570417-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

