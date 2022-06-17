Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33FC5500BE
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 01:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383691AbiFQX1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 19:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbiFQX1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 19:27:16 -0400
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F9566AFA;
        Fri, 17 Jun 2022 16:27:15 -0700 (PDT)
Received: by mail-io1-f52.google.com with SMTP id q11so5960892iod.8;
        Fri, 17 Jun 2022 16:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=mrnGJfuJSJ8KmPJjJNK/2HMET0pHuhxW1Qzfgjvk8ws=;
        b=bTu3lpFGMOsAQarUg7u8XQZ2vbjRtsqI7VIJP4bewayRdH8DomGHyn5PDCc8S3DgxM
         EoGGkvEEffbGCubozQ/AORc71vuMoD0Fu61lmsF2h5Y7NfI8HkUsEmMb3ho9SmeYy/QN
         bGbMZsXt8xmgJwdE+7NCTEF6svZUms8zoqaCCSAKozRrnoIZyFdJxp30l8Q74sQHjGBO
         E7XxsOBo/Bqtc+JycROB0iX0P7+MZ4eYiSgUJfFVu1gY+o/MFXw9FIOqcIndkpLJgAHJ
         Sq1swLjEyj6K3pSq30n6imJJhbuJJge0d/5VVzRGPuhSquHdTLJvIyQdHi55Ux5yZIsE
         FX4Q==
X-Gm-Message-State: AJIora9uWbExxcB45AaxhYauMfv7C3Jzbdyb67K9X1N3vBse00ii3sHb
        C0HgVSk2UGA+rBTHhLwJzg==
X-Google-Smtp-Source: AGRyM1tifihKpTdp799WxK6Tc+JX6s/X9nrpMyulN4Y0ijrWTb5i6wkhgCyeLD424gLNC7G3gBG1Aw==
X-Received: by 2002:a05:6638:138f:b0:332:1c0:1e81 with SMTP id w15-20020a056638138f00b0033201c01e81mr6550749jad.293.1655508434839;
        Fri, 17 Jun 2022 16:27:14 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id h20-20020a02b614000000b0032e70c4e12fsm2771998jam.28.2022.06.17.16.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 16:27:14 -0700 (PDT)
Received: (nullmailer pid 2635209 invoked by uid 1000);
        Fri, 17 Jun 2022 23:27:12 -0000
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Eric Dumazet <edumazet@google.com>, Vinod Koul <vkoul@kernel.org>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-phy@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Madalin Bucur <madalin.bucur@nxp.com>
In-Reply-To: <20220617203312.3799646-2-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com> <20220617203312.3799646-2-sean.anderson@seco.com>
Subject: Re: [PATCH net-next 01/28] dt-bindings: phy: Add QorIQ SerDes binding
Date:   Fri, 17 Jun 2022 17:27:12 -0600
Message-Id: <1655508432.548094.2635208.nullmailer@robh.at.kernel.org>
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

On Fri, 17 Jun 2022 16:32:45 -0400, Sean Anderson wrote:
> This adds a binding for the SerDes module found on QorIQ processors. The
> phy reference has two cells, one for the first lane and one for the
> last. This should allow for good support of multi-lane protocols when
> (if) they are added. There is no protocol option, because the driver is
> designed to be able to completely reconfigure lanes at runtime.
> Generally, the phy consumer can select the appropriate protocol using
> set_mode. For the most part there is only one protocol controller
> (consumer) per lane/protocol combination. The exception to this is the
> B4860 processor, which has some lanes which can be connected to
> multiple MACs. For that processor, I anticipate the easiest way to
> resolve this will be to add an additional cell with a "protocol
> controller instance" property.
> 
> Each serdes has a unique set of supported protocols (and lanes). The
> support matrix is stored in the driver and is selected based on the
> compatible string. It is anticipated that a new compatible string will
> need to be added for each serdes on each SoC that drivers support is
> added for.
> 
> There are two PLLs, each of which can be used as the master clock for
> each lane. Each PLL has its own reference. For the moment they are
> required, because it simplifies the driver implementation. Absent
> reference clocks can be modeled by a fixed-clock with a rate of 0.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
>  .../bindings/phy/fsl,qoriq-serdes.yaml        | 78 +++++++++++++++++++
>  1 file changed, 78 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.example.dtb: phy@1ea0000: reg: [[0, 32112640], [0, 8192]] is too long
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

