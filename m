Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1ED95ED6B4
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbiI1HtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbiI1HtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:49:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5091B0519;
        Wed, 28 Sep 2022 00:45:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C2F61D40;
        Wed, 28 Sep 2022 07:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E87C433C1;
        Wed, 28 Sep 2022 07:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664351146;
        bh=pJgBh3O1N8VrHVzs3TOgoSqQkabPRSZAlQTSu/F1cZc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WiJCFnEZ/DxQefElj+fuIlrxtSaXDBQU/1PgoseqLeLuyRk7oY9a2qOCiuNc/bdcb
         HKGNPNqVv07luWJhZDgkJgaQcwfr7d7NfgVqj4Fy3C2zJdkZ+TD6eX15b+sroPtATG
         DU6uR/TIcRolyBP3O5Ih7cfH3lHW32I5U6tLqmTaf0O36UdUumvRzHKWfBIctkgW0f
         8fuQsZEHwqnikly+Ra7U2RPMtao/INkdn7nSBVR+YgLgXHPzzMEzU5RgsifhD4sPVf
         WM+J7/ccf8FPz0OGi5wlTOZcKajifhAMRHwmAo9TugQPMWQTqv7IPcZ0Y19x/4NfiJ
         6q5ZaDySoLdKQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath10k: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <YzIcoloIQBDqGlgc@work>
References: <YzIcoloIQBDqGlgc@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166435114224.3623.6648213708704694100.kvalo@kernel.org>
Date:   Wed, 28 Sep 2022 07:45:43 +0000 (UTC)
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
> Link: https://github.com/KSPP/linux/issues/212
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

00d942e779c2 wifi: ath10k: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YzIcoloIQBDqGlgc@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

