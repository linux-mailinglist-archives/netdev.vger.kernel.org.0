Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC69659AAC9
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 04:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238584AbiHTC5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 22:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbiHTC5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 22:57:47 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667DEC2758;
        Fri, 19 Aug 2022 19:57:47 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id y18so4604987qtv.5;
        Fri, 19 Aug 2022 19:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=8nQrH+5egSaKXmqGf2DeUinczEZu8mYWEg+gHBiviSU=;
        b=Gtf0A/jKvkV2vWwClpTd0jS/+xh+stTbAaObdMDVXVCSMC1kH4oX+3EvemiQMv0Cu8
         1LGawVSnPEOm4Hp5oAWCUxa5RKXH07Ppz1HTDMaVcMK6bSr/vB+BrMqXy4oEFImM4h0f
         7JBp4QFRl3Jvvz/p8V74YfNl4xSZ8EY63pmSCG64BmRQe25jzsknraUjVdIQdz/OC3cy
         UuLRw7VuZ0UdTkl+TndOCd+r2J3MAJ2DIuZgLuuav26yBEfl9LmnV0LiUhQ/1PIzImRh
         m/zfH4d3VhCFI97veWqToobKVYWlHUTgkEqDXyfsBrKSsAEz/88G3vy4DDs6lJBRt7HV
         7Kww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=8nQrH+5egSaKXmqGf2DeUinczEZu8mYWEg+gHBiviSU=;
        b=SKKCb201MlDlxuSZz0PQTisc7d8iUKIUi8zHGjgXi/PBBE/AByX4t3INvrw5BK8mox
         YxZWnwPV5Gw9rftZgzG6SK0VxoL/NsNIzHvg9a1PAt0t4QuXj0GOGh47gdLPBcwkud/U
         QJYj5e9SrH0M44kPCL+EQ9YWNP1rAOpHQ/nmNFqD6y7pkRfDXBj3pzBOsJIFdqv4C1qT
         vPz3NvtH9D0SFC7/hzTtJ/vk2JAG5Wnz6xfbHMDzafyP5aUlqXzc4SAIaai/M/SS2jjJ
         KhSmuFw+p6DtPEwyNghOk58i16be0me8dDvc+nxvJ/d6G6sotpd4fsc6H40kih7mz4Aq
         LcRg==
X-Gm-Message-State: ACgBeo1q7zZ0pqk4JzTe+jPm7XK9jNY6D6fWl8JhFe8/MVAic3xBW5K3
        C4851TbosmK+y5xr8bPHmjI=
X-Google-Smtp-Source: AA6agR78A0Laf5T37YKB/npSsvs01FaWGZdSADrqD2iOzKUlv3SufyA9pTXdFOx3Zfwi6Yrt/jeHGQ==
X-Received: by 2002:ac8:7dc1:0:b0:344:6104:eab6 with SMTP id c1-20020ac87dc1000000b003446104eab6mr8674172qte.455.1660964266497;
        Fri, 19 Aug 2022 19:57:46 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h10-20020a05620a284a00b006b98315c6fbsm5176381qkp.1.2022.08.19.19.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 19:57:46 -0700 (PDT)
Message-ID: <cc31738f-53d7-df04-03fb-f6a32a9493fb@gmail.com>
Date:   Fri, 19 Aug 2022 19:57:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [v2][PATCH] net: phy: Don't WARN for PHY_READY state in
 mdio_bus_phy_resume()
Content-Language: en-US
To:     Xiaolei Wang <xiaolei.wang@windriver.com>, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220819082451.1992102-1-xiaolei.wang@windriver.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220819082451.1992102-1-xiaolei.wang@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/2022 1:24 AM, Xiaolei Wang wrote:
> For some MAC drivers, they set the mac_managed_pm to true in its
> ->ndo_open() callback. So before the mac_managed_pm is set to true,
> we still want to leverage the mdio_bus_phy_suspend()/resume() for
> the phy device suspend and resume. In this case, the phy device is
> in PHY_READY, and we shouldn't warn about this. It also seems that
> the check of mac_managed_pm in WARN_ON is redundant since we already
> check this in the entry of mdio_bus_phy_resume(), so drop it.
> 
> Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

I see the use case you have and it does make sense to me, thanks!
-- 
Florian
