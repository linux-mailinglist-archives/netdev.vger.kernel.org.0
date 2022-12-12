Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914F964A8A0
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 21:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbiLLUSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 15:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiLLUSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 15:18:34 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161EA2669;
        Mon, 12 Dec 2022 12:18:34 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id f68so513504vkc.8;
        Mon, 12 Dec 2022 12:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h+Z+AxdqG1GpBohXhEK7tUnOZpSOdGBttqpfxIX5iNc=;
        b=B3BI2gFpkN7MptFR2WtyeYZ99R5jHeHXIv1l3a5ToCQdgORhLpaqZfrxqqTaP8SbBh
         HWfM8EFt1d7ED3ClORAePvnj8OCcKyD+N4iQRMlBnWJPae/YlUQNNr5kRaQVzQ6j4jnf
         LbY9cLtav6ej6RDtXMYaRJlLjN8ctFJ8YsS443D75h9keMhso0HQi09hVOBiubm9/imr
         I4t0vhny9GaTTwNk6wIGTdOTsdYfBYH3jMQQMCVwSBCjZXTZ1yEyrvyoy3NOw0oqOFsG
         5wo9LQtHmA8wFhOiz8FaWg2GlpUyfyH+veVd7fjODHAVhOTzGcYSxSBVkbHzDkp+NEUU
         eFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h+Z+AxdqG1GpBohXhEK7tUnOZpSOdGBttqpfxIX5iNc=;
        b=xg/g+x7pyHd5RGYpixjNIqPE+VAgwQCjgR41iMKQunyZNkkOuHoGqDCCYjlY+ueK26
         bbqCsq2Do3b8bTuISgon6Z13L4mGSUq7Sk06ISKA23SQFa3ODhjPV+LZ4szv2/aISH1s
         zAmTa9LtJnARIMcPZ+dIwhs0RDnQUAuxcsArA6wuTGRrblstuqsyPjxbo29fbNkp6qcW
         BS1enyPkX4cjmis+oCjYbWT0fCNogFoWiY7KIlQx5kav+l4+eF0oIIN0kOATite5el7b
         36Qdy90wKkvQpg+6kO2a3eD/BaboAk7SF9Z3/qY0mpF/OLXZLPYqwheVBNX/FJv6P59X
         jOsQ==
X-Gm-Message-State: ANoB5pl+bYxDsqtIDROl6afaG6SRKXJheYmvOJ3zZu2ZqxGAJJpIlSqd
        KEZOnRBbtNFAWsGAATtF0nMl6PUCL9gmgA==
X-Google-Smtp-Source: AA0mqf76WYCxijEkjbWBdhnR3Nh4yuSd13AhZNtLVgWoQRhCtLOejUrSFMQDHkeZ0J33+v0wjVrNYw==
X-Received: by 2002:a1f:2cc5:0:b0:3bc:bf7d:c174 with SMTP id s188-20020a1f2cc5000000b003bcbf7dc174mr9321756vks.14.1670876313032;
        Mon, 12 Dec 2022 12:18:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i10-20020a05620a404a00b006e54251993esm6476104qko.97.2022.12.12.12.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 12:18:32 -0800 (PST)
Message-ID: <fa2d3bf9-47dd-0dc8-8efd-a5c8013b6b99@gmail.com>
Date:   Mon, 12 Dec 2022 12:18:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: hellcreek: Sync DSA
 maintainers
Content-Language: en-US
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
References: <20221212081546.6916-1-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212081546.6916-1-kurt@linutronix.de>
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

On 12/12/22 00:15, Kurt Kanzenbach wrote:
> The current DSA maintainers are Florian Fainelli, Andrew Lunn and Vladimir
> Oltean. Update the hellcreek binding accordingly.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

