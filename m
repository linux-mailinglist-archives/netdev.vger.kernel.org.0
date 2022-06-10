Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F066F545DAF
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346837AbiFJHjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242965AbiFJHjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:39:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFF3132766;
        Fri, 10 Jun 2022 00:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5A78B831CF;
        Fri, 10 Jun 2022 07:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E8AC3411B;
        Fri, 10 Jun 2022 07:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654846761;
        bh=hCht15CTX44Sxk0pUcKGojtW+Cz5f/KZ5jdF4JOrrho=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=D4uf040VQO4M09A8PXRpNKasuCp1C/MOzTMav9sOMCmqRbhu/MiZdTLL3FfuXszpj
         Fnw8puVMUizdbPAyVg9zTNgvz7TA0NwUA1QKurIYTCkBQ+rDpu30xr4XA+8X+Wl6hU
         fNpdtGPsY86G0L9fMqKJQvkWcWxrlcih/5rJBsuf3MIsI7qvT3SWEeeRpDyfE2t8we
         KEsZ+Bi3pJcNyaO9RWLbiPWg1P5zqMFYzoFiSV9xLp3DRRpD8IM8UxUBSKkIlfckcs
         rSAKClt9RaW8tUz0+MwQ78FTyTlVqoHXxRHLEgx9U+FQdT2GHkLf0Thop4dItQ50Ng
         ulpIq0spROH7g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: wifi: wfx: Remove redundant NULL check before release_firmware()
 call
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220606014237.290466-1-chi.minghao@zte.com.cn>
References: <20220606014237.290466-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     jerome.pouiller@silabs.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165484674004.24214.13068275820248967076.kvalo@kernel.org>
Date:   Fri, 10 Jun 2022 07:39:18 +0000 (UTC)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> release_firmware() checks for NULL pointers internally so checking
> before calling it is redundant.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Acked-by: Jérôme Pouiller <jerome.pouiller@silabs.com>

Patch applied to wireless-next.git, thanks.

05a2eebfa650 wifi: wfx: Remove redundant NULL check before release_firmware() call

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220606014237.290466-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

