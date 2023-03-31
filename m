Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492776D1D71
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjCaJ4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbjCaJyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:54:50 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC621DF87;
        Fri, 31 Mar 2023 02:54:22 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 2792C6603192;
        Fri, 31 Mar 2023 10:54:20 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680256460;
        bh=piM6PA0EHYRy8htLrhyuISmb7ChsQu5VGOfh5mw8r2c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lWxlktbD2qs1vfPddbKp7mpgDaoOD7JbAnTRhOUf33AtZov2yGlCosviqcwqJajf/
         gUVQx8e2r5Qirk+zveV5azVqPhsPFqcEJtq/dy+WKGH7ObCCBazVghT7pxOOk/4/aw
         kU6yfz3pJV24BYPBSz1p1CYO+EJpZ9g9SaUIf2yvZlwHzVliyWnkGyZh+jFc867HC3
         HeixATwgeKohJOsrcK2Z/JgMmv3jRZ46pxar9qWLuYFRHzLwhHNUNDfMJ/vbDvGHld
         oTS5DcA2zlNLPsluaEKmiZnMlNakKk5jUdMC154t9PqFGdhtiqXDiIr/ssOMxkX74+
         rnnAopV31zWLg==
Message-ID: <e76e9ba4-7331-9c9b-617c-74bf7d43e70b@collabora.com>
Date:   Fri, 31 Mar 2023 11:54:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 08/19] clk: mediatek: Add MT8188 imgsys clock support
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
 <20230331082131.12517-9-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230331082131.12517-9-Garmin.Chang@mediatek.com>
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
> Add MT8188 imgsys clock controllers which provide clock gate
> control for image IP blocks.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


