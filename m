Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF0A4E6C0C
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357455AbiCYBgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357426AbiCYBfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:35:17 -0400
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38514C12FE;
        Thu, 24 Mar 2022 18:33:00 -0700 (PDT)
Received: by mail-oi1-f182.google.com with SMTP id 12so6724032oix.12;
        Thu, 24 Mar 2022 18:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NoOzwpyI1Ds0dVyme/fVuHLFCjknM/Qs7UeN2WmSfX4=;
        b=hCXYgVjWOU3sSk5uBiTISjANkwWhjea72HLTTLGxh91w0Z4Ga/MvsNw9SoDoHBP/S7
         m5L8Gzz0DJs7Hw7HuOUZcflcrJNJ1HZwK2DTw3cvDca1sfLSxMgYDZeki2HFgJIWRfdZ
         TynZw3EqdrBIpZwMAUul/q7SNC893fA2WSSKYNENBU1h8sIRx/DgUFkbc3KXMgAIh84q
         S2Q/Fj1AYtJika2RLm8euLsO+CW1ECnSOpEX1A4ccFkeqdopfdH7VvmE9VJS1j3w8kEW
         0XdfUxd5qWUll6NVFdL2H5jZOMpcuxFQuazD1jBlBM0WqCvGgR4NfNoLVJYBamshK1wL
         EWBw==
X-Gm-Message-State: AOAM530AfGgSLls5Ud/HKm0K/4/IFLLscD//W57uW2rErg0vaX888HDi
        MSEFhE2LXU/r+4eSmoJDNw==
X-Google-Smtp-Source: ABdhPJwE5Pa4e88ba6g42QV2RJNfidI9/etVdqKq0RQlgzPN/XyPBceq2bvtCosS4jT+Pyn5feZyMw==
X-Received: by 2002:a05:6808:188a:b0:2da:5026:3663 with SMTP id bi10-20020a056808188a00b002da50263663mr4076928oib.79.1648171979571;
        Thu, 24 Mar 2022 18:32:59 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w8-20020aca3008000000b002ef7e3ad3b8sm2089430oiw.29.2022.03.24.18.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 18:32:58 -0700 (PDT)
Received: (nullmailer pid 2946043 invoked by uid 1000);
        Fri, 25 Mar 2022 01:32:57 -0000
Date:   Thu, 24 Mar 2022 20:32:57 -0500
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-mediatek@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-kernel@vger.kernel.org, macpaul.lin@mediatek.com,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        srv_heupstream@mediatek.com
Subject: Re: [PATCH net-next] dt-bindings: net: snps,dwmac: modify available
 values of PBL
Message-ID: <Yj0byY2NZ6gQ5CBw@robh.at.kernel.org>
References: <20220324012112.7016-1-biao.huang@mediatek.com>
 <20220324012112.7016-2-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324012112.7016-2-biao.huang@mediatek.com>
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

On Thu, 24 Mar 2022 09:21:12 +0800, Biao Huang wrote:
> PBL can be any of the following values: 1, 2, 4, 8, 16 or 32
> according to the datasheet, so modify available values of PBL in
> snps,dwmac.yaml.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Applied, thanks!
