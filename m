Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689026C883A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjCXWUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjCXWUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:20:20 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74C71ACC1;
        Fri, 24 Mar 2023 15:20:19 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id dw14so2179853pfb.6;
        Fri, 24 Mar 2023 15:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679696419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=By9zHv/lRbQ/c65Kh76IPT2uEkIdFbWD0VZUKRDMf2s=;
        b=Uq3rx+u1MzjefPaug7JFQhY5qeK+YOVdYC89h5kyFpRde03tQgKR4nH+KzsNe8MdIh
         yafZexU7nah+Z4VlAmNu/ngqZy/QqpCaHdQaM9aSky/SQkxLM4Uv1OnMcqGyHh2yxeaW
         sgphk7oyciKdR+jTBvJNYdRscqNz6dOBPjRVvWAXraX/VdzilUkvqoMosdDPuTs3Q8sf
         B0N+oXbQgA9Ul5bemrMiiWnAtivxA2aT7SLcod1F9V8ZoBhy+FaxYoE/O7L0CNZDP95d
         F/wyoodRs2zodNs5hF49S65LmcxdLg0N0X0/zvSlrdndL/qL8idHjHYTBjRDp+eSD81o
         K51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679696419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=By9zHv/lRbQ/c65Kh76IPT2uEkIdFbWD0VZUKRDMf2s=;
        b=uPOCS2MQJLZ6InuGCMAmWevdvQBDugkq4mi0Zs0oD/9fEzIv2wqPnEe4pSgbjGhMso
         TGyu3touhI8GAN8VTOr0NSOmtMv/Vxqfh+2BC+5iFWtK4prOjk2KLQoYlD2psEP8fJmA
         o5P78yMHFxNJCgmGIb/HgD/TZS5oN3p0CUwHsHdLUXXjTS7LVgAsiRyR8j7IFXQgJYow
         Ev4bKNh8LeAWjoBGA8hLHN9GrI5nsYObedrQT+lmz21/3uZX6lKIcOkRvO/d3Kc2huc7
         NCX6AM6a3nJQX2LbLrydTXnO2Mnr5mowpm0RoZXCqjoWqzWYpmWbgKfykLYWovCOYvv0
         L8QA==
X-Gm-Message-State: AAQBX9c5Q8xgAx5nThGcSGglsU91x6K5evs3gP9rQ1WLhrcysttRdFyU
        dGGgxo4SBZ4FUAWKP2dWJqQ=
X-Google-Smtp-Source: AKy350bAxAxb6P1n04ou/DxHdBQjko79/x79B7Mix1ArBluqfUMJ66U5f5iZiO4rfIrsZAgeTdQG8Q==
X-Received: by 2002:aa7:8f14:0:b0:626:29ed:941f with SMTP id x20-20020aa78f14000000b0062629ed941fmr4511702pfr.5.1679696419158;
        Fri, 24 Mar 2023 15:20:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g3-20020aa78743000000b0062c4eb40a3esm117057pfo.30.2023.03.24.15.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 15:20:18 -0700 (PDT)
Message-ID: <396fa4fb-8e85-d48d-0f09-b75135bf49ec@gmail.com>
Date:   Fri, 24 Mar 2023 15:20:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2 3/6] net: dsa: microchip: ksz8: fix offset for the
 timestamp filed
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
References: <20230324080608.3428714-1-o.rempel@pengutronix.de>
 <20230324080608.3428714-4-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230324080608.3428714-4-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 01:06, Oleksij Rempel wrote:
> We are using wrong offset, so we will get not a timestamp.
> 
> Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

