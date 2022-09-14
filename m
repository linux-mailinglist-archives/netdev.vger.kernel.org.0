Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DBC5B8642
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiINKYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiINKXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:23:16 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93957A75A
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 03:23:12 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l14so33615173eja.7
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 03:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=LQU74I/NnfNTmp9Z3fM8ePGxoN8nQq3l+ioApLvk6o0=;
        b=dPbKsYo7CZ57Y3OfjOi9x/iDNd78nOlao0ZOD/HQQA6b3GMbW+xGnISkyhLo8ix9bk
         9vJKrUYLviU3ZejnevMKESo3n8QuDmF0t8RuS/JB3ou/4mBW8XVXNsgIkhlFfQRyLMuJ
         pO2LviqwWdGFrf+x8pG3bKuY+F1IDJiCSpPaj16pRERyX3cM4qLzR70joIlgGAM+NmjR
         k5eroDVUaRVbfQDpi4xYsArAYoF9nGnMuxYT9GjhbUneLmD6yrOwzUJ28x6gA2qvSyR9
         yrduiHlH9niL+Z04aXuShgECGQtr7VI7x83qjmg47IlwiO/LSgNWeJW1zjmQ8kKvtVbl
         0k4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=LQU74I/NnfNTmp9Z3fM8ePGxoN8nQq3l+ioApLvk6o0=;
        b=l0/ojvopmYuS4hZAlHTY/LHwSi8Sm7Wk/ihyQ6xfr4YfG1s8KRJz3lX/lrqbmOC68P
         jUqcYPMeDuKt3zEZU50ciO1PU5JewOOfgS1U4l7Wb/g05W1B2k4KFzDkXgpehD5ZAkIF
         mwPgqWo+OrTFeYnBvgLLC/hXQgU9iLtE0v3uwTUIedYeSv0mtkyz8tZhTFfmWdkOBP5X
         OLb5XD9tZhiNhHFS2xz65sRjDFWKVCLfTYtKB4HsfoCAN0LDhtasWCDCFcSh87lRfii3
         Np2N0jm44g7eKZ3N0VTJFe5VWqPdE7rI0/W6cghRYPNNBgYGoR/FFpO8R0LQd6jJENQn
         ChHA==
X-Gm-Message-State: ACgBeo0kcQr4z4QmeM9+oViYsdKfPZ1jvpWd2UumPTqzlJL01yRzCmuZ
        DkELMyNBGTvB9Sj8jy6XQmd46gHhvF8=
X-Google-Smtp-Source: AA6agR7uOB8N7w6I1tQECJB/TsZD/QxqdG39XzxdPxSSZowqMxddyIOn/m5J5hO0zGlKmIwIpocU2A==
X-Received: by 2002:a17:907:75dc:b0:730:9c68:9a2e with SMTP id jl28-20020a17090775dc00b007309c689a2emr26462533ejc.22.1663150990716;
        Wed, 14 Sep 2022 03:23:10 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id la25-20020a170907781900b0078020ae040csm1376479ejc.219.2022.09.14.03.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 03:23:10 -0700 (PDT)
Message-ID: <7824ccbf-8965-dfa6-f5ab-aa26c16296f4@gmail.com>
Date:   Wed, 14 Sep 2022 13:23:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next 4/4] net/mlx5e: Support 256 bit keys with kTLS
 device offload
Content-Language: en-US
To:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
 <20220914090520.4170-5-gal@nvidia.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220914090520.4170-5-gal@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/2022 12:05 PM, Gal Pressman wrote:
> Add support for 256 bit TLS keys using device offload.
> 
> Signed-off-by: Gal Pressman <gal@nvidia.com>

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

