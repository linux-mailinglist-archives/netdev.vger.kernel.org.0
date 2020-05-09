Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D271CC324
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgEIRQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:16:58 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B98C061A0C;
        Sat,  9 May 2020 10:16:57 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t9so5723131pjw.0;
        Sat, 09 May 2020 10:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2MDoEfp7/j6oLrWCn1DJlQ3f7drg5+7hOAc4oVDov/A=;
        b=GdN2sJDy0p5/zAtSaCRGBI3HfWq/g3p35r8IhK6LKSYrcqre8PWhKb3F/HPWJiQ4tB
         OYaxx3xU+mD5AWTTwM5Si7dxvUhVLktDjOpu3mlELpLtES43vQbfP9WffeczQCg5ESJ0
         U/+/95/lxx2epdjpsKzOH/uxv/2cC6SSTNOxJIxKTxAvzxum9l2Trn3jXis3JVeYv6Uv
         r8WDR5Ka8+weGDOqqS9yJ6A/1obX1RxdA6pu+RJ8E30F3G8fMU2MyvUSFJ+TrnDvXyrg
         XiC/2AX/cJn5igxgM1anJkQSSgwckKBTqpU9r6zwwrYRTVyVJnsxylcmCfthhvvS930x
         WNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2MDoEfp7/j6oLrWCn1DJlQ3f7drg5+7hOAc4oVDov/A=;
        b=Zr6vRpz8r0Xv2/Ik9VHoL3100SJocM7MAKjxyV+r8ej0q/F1/xgBMM4d5Kx2rPZpHa
         5T5imzkn/86014K3/k41tmJxSQeFeczZfziwbLQ3etTj+sajH6DdyDJUOHFoUnBbTnp2
         eQrqnUJdieOZZbwlCxhw00E2OQQihEYtEsIv/hv/ZgOavHLED5YHdSlQBLE587g9S/GC
         LIzUZ4kdJDcTMs1sevdslbjtMQap3HFJp6zBzMIRxcjfsngRUPS1rXOd+x2XocMj9JKN
         EeN3tiBDPU2mZjwLrAti3AG/y+ilwwTX7R1UUFUkpIQPK/nIOD2xTThWlc4Ie0NJI55z
         fzuQ==
X-Gm-Message-State: AGi0PuYTv7zJN9eTAsNjbfzGpvBNafAA85gmavhWz5xtkPOIyEwtP6G1
        W3Hdq2GTIm46gPvJHzqXOIQd7Nol
X-Google-Smtp-Source: APiQypKO7I98qQU2kj6lM5hjtkBKM3lNnJkmJ6xQeBW8kcKO/S0Twzu4knNn604mmh6MlUBsIdyfVg==
X-Received: by 2002:a17:90a:37a3:: with SMTP id v32mr12984080pjb.2.1589044616658;
        Sat, 09 May 2020 10:16:56 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 78sm731190pgd.33.2020.05.09.10.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 10:16:55 -0700 (PDT)
Subject: Re: [PATCH v3 2/5] dt-bindings: net: mdio-gpio: add compatible for
 microchip,mdio-smi0
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de,
        devicetree@vger.kernel.org
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
 <20200508154343.6074-3-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ef4255d8-ceb7-2e0f-9519-ad374ea99fb5@gmail.com>
Date:   Sat, 9 May 2020 10:16:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508154343.6074-3-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/2020 8:43 AM, Michael Grzeschik wrote:
> Microchip SMI0 Mode is a special mode, where the MDIO Read/Write
> commands are part of the PHY Address and the OP Code is always 0. We add
> the compatible for this special mode of the bitbanged mdio driver.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
