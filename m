Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1166A335A
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 19:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjBZSEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 13:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBZSE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 13:04:29 -0500
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7123C66B;
        Sun, 26 Feb 2023 10:04:28 -0800 (PST)
Received: by mail-il1-f179.google.com with SMTP id h10so2778286ila.11;
        Sun, 26 Feb 2023 10:04:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UMSuEX3PzF7dxnK96QE6BnCdpykh3c5U6wgrobTc4/c=;
        b=J+lJ0YGORA0EfKzYu8njneNWIuqejDv7XvGnBItFAVwgfPQH3GMD7mowEyH/B8L9A9
         wbiDtQUXUhP2UPJ0ICstvB6augq+6BPeFD6QtIgCoWtJ2IDDaWd/RT0j1KzCAO1tqtCj
         gM7IKMOYlq/Fy2akFyAwK51uMoQ2uoBfMNnfPg3msVCWfDgy/uvB203JgecLm66zW6cJ
         hiRsFy+vjszoWMH6RmmNvH7aKthqp/QCbnGZE0BxJB0qnPjVeWS868m42ALU1gYKso8F
         4CCotOtoiElPI+DLKb/pf7NtYBW9PGDI7WllIMEHPHwTsh5VVF3sopxHTN6U7/3oym5f
         3XbQ==
X-Gm-Message-State: AO0yUKWf4FsQO0pD9xTbtjgiCuqk4zGUAJV50O/9rPrepOxnFuUlWm+N
        SZ9JPgPrxwerUgVtNumcIyDc7N9SyQ==
X-Google-Smtp-Source: AK7set/i0/757auG+RPj2GgQ8Gf8IwoAPeqDUP6Mh+t5Eh/sv0npg2IlH3JW8tgYlgcPvcdhpZtEdA==
X-Received: by 2002:a05:6e02:16cd:b0:316:acef:e65a with SMTP id 13-20020a056e0216cd00b00316acefe65amr20992008ilx.17.1677434668129;
        Sun, 26 Feb 2023 10:04:28 -0800 (PST)
Received: from robh_at_kernel.org ([2605:ef80:8069:8ddf:ff6b:c94c:94fd:4442])
        by smtp.gmail.com with ESMTPSA id a4-20020a92d584000000b003153213c586sm1411833iln.30.2023.02.26.10.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 10:04:27 -0800 (PST)
Received: (nullmailer pid 105263 invoked by uid 1000);
        Sun, 26 Feb 2023 18:04:23 -0000
Date:   Sun, 26 Feb 2023 12:04:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     arinc9.unal@gmail.com
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: net: dsa: mediatek,mt7530: change some
 descriptions to literal
Message-ID: <167743466228.105184.14755620917019401339.robh@kernel.org>
References: <20230218072348.13089-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230218072348.13089-1-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat, 18 Feb 2023 10:23:48 +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The line endings must be preserved on gpio-controller, io-supply, and
> reset-gpios properties to look proper when the YAML file is parsed.
> 
> Currently it's interpreted as a single line when parsed. Change the style
> of the description of these properties to literal style to preserve the
> line endings.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml        | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>

