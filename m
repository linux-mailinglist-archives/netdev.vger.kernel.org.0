Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EC0518D23
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 21:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241884AbiECT1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 15:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239819AbiECT1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 15:27:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823162C641;
        Tue,  3 May 2022 12:24:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso2821565pjb.5;
        Tue, 03 May 2022 12:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=waJvQWBR1alX6Q1gmx++PicUkAKKCsRDo2BEpHmI3CM=;
        b=KNRkHglMvsUHD2w2hXTXkhCyHJFhz5D5H1odFL0c7kdonoPYNm1FhaVcmZ7rH7+T9U
         7lrE5OcJycDJ4ZIJ03uyjCPci/1sV952aRy1QpYwSp48um8p5teG4Q/54Gc3Kl4Z05DX
         k+77Lj7AuO4cI7BFhvD9VnuK2kT2hfDA0lBRB++cnaupgbAQU3kcWCxDyGffU6BZtPs5
         CLN/7K1wlrZNOAyI3XmVBLaFpfIApDUp50W9QS77df61jR/Uf+GqJRTmaHz2nObIfswF
         Uzv9OxuiVfJ9lU5NouzMa+ZpxmwnSW/Inp9MTRXrI+OOdIuNkk5ebjPGI9KXk14bmSpa
         fpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=waJvQWBR1alX6Q1gmx++PicUkAKKCsRDo2BEpHmI3CM=;
        b=0uTF+GOjc5OEQppdF01/JaD5W09hA+mK9dbUVslnUj4w4EaGqDW/bcVUqLxJoZYUsA
         B5ENInCRr1vRVeJZkOAv7nx/NJsCc7VGmrLvRDCoG1k6a81ZoJGIBAksc+iuXrrJnswg
         kupa9F8BzyT5xPjEVqjz8BiJYcisG8PEcalKZyCH6BSmane5s1MRIlhrfU8Ougo5PJVL
         QkFnT/5dtdApEWRvMmsmOyoggA84oQpkHZzL/f0lYa0JqyS4aWZdnGDVEGjnMcfggUQL
         AA16u+ANbOWJU2/6tOWY6XQhurEZD3aUIgdT2zHjDz/q+XjA+RWtNwfdC/GQrKwzNU0d
         XsQg==
X-Gm-Message-State: AOAM530L9Jg8qxQjF+lZPdhADJwXiZe3ib9/YcBV8CKS0WNlJ9u8sgF2
        mlqIukqaIJ1/r5cWS5uuErY=
X-Google-Smtp-Source: ABdhPJw6m4614+CLkWNykf0AiBv5TZxYQnG9Nsilb13UOqvfRmRH/FGUJeBPA4caMLsQgMLt2X8jZA==
X-Received: by 2002:a17:902:7009:b0:158:3bcf:b774 with SMTP id y9-20020a170902700900b001583bcfb774mr17816605plk.103.1651605839945;
        Tue, 03 May 2022 12:23:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h19-20020a170902f2d300b0015e8d4eb243sm6634006plc.141.2022.05.03.12.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 12:23:59 -0700 (PDT)
Message-ID: <d9156159-8320-4242-13bf-b1e7f5bbabdd@gmail.com>
Date:   Tue, 3 May 2022 12:23:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [Patch net-next v12 02/13] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Rob Herring <robh@kernel.org>
References: <20220502155848.30493-1-arun.ramadoss@microchip.com>
 <20220502155848.30493-3-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220502155848.30493-3-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/22 08:58, Arun Ramadoss wrote:
> From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> 
> Documentation in .yaml format and updates to the MAINTAINERS
> Also 'make dt_binding_check' is passed.
> 
> RGMII internal delay values for the mac is retrieved from
> rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
> v3 patch series.
> https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/
> 
> It supports only the delay value of 0ns and 2ns.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Rob Herring <robh@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
