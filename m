Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D714869B1A0
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBQRNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBQRNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:13:36 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6E36CA0D;
        Fri, 17 Feb 2023 09:13:35 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o97-20020a17090a0a6a00b0023058bbd7b2so1907631pjo.0;
        Fri, 17 Feb 2023 09:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hWzEwdZZUhbF2dGlPC7LWrZ8d9NkyNRAdITnKp0nWHg=;
        b=XXWU/O5T5ZoOizcrhaYyF2mhoX3+3R5Gwx9Eg7mgPjjntFUVaD+TG3aL8EMvwijHP1
         EZaChaFiQAbpAfKLdIpfsu+zg5j3IwYwOdAq+7vbHBYGhaipt4Cwgo4L9IzF90VIzari
         y2m+aLAWRwlCuaIaMMt5/yXZj1AAE5g+A2ixPxww5FK0wZZw7SyyPBSNz+wW+tFhG9Sq
         pZCh5vYs1C952i1AYmiDiPMdPH5gDJoaZA32VZ0kDph2+vDxgVEA/LD+bsyFPx1ZJZ55
         Dsql5TRPxY+kw8kWn6nwdCU3B+/Pec2XlW9XgXPICR5Tlf0S/Y/16WoNAvxlutG7ozVF
         A9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWzEwdZZUhbF2dGlPC7LWrZ8d9NkyNRAdITnKp0nWHg=;
        b=fHDb2lCctr+NJu8AyE9iP8+CoKe6pQWH9BpCMARdik1/R0YdyaXkb0t8zDNotRyIwS
         vDPoaFV6sHI99v4J0+l7DYoB3YV9b1szV03PnN5gdFDceaoZyJ/hw2MbYhc9QSRomxJS
         zvSaC26wzrLaZ3cAGLet5s8ovnNm7UbuuXZ7NlFZlExytYOwhygUQx9La9B/hJkwrSae
         OhUDwp4VLqjy30nY2XPIf9amPBWFyaDSuR64Yop7wdbnIw4AOeiCga6QLiN7lt2DUlsR
         YD6nPbiYjQzHktGkdshVqBLZ+kcEZk5NeTVnU0tKymbqkz8tUqmcEiBRLQVNlFcFHnn9
         GqoA==
X-Gm-Message-State: AO0yUKWpQ+h7bpysfZxs0Ozoq69smSHkHxn34CYr06JBOoVlrwoCaSSj
        ZtSuhnlInT4gbF3bvrFhl8w=
X-Google-Smtp-Source: AK7set+ZvXpDM0zR6qnX1BSrqjKnltkg9pOMaMJzI7FIancyW6RT6BO4nFdjX48tdSyRJNrpwVhdbw==
X-Received: by 2002:a17:903:743:b0:19b:76fb:c6c with SMTP id kl3-20020a170903074300b0019b76fb0c6cmr2827011plb.12.1676654015034;
        Fri, 17 Feb 2023 09:13:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t7-20020a1709027fc700b00189ac5a2340sm3388502plb.124.2023.02.17.09.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 09:13:33 -0800 (PST)
Message-ID: <ae41658a-ddf9-290d-e674-550372619b8f@gmail.com>
Date:   Fri, 17 Feb 2023 09:13:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: BCM54220: After the BCM54220 closes the auto-negotiation, the
 configuration forces the 1000M network port to be linked down all the time.
Content-Language: en-US
To:     "Wang, Xiaolei" <Xiaolei.Wang@windriver.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <MW5PR11MB5764F9734ACFED2EF390DFF795A19@MW5PR11MB5764.namprd11.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <MW5PR11MB5764F9734ACFED2EF390DFF795A19@MW5PR11MB5764.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 00:06, Wang, Xiaolei wrote:
> hi
> 
>      When I use the nxp-imx7 board, eth0 is connected to the PC, eth0 is 
> turned off the auto-negotiation mode, and the configuration is forced to 
> 10M, 100M, 1000M. When configured to force 1000M，
>      The link status of phy status reg(0x1) is always 0, and the chip of 
> phy is BCM54220, but I did not find the relevant datasheet on BCM 
> official website, does anyone have any suggestions or the datasheet of 
> BCM54220?

I don't have access to a system with a BCM54220 but can look at the 
datasheet, could you provide the full output of mii-diag in both cases? 
What do the PC report as far as link partner advertisement goes etc.?

You are using a twister pair cable to connect your two systems?
-- 
Florian

