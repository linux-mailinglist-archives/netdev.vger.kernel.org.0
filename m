Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F6E641060
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiLBWLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiLBWLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:11:36 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642B4F8987
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:11:35 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id w23so5836362ply.12
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 14:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w0dcCRAw7breQBxRgO7vXMzRE1EKaCH1sm8fAccBDKk=;
        b=OwVi+W7xvxR/nGjj39pmX3oRQiji/LPiwOpKAVbcIfM5DiCUEx2CVjjGCPgXGrAYj2
         5UoXRgnzXLZKAL8W05vLqFxBXlQ6XcoYM3KtBnvhqQMVng3lNY2A1Ac0VfEk1e+mkKH0
         2KCcNECGN1AEN2hcX554Bmw8qWfXqc5l8cIxA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w0dcCRAw7breQBxRgO7vXMzRE1EKaCH1sm8fAccBDKk=;
        b=RRtgh1TXomFMpdpA2cuc4g/AfnnsOZycz0L03d8IjsPBPXDuZf8q5NwZU+zxg4KsVd
         PLy+yXCyzN1vyNHZnLgrR0pFmMvZpFrTjYpSb3Be0D/c3H/h1qOJylep7OrUhNPI4pa2
         xmQCg5mnb3/t3lhMLKt1cl2oWWXYXgf3ZPlP8eAT5lumB5OjFOPbUAWH+F5C7SVGvQwn
         La8TpvG8GrIMP0cAheo5m2YQACVx2i5FBH7Xb0fBh1dvO9uM/2eacvXp3OWmovl/ZnMM
         dWKZ9VgOhjo62ZjcrkemOuwTgWSUi4oMBFbaa9AT65WRGIlDBWaIPI96O9My18e83/sY
         /CFw==
X-Gm-Message-State: ANoB5pkfCRQx+QRAHeLgOd3xw3XOand+RSnDk+qapp8TBm1xxipCG+az
        U1R12MftWyFD20Lb1WM9AW3fUQ==
X-Google-Smtp-Source: AA0mqf6QTLbmI+X8jti2r+C7tdO68/bOJUECQQLNnuZG8zdOtdYlL2NT2bZgqzSjU6DeRIsbPY36zw==
X-Received: by 2002:a17:90a:9e5:b0:219:5139:7fa8 with SMTP id 92-20020a17090a09e500b0021951397fa8mr20815064pjo.15.1670019094904;
        Fri, 02 Dec 2022 14:11:34 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h131-20020a628389000000b0056bb36c047asm5510216pfe.105.2022.12.02.14.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 14:11:34 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Fri, 2 Dec 2022 14:11:33 -0800
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
Subject: Coverity: mt7996_hw_queue_read(): Integer handling issues
Message-ID: <202212021411.A5E618D3@keescook>
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

*** CID 1527813:  Integer handling issues  (SIGN_EXTENSION)
drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c:460 in mt7996_hw_queue_read()
454     	for (i = 0; i < size; i++) {
455     		u32 ctrl, head, tail, queued;
456
457     		if (val & BIT(map[i].index))
458     			continue;
459
vvv     CID 1527813:  Integer handling issues  (SIGN_EXTENSION)
vvv     Suspicious implicit sign extension: "map[i].qid" with type "u8" (8 bits, unsigned) is promoted in "map[i].qid << 24" to type "int" (32 bits, signed), then sign-extended to type "unsigned long" (64 bits, unsigned).  If "map[i].qid << 24" is greater than 0x7FFFFFFF, the upper bits of the result will all be 1.
460     		ctrl = BIT(31) | (map[i].pid << 10) | (map[i].qid << 24);
461     		mt76_wr(dev, MT_FL_Q0_CTRL, ctrl);
462
463     		head = mt76_get_field(dev, MT_FL_Q2_CTRL,
464     				      GENMASK(11, 0));
465     		tail = mt76_get_field(dev, MT_FL_Q2_CTRL,

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527813 ("Integer handling issues")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")

Thanks for your attention!

-- 
Coverity-bot
