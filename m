Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12994522BF9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238729AbiEKGCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238703AbiEKGCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:02:15 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616DD3337E;
        Tue, 10 May 2022 23:02:14 -0700 (PDT)
Received: from [192.168.1.107] ([37.4.249.94]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MXotA-1nIjKu24Me-00Y9S9; Wed, 11 May 2022 08:02:00 +0200
Message-ID: <720006e7-be4a-8878-7c2c-5b55f3e933f4@i2se.com>
Date:   Wed, 11 May 2022 08:01:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net] net: bcmgenet: Check for Wake-on-LAN interrupt probe
 deferral
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        open list <linux-kernel@vger.kernel.org>
References: <20220511031752.2245566-1-f.fainelli@gmail.com>
From:   Stefan Wahren <stefan.wahren@i2se.com>
In-Reply-To: <20220511031752.2245566-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:f8n6rxNfBSHmBKh1WOhJ9lpB6o4YHqSJXq63LosPAyflBj9ffsm
 3tPtrX6TpUN6e3FHQmJ99BKmQCl/MBRPSOiuHSpHTjBNtiXMqMfnRmxhETYLJE7UH0bMKqA
 Av6QzqQ4KNCn/SFKTBL4SkHthc0WRQQ3KDC4ivdXWdDdLz3/kuMM99F0e9f7iQ+VucMG3hk
 xm7DnIcUZ8TDSqnxsM4QQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:RieIq74dTSg=:/sBzWl/NhtFe0wGL3bC0hL
 Rvco1EAyn1tglXAStaSexEe6aST8mT/66U1MJsXRnBCI73WClbmVQ0eoHV84Oelo3aPLs9N2H
 kCXgTXzxUo5cC3t9MfxMJ//L+MqTMui14IOHtlzXYLdedxvH7ExUtzUrXkkYrDLTr+XMuwHp0
 YmZoWuzINgR6xFB5/ydq3+YZ/tYgWcYgoMKvK9WfgyHDGMhzEVYPn32rdxJqsYSeiF5EVw/ms
 LPRkJwVH0pPToRyuQaq1BU2xsL7XCI+quVZdjAWoQPVxibpQj/K2Cq/7WkqndzaifmzsmzbIr
 aFojCVTI7XdKk6BCCAVs2FYheDCXYl6ZXB3dxLwcCb+tYeJm7pHaXjlz9T2qmJm4Dz6x5Ejqb
 MYJGncQ+9Ok+UWw8TKjnSzpcqx2dcaK44Q9voBZs1kfqSBpOtfrt/OpiQoDTj48LjKqw5mdQn
 MWkYhG+ZF9KdWBceuOEMkUf1+D4LQjFPXSaZhN/Ooyy9EWEZBtAbhcPNWYLxg90c9mqPmC29o
 UMsQ+7pI5GOwHsGiPn2nKFoH44hhejUyj0y1pwaz8dHUiQ3xAw8FQ00+YvT1iQsdJYsKfCpmP
 Cbl5FDkPqfBz22G4VTTbwECZ49I2QrVNpc5jXAOzqkch+ZEzVcLCK0bw5lfN35tB5HwxPnYZy
 cZXurkSH7O3U9/TLR2r38rIXjdpyeePp/G6Jb+a7t6vtfzE0IQxmGfcVU4KQVc8ZKom/3yKZo
 ZNqAIvjnte/W+BHW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_BL,RCVD_IN_MSPIKE_ZBI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 11.05.22 um 05:17 schrieb Florian Fainelli:
> The interrupt controller supplying the Wake-on-LAN interrupt line maybe
> modular on some platforms (irq-bcm7038-l1.c) and might be probed at a
> later time than the GENET driver. We need to specifically check for
> -EPROBE_DEFER and propagate that error to ensure that we eventually
> fetch the interrupt descriptor.
>
> Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
> Fixes: 5b1f0e62941b ("net: bcmgenet: Avoid touching non-existent interrupt")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>   drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index bf1ec8fdc2ad..e87e46c47387 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3999,6 +3999,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
>   		goto err;
>   	}
>   	priv->wol_irq = platform_get_irq_optional(pdev, 2);
> +	if (priv->wol_irq == -EPROBE_DEFER) {
> +		err = priv->wol_irq;
> +		goto err;
> +	}
>   
>   	priv->base = devm_platform_ioremap_resource(pdev, 0);
>   	if (IS_ERR(priv->base)) {
