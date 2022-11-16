Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E7762C464
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbiKPQ2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiKPQ2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:28:16 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33FB5D681;
        Wed, 16 Nov 2022 08:22:58 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so2879027pjk.1;
        Wed, 16 Nov 2022 08:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qXI3XjMSMCMBO9xCUGUKNUZQZSgMc4kAU9Goj4h0jRw=;
        b=OJWI09JWX39bAeK/Sm8EhfJCDzi8bWX+YsRhrh7/WGGiRKFXFaTEjQfT5ftco9etWf
         7yjy1Yb0FFehJApfEtNRH9lJAvP1n0IgokD5V590NswnqgcUFbWJQzVWwQUeSIQ8h0uS
         1YI40mZU5rHTG8GjjnbO3kpZGPHKuscZBAwyZXkHgvGqlXKQINSfhSupaTYQMsTsMc2P
         hWJMPfN3L/idHuuF/X4wKUtbXNNH6Jn5IdhnLfO2lMLt9Abplv8X8uuVELfxgi6In0m3
         fnesXUapK0ckNIUS6qMseZLsqbavIqXQR81kQhQJUDpld1YCLGw16WsGGMzQb374eGWN
         KC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qXI3XjMSMCMBO9xCUGUKNUZQZSgMc4kAU9Goj4h0jRw=;
        b=AUgBUTQu7JcNyIWWq0JsbPi7AN4tciSNC8pbQi92KRIysNsTSdALT8FTlmntvjsbzf
         acm1mGBPKWdulXYaY+uejbaRnfP1eydyGIVK5qZJ0WC16F8DEWIl5ASc9Vpd6PW7bC91
         tvLsE1GIUpQXT0tYcksfqynwApqbhrqEeQ7kog4NU0Zmgq0TBTUjBiJwEBGmFI1d7PMd
         puFoejP30RJ1QoyjjrYQtOFxWDPV5en/rSuBbkVctEO3ki6K6SQxP/OvJMLfH2tNriJh
         SXoXONmYEQZHq1TAQOSkkbHVg3L9sbqHGrzyDR7H3teQHc2uvD8h1eT/UGIfhn35otoN
         lGqQ==
X-Gm-Message-State: ANoB5pk+I2qqvs1B58s4cEQwi7Gv/4q2ls1HwG4BQdh/CFB8mIE0dtlB
        GGpRWG6oDTac/n/Ux3W6AoU=
X-Google-Smtp-Source: AA0mqf4P6qwhby9Aea032KFkooKvuSvAolX73zIjHILS5b+Xw5w4gnMF7OreUM5lx6gxUEtBOtpsRQ==
X-Received: by 2002:a17:902:ba91:b0:186:c958:6cd8 with SMTP id k17-20020a170902ba9100b00186c9586cd8mr9533839pls.145.1668615777910;
        Wed, 16 Nov 2022 08:22:57 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:9801:5907:5eb0:dd5f? ([2600:8802:b00:4a48:9801:5907:5eb0:dd5f])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902c1c600b00186616b8fbasm12470225plc.10.2022.11.16.08.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 08:22:56 -0800 (PST)
Message-ID: <013241c5-b099-279a-7496-3169197dac58@gmail.com>
Date:   Wed, 16 Nov 2022 08:22:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 2/3] net: dsa: use NET_NAME_PREDICTABLE for user ports
 with name given in DT
Content-Language: en-US
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-3-linux@rasmusvillemoes.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221116105205.1127843-3-linux@rasmusvillemoes.dk>
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



On 11/16/2022 2:52 AM, Rasmus Villemoes wrote:
> When a user port has a label in device tree, the corresponding
> netdevice is, to quote include/uapi/linux/netdevice.h, "predictably
> named by the kernel". This is also explicitly one of the intended use
> cases for NET_NAME_PREDICTABLE, quoting 685343fc3ba6 ("net: add
> name_assign_type netdev attribute"):
> 
>    NET_NAME_PREDICTABLE:
>      The ifname has been assigned by the kernel in a predictable way
>      [...] Examples include [...] and names deduced from hardware
>      properties (including being given explicitly by the firmware).
> 
> Expose that information properly for the benefit of userspace tools
> that make decisions based on the name_assign_type attribute,
> e.g. a systemd-udev rule with "kernel" in NamePolicy.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Reviewed-by: Florian Fainelli <f.faineli@gmail.com>
-- 
Florian
