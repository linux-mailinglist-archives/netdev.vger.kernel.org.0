Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A976164106E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbiLBWNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiLBWNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:13:06 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CEDBD0DE
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:13:04 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id f3so5474055pgc.2
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 14:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/kWu3ykUp6jy2oE1ZRRlRshB8WYV422H/n94yGeyIhw=;
        b=GAXzEoo+S14lTK4cD0oXTEUsG2k/16arWIJHGYDGGoAITzPptHOYra+4PIZqAMKrAp
         0tB61+aGUNfbM+CwM2yGVn+YfT1RARaHjexCaAWA6Kq22roouKhqhimPBUwevE+wG2Sg
         ZdiVdxiW6gDD6Q9OAe7rXSCASwOhwS+nWPyfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/kWu3ykUp6jy2oE1ZRRlRshB8WYV422H/n94yGeyIhw=;
        b=ACurBt9YbrxkG5941z9EwFndLupktL6IgtBu9qx1DsMOfADr5QCTk71c7fUWIi1anS
         9OITr6KDH3OegxX3bGEQGsBxnvE4lO1ByBKPIm0nNeLeUkqMqMa02dTYWecCpmVKa2WI
         Nv8NqmCpL7jzRa85KgpkYQaq/ZSRBPCRSXZvKiFpjmpZUeg/D52YoInnYMjO1MpWKwqK
         U5p7CEtWHsV/5x17Madn5Hk7sj7D+7jukr96kzK4lg19m8bEuXiXco4sBuNGmAd8TMhG
         SOg5yZqEFwqqzlUnd/5hrMZnaMJ7YfSP2rS5E5pJrbbSEmuxaFGGqg6HoqHqhon/UVNU
         PDEg==
X-Gm-Message-State: ANoB5pkRWDh61o3s5wOeMBQgDJEU3jxS7yAwP4TxwuZLQ/ZMWQOboXgB
        AKYWvp7IVL7/P+uznGgF4dNkaA==
X-Google-Smtp-Source: AA0mqf4yMGLxJ4yzBzgABiEyiOC9Cw7v89H4Mg51yU3dIagFC0iIYu5hjOGUJWotx3YNlubWgYaiJQ==
X-Received: by 2002:a63:dd16:0:b0:476:d2d9:5151 with SMTP id t22-20020a63dd16000000b00476d2d95151mr45023874pgg.487.1670019184321;
        Fri, 02 Dec 2022 14:13:04 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f205-20020a6238d6000000b00574679561b4sm5563234pfa.134.2022.12.02.14.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 14:13:03 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Fri, 2 Dec 2022 14:13:02 -0800
To:     Shayne Chen <shayne.chen@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Chiu <chui-hao.chiu@mediatek.com>,
        Eric Dumazet <edumazet@google.com>,
        Money Wang <Money.Wang@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Howard Hsu <howard-yh.hsu@mediatek.com>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        linux-kernel@vger.kernel.org,
        MeiChia Chiu <meichia.chiu@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Coverity: mt7996_mcu_rx_radar_detected(): Insecure data handling
Message-ID: <202212021413.392BADAF@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

This is an experimental semi-automated report about issues detected by
Coverity from a scan of next-20221202 as part of the linux-next scan project:
https://scan.coverity.com/projects/linux-next-weekly-scan

You're getting this email because you were associated with the identified
lines of code (noted below) that were touched by commits:

  Thu Dec 1 17:29:14 2022 +0100
    98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")

Coverity reported the following:

*** CID 1527812:  Insecure data handling  (TAINTED_SCALAR)
drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:338 in mt7996_mcu_rx_radar_detected()
332     {
333     	struct mt76_phy *mphy = &dev->mt76.phy;
334     	struct mt7996_mcu_rdd_report *r;
335
336     	r = (struct mt7996_mcu_rdd_report *)skb->data;
337
vvv     CID 1527812:  Insecure data handling  (TAINTED_SCALAR)
vvv     Using tainted variable "r->band_idx" as an index into an array "(*dev).mt76.phys".
338     	mphy = dev->mt76.phys[r->band_idx];
339     	if (!mphy)
340     		return;
341
342     	if (r->band_idx == MT_RX_SEL2)
343     		cfg80211_background_radar_event(mphy->hw->wiphy,

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527812 ("Insecure data handling")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")

Thanks for your attention!

-- 
Coverity-bot
