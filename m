Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958BE5302FB
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 14:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiEVMTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 08:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiEVMTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 08:19:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861DE3B563;
        Sun, 22 May 2022 05:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27F00B80B34;
        Sun, 22 May 2022 12:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D87C385AA;
        Sun, 22 May 2022 12:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653221980;
        bh=hKXMh49m3HC2NYt53grruX9YhqeFdPa9MPwInMtUqm8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AslbbcAipElReokwmHE4K4OPSF3z+L9uD4NijXgoQZlPm9b2wsnw2pdZ7OgzrzJFx
         p/a9s6dC+C6H0xGrHbPi4XtvYRcNLg7pmbD9rt2NCRt6iB0Jmdxxgz4eZ1b7wHAbYD
         4XSfJXfkXTr2RI8c/iUQzkvDYow3/mtUeU09EzbvLKIGokgldgxr1UxcJF3J/fRcvH
         NoFZauUH7OuUlFeUMfeUKFlpWP+MkFK2HcZzbPnh7KYeur4BeiiMa/DZwbInsRIGur
         NNGRVQYHjH/e0E4muOdm4PC1xv4UkXZpWuIF1koaB5cpalFHzZyKqVMPsKAGRb6e68
         DjrY2NwRbjPqw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] Fix/silence GCC 12 warnings in drivers/net/wireless/
References: <20220520194320.2356236-1-kuba@kernel.org>
Date:   Sun, 22 May 2022 15:19:36 +0300
In-Reply-To: <20220520194320.2356236-1-kuba@kernel.org> (Jakub Kicinski's
        message of "Fri, 20 May 2022 12:43:12 -0700")
Message-ID: <8735h12207.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Hi Kalle & Johannes,
>
> as mentioned off list we'd like to get GCC 12 warnings quashed.
> This set takes care of the warnings we have in drivers/net/wireless/
> mostly by relegating them to W=1/W=2 builds.
>
> Is it okay for us to take this directly to net-next?
> Or perhaps via wireless-next with a quick PR by Monday?

We are not planning to submit any new pull requests so please take it
directly net-next.

> Jakub Kicinski (8):
>   wifi: plfxlc: remove redundant NULL-check for GCC 12
>   wifi: ath9k: silence array-bounds warning on GCC 12
>   wifi: rtlwifi: remove always-true condition pointed out by GCC 12
>   wifi: ath6k: silence false positive -Wno-dangling-pointer warning on
>     GCC 12
>   wifi: iwlwifi: use unsigned to silence a GCC 12 warning
>   wifi: brcmfmac: work around a GCC 12 -Warray-bounds warning
>   wifi: libertas: silence a GCC 12 -Warray-bounds warning
>   wifi: carl9170: silence a GCC 12 -Warray-bounds warning

Like I mentioned in the other email I don't really like these but I
understood they are urgent so:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
