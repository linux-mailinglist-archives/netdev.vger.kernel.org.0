Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019FC63F982
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiLAVBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiLAVBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:01:33 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075D5BEC71;
        Thu,  1 Dec 2022 13:01:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so3282567pjd.5;
        Thu, 01 Dec 2022 13:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LRq1OL6Xj9pmq08PnRJaytzi6oZ4smB3yIcsOA6bRZ8=;
        b=mL/QChE2IM6Sa+fr7sGjHdhpKLgydMltDYaZP3WHB98HQTtWKBzZBJ+MlB5LKoS6kr
         CKU4uuTE1Qs8d5dKkTq2KSCAtX1qlVYGnIF9pNZdwIaPZHBlQj58xst48Nev03oEO3G9
         ox/cIyJuMcOv7BrK67pVJgaJLOOcfh2HAJCj92YKqru70tPx+HFip1yh90mLfEVvXeSH
         +vgF4D0ALutmTZH4ZIHjzWWH3qg/Fm7p/XMXL7ahtnulI5XkQlVIiTqOCdQut3OgFx9X
         Li/+WJutX+j0Tc1GoJxIaiml4E4ZOS1ZJFE6KUAiMSRs0tkNI0CQkLtsFvKae+Iqe2AB
         /BHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LRq1OL6Xj9pmq08PnRJaytzi6oZ4smB3yIcsOA6bRZ8=;
        b=wADOf3r278pLYrGKCeP+G/FNGyW+Zbh97IbGaD2E+wDuo0wnld5xk4Ogvt1T3zSm7H
         ncU4hgrG2V2VM1le8uPAw/PCTxYbuYZ4UqF8SoazVVXHNfrKDsu9X/s3QJTCqThrr0x9
         aU5ztkbHVjQEt2Je23hb0/43Gu+EWtcFcA6pusbyBGGEUQA5OQf5UOVapTfRTGWL7A2S
         kiuXO7agSf6G92h7R+YmOMp7jLoLnGJsvlXcI4d/bQf25WHKz4Rx2az1EZveZv6i3epi
         Q6bZaJIXkFF0ltfvGaVOeF2xI53i/kxX6qbE3YRvllPb9tBgmf0suvTjKtdCUttQIXKG
         KCrA==
X-Gm-Message-State: ANoB5pnhPb+8HhjrInVTM2R/uNiLH/8Y9thSY8eTQjk8ygzpd/1XMkGs
        BOA3diEIsEkIgvyDYqB/dfA=
X-Google-Smtp-Source: AA0mqf6kwzXSHtomF6UgbQTjc6L42lOm5imMB/D9GPDhjeLMYdCotgUgkirKWbp5mNXOVt2pLOH85A==
X-Received: by 2002:a17:902:6a86:b0:187:722:f4db with SMTP id n6-20020a1709026a8600b001870722f4dbmr50441108plk.87.1669928485074;
        Thu, 01 Dec 2022 13:01:25 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:edbb:db52:d3ff:52f? ([2600:8802:b00:4a48:edbb:db52:d3ff:52f])
        by smtp.gmail.com with ESMTPSA id a15-20020aa78e8f000000b005743cdde1a7sm3643147pfr.82.2022.12.01.13.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 13:01:24 -0800 (PST)
Message-ID: <88dda176-cfbd-5351-970c-93d5aa598aaa@gmail.com>
Date:   Thu, 1 Dec 2022 13:01:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 1/3] net: dsa: ksz: Check return value
Content-Language: en-US
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20221201140032.26746-1-artem.chernyshev@red-soft.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221201140032.26746-1-artem.chernyshev@red-soft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/1/2022 6:00 AM, Artem Chernyshev wrote:
> Return NULL if we got unexpected value from skb_trim_rcsum()
> in ksz_common_rcv()
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: bafe9ba7d908 ("net: dsa: ksz: Factor out common tag code")
> Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
