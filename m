Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7554850D14B
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 12:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbiDXKul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 06:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239262AbiDXKua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 06:50:30 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336F66A41B
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 03:46:26 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id be20so6985904edb.12
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 03:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oVzC0K1km5FEf2DIMcp/bBz0zXKBQJPc+peDEO70pFw=;
        b=eE4/atb+2bnxStPsWNWQynLIYa6sos/23pwlEI4ZWeAIZg9VLhXXpLKT91SOE8rKLd
         9NFgAhngTLmeoWN+ZxxSzxkSYo03Vfxs10wn5LRwwx9/E4EEO92AEAE9Kh01oSIKUX0W
         YDHzEtv/j/KI0xRcBGsgS8VQ+ojRj8Vlr4ZC1or0wokQGFxlQXq8KjzPjqU3ue0c9RDq
         xOi/b7B8YI3Qs7iYE/mo3i5VMhGoQIxCoSe15cLxp4CzGL44n0J9YCX4eMagWyl1LXeQ
         WCP48zPT8gWVaKBSPhKDHx+OpLpbBtPMzt56PmQNnfozvh8Mno2rAPYR2Dq4km5u7PVt
         wDLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oVzC0K1km5FEf2DIMcp/bBz0zXKBQJPc+peDEO70pFw=;
        b=1t+E1LwyCa+IWMwOx4EBUty4JalppaUZTnKcVaf794P6moydNHW3M8RF2R6td/HoDQ
         4N2iYOGuFn8DPM88iUVj9KTkqeJGIxqexscL+1z6nLHSnpfCvm7bKzHBTJkCHmpolcdH
         YBPuLfjbgdOZH3dzMBUMHSFHDGBHn1PENbhYkRf/75Do3w61WfKNavrNEQbYfDR+Uu7W
         v3ic4xmai7LdUJdEWU4ZZRGpXUmZIzTu/GFbdj4QNRioK5F6ldyrs2sORka8TpInt8Fw
         VcqSaOn3f47ElcXFiHlkGC3tSPLEVtQvXNgctjJxbKvLI6k7QTFtUdn1TpAQ2aSY8BXY
         Bopg==
X-Gm-Message-State: AOAM531708fli/ABdAiDbT4TwJEwmJcRrM15rkFqJXCiEizDY83Ui0Fx
        lIQp/EJ4qgcB2Nparq8F/7Y4iw==
X-Google-Smtp-Source: ABdhPJxi9Zu9pA68t2SKh3CaPN6uN1KeAiTz3nvDye6x8cCHE+Tt523sYDTwB24S/ljcwp0ljpj2Xg==
X-Received: by 2002:a05:6402:254e:b0:424:244:faf with SMTP id l14-20020a056402254e00b0042402440fafmr13787137edb.260.1650797184999;
        Sun, 24 Apr 2022 03:46:24 -0700 (PDT)
Received: from [192.168.0.234] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id la23-20020a170906ad9700b006f3902ba948sm290806ejb.168.2022.04.24.03.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 03:46:24 -0700 (PDT)
Message-ID: <c990d0be-884c-2ae9-6161-ef50c89b00dc@linaro.org>
Date:   Sun, 24 Apr 2022 12:46:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] NFC: nfcmrvl: fix error check return value of
 irq_of_parse_and_map()
Content-Language: en-US
To:     cgel.zte@gmail.com, kuba@kernel.org
Cc:     cuissard@marvell.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, lv.ruyi@zte.com.cn,
        netdev@vger.kernel.org, sameo@linux.intel.com,
        yashsri421@gmail.com, Zeal Robot <zealci@zte.com.cn>
References: <20220422160931.6a4eca42@kernel.org>
 <20220424025710.3166034-1-lv.ruyi@zte.com.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220424025710.3166034-1-lv.ruyi@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/04/2022 04:57, cgel.zte@gmail.com wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> The irq_of_parse_and_map() function returns 0 on failure, and does not
> return an negative value.
> 
> Fixes: b5b3e23e4cac ("NFC: nfcmrvl: add i2c driver")
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> ---
> v2: don't print ret, and return -EINVAL rather than 0
> ---
>  drivers/nfc/nfcmrvl/i2c.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

How about Jakub's idea of squashing here fix for SPI (correcting my
patch) with additional Fixes tag?

Fixes: caf6e49bf6d0 ("NFC: nfcmrvl: add spi driver")

Best regards,
Krzysztof
