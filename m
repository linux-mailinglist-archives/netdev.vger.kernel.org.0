Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D456C8815
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjCXWHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjCXWHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:07:49 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C50158A3;
        Fri, 24 Mar 2023 15:07:48 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id ga7so2857280qtb.2;
        Fri, 24 Mar 2023 15:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679695667;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=beJEyR55nicgWvB9M86I+buLjk6LoWSlcejxfA/JAG0=;
        b=SIWLTsTemcfnRsAHFfiFS2+DTkpaPpdy1AozqOiKYYqqtD4Vh26H0UNg9kx+LTH0yH
         X6amfvUJ5sLq+Jv9zbM4qgBF4sOZl9Ofa5D4JDPbsVXYmYMAvt36DA0vEed/AIXrMips
         S0EpDbJX0Qus4zzmOGm+qKfMDqDMS9jWgk2tnb9WMCAG1Wrp0Tx4mg3lGYOpug0p5sW2
         HXJU8QRnq3PA0fxPJ0jDQ7MRpXo/W1TWQT+wuTkwEBa5ZWRl+7OQrq75cpTDJtbwn3Cb
         iGYNiE1fiw6fbNefxBIYZ/9y6xG1+ba0XEkHA7YWXQEJAPqKWJuAlV1e+Jxo61qX1tu9
         mW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679695667;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=beJEyR55nicgWvB9M86I+buLjk6LoWSlcejxfA/JAG0=;
        b=XHt9Wpc4U7arbja6jIvQlBOlz4gEQ5l/F+6S38LrRhBT6TJlUYDw31sTaWJnrHSGPS
         5jXbJ1u8CNfoOqqfqeluwdt/eHQgPoEuCse/+//qWpOZllWF+Nnv/EBrSZ5XNyswOEzP
         jJ3qFqhKbJfo8hBW9f+kFcz5cnua9fXcJeUdBEDM2+VfwPFQcoKGnFJcAnWk+w+jY+i1
         vxzXNLiQ0RWHJAvAWYDn7ZGYFjnXzlFk3x3asdbKKBjJicPwQLirikckBAl+Satg2iRN
         fcrb0mz85H4krdg7IuhA8IooEDw3YQSfCOWjiyMT+T2KSOnwoFV7q+vX/xs7E7tRHvUt
         R/eQ==
X-Gm-Message-State: AO0yUKVLnnQTcfxF6xuvffTJ3OtRPSHyrqiPT7+dZ3Y2HFjgQXAmQqiv
        TRg2o6amoM5WvRKTXmh3JgA=
X-Google-Smtp-Source: AK7set95CsrUxGR5Huw4UMykOTC0JjDrqW/qsbW4Zlmu1oj0ktvvomd82RSHijI7eGdpiRU+XlcV7g==
X-Received: by 2002:ac8:5f4a:0:b0:3e2:e71e:ff78 with SMTP id y10-20020ac85f4a000000b003e2e71eff78mr7812054qta.55.1679695667364;
        Fri, 24 Mar 2023 15:07:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b22-20020ac844d6000000b003e4d9c91106sm270574qto.57.2023.03.24.15.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 15:07:46 -0700 (PDT)
Message-ID: <caffd708-7734-e406-fe71-481fdac4cd7b@gmail.com>
Date:   Fri, 24 Mar 2023 15:07:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 2/2] net: dsa: b53: mdio: add support for BCM53134
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        paul.geurts@prodrive-technologies.com, jonas.gorski@gmail.com,
        andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230324084138.664285-1-noltari@gmail.com>
 <20230324084138.664285-3-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230324084138.664285-3-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 01:41, Álvaro Fernández Rojas wrote:
> From: Paul Geurts <paul.geurts@prodrive-technologies.com>
> 
> Add support for the BCM53134 Ethernet switch in the existing b53 dsa driver.
> BCM53134 is very similar to the BCM58XX series.
> 
> Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

