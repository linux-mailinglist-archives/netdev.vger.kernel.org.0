Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4007D510629
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 20:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349671AbiDZSEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349647AbiDZSEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:04:23 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F41E26552;
        Tue, 26 Apr 2022 11:01:15 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n18so30983319plg.5;
        Tue, 26 Apr 2022 11:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zUoXhYlEPUwygJjdo5BRN5pmDVa+7E+PlxHMCgZpZ0w=;
        b=hcYsRmt4lBqSWMgHEvkZnwOyFsjQ7evTB7ufr2P4rNl4239Uy5JZ/QRzy2x/OPD0ba
         2edErYgTbvDSx42epM+9ejtS89q4fYe7wwwmvdAjUpu8DnLmsF29efzUUR620aeZNz0V
         1f99LFrC27/RseSqbFbg8tS28LMaM8KDeh2BvnZyaPSECvk2NUE+XjAQY86bCzS5RuMZ
         +Keyys9FVNQuq4uUU4dImF51sFYbji97PHZN12fn4EmyrjLQiQiYdk2vgZ4QELCqP2fn
         WTivWVlcUbwuZApEK/AMzP+jRKxtdfOSehhA8unbAvcjaxFmEgJe7LVmH4gt2qf9mT6C
         7BPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zUoXhYlEPUwygJjdo5BRN5pmDVa+7E+PlxHMCgZpZ0w=;
        b=XgCo9hZz+iQB+5yKoUWjn3MQnRNUF+/D2b2Ecv14/BIkkBVEzGMspqvCwjn28tOvFy
         rjZrvDu2udupE3Xbh2FfMVw2nT/dKIrH58212yR+2MuS4tr7anLr5boI/6j4Me6rCNHU
         pW1Lq2u+0tV9x76cAl3lJPMMLyKoZKXZWOydOPgnjRVU6s4BlFky6kTlyuunVtBjxvrd
         xFLhH4EhnpHDlwpD1MokhN6xlOHqdgRCacrA69MO/rlRPOW8ICVpXrHmpyzGOumYhYUY
         UjAxwRLypO2foZPWFxtxPiA+gaAkuuzw0006OQVXwkEHyoHKFHLkRkbMQRasry7vBm7x
         WsBw==
X-Gm-Message-State: AOAM533f59KvXymAhcRh30QSY9wzY8oJQaQC1xEYn9cVfCRcOfR4xGUT
        w3Bz2aM6Ed5kYxPEzi/+1zY=
X-Google-Smtp-Source: ABdhPJxB35ksz2ue4CmyT2YMIpGvVDGSIP6OdyoL8XDkntYdMY3GPTUXqstvmhpGyQiDDfr7aRw+3Q==
X-Received: by 2002:a17:902:ab5c:b0:15c:ea3a:9437 with SMTP id ij28-20020a170902ab5c00b0015cea3a9437mr17694095plb.9.1650996074686;
        Tue, 26 Apr 2022 11:01:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z6-20020a056a00240600b004e17ab23340sm17522657pfh.177.2022.04.26.11.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 11:01:14 -0700 (PDT)
Message-ID: <bf92c94b-3559-d56a-9264-557ebf3845dd@gmail.com>
Date:   Tue, 26 Apr 2022 11:01:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [Patch net-next] net: dsa: ksz9477: move get_stats64 to
 ksz_common.c
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
References: <20220426091048.9311-1-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220426091048.9311-1-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/22 02:10, Arun Ramadoss wrote:
> The mib counters for the ksz9477 is same for the ksz9477 switch and
> LAN937x switch. Hence moving it to ksz_common.c file in order to have it
> generic function. The DSA hook get_stats64 now can call ksz_get_stats64.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
