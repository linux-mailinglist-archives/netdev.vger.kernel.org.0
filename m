Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DEC64108E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbiLBWYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbiLBWYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:24:34 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDF9EC0AC
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:24:32 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id q1so5464821pgl.11
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 14:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F3xXQ9lCYQUlSBdhMmL8tVWcZF1nta/Hqkq7klcjUGo=;
        b=ANMtQZQ22M8vFa//m1q5Nmz5C5pG2EpSadk6l4a/nZGYH8n8ibP6Wt6LaUr0FtwdxZ
         8YJeutEDfbFawUjEe7XOl53hVibAOcUc5N7HvhA+E15qlobGxxJb5hICBtS23EoLD3Zq
         oyal/07g/8aHTI8NzzysmrvqI1hNFUbBl+PCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F3xXQ9lCYQUlSBdhMmL8tVWcZF1nta/Hqkq7klcjUGo=;
        b=u7z6As1/PfrF7fuO3Qc3g7UUf3yDbUPr61xadMSqqL1NzS906bs1vCtSQwyc1NBbj3
         xbg+aDKeeznhoFRvBWWSnGVgZfLepWv0CxZbweVMOP3E+FNEpWUnkp0FT1bA6QkLtacY
         QywqmOTdRwOIRUSljRjdvuvTqQo/xa5RNfDUJjsRGC+/Ic2bKek9C9o0cePcuOB1DduK
         hi//upfVIXblhynkYJVPrlTzSyxsuMhK2neKA3ThkHfu+SOrSqUw9qW7uXbe5sxkbqvw
         495WEv1PE/raOiQcbbul7sxQtLSTsjtmBUPVAvnMT+oITuxuDec9zNp5DSQ+x60LDnKO
         F66w==
X-Gm-Message-State: ANoB5plMoQ3lro0qGJ5UQFTJlZf/LiBNe/S0y2X22xw4VEoXXKNEjCLi
        vjn6CvJwgwgjOMCMgc/RF5cVyA==
X-Google-Smtp-Source: AA0mqf5E5D//TIG/aMQomKzNdz/FjOxFMupViZN74H7lfe+o54dMc5jppUGkpbgH+JGrhPhCHz28bg==
X-Received: by 2002:a63:2310:0:b0:457:a1a5:3ce with SMTP id j16-20020a632310000000b00457a1a503cemr47333634pgj.416.1670019872324;
        Fri, 02 Dec 2022 14:24:32 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z2-20020a17090ab10200b0021885b05660sm5201731pjq.24.2022.12.02.14.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 14:24:31 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Fri, 2 Dec 2022 14:24:30 -0800
To:     Bo Jiao <Bo.Jiao@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        MeiChia Chiu <MeiChia.Chiu@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        Bo Jiao <bo.jiao@mediatek.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Coverity: mt7915_mcu_get_chan_mib_info(): Memory - illegal accesses
Message-ID: <202212021424.34C0F695E4@keescook>
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

  Thu Feb 3 13:57:56 2022 +0100
    417a4534d223 ("mt76: mt7915: update mt7915_chan_mib_offs for mt7916")

Coverity reported the following:

*** CID 1527801:  Memory - illegal accesses  (OVERRUN)
drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:3005 in mt7915_mcu_get_chan_mib_info()
2999     		start = 5;
3000     		ofs = 0;
3001     	}
3002
3003     	for (i = 0; i < 5; i++) {
3004     		req[i].band = cpu_to_le32(phy->mt76->band_idx);
vvv     CID 1527801:  Memory - illegal accesses  (OVERRUN)
vvv     Overrunning array "offs" of 9 4-byte elements at element index 9 (byte offset 39) using index "i + start" (which evaluates to 9).
3005     		req[i].offs = cpu_to_le32(offs[i + start]);
3006
3007     		if (!is_mt7915(&dev->mt76) && i == 3)
3008     			break;
3009     	}
3010

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527801 ("Memory - illegal accesses")
Fixes: 417a4534d223 ("mt76: mt7915: update mt7915_chan_mib_offs for mt7916")

Thanks for your attention!

-- 
Coverity-bot
