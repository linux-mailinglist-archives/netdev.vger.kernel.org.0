Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB835ED548
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 08:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiI1GsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 02:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbiI1Gro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 02:47:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE5DA02C0;
        Tue, 27 Sep 2022 23:45:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07DC6B81EF3;
        Wed, 28 Sep 2022 06:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8345EC433C1;
        Wed, 28 Sep 2022 06:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664347534;
        bh=cXAJ6VfpzVQftg57kNUvZ8nwMjddxstIF2Kk2NC9GNQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OSdskIxlcC8v49FQFrsM2OoIQU3eTlhfvtsgErWcG/vf/kC/j+G9inpBYBC3bd5eb
         9K7/4jYTv0dMZBbM2oUbIKa7GeJ3xup6zAUauIhyVqnIxs+x9ZdMg590bAmFNLM8AX
         xcnX2T1l7f9Ql6LRtaEcwU/p1liDuYRD7ed8Ha3SL+sDEy2naG9ISSuuy23eOH3kII
         Q903yntX0B9AOovp2A781sZsbqAuZpyHtkhWADB9gbNDSeyCpN7msI3fIjFp2dhLnx
         83qdchhprehZsp9BEuYxXXK+UyGk9pbnar6blL0eULZl1iOMSJBuhXA4okH3rY4jjq
         BVY8Sn0DihFMw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] iwlegacy: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <YzIvzc0jsYLigO8a@work>
References: <YzIvzc0jsYLigO8a@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166434753080.25202.14336746049169834761.kvalo@kernel.org>
Date:   Wed, 28 Sep 2022 06:45:32 +0000 (UTC)
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
> Link: https://github.com/KSPP/linux/issues/223
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

56df3d408a8f iwlegacy: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YzIvzc0jsYLigO8a@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

