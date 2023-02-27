Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620F16A45AD
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjB0PNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjB0PNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:13:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D32C59C5;
        Mon, 27 Feb 2023 07:13:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9A0460E8B;
        Mon, 27 Feb 2023 15:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB35C433D2;
        Mon, 27 Feb 2023 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677510789;
        bh=BjWkrs/gmj0cFLL9MNDb8Zu8rH+c69H6MGykaCOCffE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fo22Bgv5GraLLN95eClok53Gcu6rbZ8mRfKy9JRuZuN3SKAniU804B9JS33SZCvkj
         NoR8rSD4XVpYGQSqrPLFevxgd3SyPoCdmQf0SOwnDdGewCsR+v443MItLLX4hlg8un
         o3BZOmYeCdP5xJa1dy3x2cfmfgFTiPmxonx3x9xSXmFQyZ4NY6teKd0F+rx0PP97ol
         4jgHT0cLpYwBA9O2GOpqCOEiAfTNiad3UVqtrCNIocBVbd/gRNSOdj+lEZaY3TxbZc
         v46G39S2bbVwolfLDT9kPAjoaYWVeEYllUHlyt/zjjedizsI0lbfEuc2A96X29ic/1
         nyd/ua33MU+ig==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmfmac: pcie: Add BCM4378B3 support
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230214092838.17869-1-marcan@marcan.st>
References: <20230214092838.17869-1-marcan@marcan.st>
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
Message-ID: <167751078017.20016.9919421224417148636.kvalo@kernel.org>
Date:   Mon, 27 Feb 2023 15:13:05 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hector Martin <marcan@marcan.st> wrote:

> BCM4378B3 is a new silicon revision of BCM4378 present on the Apple M2
> 13" MacBook Pro "kyushu". Its PCI revision number is 5.
> 
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Patch applied to wireless-next.git, thanks.

1d5003d05f98 wifi: brcmfmac: pcie: Add BCM4378B3 support

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230214092838.17869-1-marcan@marcan.st/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

