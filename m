Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BCE621184
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbiKHMyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiKHMyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:54:17 -0500
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6C413F74;
        Tue,  8 Nov 2022 04:54:16 -0800 (PST)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-13be3ef361dso16076200fac.12;
        Tue, 08 Nov 2022 04:54:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SzZDsYsSktFleiAhrmFxUDwbBhqTEmdM7+gPTdb1QWs=;
        b=4W0DILLlQHSy+g3VC4lIhwDAPLY6Ny0z7R45gFPWhc0447/Ni1m+hJuDXO0WCzsOuJ
         XeHT5t9rVqnHf7NjgqR82UP+odQOfWPZsFCF07/UMGVTr+yU1cskgss/2IRHBSc0SbJ7
         r0nQiNmBS9wsQSOsk/UgCEEvNU5Xu7lAWcsZ7cdjsAsI5ty9R/9JCGK4xqCHiwD3f8E2
         kZekScapkoBksiNS2aeHY0HWSaEsjB7NzFjHChGPRrbZPhclgUAuZhEQWqd46OtsJXSY
         lPsdVforgZ83H6fOi/pEtwwHD53ORQRk/FwEdZS2j9olvE0ztHlhlyvT9IF/zsgz+PmC
         U6kQ==
X-Gm-Message-State: ACrzQf3LkjhRkc/6EkIoZE1ROzujlvS4uxk54GVZY+nQrPeerZGGnBun
        /mCMsvPFCrSeif+fDwhebw==
X-Google-Smtp-Source: AMsMyM580nTfyC5o5WPw6g957OJSRAI/W4Dqx0KuxfxRlUmNItCo2MLFXkiY+y+UQWVEF+C9mIlzcA==
X-Received: by 2002:a05:6870:e390:b0:13b:d088:bfc with SMTP id x16-20020a056870e39000b0013bd0880bfcmr32193427oad.199.1667912056078;
        Tue, 08 Nov 2022 04:54:16 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y23-20020a9d6357000000b00660d9afc216sm4035194otk.17.2022.11.08.04.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 04:54:15 -0800 (PST)
Received: (nullmailer pid 3254923 invoked by uid 1000);
        Tue, 08 Nov 2022 12:54:14 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     mizo@atmark-techno.com,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-bluetooth@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
In-Reply-To: <20221108055531.2176793-2-dominique.martinet@atmark-techno.com>
References: <20221108055531.2176793-1-dominique.martinet@atmark-techno.com>
 <20221108055531.2176793-2-dominique.martinet@atmark-techno.com>
Message-Id: <166791192640.3252604.4671719183528311477.robh@kernel.org>
Subject: Re: [RFC PATCH 1/2] dt-bindings: net: h4-bluetooth: add new bindings
 for hci_h4
Date:   Tue, 08 Nov 2022 06:54:14 -0600
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


On Tue, 08 Nov 2022 14:55:30 +0900, Dominique Martinet wrote:
> Add devicetree binding to support defining a bluetooth device using the h4
> uart protocol
> 
> This was tested with a NXP wireless+BT AW-XM458 module, but might
> benefit others as the H4 protocol seems often used.
> 
> Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> ---
>  .../devicetree/bindings/net/h4-bluetooth.yaml | 49 +++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/h4-bluetooth.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
fsl,dte-mode: boolean property with value b'\x00\x00\x00\x01'
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/h4-bluetooth.example.dtb: uart1: fsl,dte-mode: b'\x00\x00\x00\x01' is not of type 'object', 'array', 'boolean', 'null'
	From schema: /usr/local/lib/python3.10/dist-packages/dtschema/schemas/dt-core.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/h4-bluetooth.example.dtb: uart1: 'anyOf' conditional failed, one must be fixed:
	'clocks' is a required property
	'#clock-cells' is a required property
	From schema: /usr/local/lib/python3.10/dist-packages/dtschema/schemas/clock/clock.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

