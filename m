Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3298F5A6B2B
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 19:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbiH3RsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 13:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiH3Rr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 13:47:56 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EC1104009
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 10:44:34 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id w19so9184596ljj.7
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 10:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=rmlcaT4uod7PpBdmIDlVofuYmhAw0mWF1ocMR7J7jHQ=;
        b=cVmXkrXVB/VhRGL6WXUplEkAQijZtZRPc62bxRDQjALkNmsWvRBHB8+SZLdTSrr7Q2
         jJNPQDHL443hUjM3gm9pRsjjswMMUUxwAqnjJ44an8iwVtGJlPxWlPBGfVEN0PSk3fd+
         X+K160op9w//KYces00QD69pfUOTiQTGjOuQTQVU5NvlTqXtaYCcyzab4kSChbBP2AvF
         cw4SrUCA15vFvM6aZQFS1XZeIaQvGIENMA7nLQ/WODSBrmSLF8GYf6oHwHXfBmhEnv7O
         bq2DewdxbnUmsAbQejrrnx3RQO+QBInCtHIXVri/Q9fTZ16CIKB6QI3CpcUI/nSZE5Ul
         8AHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=rmlcaT4uod7PpBdmIDlVofuYmhAw0mWF1ocMR7J7jHQ=;
        b=7m5kJD/KTvotqo3UVuEF81oMHcxC9KnVfOM0Nn6y8I4e/hzg55MJ7mz5YuRQ77Ppr2
         +CrEcWWVoU2y0FgxzIS9y9dTBGcLXdB8OVqwBButnztm3Sudf3mmb3Uol2V/re+6EJ0Y
         CcUP6XsTK7Lm5miWjaBoEJN4qaQ0/U2csLLPr20sc0GTwwfrk1E3heV79QM6lWABNifz
         SU/rqIuv0/1TesM/GSYBPlYkAtntmmLgNbbbSEXyMhj2LevdeVo1ht8Q88BgIGZ0AeuA
         ojRFKDF6cJt7g3cr4sA7lsi7orL78OWidsC2+YbtcEul9ZD4poMJLBRZyw5Niyr/rGOC
         t1Nw==
X-Gm-Message-State: ACgBeo0sAbs5w3/EjSg7tImrHEod2KG7uq/+k2nJNlUqW6jaKRxwcytI
        429bCGZ+B6XVM0WTIzMamMmFFUlIxoaYSgzL
X-Google-Smtp-Source: AA6agR4PY6CaaARXSRtsxN/bcXrQHnxvJheo2EM1aAUGuEOPcsmtvuMW25Oc0Y2r7Drxt2Wkb0cBYQ==
X-Received: by 2002:a05:6512:3b20:b0:492:c04a:1520 with SMTP id f32-20020a0565123b2000b00492c04a1520mr8189476lfv.86.1661880699713;
        Tue, 30 Aug 2022 10:31:39 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id 13-20020a2e050d000000b0026392faf543sm1235119ljf.77.2022.08.30.10.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 10:31:39 -0700 (PDT)
Message-ID: <23539312-caaa-78f0-cd6c-899a826f9947@linaro.org>
Date:   Tue, 30 Aug 2022 20:31:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 1/3] dt-bindings: can: nxp,sja1000: Document RZ/N1
 power-domains support
Content-Language: en-US
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
References: <20220830164518.1381632-1-biju.das.jz@bp.renesas.com>
 <20220830164518.1381632-2-biju.das.jz@bp.renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220830164518.1381632-2-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/08/2022 19:45, Biju Das wrote:
> Document RZ/N1 power-domains support. Also update the example with
> power-domains property.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v3:
>  * Documented power-domains support.

You made them required, so it would be nice to see reason in such
change. The commit msg says only what you did, but not why you did it.

Best regards,
Krzysztof
