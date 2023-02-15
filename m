Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73C0697D09
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 14:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbjBONUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 08:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjBONUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 08:20:33 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0720D9765;
        Wed, 15 Feb 2023 05:20:29 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id A33E16602181;
        Wed, 15 Feb 2023 13:20:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676467228;
        bh=TYzhCq0RKGP5tpidHzO4VKVYdmJ57P4wYdGQAji5b0o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Bu+48H/hM7AnP9NpE/sqVa6pKdlign6Ms3WEA4LvK7cSBn+NTpLnxRXaSbtKrLfV5
         ZSgbV+MJKryaWFxrTMlex8xOLMpfcgvSum9n/ZPxwW5cEKlosnu+UcRfG/SPP0Yx6z
         00aiMh0FoZBaMrdy6hHnojBWBNN2p0bJgiB2oxDvARo8iF7Yrvg+damxYA+RZvIINw
         gkgUJJahKoxfkkMwhHh7fnNkv9BK7+W5NzeoJLfedpyJTparfSWBaXaOYhAZk+81sk
         0BEvtZuRlPBZTwocn0h4Q8YFXX+qCwFV6KFlqdUGaOrDnfe+5VtdnfGZA26jqGksA1
         e2K2VEBuv89zQ==
Message-ID: <c6b23a24-4799-2b71-0bf3-f2545980ae3d@collabora.com>
Date:   Wed, 15 Feb 2023 14:20:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH -next v2] wifi: mt76: mt7996: Remove unneeded semicolon
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>, kuba@kernel.org
Cc:     pabeni@redhat.com, matthias.bgg@gmail.com, ryder.lee@mediatek.com,
        lorenzo@kernel.org, nbd@nbd.name, shayne.chen@mediatek.com,
        sean.wang@mediatek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20230215055650.88538-1-yang.lee@linux.alibaba.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230215055650.88538-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 15/02/23 06:56, Yang Li ha scritto:
> ./drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:3136:3-4: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4059
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

