Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3920F592EC5
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 14:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241630AbiHOMPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 08:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241773AbiHOMPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 08:15:32 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF077F5B0
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 05:15:26 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id h204-20020a1c21d5000000b003a5b467c3abso7170184wmh.5
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 05:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=OOBxVifVngH1dKlf3OhsPXEXbSU6u+dGQCi1trZkNMs=;
        b=NU2OuWeeR1OWqN+lo3NwERctgB9H4hGpXgDpMGG89Qfp93YTLIsT+IH6hEh4j1blc9
         v2qqk8iu+hht36+5yrVJeFs7wY/wcihkdBjOsrtLXfeB0LIh9yWtshWOewecZ5rgqMwW
         HXq1+KNbaM5L2PQwUrImSeqhfmX973nhByWh/CqcCKHPl9TP5P47rzZIHw/TZGdFPhQn
         tMnMFK29hrkyGhXJFxgwrz/c6HClVhTUIYKb4glREW1ziWVJqFzCjAXiomOeE/qDTR5C
         xMKGHeoWa2uwsfq6UzbRLAjuTKw6U8682B+HYV4gnuDOZM688AV0/a62pn/eT7KJKxWW
         Bo0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=OOBxVifVngH1dKlf3OhsPXEXbSU6u+dGQCi1trZkNMs=;
        b=CUWriAZ61DK3Lwi9Dr2ZegoBpZVZ1TxleNtetgF4UNAJjQIXlG6XipG2+A3PSO8yJ3
         ncL02ypUwCjPair2K7V/yKJvS9RQMUEMmOYLuKAwYYjJE/VuBizZr5DOHJthGhaIQJFt
         fdhBsZzURAJrrr0d3Po/X/odUeh6G2QzZnUsiFzYD45IJf/Jil0WeE/H4iN9J7FEeYJr
         xx63DRGHLDOw7ax4IgGU0RKDs5lxJ0EIs6aHt9m/b0JTTDO9HfsyeqwBQBQNBXDe+WuJ
         5nutHFQfy0GnX5dmLIVlxRV7Qc0xl9j+NaMzdzjUOk3MGYJeIQ/hRc7qsUsL+CO77pIm
         kG0w==
X-Gm-Message-State: ACgBeo02pPfbOhmTNkdcuwJHK8LewFqcgnKjNC6pd38bk8ikePWWGn16
        pBIo0uNqXfKkObMi3c4iFUkYvA==
X-Google-Smtp-Source: AA6agR4lYWNXb2X8qKrmsTV/gZaJJ7w1dG1SUJCm7wll2Bbq7UZfd+Js3+RWAO35FL6sEWiHr84z9g==
X-Received: by 2002:a05:600c:4ed2:b0:3a5:f177:8a9a with SMTP id g18-20020a05600c4ed200b003a5f1778a9amr3635440wmq.4.1660565724983;
        Mon, 15 Aug 2022 05:15:24 -0700 (PDT)
Received: from [192.168.2.1] (146725694.box.freepro.com. [130.180.211.218])
        by smtp.googlemail.com with ESMTPSA id t8-20020adfdc08000000b002238a1f6b74sm7115947wri.37.2022.08.15.05.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 05:15:24 -0700 (PDT)
Message-ID: <20b6dd31-0ac3-ff92-0b58-629847508fa1@linaro.org>
Date:   Mon, 15 Aug 2022 14:15:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 2/2] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     rafael@kernel.org, vadimp@mellanox.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadim Pasternak <vadimp@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220815091032.1731268-1-daniel.lezcano@linaro.org>
 <20220815091032.1731268-2-daniel.lezcano@linaro.org>
 <Yvo0IWgDQ0wZ20g6@shredder>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <Yvo0IWgDQ0wZ20g6@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/08/2022 13:55, Ido Schimmel wrote:
> On Mon, Aug 15, 2022 at 11:10:32AM +0200, Daniel Lezcano wrote:
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>> index f5751242653b..237a813fbb52 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>> @@ -22,7 +22,6 @@
>>   #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
>>   #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
>>   #define MLXSW_THERMAL_ZONE_MAX_NAME	16
> 
> Which tree is this patch from? The define is no longer in mainline:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c

It applies against:

https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git/log/?h=thermal/linux-next

But it is not refreshed against v6.0-rc1

I'll take care of giving a respin of the patch before resending.


> Getting a conflict when trying to apply this patch
> 
>> -#define MLXSW_THERMAL_TEMP_SCORE_MAX	GENMASK(31, 0)
>>   #define MLXSW_THERMAL_MAX_STATE	10
>>   #define MLXSW_THERMAL_MIN_STATE	2
>>   #define MLXSW_THERMAL_MAX_DUTY	255


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
