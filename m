Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7080E62C5F1
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 18:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiKPRJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 12:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKPRJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 12:09:03 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B38B32F;
        Wed, 16 Nov 2022 09:09:02 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id v28so18047274pfi.12;
        Wed, 16 Nov 2022 09:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QMe9YMiBFsmsklxUPsLr6HWIKYlE/V+W7WyKafNbpI8=;
        b=lymq2nfZ9CA3nNBF4Ij2WnnY982nQ4rka2ZP7xqtrK9fpGKobmOYbpZV+dC317zH+u
         vP3+YmnkZHops1fx/YeqW/NSf51Vcj8FBZROgV03bnZvHAhd7yLqPo2/uD5Yq+R+iveF
         TV0oAk6sgZAMrHJGkKYnCQY4Ix+P02zFBOJKLpjQc6qMfB9GPV6vFSKUOOYKW+Bd1az9
         RPp2mMRJZ2wmgtRWk6LQu/zHAAT7mONs+m61IUj+s9DKetx+VRce9SxPEycnpBB6pEVL
         RHbJC0nzpF56eVJL/r4DxNtdUjbpx2LKBNHONjOyDiJ512qEu8qBDQ+3FJVGPqUSGZik
         BcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QMe9YMiBFsmsklxUPsLr6HWIKYlE/V+W7WyKafNbpI8=;
        b=sFRsGKsKyqHzntPHeNCue+c4rFrcNbzqqqN2GzGofd5RzAtglVD8A0UUiZ7BrKOHJ+
         3ALySlDyzpwceWkaArx5FFdR0daZ218idCuo0wk+AjgYr2xEfviutaS3zGQs0KLZZI3P
         E5M8gG7Na6xpPA4IB5A+U01sAe9tfGPARvzjHDiiJ6GpZRhe8Uh9SteT02H2gxYEjsuW
         lxPZYwx8ulirVRmJik86nJe6M2mlJN4IqLdp6AWy11wjkd2Le5Z4c9zYEEGxlYwFZbET
         UFT4F9AJHp9x4osZbSwuztCgzC66s3ydgYSZu+vqtafTvetVohJkq1kjhE+4grERzRj/
         qDNQ==
X-Gm-Message-State: ANoB5ple6VN1DWwza43iyeyZzC1AWWFnn2F5atjjUxJ9XNjmaIT5YwA6
        AsmCrPmv4nT7EwcMLcfmf58=
X-Google-Smtp-Source: AA0mqf7E9PikXdnXeRqBRFwPUp36NFUC5qk6qio5jeVJ79rcLmE5tZTkcdUvv19Sb+mhVAY6YGreQQ==
X-Received: by 2002:aa7:800f:0:b0:56d:3180:c7fc with SMTP id j15-20020aa7800f000000b0056d3180c7fcmr24029020pfi.41.1668618541704;
        Wed, 16 Nov 2022 09:09:01 -0800 (PST)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l17-20020a170903121100b00188b9b4139csm9868127plh.79.2022.11.16.09.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 09:09:00 -0800 (PST)
Message-ID: <5842f6bc-f578-52a1-c8a4-7c04ada3c146@gmail.com>
Date:   Wed, 16 Nov 2022 09:08:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net-next][PATCH v2 1/2] dsa: lan9303: Change stat name
Content-Language: en-US
To:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221115165131.11467-1-jerry.ray@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221115165131.11467-1-jerry.ray@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/15/2022 8:51 AM, Jerry Ray wrote:
> This patch changes the reported ethtool statistics for the lan9303
> family of parts covered by this driver.
> 
> The TxUnderRun statistic label is renamed to RxShort to accurately
> reflect what stat the device is reporting.  I did not reorder the
> statistics as that might cause problems with existing user code that
> are expecting the stats at a certain offset.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>

This looks like a bugfix no? We should not we slap a:

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the 
SMSC-LAN9303")

Reviewed-by: Florian Fainelli <f.faineli@gmail.com>
-- 
Florian
