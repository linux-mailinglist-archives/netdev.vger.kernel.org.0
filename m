Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA5A5F04D2
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 08:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiI3GcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 02:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiI3GcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 02:32:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C978140F29;
        Thu, 29 Sep 2022 23:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C119FB82750;
        Fri, 30 Sep 2022 06:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319D5C433D6;
        Fri, 30 Sep 2022 06:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664519522;
        bh=T9dC/HN79/DV+nRzTJI8gIGMCmG0JWdym4OCQAzTBEk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=reDRkwVCoNYdIzvsrLWowvtxCgc4rqmladYi3QzhXsRjvU2U2j5dzga9Kf+8BnqFZ
         9SsNdsIDqMLdNRY0hm+ElHdd1lHAZP20oEqT8nnTdvlJBy8fngkAX2/M+aMB2JUda3
         JNIrL98ycwrNZYsjfMPMSGktC8NZ5lma+J3mBeam2KZ47tsXHrJUcGMiEysc/KyDUE
         2LULu9lh+vyhNRodgdNHJ69RhXOZzKeAXpgPQSvfJgx0sMxjGjVQUmtS95tEZCTMp/
         yIqn/oR4/zG6UeS5J1ns0nMzL/mpqZBGoBaBhItnxVKm0TfWFsgC11uSi4lrKNe9hl
         f1H/+3yKoG3GA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] carl9170: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <YzIdWc8QSdZFHBYg@work>
References: <YzIdWc8QSdZFHBYg@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166451949633.6083.142608063936593125.kvalo@kernel.org>
Date:   Fri, 30 Sep 2022 06:31:59 +0000 (UTC)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members in unions.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/215
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

9ec6e20776ab carl9170: Replace zero-length array with DECLARE_FLEX_ARRAY() helper

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YzIdWc8QSdZFHBYg@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

