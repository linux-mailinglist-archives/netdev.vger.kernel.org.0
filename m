Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDE65B8B4B
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiINPHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiINPGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:06:52 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DCA7757C;
        Wed, 14 Sep 2022 08:06:51 -0700 (PDT)
Received: by mail-ot1-f48.google.com with SMTP id q39-20020a056830442700b0063889adc0ddso10550800otv.1;
        Wed, 14 Sep 2022 08:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=DHDk+ujBwhDBhgTz7mEiQ8aG+EOFTq+3XFCnw+r6W5g=;
        b=fb8oaCB0VDjVV/yaX79609SjkUhx29lqxhD1wutfMrND3E8LcGwR+3q0L0yE9iLurR
         hWDrdSEIsc09YrzC1y4hMMJEjdzC4yiMGcRtNXhqkh7Ij4BZwnM0Q5Yc3uhnmq83hO8E
         AjrgQ+aD1qYTJzB8E2b7R+jHZERbDsls8EQrkwyHnIhW8SZKvPI1XOF5Ci6Z3nyN/cqv
         Olcf2uFM8jVsbR9GGYwbk2g7keL4+hxKG9Al5n65rsBeHltgCdnPhd6ApeZLaZhjSH+s
         0wU37IALYC7YVsWjJ6VThxl/bay+zB0U6ef55Qi5CJW+20g74ZKc3zvxlOpdUowKRqPw
         ALcg==
X-Gm-Message-State: ACgBeo1KYNdoG8oMWGEucbc07/U25Ws0XOW/SvMU3Nh9QYXeTdGr0O95
        IdF4rq1h30ORO3wGOEy/nw==
X-Google-Smtp-Source: AA6agR792Z7UA4vog+YncnU/+uNb0qn6XVDArhATm/jBKo9QXacFuu0opFQm/3EpAA4itn5bYq/LIg==
X-Received: by 2002:a05:6830:2645:b0:638:99dc:e5e0 with SMTP id f5-20020a056830264500b0063899dce5e0mr15510808otu.80.1663168010178;
        Wed, 14 Sep 2022 08:06:50 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p15-20020a0568301d4f00b006393ea22c1csm7399789oth.16.2022.09.14.08.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 08:06:49 -0700 (PDT)
Received: (nullmailer pid 2226063 invoked by uid 1000);
        Wed, 14 Sep 2022 15:06:48 -0000
Date:   Wed, 14 Sep 2022 10:06:48 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-mediatek@lists.infradead.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>, erkin.bozoglu@xeront.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>, netdev@vger.kernel.org,
        DENG Qingfang <dqfext@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mips@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] dt-bindings: net: drop old mediatek bindings
Message-ID: <20220914150648.GA2225972-robh@kernel.org>
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
 <20220914085451.11723-2-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220914085451.11723-2-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Sep 2022 11:54:42 +0300, Arınç ÜNAL wrote:
> Remove these old mediatek bindings which are not used.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/mediatek,mt7620-gsw.txt      | 24 --------
>  .../bindings/net/ralink,rt2880-net.txt        | 59 -------------------
>  .../bindings/net/ralink,rt3050-esw.txt        | 30 ----------
>  3 files changed, 113 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
>  delete mode 100644 Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
>  delete mode 100644 Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt
> 

Acked-by: Rob Herring <robh@kernel.org>
