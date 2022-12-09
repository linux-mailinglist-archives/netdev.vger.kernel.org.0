Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CBC647CAD
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiLIDmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 22:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiLIDmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 22:42:02 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C1AB079C;
        Thu,  8 Dec 2022 19:41:57 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id s14so2377012qvo.11;
        Thu, 08 Dec 2022 19:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pgIpvY0LTWC8//oo98rnPVZasE3c5eO/Lj+ZMeQ7so8=;
        b=ojYAfK81/mDNxpaBmxYJMVWELNq4cY6w54Wley838af/dUV6qzPQPtFHihdyaGEP5p
         +qY85rFzd4JifddL/+FvTilwbbce05hTbr6+T2cyyxcqZe/VeU1GD38Nw23sCpVSV3S5
         LHkuo1XWfcbFO/kogNj8evHenJ0z5EDmOZ9QHIaR5kX5acxSd1fssAsp4fEStqnjfm2O
         6Xb9BxkkOqZ2EFJaHgpPkz78YRc50KYP/IqsrVIr6n8lolt5tBJAzbi8idgBMwYhWr0K
         t04xGYn7DRvRSo+I3wo5SwupYAYZFOS/iWADdVMfy56CCMJfnFWgS5yK2PEx5bFnYzCh
         2h/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pgIpvY0LTWC8//oo98rnPVZasE3c5eO/Lj+ZMeQ7so8=;
        b=jlacJQAQQn1j4vQ22TsNMKgaJs+M9WV8Z0q4721HfvHrlKxouX2TRebCpYWD2IfGjm
         P6RIPRW6PoShUwefjs9JY8WpHfXReB3oqqeXSQlQeHWOMd1rTkQUID9aMjGJfrGuwSH+
         pZLpUbNcCtQvWMSWF42tmMVMNgSjBXbmEnof8YYfa/hIygwAUfO+OCdSnVEiXUXMnkhB
         7KxG/vjWjpA70bMngDkTJJ6V7dhHxVkwEs9xG5jRynvzReFp0pWxMwzendCvdhi772e1
         ZO/CWQ5aT85zZ8Ka1aMd57+5XAmzUmiihfBvC8Jf20rf8uSy1YVrrHaGVXsQgTLgaTDd
         26Bg==
X-Gm-Message-State: ANoB5pm6A/wPWzzrx+Z5zT2qTCQbkNgUiujb0ZhR2l9cXdpF8StAa24O
        IWl79R3oMPjPFoNxwdCHtO0=
X-Google-Smtp-Source: AA0mqf5VOXaO/mBUDg1wLqT5kK6xgOdcoeWekvED2P9fqSZyuOxF6fN30qfJpAEIsYkc3DICHaei2A==
X-Received: by 2002:a05:6214:1908:b0:4c7:7ef:3052 with SMTP id er8-20020a056214190800b004c707ef3052mr6233311qvb.39.1670557316480;
        Thu, 08 Dec 2022 19:41:56 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h129-20020a376c87000000b006fc40dafaa2sm284255qkc.8.2022.12.08.19.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 19:41:55 -0800 (PST)
Message-ID: <f81e356e-0eb4-a676-ad43-2987994f4543@gmail.com>
Date:   Thu, 8 Dec 2022 19:41:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] net: bcmgenet: Remove the unused function
Content-Language: en-US
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, opendmb@gmail.com
Cc:     bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20221209033723.32452-1-jiapeng.chong@linux.alibaba.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221209033723.32452-1-jiapeng.chong@linux.alibaba.com>
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



On 12/8/2022 7:37 PM, Jiapeng Chong wrote:
> The function dmadesc_get_addr() is defined in the bcmgenet.c file, but
> not called elsewhere, so remove this unused function.
> 
> drivers/net/ethernet/broadcom/genet/bcmgenet.c:120:26: warning: unused function 'dmadesc_get_addr'.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3401
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
