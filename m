Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FB75B8A3F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiINOXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiINOXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:23:03 -0400
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84F14DB05;
        Wed, 14 Sep 2022 07:23:01 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id e35-20020a9d01a6000000b0065798eb8754so1347247ote.2;
        Wed, 14 Sep 2022 07:23:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rFWM9xJDGT4Rok1gsNfMbL/VvApMW/v8QoJV95QdoOE=;
        b=1igSJXWzf297Xk6z76riD4/2cs3Bzdl07GMaShAi2dPzqxDUvO1yNVZokB6H3x3kAF
         JSRVrLSGK+MtJ7ZR07vFU5Kci7YaeYxY5N8aYOXtz3svidaH1juZcENssWzm7TK/Fgoc
         uNu01E7+Gm/+8W/O/E6TbhMj8KkS/ZVeob+4Mywd0m65rTkPSKUgHJdYvSv53r2SOZTv
         ntY09kZk8NdLqnE0bTf9Yx97fl9HHdvbRK0yE8zLrv7Rm0Xcj7eomdBIbh18ZFLvPRWG
         iZvBUrM4B5SzyeUPswYlWdwypV23tZXALyxSwrUoOT2iyy/0jTj99tgLquPwKXdRUVzu
         aZug==
X-Gm-Message-State: ACgBeo2Z2700e19Wfz5CLmk9994jx59oSR0kGngyppe0mg6igHiNDIod
        suxBRlp2d2qolIWJWXabFQ==
X-Google-Smtp-Source: AA6agR5/Lw0KS2dspu14h4yOvBn3OtsrouCvmKRmWqehElS/IqQXm+K+23wFvn9TpuAw2tqKxhOjfQ==
X-Received: by 2002:a05:6830:1ca:b0:655:d22f:22a with SMTP id r10-20020a05683001ca00b00655d22f022amr7548293ota.326.1663165380380;
        Wed, 14 Sep 2022 07:23:00 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w15-20020a0568080d4f00b0032f0fd7e1f8sm6351804oik.39.2022.09.14.07.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 07:23:00 -0700 (PDT)
Received: (nullmailer pid 2148013 invoked by uid 1000);
        Wed, 14 Sep 2022 14:22:59 -0000
Date:   Wed, 14 Sep 2022 09:22:59 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     lorenzo.bianconi@redhat.com, nbd@nbd.name, kuba@kernel.org,
        linux-mediatek@lists.infradead.org, john@phrozen.org,
        netdev@vger.kernel.org, matthias.bgg@gmail.com,
        devicetree@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org,
        sean.wang@mediatek.com, ryder.Lee@mediatek.com,
        Bo.Jiao@mediatek.com, evelyn.tsai@mediatek.com,
        edumazet@google.com, Mark-MC.Lee@mediatek.com
Subject: Re: [PATCH v2 net-next 02/11] dt-bindings: net: mediatek: add WED
 binding for MT7986 eth driver
Message-ID: <20220914142259.GA2147968-robh@kernel.org>
References: <cover.1663087836.git.lorenzo@kernel.org>
 <2d05849aa9fdb5d14897adc51fcd93ace27f610d.1663087836.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d05849aa9fdb5d14897adc51fcd93ace27f610d.1663087836.git.lorenzo@kernel.org>
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

On Tue, 13 Sep 2022 19:00:52 +0200, Lorenzo Bianconi wrote:
> Document the binding for the Wireless Ethernet Dispatch core on the
> MT7986 ethernet driver
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../arm/mediatek/mediatek,mt7622-wed.yaml     |  1 +
>  .../mediatek/mediatek,mt7986-wed-pcie.yaml    | 43 +++++++++++++++++++
>  .../devicetree/bindings/net/mediatek,net.yaml | 27 ++++++++----
>  3 files changed, 62 insertions(+), 9 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wed-pcie.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
