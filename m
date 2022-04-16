Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6055037F4
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiDPTdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbiDPTde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:33:34 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5C86E4DC;
        Sat, 16 Apr 2022 12:31:01 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k14so12012321pga.0;
        Sat, 16 Apr 2022 12:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=f7aiVkYi+hfU4xil/hDA8uE502gW3kBK6AfYVK5fMjA=;
        b=D4Vva0JqfqwqABF96OkAQW68aCmSRHi8TTFg+35kSz/XtZDT0wUx1q7mzJYQOOJQ+0
         07PG/JeZO6/U92/Vcu8ngpxAGoXneGiS51WrnQ96AUUIgoHl1qs3BcV62xwzXAXeao4n
         +RcgRGwOE6xHYRlmU8i9HWbzNdbFm4AzBu+8d0U3Ot+5q4XN1g11jgGka65Ay2qOARHF
         294aDivk+ubpbY6Z5YrjzVVHCcYBl8WkaQ4EeQOzrTdxPWjlqgNfaR8R27edpj7uT8Pr
         N1cOjrkskPckoDet5zHLPCjCETu87BbhApLpGykGhj+GS8gehTyxxUavj3i5quP2LdHK
         BQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f7aiVkYi+hfU4xil/hDA8uE502gW3kBK6AfYVK5fMjA=;
        b=YUUFICf9UxvV+qVmrrYCOChpizVlA91ZAvR5Jjq+8Ah2W6LXhh+NxY+tE3oplnr8rc
         Q6LBb+crc83/QqIuFKrYRyY/KnIFyhpMfmPssePt3J+gTQqWv3oZjIqbHpfUzwH34LOL
         Yq+C2A92d5fuhbkZvi9nfDvpQeIvicZJHmuAi7pTQDEossCTCxRp8VTra43U1CAmgreN
         NJZHYykR3ekLSXS9aIRxWwPUeAVnxKiHfN4J/g54Wz7Cpd3NiSwFzyzLvp1Qpl02V9Vu
         xNUKd4EJKBdxtV0UycidW7Wrs4xkM0IgXJ+NLJWzYuVSt46cGCNKeeH7BAZ5wT79WgfO
         IOGQ==
X-Gm-Message-State: AOAM5334FP9N82oi1j/RIEteEFHO9PY9AySVbuUDaZWUqeT3zT/8cezC
        hG5QoYvfIzsKeDkZRzLRkrs=
X-Google-Smtp-Source: ABdhPJy5GPZdN5UjGTVyg+7ef4e5TbODY3XaP73NXA8K62x89Suul2Q3/prjXn/4MyZUbrm1Sl76nQ==
X-Received: by 2002:a63:35c1:0:b0:386:3620:3c80 with SMTP id c184-20020a6335c1000000b0038636203c80mr3942658pga.327.1650137461012;
        Sat, 16 Apr 2022 12:31:01 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g14-20020a65580e000000b0039ce0873289sm7972183pgr.84.2022.04.16.12.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:31:00 -0700 (PDT)
Message-ID: <c94db8a6-3595-ae0e-8ca5-bba12632e7d5@gmail.com>
Date:   Sat, 16 Apr 2022 12:30:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [net-next PATCH v2 4/4] drivers: net: dsa: qca8k: drop
 dsa_switch_ops from qca8k_priv
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
 <20220412173019.4189-5-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220412173019.4189-5-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2022 10:30 AM, Ansuel Smith wrote:
> Now that dsa_switch_ops is not switch specific anymore, we can drop it
> from qca8k_priv and use the static ops directly for the dsa_switch
> pointer.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
