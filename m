Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C01A520141
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbiEIPkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238342AbiEIPkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:40:17 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7595240E61
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:36:22 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id bo5so12555277pfb.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 08:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/H8X/t96Z0Ja/vl3a5IQ5/81ZYUwm6CMVw4j5Buqh7w=;
        b=ntvNPUBJPhcuEj8Zc5lwaRsDGEhhpYh70UsvIG3x+U35M48Rkk6iEaFDZk3YoZXLmj
         WZHSO6XNItgSw/TJ58MpjNkORXW2QvYdBkzOAxoEDUxaqPn97MRaEBEcf3Fnth2mleBF
         vBsN5hLRCBG0LsmpvNPw8NJnNbMPTIs8KX84o0i0zedUZAXTqFWugVzYAWAbPy2jTV82
         Bgzank6vxNjZraVmZp2cCL3zyw4MsYQDVHwfp+D6ezkzlIi1hYelL+nxCvYYoLjaAyXK
         ZAMxgHJ3IhP6TT8UcEU21aGDUsvWaxEGXsvFGJr9IBKMa3XdUi1jW2cqtRFR5bgbkboC
         VmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/H8X/t96Z0Ja/vl3a5IQ5/81ZYUwm6CMVw4j5Buqh7w=;
        b=u3UpWdb3siGDjo5Q+bBVU3BctC8jkMe9nyE92uawgpK3GgomceBzGmuQQdTWxCV58y
         ecNr6/hYocVpIN5+SupY8ebbrRmb9xtn8pYcEvEHFCB+wso5aHdxcWGZHQx5zTgMoU8D
         NvuXjYT3d9LKEsgfu+qOzxuFjSDc1MWQt0F3BtIfyCdQE7OVH0l+YC44L9oKN1TphIqT
         zPuhWsfn8Qw+2IpOEUOixjzGnn8uEXafO6oBYZPZ0CR10TfBu0WA4KbR8JPRv1/sjava
         BIeWx5TJd7MSdGZk/rTtIUInrWWDgB+hDUa78oj0JgS9EG3+q5EUnp+G02WRXeSS2Ivc
         dzpQ==
X-Gm-Message-State: AOAM530ZGEOEmtMavz/iodHwkbHk17RY0Ey3aYrL1sidiuZRa0ydh2fU
        Bq7dBX8wGj45J2hdecBXCh2jDswhACA=
X-Google-Smtp-Source: ABdhPJz71z4mEHE+qnueHSh3hNZ0KxbE266QnlLKt655Eah2E0CxSCm4e1JTXGvWDZdoiIrF3eGXKg==
X-Received: by 2002:a65:63d9:0:b0:374:6b38:c6b3 with SMTP id n25-20020a6563d9000000b003746b38c6b3mr13763321pgv.195.1652110581733;
        Mon, 09 May 2022 08:36:21 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id v7-20020a170902b7c700b0015e8d4eb2bcsm7193516plz.262.2022.05.09.08.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 08:36:20 -0700 (PDT)
Message-ID: <4724449b-75b2-2a25-c40b-e31bfcffa7ff@gmail.com>
Date:   Mon, 9 May 2022 08:36:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 0/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII
 support
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <CAJq09z7+bDpMShTxuOvURmp272d-FVDNaDpx1_-qjuOZOOrS3g@mail.gmail.com>
 <CAJq09z5=xAKN99xXSQNbYXej0VdCTM=kFF0CTx1JxCjUcOUudw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAJq09z5=xAKN99xXSQNbYXej0VdCTM=kFF0CTx1JxCjUcOUudw@mail.gmail.com>
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



On 5/9/2022 12:38 AM, Luiz Angelo Daros de Luca wrote:
>>> Hauke Mehrtens (4):
>>>    net: dsa: realtek: rtl8365mb: Fix interface type mask
>>>    net: dsa: realtek: rtl8365mb: Get chip option
>>>    net: dsa: realtek: rtl8365mb: Add setting MTU
>>>    net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
> 
> I didn't get these two, although patchwork got them:
> 
>    net: dsa: realtek: rtl8365mb: Get chip option
>    net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support

Probably yet another instance of poor interaction between gmail.com and 
vger.kernel.org, I got all of them in my inbox.
-- 
Florian
