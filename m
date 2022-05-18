Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD32252B3E3
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 09:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiERHma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 03:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiERHm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 03:42:28 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A80119936
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 00:42:27 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s28so1271934wrb.7
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 00:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PZe7B1SAg/NvAsreeWm7hbTi5QirWdQpQUJ5L0AorIU=;
        b=vgklGlMKW7F2bY/DKtwbtFMI3EA0MYdrb0Jv/Y3163/Kcq1jzvCRLEL2ftkB2ILKBL
         +jTzWV3ec8EsE70szAevGBz4mMj+AH8DVFgc5a4nLRCNapiYmacxb1TEr3ckFdRbfX3F
         dArJhK5QhgK0b8KWmoBKa4WqmuCv479JqpphOQ2tF5ooKtH6sl2SUoPrxQtWpOiApypo
         VO4ICZZ+CwPCeQE7xpTnkKRMDrzjr9QHzlNabW5cVQwYE8QE0yR0yAmGsvsloWQeSOIo
         qudmbo9QrWxCDHNc2GLW+IW+SBUqqhBCsZ+yps4aqasTwb6/LDYYSSv4SY+mVXteYLK3
         sEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PZe7B1SAg/NvAsreeWm7hbTi5QirWdQpQUJ5L0AorIU=;
        b=xkVew+ZVcPmmWUVzz0hj7bPF473l77nK/+2jXLQG1LI55sWDRXy7OmL1hkqir4/TDl
         9LSaeAM8q28WEb8Fbf65TrAw0P7+qhBo9K/f3VYRk+ikm3Ho8wqcarT5wIOO25NvqIlx
         IBJBHbeOu0vHM9mzEGUmeya/wAfzsWfegc33W34lbbwX55DVXQn/QBpkTtLaatiD1zb4
         N0MOMgQD1E5qso6cFC76BHlh4wfTLplwwH7/szTeFOEPW5YsWNDVcPqWjU6wpPHrTe8K
         RQu7uYfd3me1bYkD8V7KFpEtMaSYPdHOfh5gGkapWqfSDsHXRO2Dgpi9C0h+QMhf5nSr
         5T5g==
X-Gm-Message-State: AOAM530AppiZvsccbwmdaTBhLI8cwfAmJsv2HsSdjYbW/srEVVVoq+uO
        IMo7kYbhiGB7psy1cD1MEsDXCf0aDzi79Fgzb7I=
X-Google-Smtp-Source: ABdhPJyiYMjqpL30BhGSH1v8571TGtFA6rIMZ/ZQVjfsHk0XJ6O7lTuwWZSUHQ58ND6IVFDCZ1iT9w==
X-Received: by 2002:adf:e10d:0:b0:20c:dc8f:e5a5 with SMTP id t13-20020adfe10d000000b0020cdc8fe5a5mr21995763wrz.265.1652859745763;
        Wed, 18 May 2022 00:42:25 -0700 (PDT)
Received: from [192.168.17.225] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id 19-20020a05600c26d300b003942a244f35sm3446362wmv.14.2022.05.18.00.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 00:42:24 -0700 (PDT)
Message-ID: <a9bf6238-b777-75d7-5c74-86dec47ee330@solid-run.com>
Date:   Wed, 18 May 2022 10:42:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20220509122938.14651-1-josua@solid-run.com>
 <YnkN954Wb7ioPkru@lunn.ch>
 <1bc46272-f26b-14a5-0139-a987b47a5814@solid-run.com>
 <20220511154838.7ia7up6uys55nc2t@skbuf>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <20220511154838.7ia7up6uys55nc2t@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

Am 11.05.22 um 18:48 schrieb Ioana Ciornei:
> On Tue, May 10, 2022 at 11:56:06AM +0300, Josua Mayer wrote:
>>
> 
> Hi Josua,
> 
>>>> On the Layerscape platform in particular these devices are created dynamically
>>>> by the networkign coprocessor, which supports complex functions such as
>>>> creating one network interface that spans multiple ports.
> 
> Are you sure that by multiple ports you do not mean multiple SerDes
> lanes? Otherwise, I do not understand what you are referring to.
It is very likely that I meant serdes lanes.
However the concept of my question only makes sense when their 
assignment to netdevs remains fixed.
> 
> The dpaa2-eth driver will register one netdev for each DPNI object
> (network interface) and will control/configure one DPMAC (MAC).
> There is a 1-1 relationship between these two.
That is good, so the dpmac nodes in device-tree are good objects for 
linking LEDs to.
> 
> Ioana

Thank you for the clarification!

sincerely
Josua Mayer
