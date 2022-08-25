Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF235A1A05
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbiHYUH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiHYUH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:07:58 -0400
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28219B777E;
        Thu, 25 Aug 2022 13:07:58 -0700 (PDT)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-11ba6e79dd1so26295642fac.12;
        Thu, 25 Aug 2022 13:07:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=dcjkA8oR36peP3szO6S9L8w7MpN9/Fk3Gid3MLuZnfs=;
        b=ymyLYMTrtpUudoanDrvWMDQ5ZfriCjgJBhgv6SHIkAAdLYJKg1VlQb32xQjM0wBLru
         qCJc3zXvHOqDKHJLM6L1OcsT4r1htp6JPUbl/Rt3h5IhfNRAhwwIdHran8S8nu4fYZ6x
         CZ7R1AHXxkOmkROMIUdrriudlBWb0E4f8KmltOmBObnjHJp0oQLSfk9kOUmgW9zoYceh
         ZBzIAZHUbqNiRRZVdANDFxP9xHaFJh8JWoPcz2E/WnYWJd9OZl5lUNESgHyxETSD+RFg
         S2lRdY97IrpTNR8YVMs37xr2sz5p10ipbSQPEoaCOfKZdIqVP/XlUe2Twg9iIsupfL0s
         6tmw==
X-Gm-Message-State: ACgBeo35OKH1GxFWezwaj3uZAvXQqdl3fjxcn5pvt4Gn9czdzNNsR78j
        tKTf8T+msjXiiibJHLeOqg==
X-Google-Smtp-Source: AA6agR5PXbEwCG8AwialgepZdugBrmMEZdowrhrFPXaxg+wjPbVy2Oz6dHDL8A5G0BoeyqvlBsw2Bg==
X-Received: by 2002:a05:6870:5820:b0:11c:b6d0:b84c with SMTP id r32-20020a056870582000b0011cb6d0b84cmr307885oap.236.1661458077465;
        Thu, 25 Aug 2022 13:07:57 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t38-20020a05687063a600b0011bde9f5745sm79713oap.23.2022.08.25.13.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 13:07:57 -0700 (PDT)
Received: (nullmailer pid 1604965 invoked by uid 1000);
        Thu, 25 Aug 2022 20:07:55 -0000
Date:   Thu, 25 Aug 2022 15:07:55 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Landen Chao <Landen.Chao@mediatek.com>, erkin.bozoglu@xeront.com,
        linux-mediatek@lists.infradead.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>, netdev@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Daniel Golle <daniel@makrotopia.org>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v6 1/6] dt-bindings: net: dsa: mediatek,mt7530: make
 trivial changes
Message-ID: <20220825200755.GA1604801-robh@kernel.org>
References: <20220825082301.409450-1-arinc.unal@arinc9.com>
 <20220825082301.409450-2-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220825082301.409450-2-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 11:22:56 +0300, Arınç ÜNAL wrote:
> Make trivial changes on the binding.
> 
> - Update title to include MT7531 switch.
> - Add me as a maintainer. List maintainers in alphabetical order by first
> name.
> - Add description to compatible strings.
> - Stretch descriptions up to the 80 character limit.
> - Remove lists for single items.
> - Remove requiring reg as it's already required by dsa-port.yaml.
> - Define acceptable reg values for the CPU ports.
> - Remove quotes from $ref: "dsa.yaml#".
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 50 ++++++++++++-------
>  1 file changed, 31 insertions(+), 19 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
