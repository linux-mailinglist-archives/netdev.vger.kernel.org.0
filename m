Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7B354BDBB
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 00:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349827AbiFNWfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 18:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345124AbiFNWf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 18:35:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6CC4EDCA;
        Tue, 14 Jun 2022 15:35:27 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id a10so9661622pju.3;
        Tue, 14 Jun 2022 15:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NwwLE3/14phzBfjRizqiAq2vengibXcV3OpeGRTTx4A=;
        b=aYWZw5Ji6QQA51FQsaM4Vc7ZZN6xsfrRwRNaU3Q35YA4tq6kS9doapSK2QIL0jQ5wf
         mDr0cwFET3f8gJ87YfxKe0kZPrWyVNutkqn77emxOHtmXQV9rBacfo/Sdc2rb54Kp2FQ
         K24gD0poQ6LgJhkqKJdZ6v2K5veqhS+ovFjX6g7HiGh2ejhBTJAl8j7wQMWZz8C6iuhy
         TxLGMJTR5qRWcBZ2wNEmeis7UaLEhGK3MtfO6Zc+CDreNt1bAK2OSWjfTgjQxbsLRdqs
         ryvGXdW9vbORyB+QBKMEZLlw5nGWqvHLU5ufCn1pW7CLCoJ5wcfciQ/k8jF0AalI/aBj
         c3xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NwwLE3/14phzBfjRizqiAq2vengibXcV3OpeGRTTx4A=;
        b=M2ljtRwMpgCMYBIYk8i/Md8Jg3Lesh0XGo8KenccTzoXbI9vM0OUIa2VFhwECMoeN0
         teaNe62Lqy2wxp6PA3DMM+TU3aCsPeJhjGJOXALuqfmiSQntWfZ0ErHtP2+Av57oupHi
         UWKUrjsUQztPRrMF5tZY9bA7RwHKa9FPU4BMai+W28NCF3ZnjaTuH5B4vom6mLquTCo2
         5t19FbttUbNSDAc0DWICxnc+w2z4sQrqQ+XdzWu5i0T0RAEoAOW7so7bq1Ec3UMF2EsL
         kBTgueBO5UF+X3UNwm4CnrU0iP987BnMzuO9J6Z8mdxV5Fue44xbezy+am+/le3GoasN
         vKDw==
X-Gm-Message-State: AJIora+liQ1l6Rxh5i71+kF0Zn5eBJ4aVfpcVeHRhm88DWUiuiTfj75m
        yX7XushyITr/R1rxzjOTcw8=
X-Google-Smtp-Source: ABdhPJx/RHkeFCVkRg7nBFbWmI2VL038XtCgy8qmzH1Fp7OdkNHaYk9vLplec+dk5bINIVeK6WuE3g==
X-Received: by 2002:a17:902:d312:b0:168:9573:8043 with SMTP id b18-20020a170902d31200b0016895738043mr6656295plc.44.1655246127468;
        Tue, 14 Jun 2022 15:35:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g12-20020a056a00078c00b005190eea6c37sm8067747pfu.157.2022.06.14.15.35.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 15:35:26 -0700 (PDT)
Message-ID: <3d7d69c1-c0f9-45e8-7e0a-2b57c96dd14a@gmail.com>
Date:   Tue, 14 Jun 2022 15:35:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 3/6] net: dsa: mt7530: rework mt753[01]_setup
Content-Language: en-US
To:     Frank Wunderlich <linux@fw-web.de>,
        linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
References: <20220610170541.8643-1-linux@fw-web.de>
 <20220610170541.8643-4-linux@fw-web.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220610170541.8643-4-linux@fw-web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 10:05, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Enumerate available cpu-ports instead of using hardcoded constant.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
