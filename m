Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160416D1D48
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjCaJzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjCaJyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:54:38 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D55C1F786;
        Fri, 31 Mar 2023 02:53:56 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 654D56603192;
        Fri, 31 Mar 2023 10:53:54 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680256435;
        bh=yhQGBDjpiXyLokl8kEYVcGcEJe5LqNnu7hroUolK+mU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eUIzykCbC3Q43OHz5RLWCTPLCx6is8ikutsTOpvwzSHg68izkq/sH4gmji1tSwUnr
         B+n/x+gkSPslk5c5dNgJli6tfHC1Ish5eJmR3nPY+DH0aYl3X08i7pqFC8I4lktMXt
         OH619Htn3jLr2XEULEyRKvLGE/SNhFVpZ4jAMZ8+WClQG+z1t+IJgt1dmfTui17Eo/
         rBHakUZbzc6oA3HFCwFmisWOGu8TK2SO8USxUu276xwL576JoinXOy82k6jz1gxmLz
         M4MjAsCsCgsco6MeKm4sLhNpC40WO6Rn4BS6S/nw7fSXLlB42WhbtgBodOk/KTxVqN
         AZEFLq9ljB+xA==
Message-ID: <ea3f90c7-a9ba-cbf0-c742-c31db77f302b@collabora.com>
Date:   Fri, 31 Mar 2023 11:53:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 02/19] clk: mediatek: Add MT8188 apmixedsys clock
 support
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
 <20230331082131.12517-3-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230331082131.12517-3-Garmin.Chang@mediatek.com>
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
> Add MT8188 apmixedsys clock controller which provides Plls
> generated from SoC 26m and ssusb clock gate control.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


