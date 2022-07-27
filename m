Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093CB582713
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiG0Mw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiG0Mw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:52:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1B911C1B;
        Wed, 27 Jul 2022 05:52:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 395F8B82113;
        Wed, 27 Jul 2022 12:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03009C433C1;
        Wed, 27 Jul 2022 12:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658926345;
        bh=qsjPCm4fV+iPGr7gTwRqoGfpzmZJ15q2MJy2FG0DsCA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Y6f5Wug1VMjFTlmCBAqQCNDaaQWG4aeoAkcqlSQW7ah40txVs2FGd2ZsuFbrBfdbx
         qESAANRKMWvX3+RVaumzwtLTDrUIrr26X2aLjowaoUMcrRLUAJ4SKjsPHW8a1IZIdM
         cHXbI5MOgmpe0XhsBethNB4z+F22qgWbziGWb47bVrGV/Zrx1l3BtUa2bP6th5uw6B
         Uo2TYTOXKHa66y5uei7VUYxFPyNSVyt/89b0zBC7HJ2tIUFoHR/KrjFWoHFovNL0cs
         f6aZVUVWP8xicSzgJI8JwbeStovVA9IjIX8rglrnmciXYF/wfWOGsZexuPZ2IxB3lE
         JP2z3geIvY2sA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: wifi: wl12xx: Drop if with an always false condition
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220715224619.ht7bbzzrmysielm7@pengutronix.de>
References: <20220715224619.ht7bbzzrmysielm7@pengutronix.de>
To:     Uwe =?utf-8?q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165892634124.11639.5820466712646942521.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 12:52:22 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> The remove callback is only called after probe completed successfully.
> In this case platform_set_drvdata() was called with a non-NULL argument
> (in wlcore_probe()) and so wl is never NULL.
> 
> This is a preparation for making platform remove callbacks return void.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Patch applied to wireless-next.git, thanks.

69ddcea56443 wifi: wl12xx: Drop if with an always false condition

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220715224619.ht7bbzzrmysielm7@pengutronix.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

