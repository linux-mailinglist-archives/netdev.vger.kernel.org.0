Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899934F5CD7
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiDFLzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiDFLzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82307B0A6F;
        Wed,  6 Apr 2022 00:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF60561B03;
        Wed,  6 Apr 2022 07:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B81BC385A1;
        Wed,  6 Apr 2022 07:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649229527;
        bh=UR4JAaBQa61qlZC04TBcieCdJUeGJ8gH4nQ8PLOLCUU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QwGs9sdihyVKnkQlY11TgpnX3p/Plv2QgabFyIta3ksfqmFjgU71HGGdmD4BdlRNn
         OQSzPea02kxgVo/oiFAP9Uglk8qo6hjrnTsJAOtq7g+iiid+StjMBzxpj/y2l1HaDM
         iyNpvNZ3U3po2kiTCbUxMO7A0gFZg6PuS2EtPnZwqYusoEwR94dsW25egfh4gUu4KH
         qvmbYOrdATnYmr+hss0VY3k/AoY9lVEPd3czSHdtQcpbw3p+/hvrKGrFRwbYQanXNP
         AH2DY87QceGJEMNo6GrYwMLFuR+xMd73G2533wKkUvTdAE6QaK3WbgqrWjQVD5dwab
         n++l92b1/vw5w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] iwlwifi: fw: Replace zero-length arrays with
 flexible-array members
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220216195015.GA904148@embeddedor>
References: <20220216195015.GA904148@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164922952168.27650.118624078658922574.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 07:18:45 +0000 (UTC)
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

34e63cd5ba29 iwlwifi: fw: Replace zero-length arrays with flexible-array members

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220216195015.GA904148@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

