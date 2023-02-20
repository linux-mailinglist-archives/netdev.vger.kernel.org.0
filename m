Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4E969C744
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 10:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjBTJFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 04:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjBTJFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 04:05:11 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8141513D66;
        Mon, 20 Feb 2023 01:04:55 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id E66026600872;
        Mon, 20 Feb 2023 09:04:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676883893;
        bh=6pMjB3CwfdxT0lcoBj6rbLitJri1o6cACyPKXzc0sMI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=dRU1TbHgVoJ3/QskG6P40PtEurbE7EFYxSln9fuV05r4Om8/FzVIs5CLSDC/nx5oG
         CvNL+ae8p8pFMoa2kdA3L+EqUfqZFkk5vNK60JvMC2K0r+23tjSecqX3OlLIBD8Q49
         jXNsb8VkRIUxrGze9sIxSwatCW+1Bwibnq72sqeTJJXHigUl5o6i9WJNiJ3mUJ7wzw
         ZLIe6awyeFIXTcDall9sq8vCRxmSiujh1jpY6hxj1e6LJbejXrxp6KHKvfMxuA6fRF
         tKSgROVZH1QO6NLgjUXXZkQwHMJ3SiXEmQDPNGbMZEEi4285IKUqk7IdCtvGPGtekC
         nTE+iCMAqGo8A==
Message-ID: <d67a960a-5a24-3744-276b-bf65bdddebfb@collabora.com>
Date:   Mon, 20 Feb 2023 10:04:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] mt76: mt7915: expose device tree match table
Content-Language: en-US
To:     Lorenz Brun <lorenz@brun.one>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>,
        Peter Chiu <chui-hao.chiu@mediatek.com>,
        Sujuan Chen <sujuan.chen@mediatek.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230218112946.3039855-1-lorenz@brun.one>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230218112946.3039855-1-lorenz@brun.one>
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

Il 18/02/23 12:29, Lorenz Brun ha scritto:
> On MT7986 the WiFi driver currently does not get automatically loaded,
> requiring manual modprobing because the device tree compatibles are not
> exported into metadata.
> 
> Add the missing MODULE_DEVICE_TABLE macro to fix this.
> 
> Fixes: 99ad32a4ca3a2 ("mt76: mt7915: add support for MT7986")
> Signed-off-by: Lorenz Brun <lorenz@brun.one>

I don't think that this commit needs a Fixes tag, as you're only adding (good)
auto-load commodity.

Regardless of that:

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

