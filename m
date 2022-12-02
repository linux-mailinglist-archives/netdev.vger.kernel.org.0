Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A150641051
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbiLBWFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiLBWFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:05:46 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA398F230C
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:05:45 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c7so2744374pfc.12
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 14:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YGmhfz9LKketteJ29KbDn67sA38cLHNS36kuvwxlMm8=;
        b=TSqUQgbjbBdg6dvDWR1KVKuTEI3gAe6/W+8DLD7nw2mWi+QX+pcwtPxwJFoxQmJGEe
         uNxgwfWgkBGeh75QcHsRkRMQfxOkr6GVNv7M9DU6N537BAZNupUYZmYR8DdUZWlAAwbR
         KMF3Htct7RWcrCqmWw5tW/Ic0PXvyQHTzFYVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YGmhfz9LKketteJ29KbDn67sA38cLHNS36kuvwxlMm8=;
        b=7ODGsWlt/HK0cdUxBEQ3NfmwTdvG28ywI5NTBpPLDVXSp41ruUfj9L5uUaUVjl7zsl
         9osf9Os3/pjt1+folXZBpYRUFmTTVrhtL3eukk/DIi5X32QRwJySVALqOweTs8ymd57A
         6pof4P5fUAnDvbKjaroTZAOdJnPPf6LCTZsg3hwTcGJLihTARnd5ZuZpsxD3kEgCdqWn
         OYhXkki9KdZKDxuNxBJCA1RrwQVldk22frU5FTEtfCKcMog5rA36Pc85mz1UlV9+PUie
         qOhA2Abyh6Sx8/JFosDXeI+FoMPC8jW6YsGDeG9bnO8/8KB9uONXIjodKvR6tybKfzaV
         F8pA==
X-Gm-Message-State: ANoB5pndfceUffMktxXSx5osMWwrinV7noipTFvr7st4KHU5WE3CAriu
        7+3CBq4Veu9ltGqo/JlDHBaU2WuLrLDUyhY3
X-Google-Smtp-Source: AA0mqf5DhG6zysI+aj3WH5KAazaNoxWHCLIcnDeHYGVOYKMWwq4jAur5eQGJ0+dbDGN2a+EriUvEoA==
X-Received: by 2002:a05:6a00:4009:b0:563:2ada:30a3 with SMTP id by9-20020a056a00400900b005632ada30a3mr55402742pfb.27.1670018745233;
        Fri, 02 Dec 2022 14:05:45 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s24-20020a17090ad49800b00210125b789dsm5170014pju.54.2022.12.02.14.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 14:05:44 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Fri, 2 Dec 2022 14:05:43 -0800
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
Subject: Coverity: mt7996_rf_regval_set(): Integer handling issues
Message-ID: <202212021405.93CF11D2A@keescook>
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

*** CID 1527816:  Integer handling issues  (INCOMPATIBLE_CAST)
drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c:657 in mt7996_rf_regval_set()
651
652     static int
653     mt7996_rf_regval_set(void *data, u64 val)
654     {
655     	struct mt7996_dev *dev = data;
656
vvv     CID 1527816:  Integer handling issues  (INCOMPATIBLE_CAST)
vvv     Pointer "&val" points to an object whose effective type is "unsigned long long" (64 bits, unsigned) but is dereferenced as a narrower "unsigned int" (32 bits, unsigned). This may lead to unexpected results depending on machine endianness.
657     	return mt7996_mcu_rf_regval(dev, dev->mt76.debugfs_reg, (u32 *)&val, true);
658     }
659
660     DEFINE_DEBUGFS_ATTRIBUTE(fops_rf_regval, mt7996_rf_regval_get,
661     			 mt7996_rf_regval_set, "0x%08llx\n");
662

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527816 ("Integer handling issues")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")

Thanks for your attention!

-- 
Coverity-bot
