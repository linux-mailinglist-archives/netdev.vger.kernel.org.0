Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADF9641096
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiLBW2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbiLBW2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:28:00 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DAC37FBC
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:27:58 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id jl24so5881056plb.8
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 14:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ALZWGLHwa13YfXZGkxW0FB63ANWeHG5fPT+X9QnIXNE=;
        b=X3/Ygkl9QthpO86CXg54X6whNZrFQqYUC0a1gJ7z1caR4J8jEDl6DfVlTLaBNivhcY
         NiphJrlOXZlUsJ+SpV9Zi/OaCqZQmF+w8BKtnwGuplrgBPudjQNAGaFRELzlURBACYjN
         fvskVx3RWz/t+JrUbcEZFBXzzW/hbUS1lG/vc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ALZWGLHwa13YfXZGkxW0FB63ANWeHG5fPT+X9QnIXNE=;
        b=F3RWdZ3eJl86/y7AmXbrmp6t5QeVQgv3zKjem5yHmJh0+31ve1O6RiseC61RrTfSKS
         6EPEJmvRUPUgrxezFcfy5i9b6QzSyf4C+aFq6At8UiUMX7E+DVibaWMbWCz7HJp/QE3C
         DGS1Ftk5LqFVYPQr3UA5YBoNqM9Yet8ymtBTI49Z65LddgiCV/MnDJvoU/rCtxQcdild
         tBtIobS6Y6fNVMh4eRpvmlruy3VboQdGWmW8UepORwBpf5Zj8li6jmngIRtRil3Tox5F
         PpkKPEYHqAYKcDg2YMvu0mWgZh2rfLYm938PfooDRs7HbIvDhw7v6gk4PY5KJmHy62v/
         Dd6w==
X-Gm-Message-State: ANoB5plyUj6//wgliF9RLT6XefCcVoC3Ia1jy6N7ou80pfGNWbrpZDBe
        bAwsVWsivrcdC4uaGLyLHAxjbg==
X-Google-Smtp-Source: AA0mqf5jLuXI/3izYGoUxy610VM/+FmgD12XJpKjAnMQ9yTLUWnTyNdgZ4kJJE+Exwk0YwLhcYT/sQ==
X-Received: by 2002:a17:90b:3608:b0:219:6b1b:63d8 with SMTP id ml8-20020a17090b360800b002196b1b63d8mr14207707pjb.143.1670020078378;
        Fri, 02 Dec 2022 14:27:58 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b00189ac5a2340sm5734186pln.124.2022.12.02.14.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 14:27:57 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Fri, 2 Dec 2022 14:27:57 -0800
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
Subject: Coverity: mt7996_mcu_ie_countdown(): Insecure data handling
Message-ID: <202212021427.3A86EE0@keescook>
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

*** CID 1527797:  Insecure data handling  (TAINTED_SCALAR)
drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:415 in mt7996_mcu_ie_countdown()
409     	struct mt76_phy *mphy = &dev->mt76.phy;
410     	struct mt7996_mcu_rxd *rxd = (struct mt7996_mcu_rxd *)skb->data;
411     	const char *data = (char *)&rxd[1], *tail;
412     	struct header *hdr = (struct header *)data;
413     	struct tlv *tlv = (struct tlv *)(data + 4);
414
vvv     CID 1527797:  Insecure data handling  (TAINTED_SCALAR)
vvv     Using tainted variable "hdr->band" as an index into an array "(*dev).mt76.phys".
415     	if (hdr->band && dev->mt76.phys[hdr->band])
416     		mphy = dev->mt76.phys[hdr->band];
417
418     	tail = skb->data + le16_to_cpu(rxd->len);
419     	while (data + sizeof(struct tlv) < tail && le16_to_cpu(tlv->len)) {
420     		switch (le16_to_cpu(tlv->tag)) {

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527797 ("Insecure data handling")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")

Thanks for your attention!

-- 
Coverity-bot
