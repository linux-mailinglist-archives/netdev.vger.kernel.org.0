Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF105FC2F2
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 11:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJLJTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 05:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiJLJT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 05:19:26 -0400
X-Greylist: delayed 437 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Oct 2022 02:19:20 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED70BD070;
        Wed, 12 Oct 2022 02:19:19 -0700 (PDT)
Received: from [IPV6:2003:e9:d70e:f1c1:fef2:18a8:26e3:47fd] (p200300e9d70ef1c1fef218a826e347fd.dip0.t-ipconnect.de [IPv6:2003:e9:d70e:f1c1:fef2:18a8:26e3:47fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 60649C00BF;
        Wed, 12 Oct 2022 11:11:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1665565919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZtg5Y3YtjLfjZ4AiTBdcZo4Fd7NX7MVDXLwGnUiQ7Q=;
        b=R3ttwxL9bRyb4vppo/ti1r3DgUf0lKIstR2BJ2kgWJyC2GrRAKK0BjfVkPOrl7ZbDkjJZb
        hq9g2ubZUQnl+YMJDiSbmzM3zfTnxVdFLRHWi5gWrf1+EvRG9Ymck5ESr2BIZMx+qvkfOI
        UQgPt1HWgve8lKY/3h6RAbAosTWDXdgAFFPry1XeytBpzs/efXMsngqQBwvQDtqLZ1IKK/
        i3Ksf/9wVMCl1f0ayQYHe1QHu0FsTwBHUUkMsdmozinVjrZDRitLRMlfjhapzXkME9zIi+
        meOc22QFEkVXPpXVwy45wgreNXJ85NIx+gnqQrVC/EA3a/BxKaXh/faBZ0QB5A==
Message-ID: <20f6407e-aecc-cd84-f57c-8f4f477630ab@datenfreihafen.org>
Date:   Wed, 12 Oct 2022 11:11:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH linux-next] ieee802154: cc2520: remove the unneeded result
 variable
Content-Language: en-US
To:     cgel.zte@gmail.com, varkabhadram@gmail.com
Cc:     alex.aring@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xu Panda <xu.panda@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
References: <20220912072041.16873-1-xu.panda@zte.com.cn>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220912072041.16873-1-xu.panda@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 12.09.22 09:20, cgel.zte@gmail.com wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> Return the value cc2520_write_register() directly instead of storing it in
> another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> ---
>   drivers/net/ieee802154/cc2520.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
> index c69b87d3837d..abe331c795df 100644
> --- a/drivers/net/ieee802154/cc2520.c
> +++ b/drivers/net/ieee802154/cc2520.c
> @@ -632,7 +632,6 @@ static int
>   cc2520_set_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
>   {
>          struct cc2520_private *priv = hw->priv;
> -       int ret;
> 
>          dev_dbg(&priv->spi->dev, "trying to set channel\n");
> 
> @@ -640,10 +639,8 @@ cc2520_set_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
>          WARN_ON(channel < CC2520_MINCHANNEL);
>          WARN_ON(channel > CC2520_MAXCHANNEL);
> 
> -       ret = cc2520_write_register(priv, CC2520_FREQCTRL,
> -                                   11 + 5 * (channel - 11));
> -
> -       return ret;
> +       return cc2520_write_register(priv, CC2520_FREQCTRL,
> +                                    11 + 5 * (channel - 11));
>   }
> 
>   static int

The patch itself looks good, but it does not apply here:

[stefan@localhost wpan-next]$ git am -s 
linux-next-ieee802154-cc2520-remove-the-unneeded-result-variable.patch
Applying: ieee802154: cc2520: remove the unneeded result variable
error: patch failed: drivers/net/ieee802154/cc2520.c:632
error: drivers/net/ieee802154/cc2520.c: patch does not apply
Patch failed at 0001 ieee802154: cc2520: remove the unneeded result variable

Against which tree did you make this patch? Could you please rebase 
against latest net-next or wpan-next?

regards
Stefan Schmidt
