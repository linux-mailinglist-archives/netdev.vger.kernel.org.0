Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809DB641085
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbiLBWVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbiLBWVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:21:50 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31DBF8188
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:21:48 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id k79so6149932pfd.7
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 14:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aMS0b2RE+vIHMOYP2E8EZZmUlghR9trNposIEeXjKJI=;
        b=GNTcUDsFn03JscGIy0a+vYklYFfFxJZZqGpErbZZkJXfUy51L4mNHn15JV39Wn01z3
         vb4zrIv5tFVn1hMThrwS+Z1/O+pe9nX5VyfbHAqFsufDYe/6mHsHteF9gFgr7BbTHhZt
         kdAMU2oSGR44L1sJjQuBc7Zg+9UiSLhcbzifE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aMS0b2RE+vIHMOYP2E8EZZmUlghR9trNposIEeXjKJI=;
        b=6SJv2HVdq3ad0fIT7f0AhVXW3iBxJ+ufHz8+bJvFxcCy261Sg5EPBb/+TQMceii+QU
         NL31lXbN5RBARrvszSCEZzrUQLYrgtlGlI7vMqYUiLx6jr8/RwJSXWxCXX8TolhRBUgc
         A21qD1mQuhzsA/otru41KnUcaZsK27GOrCjJV8XT9TsJpNMdDNLxbycwxBfffAiJ7bis
         oyP7PCU6NOaRHGgchedQSTXWoqSj8D7yKAB4PZ+WVIvgCN2Sf12ajymC1Gl9INmj/yQ3
         7330+qavZmZP0cW4Z97PYWhTL6PMoH8l4SzGtYUb6yygjL50UoGF93yPwX1nBW/hsxv3
         LXAw==
X-Gm-Message-State: ANoB5pmmSw7wcPnc1Xd4sy+cglDeC9C6RVM6dmfOsS5ju2XyJgF5YV4k
        JmtyLxavk0wSfbmXLI/1JGxmZQ==
X-Google-Smtp-Source: AA0mqf793ESx/sscIPyNmg7Zc2YStJKUoN2l9l7kbnO18Sros+YI1MVyANNMCuAajv/r7OdyYX7R0A==
X-Received: by 2002:a05:6a00:3029:b0:576:6bff:1c61 with SMTP id ay41-20020a056a00302900b005766bff1c61mr3817196pfb.15.1670019708300;
        Fri, 02 Dec 2022 14:21:48 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t15-20020a170902e84f00b00188c9c11559sm6123882plg.1.2022.12.02.14.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 14:21:47 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Fri, 2 Dec 2022 14:21:46 -0800
To:     Sean Wang <sean.wang@mediatek.com>
Cc:     YN Chen <YN.Chen@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Eric Dumazet <edumazet@google.com>,
        Leon Yen <leon.yen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Deren Wu <deren.wu@mediatek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Quan Zhou <quan.zhou@mediatek.com>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Ben Greear <greearb@candelatech.com>,
        Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Coverity: mt7921_check_offload_capability(): Resource leaks
Message-ID: <202212021421.6B6D4F45@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

  Thu Dec 1 17:29:13 2022 +0100
    034ae28b56f1 ("wifi: mt76: mt7921: introduce remain_on_channel support")

Coverity reported the following:

*** CID 1527806:  Resource leaks  (RESOURCE_LEAK)
drivers/net/wireless/mediatek/mt76/mt7921/init.c:178 in mt7921_check_offload_capability()
172     	ret = request_firmware(&fw, fw_wm, dev);
173     	if (ret)
174     		return ret;
175
176     	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
177     		dev_err(dev, "Invalid firmware\n");
vvv     CID 1527806:  Resource leaks  (RESOURCE_LEAK)
vvv     Variable "fw" going out of scope leaks the storage it points to.
178     		return -EINVAL;
179     	}
180
181     	data = fw->data;
182     	hdr = (const void *)(fw->data + fw->size - sizeof(*hdr));
183

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527806 ("Resource leaks")
Fixes: 034ae28b56f1 ("wifi: mt76: mt7921: introduce remain_on_channel support")

Thanks for your attention!

-- 
Coverity-bot
