Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE2E5F3449
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJCROD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJCRNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:13:25 -0400
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5BE32DBA;
        Mon,  3 Oct 2022 10:12:39 -0700 (PDT)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1322fa1cf6fso6430524fac.6;
        Mon, 03 Oct 2022 10:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=uRqCFgOMTpM36wCs+5DGyRVOIuiv4dTJX59+BmawhqY=;
        b=e23kMsM232bPvucobkYeS46SgyiE2p85WQKp9Nw822HodnoMw9W/8edFKZQCPDq/DP
         BwbYyEpCCedQNWQRI9cPvehIbyl1L0b+ZH0C2AnKhSxdavh4hwBLuNOGck+RIY2AL7CR
         7VWc0JCQ/0NhXFfHwzUB7jpadH9+jma/MGDpiycB7AlFvCMSbzAVHNrlDuD99LqMb4Wt
         HzchMGLVl8NlB3i9h/MJHc0tYj4ADWhcFD1i7guaBc089fQuWd/6D2L9AdpvH6fy+R0o
         lDkk36AN6sKGzT2zyJ/D985e9wEPv6Ow8HwV03TmRi3toByIlq1LNsp/F2I5+goIwldh
         j8Ng==
X-Gm-Message-State: ACrzQf3NKgfUc5UjYYkz7b7UR1oQRv0UnRVyEUq2f5/hef14SrQd1aJ/
        68I3ZB2VS2+84ygqGpxq/Q==
X-Google-Smtp-Source: AMsMyM4/DXxwUHxEN186bkLWdJo11qUzRyKhmVDXYKgZWltQ1KnSjcboYvU0qrUc5MH1Xqo6wd3P2A==
X-Received: by 2002:a05:6870:59d:b0:f3:627:e2b0 with SMTP id m29-20020a056870059d00b000f30627e2b0mr5849192oap.47.1664817159014;
        Mon, 03 Oct 2022 10:12:39 -0700 (PDT)
Received: from macbook.herring.priv (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v68-20020acaac47000000b00349a06c581fsm2556020oie.3.2022.10.03.10.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 10:12:38 -0700 (PDT)
Received: (nullmailer pid 2461899 invoked by uid 1000);
        Mon, 03 Oct 2022 17:12:37 -0000
Date:   Mon, 3 Oct 2022 12:12:37 -0500
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        devicetree@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH net-next v6 1/9] dt-bindings: net: Expand pcs-handle to
 an array
Message-ID: <166481715716.2461840.14872629352743096411.robh@kernel.org>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
 <20220930200933.4111249-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930200933.4111249-2-sean.anderson@seco.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 16:09:25 -0400, Sean Anderson wrote:
> This allows multiple phandles to be specified for pcs-handle, such as
> when multiple PCSs are present for a single MAC. To differentiate
> between them, also add a pcs-handle-names property.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> This was previously submitted as [1]. I expect to update this series
> more, so I have moved it here. Changes from that version include:
> - Add maxItems to existing bindings
> - Add a dependency from pcs-names to pcs-handle.
> 
> [1] https://lore.kernel.org/netdev/20220711160519.741990-3-sean.anderson@seco.com/
> 
> Changes in v6:
> - Remove unnecessary $ref from renesas,rzn1-a5psw
> - Remove unnecessary type from pcs-handle-names
> - Add maxItems to pcs-handle
> 
> Changes in v4:
> - Use pcs-handle-names instead of pcs-names, as discussed
> 
> Changes in v3:
> - New
> 
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml          |  2 +-
>  .../devicetree/bindings/net/ethernet-controller.yaml  | 11 ++++++++++-
>  .../devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml   |  2 +-
>  3 files changed, 12 insertions(+), 3 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
