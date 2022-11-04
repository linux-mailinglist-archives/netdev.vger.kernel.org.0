Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5783C619508
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbiKDLBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiKDLBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:01:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364D32CDFE;
        Fri,  4 Nov 2022 04:00:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0479B82CF8;
        Fri,  4 Nov 2022 11:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14151C433C1;
        Fri,  4 Nov 2022 11:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667559650;
        bh=QjAFhO9rFtgXWFIUq0wyH0sI8tEe72854Gae7+q/lWg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NeQtTOHCQnw7d8Ih/+HtrpcJ17OZwKqPQpGZH9oRnonRYehh4GDZ3hM6FfZJ9gdUt
         ukkXWsE7hQUjCqMOE8exubsThdIA1k/6fpUF9OQe6nYEFbvOU9rkKCOicRQA20GfTp
         yH1aJMNe6nISa0uhpB1BO9Tj/UYxWe02WlIp0EFAjkPqogDAWWouv3G1p9+Ia44GrE
         Z2aZD8aiQvvgNTJG+fPf9eATBSYcaWC8h7DNu7mra21SgG3e1XnDkYNN+eEiLKwwoK
         irnQuD8j/OaPtHID9ViQTr0cmID4ujmwIrov2Yio7GiwDdtIzjq5A/nL7Ne5Um92f4
         BXJ0kzg72IdwA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: wifi: brcmfmac: Fix a typo "unknow"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221101170252.1032085-1-j.neuschaefer@gmx.net>
References: <20221101170252.1032085-1-j.neuschaefer@gmx.net>
To:     =?utf-8?q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Cc:     brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        =?utf-8?q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?utf-8?q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marek Vasut <marex@denx.de>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        linux-wireless@vger.kernel.org, SHA-cyfmac-dev-list@infineon.com,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166755964415.3283.6960559954104062381.kvalo@kernel.org>
Date:   Fri,  4 Nov 2022 11:00:45 +0000 (UTC)
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Neuschäfer <j.neuschaefer@gmx.net> wrote:

> It should be "unknown".
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Patch applied to wireless-next.git, thanks.

22ebc2640cc7 wifi: brcmfmac: Fix a typo "unknow"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221101170252.1032085-1-j.neuschaefer@gmx.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

