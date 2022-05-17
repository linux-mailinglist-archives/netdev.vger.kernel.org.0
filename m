Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15B452978D
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbiEQC4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238680AbiEQC4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:56:48 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C3543EC6;
        Mon, 16 May 2022 19:56:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x23-20020a17090a789700b001df763d4ed0so1214458pjk.0;
        Mon, 16 May 2022 19:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9KX2rNSpm7G/R0VZyjyh5/JqxNaDhTeViihPgsYkixU=;
        b=qnIxlwHE4ODBVjeROGePBqUZEUU1cv0LHbZMf8T+kkXX4v1wsqzKsLZFK6qCarI3T0
         60Nh1pirAHV9lrmI0lo/+3UlXCVrXde9iWA6E3ekixoLlC43oCMH+Kx/3QZ3saepKTPP
         U7gdZc639VqAP05XtMabrHAA77l7Zq4hhQpq9JWlQsXArNe31jBD4lUpgBmfmBRjfM+J
         eNcoP7euNa0JeBCVecoeS11j4lZnYhMvQDAfift54G43J8MP/AO6wecqBGbjRQORPz6z
         0orXfh9TArbOSuO2Gx72VNvQ199wCiW5y1PiEgQSwZ+VNDyoAb68iVuzhtYpi6eaKc5M
         9auw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9KX2rNSpm7G/R0VZyjyh5/JqxNaDhTeViihPgsYkixU=;
        b=PjNdTx+UeuwAgC//1i2Y99vkUHvN36GuMRgtACTLpTKvHlsCuJ4XA4fzqleyVO4stw
         A7efdw1GfJHzxrlDEV1UmbLBpY2M/83kFt2Uo6KGX08gYO0XE6IlJrlLjVlqub6AV3IU
         pEqrg/6NcQUcqYs2bSh6Ede1uXxb5TLdXHM7zlDsQkfHAn8NsnYFFDZRoprjkTc+kwnD
         OVZvF9hbTvUV+spO17Mclq2pmcVeYTVIhr/YqqS4iNGhz6A/jh9Qg9SjN5pGnTAKfgoS
         FzdU3VtbVO/BAyvvg5NGyW/+O7QxW2JcHd8hY53CUYVSB7ZffGZ6FZF7HNgiDTjMMm4z
         ohew==
X-Gm-Message-State: AOAM531HVl+rmG17FmQerHnledhT3XNDKVVw9AvNtP0DtQv17Sd8q1X7
        QdrvFUGrXh/fmFKKHqF+Rnc=
X-Google-Smtp-Source: ABdhPJxGyVqCf0Mh+9ABKlRhSjyf46eKwGM/zPuXo19NgHhfqWj3WO46ATBrbXGx91QK3R78lE5/lQ==
X-Received: by 2002:a17:903:189:b0:15e:9584:fbe7 with SMTP id z9-20020a170903018900b0015e9584fbe7mr20207430plg.65.1652756204196;
        Mon, 16 May 2022 19:56:44 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q1-20020a655241000000b003c14af5063dsm7437223pgp.85.2022.05.16.19.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 19:56:43 -0700 (PDT)
Message-ID: <602b898f-1b25-dbc8-c007-74121a1f7912@gmail.com>
Date:   Mon, 16 May 2022 19:56:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC Patch net-next v2 7/9] net: dsa: move mib->cnt_ptr reset
 code to ksz_common.c
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-8-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220513102219.30399-8-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2022 3:22 AM, Arun Ramadoss wrote:
> From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> 
> mib->cnt_ptr resetting is handled in multiple places as part of
> port_init_cnt(). Hence moved mib->cnt_ptr code to ksz common layer
> and removed from individual product files.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
