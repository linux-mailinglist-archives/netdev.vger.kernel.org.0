Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CD56A1B54
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 12:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjBXLUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 06:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjBXLUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 06:20:41 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064DD63DE8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 03:20:38 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id i34so28169821eda.7
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 03:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v3hEGyCucdzbqe3LrutT0J4NZq9m5aBL5wEqBphvaXQ=;
        b=jbUpwEFLdpLKVZ953n8tg2+JdWrD2rrbXAVTkJRRzca1k45TyM00PvwsLpS0vJGFrc
         RwMLvwKwI8TwqNYj21oQJA/ud3Unyv4HVPhUVAe50anXgbAQmTwr0li8Xf+i6ZZHJ1im
         UCc0uoXxnARYlaoAX8eqvTYwDn1zSGFZ0u+N72c6LQ1VYgNk/JFUQCb3OJzvoyUEzoaD
         cRxSDJWSpmiEb7qYa/k0szyVNZ3gEQ8vnk08SvSP65B4jXmH6bf4LXWGRZq+aBwve8de
         ehfwXeVca7WeyRLbqMBhfzNx+pPeQzprzUc5xdj0xZTzxwdu5Xtitvmrwzt4Es8uGUnn
         khOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v3hEGyCucdzbqe3LrutT0J4NZq9m5aBL5wEqBphvaXQ=;
        b=1b7P3gqdp4OcJaMQkWrSw8iEzQojuPmiPkh/7YyfdWQr/oVzs/dLidre8CDoF7Clyv
         thLk8kURG8MpXoc6TNmuwPILTRFwHGZwMIjWdt76ohn4tYVv8HfdNGDrsMcS/034+FRP
         XNgQe0nTd1nYaYUJCfQ86s6dtefkir7mV4uIqRmz49IDBnbs/wpMWw6LPlFD0ZgyDru7
         Zj9KSGWgauVi27Vzy+SybBjgNV/wpqw+JIhK7u04d0WDNNNQSUvPvxWS/UliG0K8rDjY
         0Nck4FdjB6Qy+AUrx75gPijhiWuZ2a4MPkGWJ/gV+Syi/qTtFkzfJ9VDJYIyNBMfIZL6
         UpcA==
X-Gm-Message-State: AO0yUKVzAebTJh1mMd4ChPf1G5RN/Xsb5QSsJ+ftwGyWlKgeccREN3ql
        iHcnxwz6hD2J/+uAXCYs3Mb5BQ==
X-Google-Smtp-Source: AK7set98CJO+wXTLM4UFAXnn0d/1LPj+v6ZqaACgh7v/kaIs6ZoV7T9E/BJ/U9Ahs/LjexIsQttccg==
X-Received: by 2002:a17:906:1093:b0:8b1:75a0:e5c6 with SMTP id u19-20020a170906109300b008b175a0e5c6mr26507949eju.18.1677237636530;
        Fri, 24 Feb 2023 03:20:36 -0800 (PST)
Received: from [192.168.1.20] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id kv7-20020a17090778c700b008e53874f8d8sm3436088ejc.180.2023.02.24.03.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 03:20:36 -0800 (PST)
Message-ID: <1cda61a7-91cd-6f47-619b-e38a5131d182@linaro.org>
Date:   Fri, 24 Feb 2023 12:20:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 2/3] dt-bindings: net: Bluetooth: Add NXP bluetooth
 support
Content-Language: en-US
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
References: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
 <20230223103614.4137309-3-neeraj.sanjaykale@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230223103614.4137309-3-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/02/2023 11:36, Neeraj Sanjay Kale wrote:
> Add binding document for NXP bluetooth chipsets attached over UART.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

