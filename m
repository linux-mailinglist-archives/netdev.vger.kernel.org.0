Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DAD52014E
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbiEIPpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238400AbiEIPpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:45:35 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894311EECD
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:41:40 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id g8so12565897pfh.5
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 08:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0hvqCAtu2LJyWrSW4potgPwwZquB2LshhfeXp+f9aUI=;
        b=GBrOt+3+iRlX2FN8Wu+sUIbbsCtolUn8i6YRTDCJQFn+w7AFhmyFzX6MS3q1ebpF57
         j5s1SFOhT9UZvkpmZCUuaEMaaxqyXlRHq4306Er2Hlvk7gcTOFE97Uktud6S4V68wMI5
         iV8uynTmB1kOlWeOSUaWS7tRN6zI0CdQKgHvs/z/DNUG5mxAGedBOk24LlOFfBSy94i6
         10JieFXVTvTGIzGVlpMwHe4QaZ5xTJNBEt1i8RqtTyeQ+vZxmXyw96Vb9JQPeqeZrGEg
         6o3NI0UWu7R9Edya25Z7u6bPG0948yrZm/N4LJtNlDwAvS0d4UBQkkdKjm03HZ68ESsR
         qILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0hvqCAtu2LJyWrSW4potgPwwZquB2LshhfeXp+f9aUI=;
        b=a6Hf9RU2Bq+mvpoAn/sYhSJwsDZf5lS2fgPVwpgoA4wjm+XEYgQwBaO25eii5bO4ZB
         5aqZrfgDlJjBO5L/Gpb/SAcufbVZviZrjwMq/kE+ot4x2iXMNl5KAJAwfoJ0iAtOoKsR
         qf0NOsshxNVH+0r+mP8fxVT0TEzLPYPmuYgCwKEe62EAlv2fW2lgImSl+od83uUoP7HD
         ErQKfAIIw4u7V4rfk2DQyp0GvU3qVeBiZaq+vBmBzHsOHOh9Ce//6po0VVsUyGrwitj4
         5BBbRTyCxAG5eHGm+Ur/kzz5LqTBPxbz07JcEed9EMzJZBex72GjhAYpEWfQVsz4i8z8
         2ZmQ==
X-Gm-Message-State: AOAM531BW2sm19Mf+dmWkHlT+VbczZJmaemoxpGL02rqzFDiA8rF2HIe
        j1eYwIeEvlRYpqyhY7HbMG0=
X-Google-Smtp-Source: ABdhPJybUkChPlUwKSi1ZyMgKFFgXwvzToUmEFSqtVcuxgMjIVHPm0VnzNc+mY1W92OTclSKBJ15Ig==
X-Received: by 2002:a63:82c6:0:b0:3c6:4472:3dba with SMTP id w189-20020a6382c6000000b003c644723dbamr13447002pgd.562.1652110899882;
        Mon, 09 May 2022 08:41:39 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a23-20020a1709027d9700b0015e8d4eb2c3sm7313723plm.269.2022.05.09.08.41.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 08:41:39 -0700 (PDT)
Message-ID: <78133b16-7e33-7329-3300-a30df16ada5d@gmail.com>
Date:   Mon, 9 May 2022 08:41:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 0/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII
 support
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <CAJq09z7+bDpMShTxuOvURmp272d-FVDNaDpx1_-qjuOZOOrS3g@mail.gmail.com>
 <CAJq09z5=xAKN99xXSQNbYXej0VdCTM=kFF0CTx1JxCjUcOUudw@mail.gmail.com>
 <4724449b-75b2-2a25-c40b-e31bfcffa7ff@gmail.com>
 <20220509154038.qt4i6m2aqxuvhgps@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220509154038.qt4i6m2aqxuvhgps@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/2022 8:40 AM, Vladimir Oltean wrote:
> On Mon, May 09, 2022 at 08:36:19AM -0700, Florian Fainelli wrote:
>> On 5/9/2022 12:38 AM, Luiz Angelo Daros de Luca wrote:
>>>>> Hauke Mehrtens (4):
>>>>>     net: dsa: realtek: rtl8365mb: Fix interface type mask
>>>>>     net: dsa: realtek: rtl8365mb: Get chip option
>>>>>     net: dsa: realtek: rtl8365mb: Add setting MTU
>>>>>     net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
>>>
>>> I didn't get these two, although patchwork got them:
>>>
>>>     net: dsa: realtek: rtl8365mb: Get chip option
>>>     net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
>>
>> Probably yet another instance of poor interaction between gmail.com and
>> vger.kernel.org, I got all of them in my inbox.
>> -- 
>> Florian
> 
> But you were copied to the emails, Luiz wasn't.

Yes, that much is true.

> I'm also having trouble receiving emails from the mailing list, I get
> them with a huge delay (days).

Time to switch to a different toolset maybe: 
https://josefbacik.github.io/kernel/2021/10/18/lei-and-b4.html
-- 
Florian
