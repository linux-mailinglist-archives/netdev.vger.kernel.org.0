Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47066B7943
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCMNoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjCMNoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:44:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34091EBF0;
        Mon, 13 Mar 2023 06:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E0A8612C5;
        Mon, 13 Mar 2023 13:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A35C433D2;
        Mon, 13 Mar 2023 13:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678715050;
        bh=H6vzGnYg6IJuFyWGMCrpxmuKtm6Mwcd0NvIiKg9tHZo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aNWegKoc6e3j9LNaiAzjI3LQod60EOcftOODf8i6JAv4IznXvPk9I29umnnQ2liW+
         APl2IW/37uBRQhsX+1+b0JQ3u+dhlYxvc5jetpKMOJ4RyCWMEL32XdXXSj0RJWJwJ+
         02A7FJylmAf0mRc8CHjX5uvuL8tBfVAHCz24iE2Fadn+6THZEI/n1+K/C8RGo5P2kE
         QuZXtbds/VHnCEXeKCYkOFSuZo+TSNs1O6xfKQMNJ3+Q0lQJLd/llJnG5DGwcSQz3W
         pI6XScjeZ9auqdFn6KXEjyfqD61V6fh1sPg/OAFNc565c9au8Ws0vQrEhdtDGoBV6w
         Ypa3NvKndS+3g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtl8xxxu: use module_usb_driver
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230307195718.168021-1-martin@kaiser.cx>
References: <20230307195718.168021-1-martin@kaiser.cx>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Martin Kaiser <martin@kaiser.cx>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167871504675.31347.18380662034619588153.kvalo@kernel.org>
Date:   Mon, 13 Mar 2023 13:44:08 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Kaiser <martin@kaiser.cx> wrote:

> We can use the module_usb_driver macro instead of open-coding the driver's
> init and exit functions. This is simpler and saves some lines of code.
> Other realtek wireless drivers use module_usb_driver as well.
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com> # Edimax N150

Patch applied to wireless-next.git, thanks.

0606b344021a wifi: rtl8xxxu: use module_usb_driver

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230307195718.168021-1-martin@kaiser.cx/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

