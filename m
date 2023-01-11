Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FC5666600
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 23:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjAKWHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 17:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235878AbjAKWHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 17:07:15 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5D525F7;
        Wed, 11 Jan 2023 14:07:13 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y1so18265322plb.2;
        Wed, 11 Jan 2023 14:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DKDZkHWM2smJMOZlEjmgw+FPi9DH/Ye7FE5jdiOv7UA=;
        b=EqoS9wneeY8UFpxoLM3a31qwexwRmaRRkM8F7kjxnOrQLJq0UkQDVJjWAUMM8jNzpN
         IfVmv2Z9K+LFbWLOenThrjWGSkXLKYQqphSprbTHvApUDzhgDV2nNQKuGUFtQMUkOyK5
         +qccmz1gzgFiXpu6Ihpw3kK4PZkEvxx0KI9ucfbpq6nxFhoaboNjj8h9z0scD3DyA/9j
         w7+vjSFiRPvXcO5LH43+VVY8UzHmTavIwPIGrVZhk9zGHfConRLEI8mNLO2T4dCAV8Iz
         Z181PMzoFXqqdNw1xosxT6/kL7IrW6I+ut9QQ0pVTk9q4QAFTIE4iMQIxRhvVc7nTjtT
         p8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DKDZkHWM2smJMOZlEjmgw+FPi9DH/Ye7FE5jdiOv7UA=;
        b=jNLwJDaKfFcpmMsB/axCn5TbXs+rQVYxVXlMO/lJzZAJGfvYrZH4HgmaD7evEKozw8
         iZbgi8R0JlKDsmN3Lln5SUfM4Pbn/c+EQC3qLbi9KVxuJnG5ac+NNQMhJ7cFMkx+B9yX
         4nfiPEsyb7QxKXCbMk3EH4s45G2Gikyc7cIRXW7UQHtsoeShVfCAvznwolJJgQ/hUdQZ
         HkZN9rKTrqLT1kZ+QjXjQTpSN4qqADRX5LQ0k739Nlin/3KPWKAuPH4kDb8OfnOmHqTM
         16jBFLZqBnaU6hPwGwyNhre/5mapxL+7/eURop3T/ZA1Rrpea52EHkuse7K17X94Cyf7
         DL+w==
X-Gm-Message-State: AFqh2kojz2r5G8ed4MzeSIz/0HhJrO8EQ0zD2FMUxQ2nzxk8I1RjriGh
        W0birJwf4nUQil++LIc8QxA=
X-Google-Smtp-Source: AMrXdXvMvhc8KLaN8Ky1bSgkcOiM1suRRMo9cQqpPE6bLmQSoEvOYusvrwv1EFo7ke1/lB2hQLJzGQ==
X-Received: by 2002:a05:6a20:8414:b0:b3:87f8:8386 with SMTP id c20-20020a056a20841400b000b387f88386mr94452202pzd.24.1673474833161;
        Wed, 11 Jan 2023 14:07:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 127-20020a630985000000b004ba55bd69ddsm386562pgj.57.2023.01.11.14.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 14:07:12 -0800 (PST)
Message-ID: <810695e9-e0ae-152f-c64e-2350339d4e3e@gmail.com>
Date:   Wed, 11 Jan 2023 14:07:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v6 1/6] dsa: lan9303: align dsa_switch_ops
 members
Content-Language: en-US
To:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, jbe@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-2-jerry.ray@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230109211849.32530-2-jerry.ray@microchip.com>
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

On 1/9/23 13:18, Jerry Ray wrote:
> Whitespace preparatory patch, making the dsa_switch_ops table consistent.
> No code is added or removed.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

