Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCFE474C73
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 21:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbhLNUEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 15:04:55 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:37384 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhLNUEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 15:04:54 -0500
Received: by mail-ot1-f45.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so22149169otg.4;
        Tue, 14 Dec 2021 12:04:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=ca/8UwhkKrIrm1GYEgOJKPRg9ilbjbbUc4xGIZnlUw0=;
        b=OLlzFOuTYtQO63bi1btZdmCqs5Gxwnt7iwlgDfqWk0y8m0qvFnMlRbH4o/gcs1icHX
         V/WmP+KIm5oa/bPHBSMO4fS1y2owMrIbld1tg3ZlJGHNe7+7IX2Nf1NXHdIyy+FWjXPD
         ONmUb2Qo7UWB+3nGKhvg2OGcS2NVjP7FVkf1qvsqPVmYh75zzwBzsgSGMfduAQGIf74C
         gO3de3f8DendgDa9BnNkerna3d+09ZkaXrPp7uODEVweHIdMLqURhuf0QWQWfoY9xaEj
         z6uEUvSs2lz13tB790LpM68QdlCVyF1R/+cU5VisyVo/pdYLMwu2xZqQBz6TsIaJPPz4
         jW/A==
X-Gm-Message-State: AOAM53304+EdAx7LNd8RpAwircGtnBoZnSARuLPWbDr2MKHqAIdB3StR
        PNskkdW45B94JR6pnmpTGc8nU7MYag==
X-Google-Smtp-Source: ABdhPJxjjNMTn71D4902pz6s8UtNh8ftM5r6dHrAsXV2UWzK6nMfcRwddt9l/qf2loDIKyIicx2YlA==
X-Received: by 2002:a05:6830:1688:: with SMTP id k8mr5951527otr.238.1639512293684;
        Tue, 14 Dec 2021 12:04:53 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id r22sm171007oij.36.2021.12.14.12.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 12:04:52 -0800 (PST)
Received: (nullmailer pid 3819897 invoked by uid 1000);
        Tue, 14 Dec 2021 20:04:50 -0000
From:   Rob Herring <robh@kernel.org>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
In-Reply-To: <20211214163315.3769677-3-davidm@egauge.net>
References: <20211214163315.3769677-1-davidm@egauge.net> <20211214163315.3769677-3-davidm@egauge.net>
Subject: Re: [PATCH v4 2/2] wilc1000: Document enable-gpios and reset-gpios properties
Date:   Tue, 14 Dec 2021 14:04:50 -0600
Message-Id: <1639512290.330041.3819896.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 16:33:22 +0000, David Mosberger-Tang wrote:
> Add documentation for the ENABLE and RESET GPIOs that may be needed by
> wilc1000-spi.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
> ---
>  .../net/wireless/microchip,wilc1000.yaml        | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.example.dts:30.37-38 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:373: Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.example.dt.yaml] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1413: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1567796

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

