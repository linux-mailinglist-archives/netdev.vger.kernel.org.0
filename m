Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7715FABAE
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 06:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJKEjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 00:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJKEjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 00:39:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F9486836;
        Mon, 10 Oct 2022 21:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AFACB810CC;
        Tue, 11 Oct 2022 04:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE2FC433C1;
        Tue, 11 Oct 2022 04:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665463160;
        bh=MF6sPs/ojJLHcDz9LKEHAOwV2EjPI7ajblySZvBQSqU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=BTkKEh7vCIHIcwrEIVzEVCoMhuXc2ZpptturYvLqVbyaGMbclL4k0ZTYhSU/1R8/j
         /uCu8FGkIHV3UXam8bvCXwmV8XmWzW+4rym65HzTRj/dzP4UzgWYxKA7FeuA6519wP
         4/L3V4W9do+d/QDfVitKESL1f/R3/idivYmiu4sLOgnogZcISk9STYYd2S3H1JG00X
         JWl5hgwEfTqirtwLxw1u0v5O5QvhkOlMZJ66uA1MOjClagDwY2z5ktx6j/P+7fbOUd
         YpzxpTxha7uU/7dvDLV8LSsDF8kP1uDtGMr1/gbYPJCf/RBcfxM+WqATBuYDSbTl/S
         dLWfCB56iTUwQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: Remove -Warray-bounds exception
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221006192054.1742982-1-keescook@chromium.org>
References: <20221006192054.1742982-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166546315646.5539.15810810835446858969.kvalo@kernel.org>
Date:   Tue, 11 Oct 2022 04:39:18 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> GCC-12 emits false positive -Warray-bounds warnings with
> CONFIG_UBSAN_SHIFT (-fsanitize=shift). This is fixed in GCC 13[1],
> and there is top-level Makefile logic to remove -Warray-bounds for
> known-bad GCC versions staring with commit f0be87c42cbd ("gcc-12: disable
> '-Warray-bounds' universally for now").
> 
> Remove the local work-around.
> 
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105679
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

d174768932a8 wifi: ath9k: Remove -Warray-bounds exception

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221006192054.1742982-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

