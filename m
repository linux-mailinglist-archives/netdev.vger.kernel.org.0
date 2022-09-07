Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B6B5AFE26
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiIGHxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiIGHxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:53:48 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A8A2B1B6;
        Wed,  7 Sep 2022 00:53:47 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 0A7736601F54;
        Wed,  7 Sep 2022 08:53:44 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1662537226;
        bh=BCD43Ro81TvvaaUtrHY0+2JtCkCiz8j/yBq4ltRbsKI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XO3p5ccUnzLCVIUiWhaBkep7zenLC14RqR7a3ae8hPbcq1n4wsyCB6AhLQi4LD2D1
         6/EO/8jt0Vqk2nGe6T3lFwah9pjQ/KDKIEN38WD1v+Nux/sPUPdjT6p5lULfqhjIdt
         CnCDPGHc+BEiS9VeTypKnmDyMwv6GUnhdami2qbmQ5+IoCrrD/28r+5LVMF/iJlME4
         ikH4xwCJuGrowCnWntLTOrql3hEmhLYmLxVU0iXiZol4T13QOHjklFYKvG5K9legPg
         +ygLo5cKpZL6CERO9DgCHCS5mIQ25XRes26OAaytBD8YkYn8wXsV3+CFy+Wq2hvfIV
         8UY24aZiE/Fvg==
Message-ID: <2e4b92ba-8b0b-bfa7-8056-81cf127a251e@collabora.com>
Date:   Wed, 7 Sep 2022 09:53:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v3 06/11] leds: mt6323: Get rid of custom
 led_init_default_state_get()
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gene Chen <gene_chen@richtek.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Lee Jones <lee@kernel.org>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
 <20220906135004.14885-7-andriy.shevchenko@linux.intel.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220906135004.14885-7-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 06/09/22 15:49, Andy Shevchenko ha scritto:
> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

