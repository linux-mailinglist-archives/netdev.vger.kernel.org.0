Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844CA578B1A
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbiGRTkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbiGRTj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:39:57 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E05D3135F;
        Mon, 18 Jul 2022 12:39:52 -0700 (PDT)
Received: from [IPV6:2003:e9:d737:b8a6:bfa9:9b4a:f710:ca2f] (p200300e9d737b8a6bfa99b4af710ca2f.dip0.t-ipconnect.de [IPv6:2003:e9:d737:b8a6:bfa9:9b4a:f710:ca2f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 4DBF7C0470;
        Mon, 18 Jul 2022 21:34:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1658172859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cj6PjsnW8S5E4d243AogipMDr+j0eDzgL34equMnMcc=;
        b=byIl5MKrvn7FQ6nj7Hk39zOwJG0BH8iLEJfMBdSXTlvXLrQe4rU31ZCYwi3fQAueRHRgDW
        XLx737kOWVOt+HlwRCbaKapcISf+IYc1IyBCLl8tdCUari9f6HAsNtyUN6aqDMYsS6JxqJ
        rGQpsYCqUjmCIF1G5o3x0zLGrvSHIC8u2WSs00vvaTtnwGgdhZlVsLvb1tmB0d5ZfctxjG
        5gTyFzxDkOtR0G5qD8qdVKDGJ6CwQCoEcPkvL2k9sB2j8H0c6V4X+X7vqW4Y83qLhYryGe
        P9vH5TlSRz3A9p5pclqf4UywAbMlNBNoyDBGf92DNv3lWqYh4X/CZpl0yarH1g==
Message-ID: <f34e5a68-1cb4-b4d1-4d44-7d8b905a2ec4@datenfreihafen.org>
Date:   Mon, 18 Jul 2022 21:34:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] net/ieee802154: fix repeated words in comments
Content-Language: en-US
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, alex.aring@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220708151538.51483-1-yuanjilin@cdjrlc.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220708151538.51483-1-yuanjilin@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 08.07.22 17:15, Jilin Yuan wrote:
>   Delete the redundant word 'was'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>   drivers/net/ieee802154/ca8210.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index 42c0b451088d..450b16ad40a4 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2293,7 +2293,7 @@ static int ca8210_set_csma_params(
>    * @retries:  Number of retries
>    *
>    * Sets the number of times to retry a transmission if no acknowledgment was
> - * was received from the other end when one was requested.
> + * received from the other end when one was requested.
>    *
>    * Return: 0 or linux error code
>    */


This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
