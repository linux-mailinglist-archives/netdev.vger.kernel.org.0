Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6FA6A45B8
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjB0PQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjB0PQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:16:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F3D222F6;
        Mon, 27 Feb 2023 07:16:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E63D860EA5;
        Mon, 27 Feb 2023 15:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703C8C433D2;
        Mon, 27 Feb 2023 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677511000;
        bh=dUbHpcLAghiOE0eFyFevEtnmxGMwC9i99mMFa8Y9N94=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ALg2Zjokt9qCTMnZSpi1ZYiC4Z4y0vpYtj2V5ttvJMlfZGoX0TtWbdQdU1Y1r1xMD
         tSy+/rdO1ls5gez2G+09x2HILeOC9wZtxAjJtbkGwLcVZieGLudt1PKJNrdb995bqN
         TUw5Ru3KFgu+Po2if9rP4kbfzn2GqCjz01qEJwNoYAS5Y3HS2QTFtj4/rsVt4R806F
         cHH7SfCE/0Ue6frA8VsbKwbsssBj72KMm9dcK+t/AfXPNoQ+dDlgMTaBBzt0sljB6H
         qrOUMa3qr0JvsRr9TGJtSB/v08MLRK+jmcDCCo9qd8TPaFfmp5xGM7xu/10B4cJvxa
         nDASP8iTEE2uA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: cfg80211: Use WSEC to set SAE password
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230214093319.21077-1-marcan@marcan.st>
References: <20230214093319.21077-1-marcan@marcan.st>
To:     Hector Martin <marcan@marcan.st>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167751099053.8427.17402921187469038381.kvalo@kernel.org>
Date:   Mon, 27 Feb 2023 15:16:36 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hector Martin <marcan@marcan.st> wrote:

> Using the WSEC command instead of sae_password seems to be the supported
> mechanism on newer firmware, and also how the brcmdhd driver does it.
> 
> Signed-off-by: Hector Martin <marcan@marcan.st>

If I understood correctly this patch is not ready yet so I'll drop it
from my queue. Please resend as v2 once it's ready and add "wifi:" to
the title.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230214093319.21077-1-marcan@marcan.st/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

