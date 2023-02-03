Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B24768A348
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 20:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBCTwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 14:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbjBCTwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 14:52:08 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECC0A56C5
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 11:52:03 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id g18so4449879qtb.6
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 11:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wrLXf9b29YQ5LsZnVMYh+mI1T14QrpiFpmaQuS42BR4=;
        b=hWILrWb0hkAtgfU8zjrTipb7svqQJCNr3OGyaNB0dnH3epigwUG7C/ZgPGZZDTFvn/
         UVUYf75OxcLy3etBa6l2TCDn7G1Yfyd6G/zcXPdW/FaLYHm0cccRkfbkBUZnqqlbPy/a
         eVVpPH4JaGjIPFFZTzwRunJJGS3RLuh6O+YvNEAbqt/vnpQ4g2ogeKhicYzVMsVN1stk
         79ixQBUr87lrFi/Jk50B2zjsibEb2VbPuUKVblJEoiEdDMgdUBDruztXgwUsSQCBHjcm
         gZfQ/E7BGtmDh+8KvFM7ghKHLzJy8Npdy/rKj0zuKW7gIHaFysIZBfhOalw0iYWZvFyI
         0J/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wrLXf9b29YQ5LsZnVMYh+mI1T14QrpiFpmaQuS42BR4=;
        b=PXnUm1MtRe1NjEuj6f74Nzsp6IFmDoLsevWhX9BkrzTCchgbU5rEiRLa5DPRCG6FO0
         /AVJkzvBltdX90w61WSgmq/feYcVfLezKigsKaH/YPMitA1ncoFsd4MnrzXWevynCyhX
         4Bxki8Z3fiJY67AoruDVYl5y5Jl0EJKHk/aDHpWmTjb1Iad+86UB5afbGr2/bg59rFHx
         bWfDBA4vS+CudKT+Oq8C4lt8fiZEgQe6PODs9wfUWxdJi3nQDJjK/v4ZKK/1Q6WMfSFr
         BLpV9HtuZW6bSsf4LsWPUdZRMz6PAGt4cVvM0ePf13fD48vf4RAh1XM2V1FrRR7AD9oD
         E1OQ==
X-Gm-Message-State: AO0yUKWP2cMt3joUL21deccT8rQ2RTUuQo+ZlQA93visjp8VtNwyC+tc
        5wZ9ZojtyZVrZItLxy+CArQ=
X-Google-Smtp-Source: AK7set+vAt6Un0eVQfd1VAkmZMshnzxl63sltuJczVEM3tuywF+byznlRR9qrKMbZlpZo3WESR8eHg==
X-Received: by 2002:ac8:5b93:0:b0:3b9:d8fc:3206 with SMTP id a19-20020ac85b93000000b003b9d8fc3206mr8761154qta.56.1675453922253;
        Fri, 03 Feb 2023 11:52:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j6-20020ac84c86000000b003b642c7c772sm2095702qtv.71.2023.02.03.11.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 11:51:59 -0800 (PST)
Message-ID: <43ee79d2-ca06-7bd9-f000-16b76f348ff2@gmail.com>
Date:   Fri, 3 Feb 2023 11:51:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next] net: dsa: use NL_SET_ERR_MSG_WEAK_MOD() more
 consistently
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>
References: <20230202140354.3158129-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230202140354.3158129-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/23 06:03, Vladimir Oltean wrote:
> Now that commit 028fb19c6ba7 ("netlink: provide an ability to set
> default extack message") provides a weak function that doesn't override
> an existing extack message provided by the driver, it makes sense to use
> it also for LAG and HSR offloading, not just for bridge offloading.
> 
> Also consistently put the message string on a separate line, to reduce
> line length from 92 to 84 characters.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

