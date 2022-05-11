Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036C152371D
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243791AbiEKPXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241963AbiEKPXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:23:12 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1852173F8
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:23:11 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id x12so2072409pgj.7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R5uy2MzFnEPAJ46SroZ4BGsXRs0x5PyJzyCM6RvJGxw=;
        b=cHlGxoee02c2U4NJq3rjC0jMvpaZiAXN9nDCzDkqDSjucf6G2gMLTaFwhPIoBNbtcD
         cn/OycKImfSeuTAU/fHvqMMH/5uSTxCo0UGqU6IsBbHNi17xeGYFrjkci8X4Gc6k79cR
         CuMCn3tkwUeeRjRkMaSbFYGqvp3C3jY7HJP73AVrYKQDoLUNrJ3MxGG6L45M7gTkb6dd
         ydQALFZW9CvMHUPCA0n7KSNPRD1QP/TTTccRYO1a8VD7Khu5bTUBnRHxQzMTeIkiH41D
         i31/cgQ6Zdcu7+1qJXy3YbA+OaY13AibfDFG/mZ9IHdXjUCaAeYE0sEfyDNAuV1VMxgE
         f7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R5uy2MzFnEPAJ46SroZ4BGsXRs0x5PyJzyCM6RvJGxw=;
        b=VHEwRKBUUFwPcp9FJjPbzDllEa/4Hfk0qfcKCYbw6OfAdLqFGbBMYD+gOR3+jyORpE
         rWG2yc0DZnyOYQbNzntyjBdOdbximYTprsqPWyoC8vToeV+V2ObDCf0Q8hodgs1N5y2C
         r92i4wlxVD5P5/iRTqiA//JfqNf8P9kTbRGEC4blijhOJ+sn4ChokVmtJNQBU6yxrXgY
         xiHGDQHR8ecU2B/U9c3pA4rmqU9R7gA4WPi+imlz79EHB3Eb3t8y6MSEAZ01jDZKAcJj
         /Hj7kzeIFcQwsd1WrN0w42l3hPj8DoZ7Tgi2Hg8fDppwB9scbmqQyz8i+3/zHrh+Gnw+
         ca/Q==
X-Gm-Message-State: AOAM531+HuAP8wxgH6xEEcGdkWkXZQ9LIcxc1WItOzgUzCNDt4WGrPO9
        A6L6bhi/VHHylUVg0v9UR0o=
X-Google-Smtp-Source: ABdhPJwxkm+nBkHcBlZBnjkKNKygO6PRynwqOwvRmxvhv0Anjlwfn2dBrec2izxChtjeH5pOWXwCQA==
X-Received: by 2002:a63:a50e:0:b0:3c6:d417:6704 with SMTP id n14-20020a63a50e000000b003c6d4176704mr10300996pgf.526.1652282590512;
        Wed, 11 May 2022 08:23:10 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:acf0:1275:6d1d:46ac? ([2600:8802:b00:4a48:acf0:1275:6d1d:46ac])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902b70200b0015e8d4eb21csm2030337pls.102.2022.05.11.08.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 08:23:09 -0700 (PDT)
Message-ID: <a979d044-428e-f793-1437-01336530c910@gmail.com>
Date:   Wed, 11 May 2022 08:23:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next 0/5] Simplifications for Broadcom and Realtek DSA
 taggers
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220511151431.780120-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220511151431.780120-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2022 8:14 AM, Vladimir Oltean wrote:
> This series contains the removal of some "if" conditions from the TX hot
> path in tag_brcm and tag_rtl4_a. This is made possible by the fact that
> the DSA core has previously checked that memory allocations are not
> necessary, so there is nothing that can fail.

I would like to test those before they get merged, please give me a day 
to test those, thank you!
-- 
Florian
