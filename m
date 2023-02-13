Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C858694D5B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjBMQxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjBMQxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:53:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B594F5590;
        Mon, 13 Feb 2023 08:53:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F937611F8;
        Mon, 13 Feb 2023 16:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEAAC433D2;
        Mon, 13 Feb 2023 16:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676307193;
        bh=w3P8EUoGgjECsuPQVUgP3LsF29CldSC6Eowtr61B7Ys=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ST8oMqPsP1L+OUK8ADJjGOJDd/kpPD3aVoCSrAgyHtMvfwDyYkjWVvdAk5sTOlQuJ
         ZUcv3MdFPaNbyhE7vsrfHan0xevOD05HVX18uLqDmhgy6qF3WW+/K46ky3mNMffp1M
         itKSnWjYvDtzGLlTm0w+6OYSWC2At/Mel4aQ1tYjTYU89cHjgy503X8gAvWMBVH3rY
         vNNpyBz0tbjIXJCUBlNLvs9r1rPdrEWAj0GfCH9F1ajhEfOPYUwxGaiLaUF1PAezoZ
         b5j0+Rwn+f+cL0HQCbUHKvGSuPAJmZLODholNwBovNCTFnZbdvQ2s0BzK9ZIS8pgH1
         YdWtmQ9GwC0Qg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wifi: mwifiex: Replace one-element arrays with
 flexible-array members
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <Y9xkECG3uTZ6T1dN@work>
References: <Y9xkECG3uTZ6T1dN@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630718885.12830.1877017249326992310.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 16:53:10 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element arrays with flexible-array
> members in multiple structures.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> This results in no differences in binary output.
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/256
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

7fcae8f7f815 wifi: mwifiex: Replace one-element arrays with flexible-array members

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/Y9xkECG3uTZ6T1dN@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

