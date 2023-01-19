Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFD16736C1
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjASL0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjASL0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:26:00 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130906FF9D;
        Thu, 19 Jan 2023 03:25:48 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 090286600871;
        Thu, 19 Jan 2023 11:25:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1674127547;
        bh=P24BRF7G7AAJcBdQBiIy1w/i3HakP9ngzoNRVWMdu7M=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KpvG3szd4tWA0VjCEYmAoCWKdkBPJuPlFQdL8rOhTvoY+HEBYkHuT/G9OsOI3cJaO
         +zKIogHTO850/DhNIz7klyy5Pday+8CmJewQ+9rc4HLPG8XlBoduL8AJe3TUoiugT5
         XZAGtA1cH6r8dIigXdGymIMRKoIaviOdDZtZHCK2j/zedqwT7M+ToAP37IlTytv34z
         NH5pbOOZ5eWRYLPtrPP2SWA/oXGyM+A4vx/6K8VWS//Gkr2rP7vwtabci2BY7DkIx1
         RVt43lAzL/4y9kSLSv7FOLHq8gS+fYPUWQDyxEO9R+7nVkxHHnzqlHILJLh12j1THg
         eTy7x4/zZMO4A==
Message-ID: <eaf43efd-e750-a09a-00b2-513c1a11a4aa@collabora.com>
Date:   Thu, 19 Jan 2023 12:25:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 2/2] soc: mediatek: pm-domains: Add support for mt8188
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
References: <20221223080553.9397-1-Garmin.Chang@mediatek.com>
 <20221223080553.9397-3-Garmin.Chang@mediatek.com>
Content-Language: en-US
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20221223080553.9397-3-Garmin.Chang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 23/12/22 09:05, Garmin.Chang ha scritto:
> Add domain control data including bus protection data size
> change due to more protection steps in mt8188.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


