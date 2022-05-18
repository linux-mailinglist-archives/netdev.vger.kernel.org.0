Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DD352C445
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbiERUOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242377AbiERUOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:14:51 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E1235852
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:14:51 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id q4so2803251plr.11
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/Gu2oUwxEhzfvkUmWbwcxUrRaEA86FGELZr0o4UTvLE=;
        b=EYAdFw2Z5xLwqIE59tODxm8XD++xJIw7nD8YgXEC+n7FHzh/1fVqi+IVZaoMuNl9MJ
         0XLJYDNMs1+FINNLdmVKVuh9vwM+Gsk+cYXAVRBqbX+SYMGnHqUTW1WHgimU58yZbdXs
         PRciX3LK547gz+Of2g634IWp5p7CW7gI0eO5oPo9/obv53fZRnUFbadq+MYMZkzsj1JS
         wqjcG6bhWvT3EeHK9NZETpsIMExyV5we80s8hc+KhuG6TikGq0i0jsD0q3m4TlefkL37
         3A9EvErWvH5hmrMlCsN6AQ4hbYALjlDIGnraTxckiBeYev8rnzN5jhx3GudoAxu4qHz+
         jh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/Gu2oUwxEhzfvkUmWbwcxUrRaEA86FGELZr0o4UTvLE=;
        b=usYr5ymjxOBf7+U3qlLwJaxF6CjME6R1oHq2ciMv1HSOMXmtaKbckPyEZTlbjPWdvZ
         UWcPrr2itYewoGfskJEOUnd1Q+pnTqMaTPtCbSQ++Sbif+Bw77pSBDEmVsNqvrpmJQAv
         wtx/JVtUIi5f9ZMBEH9v2ptJMrUA52X44zmRek95WeROPkTaOfOlPya1EZhGqEzirmEW
         +skgHfwWx8lTAvvVWXvIVeMaGqHJuhJUBKT7ne5CUs9BSWLPeFyq0enPKsjWEEQZMYbe
         Rhl3bax0ZA9rb6n0rog/uQyhJ6VmFqcIOcWPbL2Hd0WOZbEEv0Wr6mA7Y6LX04c/e3En
         UMMw==
X-Gm-Message-State: AOAM531QA+ok975/MoOJYsHCfQCVbAtIxa/4M0BR+D4JyjaZH3++Ridx
        KnZXvCugT1SUFt+S1+AcJU8=
X-Google-Smtp-Source: ABdhPJwq4ldgJA5CQ17KYdJGdMSi/rCbWRTmvq7//DCyWtwg3FsC+rvg8PuzRgiWjbabG90E3yS+Kg==
X-Received: by 2002:a17:903:110c:b0:15f:f15:30ec with SMTP id n12-20020a170903110c00b0015f0f1530ecmr1266826plh.162.1652904890859;
        Wed, 18 May 2022 13:14:50 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902900700b0015e8d4eb246sm2126818plp.144.2022.05.18.13.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 13:14:50 -0700 (PDT)
Message-ID: <d58a9e3b-b492-8a56-964a-e9599cfe3009@gmail.com>
Date:   Wed, 18 May 2022 13:14:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v4 0/2] Broadcom PTP PHY support
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        lasse@timebeat.app, clk@fb.com
References: <20220506224210.1425817-1-jonathan.lemon@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220506224210.1425817-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/6/2022 3:42 PM, Jonathan Lemon wrote:
> This adds PTP support for the Broadcom PHY BCM54210E (and the
> specific variant BCM54213PE that the rpi-5.15 branch uses).
> 
> This has only been tested on the RPI CM4, which has one port.
> 
> There are other Broadcom chips which may benefit from using the
> same framework here, although with different register sets.

Jonathan, any chance you could repost this before net-next closes? Thanks
-- 
Florian
