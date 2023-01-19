Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D225E674B44
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjATEua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjATEt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:49:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D15AD88C9;
        Thu, 19 Jan 2023 20:43:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9DA6B820E7;
        Thu, 19 Jan 2023 05:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C09C433EF;
        Thu, 19 Jan 2023 05:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674105241;
        bh=vOpQ4Ds9jWqyGxR9dJ6k9KZUW8KJ9ISfjtx7rMdu5Vo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=tSrDNfwWpTpr7+utoIBt0yr9qOIlNUR6q3GVm7F6C3MXYpzwIcJhJkPd/xCgjkW1Q
         KyUqqDC98bCI0JpuVjU3GxTGPFSUYqyD5ihoBoEJZMwUz4b3XNABP08FYhJyySJVzv
         BYBUdkpWnh3Mf0oky2BSSNGH4p14qIW/nDr8lIzptM4+m2/At9i4kvFInVW9z8sbFV
         q2ksRhOjtceeaBxdAeuV/CoNi83BELbyNE03TPPtoMgl+ZtPN7AJTEOVPJOUEJMn58
         yt706ICqTTwZ6u+tWi3ddued5oW/hSHksddbDe/ZkiZEyNnCyztmwO/jdfALAaYoMN
         iZY4ZR/+17kcQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        de Goede <hdegoede@redhat.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, ath11k@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: net: wireless: minor whitespace and name cleanups
References: <20230118175413.360153-1-krzysztof.kozlowski@linaro.org>
Date:   Thu, 19 Jan 2023 07:13:52 +0200
In-Reply-To: <20230118175413.360153-1-krzysztof.kozlowski@linaro.org>
        (Krzysztof Kozlowski's message of "Wed, 18 Jan 2023 18:54:13 +0100")
Message-ID: <87bkmv85tb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> writes:

> Minor cleanups:
>  - Drop redundant blank lines,
>  - Correct indentaion in examples,
>  - Correct node names in examples to drop underscore and use generic
>    name.
>
> No functional impact except adjusting to preferred coding style.
>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../bindings/net/wireless/esp,esp8089.yaml    | 20 +++---
>  .../bindings/net/wireless/ieee80211.yaml      |  1 -
>  .../bindings/net/wireless/mediatek,mt76.yaml  |  1 -
>  .../bindings/net/wireless/qcom,ath11k.yaml    | 11 ++-
>  .../bindings/net/wireless/silabs,wfx.yaml     |  1 -
>  .../bindings/net/wireless/ti,wlcore.yaml      | 70 +++++++++----------
>  6 files changed, 50 insertions(+), 54 deletions(-)

Thanks for the cleanup. Would you like to me to take this to
wireless-next or do you have other plans?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
