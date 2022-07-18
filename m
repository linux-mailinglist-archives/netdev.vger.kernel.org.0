Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88025578AFB
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiGRTfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbiGRTfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:35:40 -0400
X-Greylist: delayed 73 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 12:35:37 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB11B28E34;
        Mon, 18 Jul 2022 12:35:37 -0700 (PDT)
Received: from [IPV6:2003:e9:d737:b8a6:bfa9:9b4a:f710:ca2f] (p200300e9d737b8a6bfa99b4af710ca2f.dip0.t-ipconnect.de [IPv6:2003:e9:d737:b8a6:bfa9:9b4a:f710:ca2f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 0C78FC0539;
        Mon, 18 Jul 2022 21:35:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1658172934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1paUxRvc5eH+J/gzQtPeczchHZdGTnFA1uKl01VTyhg=;
        b=qhAp9vf3GMmPW0/JhhGmGqk0tX3xDLQO+DUnxFkDyFEBL5pxCIybKhd660On+mg85dClmJ
        OpuaukTSAZoSqFsdjntZonqy6f7PNDUPmUyb6ikkvOYE6vbCdMksyw+MiNRlsFYymftn63
        zMSYF3HT3BZ617IBB0goBeBcTRcOvlIDPupE/g3nNpA3blSkyzoyTHzv5redHLDfDwU0FA
        xjHOS4Fxz8e2c5An2V8yhUhmoS/6PCVxQ32+BAfjTRzMlcMgGqJ4agZ7SS0XINw6HAhFbo
        V18jsmL2eit1yP3rM4VWELIYS/CNZL4n9cCtGmhR7n9llFoLHMaLI6XaCwBufg==
Message-ID: <b992487a-5c0e-35ff-c789-d1f6133064b8@datenfreihafen.org>
Date:   Mon, 18 Jul 2022 21:35:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] net: ieee802154: ca8210: Fix comment typo
Content-Language: en-US
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     alex.aring@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220715050748.27161-1-wangborong@cdjrlc.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220715050748.27161-1-wangborong@cdjrlc.com>
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

On 15.07.22 07:07, Jason Wang wrote:
> The double `was' is duplicated in line 2296, remove one.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
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

A similar patch was submit a week ago which I finally applied today.
Which means this patch has not been applied as the problem is gone.

regards
Stefan Schmidt
