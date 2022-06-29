Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E237655F343
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 04:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiF2CKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 22:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiF2CKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 22:10:10 -0400
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BC22ED46;
        Tue, 28 Jun 2022 19:10:06 -0700 (PDT)
Received: by mail-il1-f173.google.com with SMTP id 9so9375639ill.5;
        Tue, 28 Jun 2022 19:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=akCaK7/6hiO9qiDqUC6BjphM3QTCscKxuIGksCMRv4Q=;
        b=qw7QGmRtknT8SHk4/fjSpan3+R2RdbsAn3+a6UmKweoDKdHuU+8KLOy3Ot+hJ8w/iy
         3zChQgqhWh3o+jWY4kPsmfTQ9+ys2BZBw7KHrVgMJgjeoFJqRVqUiDsaEx4zwaK2Hgek
         JYyiNhdt/ok56z4G/T7ViDNxpJrvfj9z0HrSKcvXKVGyqIjSmSA6KUmIkyqrplDdwYeQ
         /tsTRGN7UJBjgBOrGDUozmO1Th0rNFeFwVfVI+9to/jNKAFgk2vuLMge52gVEyiqFrD6
         I2t/M4/o4Q6+QQvDIJ9kRxMX+3MhrkoRT28Q0AWBhxukXFmD1Cc7NOcWyEj01iS/CZpt
         sOYQ==
X-Gm-Message-State: AJIora8Zf+CRohPEPWe9EI7I5V7paPM2LwagUp0XrDX4FNIyu1g/GCAc
        SlvgApfbOHHYcbIK59A2pg==
X-Google-Smtp-Source: AGRyM1s+vAu0J3FAxJurSCzpU4DCe5h38yk8r+xC7m9WUBJ56dufRl4BRYIH390A+L4jw+4zToyPjA==
X-Received: by 2002:a05:6e02:216b:b0:2da:c09b:179f with SMTP id s11-20020a056e02216b00b002dac09b179fmr659560ilv.0.1656468605851;
        Tue, 28 Jun 2022 19:10:05 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id w18-20020a92c892000000b002d909e3d89esm6515075ilo.60.2022.06.28.19.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 19:10:05 -0700 (PDT)
Received: (nullmailer pid 1403684 invoked by uid 1000);
        Wed, 29 Jun 2022 02:09:39 -0000
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vinod Koul <vkoul@kernel.org>, linux-phy@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20220628221404.1444200-2-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com> <20220628221404.1444200-2-sean.anderson@seco.com>
Subject: Re: [PATCH net-next v2 01/35] dt-bindings: phy: Add QorIQ SerDes binding
Date:   Tue, 28 Jun 2022 20:09:39 -0600
Message-Id: <1656468579.935954.1403683.nullmailer@robh.at.kernel.org>
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

On Tue, 28 Jun 2022 18:13:30 -0400, Sean Anderson wrote:
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
> added for. There is no "generic" compatible string for this reason.
> 
> There are two PLLs, each of which can be used as the master clock for
> each lane. Each PLL has its own reference. For the moment they are
> required, because it simplifies the driver implementation. Absent
> reference clocks can be modeled by a fixed-clock with a rate of 0.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v2:
> - Add #clock-cells. This will allow using assigned-clocks* to configure
>   the PLLs.
> - Allow a value of 1 for phy-cells. This allows for compatibility with
>   the similar (but according to Ioana Ciornei different enough) lynx-28g
>   binding.
> - Document phy cells in the description
> - Document the structure of the compatible strings
> - Fix example binding having too many cells in regs
> - Move compatible first
> - Refer to the device in the documentation, rather than the binding
> - Remove minItems
> - Rename to fsl,lynx-10g.yaml
> - Use list for clock-names
> 
>  .../devicetree/bindings/phy/fsl,lynx-10g.yaml | 93 +++++++++++++++++++
>  1 file changed, 93 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml: patternProperties:^thermistor@:properties:adi,excitation-current-nanoamp: '$ref' should not be valid under {'const': '$ref'}
	hint: Standard unit suffix properties don't need a type $ref
	from schema $id: http://devicetree.org/meta-schemas/core.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml: ignoring, error in schema: patternProperties: ^thermistor@: properties: adi,excitation-current-nanoamp
Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.example.dtb:0:0: /example-0/spi/ltc2983@0: failed to match any schema with compatible: ['adi,ltc2983']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

