Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5632554039E
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 18:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344869AbiFGQTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 12:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343714AbiFGQTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 12:19:38 -0400
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AE9101715;
        Tue,  7 Jun 2022 09:19:37 -0700 (PDT)
Received: by mail-io1-f41.google.com with SMTP id 134so9724077iou.12;
        Tue, 07 Jun 2022 09:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T8bDFzFxvGKBXIa1I0lB1TI0RNvCh77l2ZFzrHICquA=;
        b=toHO4jjq+9pb1EcDTWh377j/Z4lEvzFmh/24XMX4DqcMlDYfIoVhnTRRWvY9vak4pk
         pk8RpzDcz22HZ+taEPuFbIBjBu7lNTgHzGTlz6fwnjt3bQASKGwiWN9VgC7iqlW08jhn
         1KW+oMf+cu1GaQz78PW0bgUewIr8dqW5yA8Cvh9fy97FlG/v+se2wZ1sgmxRLJjwxhEi
         DWVW0JXeqSQfRwgxGzQT6wxNrzT/FqlStnc/6XiyTy/322uveZZP/PLm6Fu83bDXbouy
         9fu0A2GQbHuEo2yrgpddgBrSaz+qvRjBQYNII2Bd3P4vFvVLZOJhhjLzpuX9N+7L6YoW
         Qz8A==
X-Gm-Message-State: AOAM533d81of+n23h68OkSOtb8/kLx55/cCbvn4siCFn1JVUq1Do5Zj2
        DT3TIlNYwJpWSyjGEjkr6Q==
X-Google-Smtp-Source: ABdhPJznA3tBEmTJuk9dMlI0xK1ImseC7RMKP1A1Ss/doNhS2WbvIuDdne9RTEmT/Vyt1gLcxzNPog==
X-Received: by 2002:a05:6602:14cc:b0:669:7561:ee0d with SMTP id b12-20020a05660214cc00b006697561ee0dmr2260716iow.156.1654618776943;
        Tue, 07 Jun 2022 09:19:36 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id x19-20020a056602211300b0065a47e16f49sm1945360iox.27.2022.06.07.09.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 09:19:36 -0700 (PDT)
Received: (nullmailer pid 3370017 invoked by uid 1000);
        Tue, 07 Jun 2022 16:19:34 -0000
Date:   Tue, 7 Jun 2022 10:19:34 -0600
From:   Rob Herring <robh@kernel.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Daire McNamara <daire.mcnamara@microchip.com>,
        linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Albert Ou <aou@eecs.berkeley.edu>, linux-can@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] dt-bindings: can: mpfs: document the mpfs
 can controller
Message-ID: <20220607161934.GA3369934-robh@kernel.org>
References: <20220607065459.2035746-1-conor.dooley@microchip.com>
 <20220607065459.2035746-2-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607065459.2035746-2-conor.dooley@microchip.com>
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

On Tue, 07 Jun 2022 07:54:59 +0100, Conor Dooley wrote:
> Add a binding for the can controller on PolarFire SoC (MPFS).
> 
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> ---
>  .../bindings/net/can/microchip,mpfs-can.yaml  | 45 +++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/microchip,mpfs-can.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
