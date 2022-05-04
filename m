Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1947051ABF2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 19:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359514AbiEDSB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 14:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376584AbiEDR76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 13:59:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F1F56766
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 10:14:16 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so1808477pjf.0
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 10:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=JVM5nOO1w0pQ3xB8W507RNZ8sMBOPglO0nbyVRE3h60=;
        b=hb6lZYUo2W9Lg5hDDjLhBFGbqKI7IELnLTqFYXM/AX5nbnUnjMuWUoL8GTYWbtbidH
         WsLhoT3Rq0uZHE9fVXRoPEZi6zemJM6kItCXsNmRIb5ob2pvUL+Sxc4u/Fc7yoKW/7a9
         MQIscOc9fT9m0DBeWY4Hnj7bWmEKNLToHPnTx1xOWBGC/TQpzVQFBN4d/tRJHyDIkRDy
         DtjIFVl8XGln+6WibtmqhImsjSfBBn9gqFqr1n3TF8cupIWQlnnXdKv1BnE8rGh6AbHg
         1SD8pS4/TFchg07I6g6ohCozxgUY3z5M4ydx40tYDoKLi/CpshuAV6W7B2909kVj7sVZ
         zgKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=JVM5nOO1w0pQ3xB8W507RNZ8sMBOPglO0nbyVRE3h60=;
        b=JC1qEoCWa6cJwcbYlspjwebHOvVVW1dpEiAQj1w+g73T/O+JNs+JQ8OuQQici6nPwb
         sjjcwvpBOtEUZrTFj0cgN42O+1L7kBEHQuWIRds/UaXARFsUia4hN1/dDOLiTBuHiMNT
         q6Oikpbc4O9q4qeOUBhnvhG4IqyUD4hBNub5D/ZjpcYmtJAmIJ0aflutswBOlLbTGYaz
         28JiATcWvjh32lv9zRWqfnMKrDytU08wv/x5Q08/XlPNLdZOmriYCWAqzRzZ/X/fWTts
         OyYbN8OiGQc78rAW5RZ50VGvJtUFnbK4bxvVGrcyAgM81LFEhTDtFVV96CsNUXYaAYXJ
         Pd1A==
X-Gm-Message-State: AOAM532VYhIVjHFdDrm9Ac80DiCf3NnARUscHVt59JLrm05XSQxetRFa
        8IYN9GTX0II1dvpAojotdTQ=
X-Google-Smtp-Source: ABdhPJy7sjoKyQya6j95PEgMAOAfMTcVX3uBP6F/7MW6Nq2ZgfeK7VCGBN/dKD97QX6OHpwBSI0lxA==
X-Received: by 2002:a17:90b:4a90:b0:1dc:4122:6a70 with SMTP id lp16-20020a17090b4a9000b001dc41226a70mr537133pjb.216.1651684456145;
        Wed, 04 May 2022 10:14:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n23-20020a17090a929700b001d7f3bb11d7sm3508931pjo.53.2022.05.04.10.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 10:14:15 -0700 (PDT)
Message-ID: <7bde58d4-dd0b-e403-1aa2-1b024f5d07e1@gmail.com>
Date:   Wed, 4 May 2022 10:14:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: imx6sx: Regression on FEC with KSZ8061
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>
References: <CAOMZO5BwYSgMZYHJcxV9bLcSQ2jjdFL47qr8o8FUj75z8SdhrQ@mail.gmail.com>
 <3d6aa110-8172-378c-c89e-7601111c8730@gmail.com>
In-Reply-To: <3d6aa110-8172-378c-c89e-7601111c8730@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 10:13, Florian Fainelli wrote:
> On 5/4/22 03:24, Fabio Estevam wrote:
>> Hi,
>>
>> On an imx6sx-based board, the Ethernet is functional on 5.10.
>>
>> The board has a KSZ8061 Ethernet PHY.
>>
>> After moving to kernel 5.15 or 5.17, the Ethernet is no longer 
>> functional:
> 
> This should help because kszphy_resume() calls kzsphy_config_reset() 
> which sort of assumes that we have allocated a kszphy_priv structure 
> from a probe function. Whenever we do not use the standard 
> suspend/resume function, we need to make sure that we do have a .probe 
> callback essentially.

And I just came across your other email/patch submission, never mind me.
-- 
Florian
