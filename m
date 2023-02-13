Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A75694D48
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjBMQu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjBMQu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:50:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9101D914;
        Mon, 13 Feb 2023 08:50:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21E25611F2;
        Mon, 13 Feb 2023 16:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC7DC433D2;
        Mon, 13 Feb 2023 16:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676307023;
        bh=Rj4b5OcNcUEi5G0PXsOiV12Dhn98uCWgxCg+T++ejCI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=j9mnAfY33kOYp1aEXfqKhjBSTcecFDWKKpag1CJabG2XcUzUDPARmvil8fop/LYAi
         N+z3B/WUT5E+yEqZKt0oQefjPuniz0XZzWOCCVpDG98eZtmT+t8SYsnhpvvXxUnOO5
         gBHCby+4stmRtAYK8k/szM9bentQSj6765/O/i4uXsrHgVGoJCZIDMGlybAsaM3pkg
         ooqCeyseBW2dnFQeUZvHEhuNxexfwBNzKwCPq1Y6dcyAsG9ikdM5nKyzXMgdQxqGUo
         ZDARxWX2fRqFYDFa1vTXwIrB4fn0FGJ6lbIcOJYeJggi9QcL64C8pn7Soai2IfQcvE
         amaXGKuIULFng==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] dt-bindings: net: wireless: minor whitespace and name
 cleanups
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230118175413.360153-1-krzysztof.kozlowski@linaro.org>
References: <20230118175413.360153-1-krzysztof.kozlowski@linaro.org>
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
        =?utf-8?b?SsOpcsO0bWUgUG91aWxs?= =?utf-8?b?ZXI=?= 
        <jerome.pouiller@silabs.com>, de Goede <hdegoede@redhat.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, ath11k@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630701594.12830.46272053415017973.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 16:50:18 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> Minor cleanups:
>  - Drop redundant blank lines,
>  - Correct indentaion in examples,
>  - Correct node names in examples to drop underscore and use generic
>    name.
> 
> No functional impact except adjusting to preferred coding style.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Rob Herring <robh@kernel.org>

Patch applied to wireless-next.git, thanks.

1c30e9c0c8eb dt-bindings: net: wireless: minor whitespace and name cleanups

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230118175413.360153-1-krzysztof.kozlowski@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

