Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB1624B37
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 21:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiKJUJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 15:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiKJUJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 15:09:27 -0500
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D3F10B5F;
        Thu, 10 Nov 2022 12:09:26 -0800 (PST)
Received: by mail-oi1-f180.google.com with SMTP id t62so2948561oib.12;
        Thu, 10 Nov 2022 12:09:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8DAIYPywI0mxn7CCbjHVTuM6h/N+D8/hFU0/orRKO0=;
        b=kiwTAlgjK4rLuDwxjXxBia4QYhvZrd0nXziWRR1AFJlH7zfnbhq5JjmegPuETzNE3q
         FjnC+2Q3ZE/i50k+vnK+WCg4kdK6iJayrp4fpCveD+9UhwAXVFYWebVoTRoKV6y4JDzS
         8n7CcUw1IAZyuYwmC7/uhwBGLL8oLx1MW+pNXQLtpU55SR5EMQOea2dygncF9ARyoTyz
         RPlozoU49jDTJQR0vOdoNG/oG+YzGy3ffrhLHFTykFjSrDAxlDL6tmvnyJZIANrwQV7Z
         UeHjqTkgNO1jjirwrUVDrPWeYUHElGS6tDbVLZf9jRSQL3CIq9Pn3ExaoiP/ofp21bPE
         lgxQ==
X-Gm-Message-State: ACrzQf3ljxFM9Msi8ohEr7wbO6fEKLLbu4cpaZ82Bm7OmR1ynhqX4nNE
        0IVP9urfD3ZXyL10r7egUw==
X-Google-Smtp-Source: AMsMyM5GXBLkSQdxXUGbRIIAq883HBK7Xe0JJqWb1HTOOngkCOzjFhLSV9rqe8a/Y/gY0wHmfaBTzQ==
X-Received: by 2002:a05:6808:1396:b0:359:f059:ed05 with SMTP id c22-20020a056808139600b00359f059ed05mr1956775oiw.148.1668110965817;
        Thu, 10 Nov 2022 12:09:25 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id bu7-20020a0568300d0700b0066cf6a14d1asm253530otb.23.2022.11.10.12.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 12:09:25 -0800 (PST)
Received: (nullmailer pid 907677 invoked by uid 1000);
        Thu, 10 Nov 2022 20:09:26 -0000
Date:   Thu, 10 Nov 2022 14:09:26 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com
Subject: Re: [PATCH v4 net-next 2/8] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Message-ID: <20221110200926.GA885371-robh@kernel.org>
References: <cover.1667687249.git.lorenzo@kernel.org>
 <2192d3974d30b1d0b8f4277c42cdb02f6feffbb9.1667687249.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2192d3974d30b1d0b8f4277c42cdb02f6feffbb9.1667687249.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 05, 2022 at 11:36:17PM +0100, Lorenzo Bianconi wrote:
> Document the binding for the RX Wireless Ethernet Dispatch core on the
> MT7986 ethernet driver used to offload traffic received by WLAN NIC and
> forwarded to LAN/WAN one.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 52 +++++++++++++++++++
>  .../soc/mediatek/mediatek,mt7986-wo-ccif.yaml | 51 ++++++++++++++++++

Are these blocks used for anything not networking related? If not, can 
you move them to bindings/net/. Can be a follow up patch if not 
respinning this again.

Reviewed-by: Rob Herring <robh@kernel.org>
