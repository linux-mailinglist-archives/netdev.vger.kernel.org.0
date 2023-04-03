Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A748B6D5290
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbjDCUgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbjDCUgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:36:16 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6396B40EF;
        Mon,  3 Apr 2023 13:36:12 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-17aa62d0a4aso32217890fac.4;
        Mon, 03 Apr 2023 13:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680554171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+FV7kaEhYq8hPkWP8x51YjtButdsWCOy21wJQSXxrNc=;
        b=BGlRdg6rZMgWmsjAbw9fA2sQDKVXF3k7CUqcw5iez7mzemzqtS5lINkDeR0ykg/Z2A
         +ZdSKyvyWFjPKO6JngnORcZR7+Gykyyy/xjPSz0w62MJSwvirmY4dd9hXM5VBS0tnTyi
         n7cR9LRww/HIJ/kkt/XBpihMeHgZoBFIXYaTqOie5NqWJFwbVATmcOGUh4aAkg5HjRJf
         Kj60pqtndcC8nrtTV+3YpSjwhK8bUANcQFJ5fholi3dbkdaUdxPzP+3DCNJN58DJc4pW
         VmZcraNdTBzxajsgqREtwZgrGyKyW1xAQGPZgbOcFSDLlbKXPAq7z2E5ceoVUoiNHtHq
         7djw==
X-Gm-Message-State: AAQBX9fprjCsmm337uekqradsGlePRdajgM79sl0XM4bgm1guICTGHFH
        JuDbuNKgEtnpKucINJzgag==
X-Google-Smtp-Source: AKy350aB1944ukBSjhjdSkpx32AuFktYk5TasyKwQZRi4khTxO6rgxHBV5Rzx3+wZXB2zK2Ppb6XhQ==
X-Received: by 2002:a05:6870:d210:b0:172:80fd:8482 with SMTP id g16-20020a056870d21000b0017280fd8482mr451861oac.5.1680554171357;
        Mon, 03 Apr 2023 13:36:11 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id aw20-20020a0568707f9400b0016e49af5815sm3878520oac.51.2023.04.03.13.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:36:11 -0700 (PDT)
Received: (nullmailer pid 1703260 invoked by uid 1000);
        Mon, 03 Apr 2023 20:36:10 -0000
Date:   Mon, 3 Apr 2023 15:36:10 -0500
From:   Rob Herring <robh@kernel.org>
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc:     pabeni@redhat.com, linux-kernel@vger.kernel.org, wg@grandegger.com,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, mkl@pengutronix.de, kuba@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-can@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        davem@davemloft.net
Subject: Re: [PATCH] dt-bindings: can: fsl,flexcan: add optional
 power-domains property
Message-ID: <168055416976.1703203.4200432741574181226.robh@kernel.org>
References: <20230328054602.1974255-1-peng.fan@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328054602.1974255-1-peng.fan@oss.nxp.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 28 Mar 2023 13:46:02 +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Add optional power-domains property for i.MX8 usage.
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>

