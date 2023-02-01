Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F589686F9D
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 21:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjBAUTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 15:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjBAUTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 15:19:07 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A895CFD7
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 12:19:00 -0800 (PST)
Received: from [2a04:4540:1401:2600:5cbc:44aa:48a9:eb97]
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john@phrozen.org>)
        id 1pNJZJ-004GDj-Rp; Wed, 01 Feb 2023 21:18:57 +0100
Message-ID: <38aa8894-a3a4-804f-7216-a7012845d23b@phrozen.org>
Date:   Wed, 1 Feb 2023 21:18:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net 2/4] mailmap: add John Crispin's entry
Content-Language: en-GB
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        nbd@nbd.name, lorenzo@kernel.org
References: <20230201182014.2362044-1-kuba@kernel.org>
 <20230201182014.2362044-3-kuba@kernel.org>
From:   John Crispin <john@phrozen.org>
In-Reply-To: <20230201182014.2362044-3-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01.02.23 19:20, Jakub Kicinski wrote:
> John has not been CCed on some of the fixes which perhaps resulted
> in the lack of review tags:
>
> Subsystem MEDIATEK ETHERNET DRIVER
>    Changes 50 / 295 (16%)
>    Last activity: 2023-01-17
>    Felix Fietkau <nbd@nbd.name>:
>      Author 8bd8dcc5e47f 2022-11-18 00:00:00 33
>      Tags 8bd8dcc5e47f 2022-11-18 00:00:00 38
>    John Crispin <john@phrozen.org>:
>    Sean Wang <sean.wang@mediatek.com>:
>      Author 880c2d4b2fdf 2019-06-03 00:00:00 7
>      Tags a5d75538295b 2020-04-07 00:00:00 10
>    Mark Lee <Mark-MC.Lee@mediatek.com>:
>      Author 8d66a8183d0c 2019-11-14 00:00:00 4
>      Tags 8d66a8183d0c 2019-11-14 00:00:00 4
>    Lorenzo Bianconi <lorenzo@kernel.org>:
>      Author 08a764a7c51b 2023-01-17 00:00:00 68
>      Tags 08a764a7c51b 2023-01-17 00:00:00 74
>    Top reviewers:
>      [12]: leonro@nvidia.com
>      [6]: f.fainelli@gmail.com
>      [6]: andrew@lunn.ch
>    INACTIVE MAINTAINER John Crispin <john@phrozen.org>
>
> map his old address to the up to date one.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: John Crispin <john@phrozen.org>


> ---
> Cc: john@phrozen.org
> Cc: nbd@nbd.name
> Cc: lorenzo@kernel.org
> ---
>   .mailmap | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/.mailmap b/.mailmap
> index 8deff4cec169..ac3decd2c756 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -214,6 +214,7 @@ Jisheng Zhang <jszhang@kernel.org> <jszhang@marvell.com>
>   Jisheng Zhang <jszhang@kernel.org> <Jisheng.Zhang@synaptics.com>
>   Johan Hovold <johan@kernel.org> <jhovold@gmail.com>
>   Johan Hovold <johan@kernel.org> <johan@hovoldconsulting.com>
> +John Crispin <john@phrozen.org> <blogic@openwrt.org>
>   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
>   John Stultz <johnstul@us.ibm.com>
>   Jordan Crouse <jordan@cosmicpenguin.net> <jcrouse@codeaurora.org>
