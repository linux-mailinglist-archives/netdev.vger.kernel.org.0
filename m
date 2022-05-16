Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEDD528967
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245551AbiEPQCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245548AbiEPQCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:02:53 -0400
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E6E2FFC5;
        Mon, 16 May 2022 09:02:52 -0700 (PDT)
Received: by mail-ot1-f52.google.com with SMTP id z5-20020a9d62c5000000b00606041d11f1so10366328otk.2;
        Mon, 16 May 2022 09:02:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2s6RgX26JLo7sa0JrV1c49E2OU9YNnR6NzfYuC55HJw=;
        b=kS9hMd5oGAgvNNDw9e8ghXN3l4BufDKchaXUSkHp/OOC1+LGRqemsnHA68L37DuJJi
         33CNIJtz05HysEGaRvVeQtBJ0PqzbeOGluu/6/ULiKDB98SX68XZ4WS/RVO+8Xmt4itv
         0IvUXtXccFqtyF72VGVaW9Xih5odEtCSBo+7RcUF4oRswrSV7W2KkXzzZxev7XnSeWi5
         Zae+xy1aV0DyO1rzcd3UfEVVxrH4kgIyb/tUDAGo6quT47UzdEqXCWhlxQSqGvHIqtBA
         AUg0s9SrODcBLq1kGgMGF+vnZGnbixm6/nibvItP1Ip8yjmosslwat1UeiSG3XapciyI
         PBjA==
X-Gm-Message-State: AOAM5319tEhEsvhTNDrZa2mV6g8GafSAoHo++BPCddyIoHL+7Bn7xvRB
        FWMqFqPRLjsDuCf6V7kYRg==
X-Google-Smtp-Source: ABdhPJzGWjXFNa+2sThLYEmjVccy/lfEwvFPIeNBJBksa96HNq8xHla6Fr1Cd9RUBRKO59mgX2Jdew==
X-Received: by 2002:a05:6830:1099:b0:605:fa6e:ac2a with SMTP id y25-20020a056830109900b00605fa6eac2amr6260664oto.305.1652716971624;
        Mon, 16 May 2022 09:02:51 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t14-20020a056870f20e00b000f15a771206sm4918661oao.36.2022.05.16.09.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 09:02:50 -0700 (PDT)
Received: (nullmailer pid 2732173 invoked by uid 1000);
        Mon, 16 May 2022 16:02:50 -0000
Date:   Mon, 16 May 2022 11:02:50 -0500
From:   Rob Herring <robh@kernel.org>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        pisa@cmp.felk.cvut.cz, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, ondrej.ille@gmail.com,
        martin.jerabek01@gmail.com
Subject: Re: [RFC PATCH 2/3] dt-bindings: can: ctucanfd: add properties for
 HW timestamping
Message-ID: <20220516160250.GA2724701-robh@kernel.org>
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
 <20220512232706.24575-3-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512232706.24575-3-matej.vasilevski@seznam.cz>
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

On Fri, May 13, 2022 at 01:27:06AM +0200, Matej Vasilevski wrote:
> Extend dt-bindings for CTU CAN-FD IP core with necessary properties
> to enable HW timestamping for platform devices. Since the timestamping
> counter is provided by the system integrator usign those IP cores in
> their FPGA design, we need to have the properties specified in device tree.
> 
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> ---
>  .../bindings/net/can/ctu,ctucanfd.yaml        | 34 +++++++++++++++++--
>  1 file changed, 31 insertions(+), 3 deletions(-)

What's the base for this patch? Doesn't apply for me.

> 
> diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> index fb34d971dcb3..c3693dadbcd8 100644
> --- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> +++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> @@ -41,9 +41,35 @@ properties:
>  
>    clocks:
>      description: |
> -      phandle of reference clock (100 MHz is appropriate
> -      for FPGA implementation on Zynq-7000 system).
> +      Phandle of reference clock (100 MHz is appropriate for FPGA
> +      implementation on Zynq-7000 system). If you wish to use timestamps
> +      from the core, add a second phandle with the clock used for timestamping
> +      (can be the same as the first clock).
> +    maxItems: 2

With more than 1, you have to define what each entry is. IOW, use 
'items'.

> +
> +  clock-names:
> +    description: |
> +      Specify clock names for the "clocks" property. The first clock name
> +      doesn't matter, the second has to be "ts_clk". Timestamping frequency
> +      is then obtained from the "ts_clk" clock. This takes precedence over
> +      the ts-frequency property.
> +      You can omit this property if you don't need timestamps.
> +    maxItems: 2

You must define what the names are as a schema.

> +
> +  ts-used-bits:
> +    description: width of the timestamping counter
> +    maxItems: 1
> +    items:

Not an array, so you don't need maxItems nor items.

> +      minimum: 8
> +      maximum: 64
> +
> +  ts-frequency:

Use a standard unit suffix.

> +    description: |
> +      Frequency of the timestamping counter. Set this if you want to get
> +      timestamps, but you didn't set the timestamping clock in clocks property.
>      maxItems: 1
> +    items:

Not an array.


Is timestamping a common feature for CAN or is this specific to this 
controller? In the latter case, you need vendor prefixes on these 
properties. In the former case, you need to define them in a common 
schema.

> +      minimum: 1
>  
>  required:
>    - compatible
> @@ -58,6 +84,8 @@ examples:
>      ctu_can_fd_0: can@43c30000 {
>        compatible = "ctu,ctucanfd";
>        interrupts = <0 30 4>;
> -      clocks = <&clkc 15>;
> +      clocks = <&clkc 15>, <&clkc 15>;
> +      clock-names = "can_clk", "ts_clk";
>        reg = <0x43c30000 0x10000>;
> +      ts-used-bits = <64>;
>      };
> -- 
> 2.25.1
> 
> 
