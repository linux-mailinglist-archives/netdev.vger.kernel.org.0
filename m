Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377176E5021
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjDQS0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjDQS0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:26:43 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C303C1F;
        Mon, 17 Apr 2023 11:26:41 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id ey8so1909687qtb.3;
        Mon, 17 Apr 2023 11:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681756001; x=1684348001;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=foj2FZg70HNMg3V5x0Kz+tnYOlrRauJivuG7dJ4srDk=;
        b=QPo7rEYhug3JJgpy9Yfw4kT778/KMC6UTYG658AnGXtkntwskiuPTcwqIQ1mX97n1x
         xtOZoCh6OzGNS3Y1JCFFua4dl6QrYwf+vLPV3HfJMezibkY2mFgevwj6zUfaEfSYrHyn
         axMOsNu2+ZomDmbewpF15c76vf56UlxPp/5oHbU5B2WayY2MIEqTCR6hNn2iBk6oLN1P
         vD44A1PChsqcBrI9/+DEwEg7yCugNpbYXOOfjbADGnZUhdoEzfeH+EdME75oLbSStYFi
         h6JqLeE6kqBfhAJrCXkOZR6X1KaNIW44hYnSRmC/OhXGQEX9+vr8w50fxjBGFPAKwDAH
         0Szw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681756001; x=1684348001;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=foj2FZg70HNMg3V5x0Kz+tnYOlrRauJivuG7dJ4srDk=;
        b=VvhkIggBxDbChRGUuLZVSPJj+LGh3kdI6AJM8XaELwFxT5EBjXb+g1lfxx4G386SSb
         C0IdO9GRoJEXI8tx9T3upqlv7jGGExSiCfHkjtYlGQ80mFPhficVvKq0f7Jl9E/k629Z
         jPQval1USGdCmDphybxspNnrn1yffbO4U9Zgy3LV+Wxo6mm4H1z4jrM2K/IdSXVMqWec
         /470vi/JmaEGXd/8azRxnT0DevHwPp9GnODjp3/QpSKyjvvbrdC5Rf4Idezixqby2S0o
         x5Da2CtvfR6Bg/x4PdMh3AUh4GdK0NskIgrc9ZfDmrtwnDLOVOh6C5tJlD0nRO9C3yhn
         ePng==
X-Gm-Message-State: AAQBX9dnx6a28Mah3E6V/HD6okS9Tz/jKgAkmH0cy8F6z2HDUlBooERl
        xiGCrgpyGoXraBqHePW7nW4=
X-Google-Smtp-Source: AKy350ZwGxah12Zppxa0pFO2Ibp0e89Qq+9B+IHYw6c074kOEm7KrWZxdgcbNC+zEPm5ZKaMm0uf3A==
X-Received: by 2002:a05:622a:102:b0:3ba:26a0:d0ee with SMTP id u2-20020a05622a010200b003ba26a0d0eemr20968539qtw.52.1681756000846;
        Mon, 17 Apr 2023 11:26:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r12-20020ae9d60c000000b007485ba3d794sm1016544qkk.105.2023.04.17.11.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 11:26:40 -0700 (PDT)
Message-ID: <9a9b9c3e-c4c9-8fe3-7c06-850589bc853a@gmail.com>
Date:   Mon, 17 Apr 2023 11:26:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [net-next PATCH v7 05/16] net: phy: Add a binding for PHY LEDs
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
 <20230417151738.19426-6-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230417151738.19426-6-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/23 08:17, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Define common binding parsing for all PHY drivers with LEDs using
> phylib. Parse the DT as part of the phy_probe and add LEDs to the
> linux LED class infrastructure. For the moment, provide a dummy
> brightness function, which will later be replaced with a call into the
> PHY driver. This allows testing since the LED core might otherwise
> reject an LED whose brightness cannot be set.
> 
> Add a dependency on LED_CLASS. It either needs to be built in, or not
> enabled, since a modular build can result in linker errors.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

