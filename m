Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD07D6D1D7A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbjCaJ41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjCaJy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:54:56 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6102D1D87C;
        Fri, 31 Mar 2023 02:54:32 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 949386603192;
        Fri, 31 Mar 2023 10:54:30 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680256471;
        bh=EKo8lmMORAFDv19yQTTjgobq46D/Fo4c8X7gdyEavKQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KwxWI6cR6mqxEs+F42ywrhgNIgTkkjLLtHbE8D8xOVXMavthi3A5cfmnmQHJ471L0
         z1liRGomVgDKl3mEZaTALxf0Xglv1zF/etZiVfyTXWA0N7Fjs9xhadkO4TM4JaIM8v
         dduy5WugvVdos8SmygbaED+Rq8oaUFYUrBSYXFnVvMFmdCOazvq6qLSJ4WxSQZ783p
         AN2VaFkZ75b15Ken74WsJaJv8beDrJz4lCOPd1guqjbN/8H/9AHBc/pAqfET5UVUDI
         4DjuDY0n5OOR/OKBbMWL5nRsqH82z/hMT+263YctdEJPNiVqiOp5/787XfavHKeyEH
         jXszDK2yGQscg==
Message-ID: <2abf653e-b8be-ec16-e906-10411f84e957@collabora.com>
Date:   Fri, 31 Mar 2023 11:54:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 10/19] clk: mediatek: Add MT8188 mfgcfg clock support
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
 <20230331082131.12517-11-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230331082131.12517-11-Garmin.Chang@mediatek.com>
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
> Add MT8188 mfg clock controller which provides clock gate
> control for GPU.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


