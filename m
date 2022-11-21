Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E320632D78
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiKUT4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiKUT4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:56:08 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF631C115
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:56:06 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id j6so8702555qvn.12
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qMswPHfXDHDzuzoJX9vqTG8B66tYx+rX5hrDFbgwYmc=;
        b=OOPWyiajDPVhHR4HNhPDwd7G9/8IDVHqU6zqxnmvkK2I/Id/hXy32soGoEsUX3E8OK
         si0IsUg74vXLS3BCqfWECKyxmEkOTPafh9lmnxqe7CiRAvMi9oLXD39/+qPKB19Wbbf0
         kAoQjbOvZtfOpYkoooyEi3NLeT9SpNIDM1M2sznRPcpLsUHUCY15mI8U4oLcDu9YxDVY
         D0j6EpXcgwPEZfDx1ZqVjRUxsiVslUqJXeiYv3L5aGwDRq3CeeVF8MADT44r9G3ZAkz2
         xAnO20n7NGGIyu4Nkc9ydY2iChXTuO/QasRuIbL5fhrmSLmkTLWnrVd2b8H7aO49dB4l
         W1hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qMswPHfXDHDzuzoJX9vqTG8B66tYx+rX5hrDFbgwYmc=;
        b=dWi8jizeh5UjYztOXWH8pfeplR3SSN9W8SrKe97JIerkcdjMkhuYzmRnF2cDgYCPf/
         nb/qI1950/3+f14hUI3gCBIGT7i2ez1Ak9kwJoI8VebLNSO5pc7jc5NPpY8PPg6Zdxae
         BjlXT7SBXw5SK8U4sj95msoF7OFdX7ZM5rnzH0T1FWH4Vi8qhY2CdHffXPh2aAFkrYK5
         c513+h2IbAYSFI64LdhNCgb2h0oS0t/9on93IrPg9VPU+msN0trXxouoxbSDh48ue/zP
         i2Pk+be/4EXBo9AP0+KXXvwyYgjH4Q1xLU1OC+8wIW5FBteDxwAWSBoYrFAt72IuWD39
         5QCg==
X-Gm-Message-State: ANoB5pk0ICB6kUQLuXcJuZiqAY00xX4jJR8YRRJPDiNqcIK291/fKwJK
        Avs49PKjYs3mgwhqKE7f+uY=
X-Google-Smtp-Source: AA0mqf6WSkyLSDRa7F9ZmuIFaQ0XPJulF65wRHHoma7tF34Qw1hBxQHSOTm26mPP4OHQriVCQybVOQ==
X-Received: by 2002:a05:6214:590e:b0:4c6:aaeb:6384 with SMTP id lp14-20020a056214590e00b004c6aaeb6384mr775846qvb.41.1669060565393;
        Mon, 21 Nov 2022 11:56:05 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j11-20020a05620a410b00b006bba46e5eeasm8907490qko.37.2022.11.21.11.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:56:04 -0800 (PST)
Message-ID: <e5d2b1f6-f3ba-36b3-cc75-334901d14e64@gmail.com>
Date:   Mon, 21 Nov 2022 11:56:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 01/17] net: dsa: unexport dsa_dev_to_net_device()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-2-vladimir.oltean@nxp.com>
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

On 11/21/22 05:55, Vladimir Oltean wrote:
> dsa.o and dsa2.o are linked into the same dsa_core.o, there is no reason
> to export this symbol when its only caller is local.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

