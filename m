Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD9054BDC8
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 00:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352001AbiFNWhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 18:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiFNWhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 18:37:06 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A8C4F44F;
        Tue, 14 Jun 2022 15:37:05 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id u2so9825993pfc.2;
        Tue, 14 Jun 2022 15:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ehMdU1wUOTSLPaXmLlr3cJgFkTKRonoGOZLrFCdQIRA=;
        b=Dp09UW6yv8u8DJ5Hc4yf8A/Y/UC+N8nBXwwzDZLo+VqmHZjkB9ewlAY8ajlUcZgF9k
         UdakADtH7vt28/CxePNkuxauxiqQqxDCbTSOobBH8vgPyKK9IF5Q/aD+EHPPI8eszJtz
         gAhyWu0ywr6XythaXm0cPINL7t5SGMwMxu2i9oHRqzEBy4Xi+APw4tY0zjOT0/n0N5B2
         2TEtazJ1HUE/v1T8CIv0BvwFqIKBPJ9q6iPJUHgTj8KgOr6AjrVn8doCYDrw7SWzDZH0
         xHRpoPnneeKxeI9z6Sykjqt5O4Fa0DdoXnrp5FCKxpzPQYYFjA21pgEyT7BWRO/cxIu8
         OIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ehMdU1wUOTSLPaXmLlr3cJgFkTKRonoGOZLrFCdQIRA=;
        b=uZxX8A9r+BHJ3mbOeRfwoI7dOo0BzmDMFlIWoTuSdp7HPtnIzXGQGNRDP3JuVTkECZ
         zdIX9x0VCCBrwZP9LSVdq40jwqmU+XvKyUcPKt3ouLBssFCjT6kfp0bNMGnNKOCCNTrV
         hT7khWoRmi1SjBlVeIGE1zxuC0VWnU2c5eGDXrFAG2Za0Hpz1H7Tgk6X06DXHopQxdvr
         dw/2zds72zQfRk1c7mslslnCpaaJkzQY3D/eSHqUWPM62dX4F7Tz88Q2L7sOc2PfZeqK
         enVbZmb5NETGRRwLP/w3PYVOKnRCUUTH+/V9RhilIdRKIss23N8Vi+3MEXHbBcxML9fL
         0BFw==
X-Gm-Message-State: AOAM532veZSTRseBsbX6BYxSooeUIqPfCXxpbBCtSWm/D1AMU69Hx8Fq
        CardQevux1AR4vOsNJPdYJk=
X-Google-Smtp-Source: ABdhPJyz5atbGbpNHgmgU5yU8QCEQtJBmUiQY46Exz4wbdmtkbxIaNTG9WUuvWndA7T87oS6MDSvFw==
X-Received: by 2002:a62:601:0:b0:522:7a73:c0b2 with SMTP id 1-20020a620601000000b005227a73c0b2mr6819990pfg.33.1655246224606;
        Tue, 14 Jun 2022 15:37:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x4-20020a17090a530400b001e0cc5b13c6sm108943pjh.26.2022.06.14.15.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 15:37:04 -0700 (PDT)
Message-ID: <ce8b295b-4330-f0c2-328a-eead693a1c79@gmail.com>
Date:   Tue, 14 Jun 2022 15:36:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 6/6] arm64: dts: rockchip: Add mt7531 dsa node to
 BPI-R2-Pro board
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
 <20220610170541.8643-7-linux@fw-web.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220610170541.8643-7-linux@fw-web.de>
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
> Add Device Tree node for mt7531 switch connected to gmac0.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
