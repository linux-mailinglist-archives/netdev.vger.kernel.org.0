Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E38E6D1D15
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjCaJy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjCaJyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:54:19 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C6D1EA3B;
        Fri, 31 Mar 2023 02:53:39 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 5CB366603192;
        Fri, 31 Mar 2023 10:53:37 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680256418;
        bh=deLqx63P1coOF+1pVILuu8j8ewdBvYytvCncdnzv0ZI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=N2YVaMzDNC2uqUpwNIkCRyCb+7iHoXILrlpssq0yVJ0bEmsFImmRh03y8o77kha/P
         8Xa8cGHvjVc8B/6/b3PIqT7OoOOFzhlwroQDe3khvrf3GPCxs01/vuoz9n1fAdyW1r
         DWD6lTGsSyTw4qd9zZPNSyn1fLVhB6YkKbk3Pj9kl4CGoXLmglo8yFop52/p5XorB7
         5BTUVeOJh5KaS+oEc0OKj95JNoA1YvzR78pfseNujPEvm23zjpIVp4Ailtbh+ID7eu
         ZjqQb4D53nL0OnWsnvqqWlZoRpLJlO9Sq40WbSV8hC9AVKA+c7yyDOBxk5VOwbjRLM
         Ht8Dfath4816g==
Message-ID: <5e55a616-8439-7ec3-0c47-f7eb8c4abd44@collabora.com>
Date:   Fri, 31 Mar 2023 11:53:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 03/19] clk: mediatek: Add MT8188 topckgen clock support
Content-Language: en-US
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
References: <20230331082131.12517-1-Garmin.Chang@mediatek.com>
 <20230331082131.12517-4-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230331082131.12517-4-Garmin.Chang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 31/03/23 10:21, Garmin.Chang ha scritto:
> Add MT8188 topckgen clock controller which provides muxes, dividers
> to handle variety clock selection in other IP blocks.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


