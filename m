Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9589B2AB3A3
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 10:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgKIJdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 04:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbgKIJdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 04:33:21 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABE8C0613CF;
        Mon,  9 Nov 2020 01:33:21 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id i19so11239500ejx.9;
        Mon, 09 Nov 2020 01:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IHungiHT/f4D67ZQdjDZfWAd4Ctml2t7aYYvgdv+uwk=;
        b=ef39yYsxYXnKEVoZvgLQGNp1B1bQ+hUe4cxF5KmNwwfLKxD5oQoym0KrhPfjOiOVjr
         3JRaOlrjJQeMcNsB5FmRkwChBF7RcHw4ugLEy2Sm6SA5Py5WNucDYx5nbi5UQ+rqFHX/
         06qa0IQgjYQLIEVGAf3AjKLuzxQaxuk1fNv85+sC0WhFd4mQ9skAzAm9/lABBxjPa/mi
         /D3RVfBjhZZTXCkVFa7/AnuYSfXwcDspCrWAbs+d1ldZv/u70yFVFje2Cv++rmq+FdRQ
         2nDuY8WL5W1ySnpxRTWB/3gVjCzcR67OrTYE9xoCZQ5oQBnb2hqgcbOVPBKVFeWbG1rt
         GAZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IHungiHT/f4D67ZQdjDZfWAd4Ctml2t7aYYvgdv+uwk=;
        b=E8ozpq1JwEHvvajVLUttIRdFWqLZRxO7xxMcZ2wGj2cMHX0CrAw+Lkeslec7WYpLLQ
         gNrc1BQ7oCdeU0xNUXiJ7vqnMRuLdzAv0Nk5EN+XBTgQu1LzPYADx2iKrQowkYNdLAGy
         yj61Yy4zM1NWvj1vShMR/CVPU26B4lWY4DotZkOaWJhKGQWOMh6erHg3FfTCVPKJ35aO
         PxQD60x7BIF3Chj8QB5oXk7JtI8+M8Zpd+k4CYZgmTA0Zn8lNfa6C3sjAbvEob4KIhfG
         tc7n74//rjPNFZ5Zk+a4V9pDD8CDVb0gbXwxeYSTj4UeX/gxxklm9XX4s8Lr57Yj6Uwl
         9/6A==
X-Gm-Message-State: AOAM5304mSfjijihcKRpIhXmpvdubuq4hS1Ftm7LYBE2Em0QiHmhua+X
        4ZeQdYctVjqhzkPbNmlOXU4=
X-Google-Smtp-Source: ABdhPJyzSZlz7BdJu5CG/wv4OanI7GN8FVBkDKnd4jTFEPBzI/FQC1JXkP/HHm8LrTx/jro5wOGI2Q==
X-Received: by 2002:a17:906:1317:: with SMTP id w23mr13796181ejb.120.1604914400405;
        Mon, 09 Nov 2020 01:33:20 -0800 (PST)
Received: from [192.168.0.103] ([77.124.113.118])
        by smtp.gmail.com with ESMTPSA id u13sm8338105edx.38.2020.11.09.01.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 01:33:19 -0800 (PST)
Subject: Re: [PATCH] net/mlx4: Assign boolean values to a bool variable
To:     kaixuxia <xiakaixu1987@gmail.com>, tariqt@nvidia.com,
        tariqt@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1604732038-6057-1-git-send-email-kaixuxia@tencent.com>
 <9c8efc31-3237-ed3b-bfba-c13494b6452d@gmail.com>
 <c6901fed-d063-91be-afd6-b6eedb2b65b6@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <a1cd492d-80bc-80e0-d864-21fa2a770ddb@gmail.com>
Date:   Mon, 9 Nov 2020 11:33:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <c6901fed-d063-91be-afd6-b6eedb2b65b6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/2020 9:07 AM, kaixuxia wrote:
> 
> 
> On 2020/11/8 16:20, Tariq Toukan wrote:
>>
>>
>> On 11/7/2020 8:53 AM, xiakaixu1987@gmail.com wrote:
>>> From: Kaixu Xia <kaixuxia@tencent.com>
>>>
>>> Fix the following coccinelle warnings:
>>>
>>
>> Hi Kaixu,
>>
>> Which coccinelle version gave this warning?
> 
> Hi Tariq,
> 
> The version is coccinelle-1.0.7.
> 
> Thanks,
> Kaixu
>>
>>
>>> ./drivers/net/ethernet/mellanox/mlx4/en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
>>>
>>> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
>>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>


Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks,
Tariq

