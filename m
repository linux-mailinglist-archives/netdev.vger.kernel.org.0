Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834D34F5BC9
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344370AbiDFK6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 06:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351229AbiDFK5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 06:57:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0380635C05F;
        Wed,  6 Apr 2022 00:19:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 930C661B07;
        Wed,  6 Apr 2022 07:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A23C385A3;
        Wed,  6 Apr 2022 07:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649229561;
        bh=Cz6TDzs+jZOWZjAc5HjVcIh2AZntniGosREgoBaLQnc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=BCuqDE3dUreTJ570sFvl187t+R8w+yJTzRMfxnfED3xUvlqgWcERMWuolZJxJJwjv
         7RKQIiy6oPlQXky50+7ipd6Q3B4DPt/y+7HqZl0oj1ZSZG2IpgN2TNla4YnOlEWoyS
         zG9R4Nswt6z9eTM/nTp9XGCQ4XDp0fkotQ5F8msq0uIv6l23IZgaANhZzDi89nqUke
         UxzWThZ3MEFakzK0YM1XeZ1pJWSLIfAps0+lncQehGUd5i217srChgNCdxkAMC5IkR
         4cZ6N/kcWdoVWClbCjlonGVum9vItz8sSOkZy4UvSfhAT5fEk76OvtuHkHsFiJLuRt
         B+jZlFNK570vQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] iwlwifi: mei: Replace zero-length array with
 flexible-array member
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220216195030.GA904170@embeddedor>
References: <20220216195030.GA904170@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164922955689.27650.1046956549336676737.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 07:19:18 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use “flexible array members”[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-next.git, thanks.

c5f675748cf0 iwlwifi: mei: Replace zero-length array with flexible-array member

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220216195030.GA904170@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

