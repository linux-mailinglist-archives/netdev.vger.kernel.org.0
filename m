Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D28042B31E
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 05:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbhJMDKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 23:10:55 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:39869 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbhJMDKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 23:10:54 -0400
Received: by mail-ot1-f50.google.com with SMTP id k2-20020a056830168200b0054e523d242aso1850687otr.6;
        Tue, 12 Oct 2021 20:08:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=dG7YKVkdDHgU/EVdP5rWldt/Wd4xuXVEeGYHHbyU6pY=;
        b=WglxSxVgt/9zWvhHSfPuH2OAOHpAGX+Khs0OhpMn7pjFzANsTtnQuP0Mt9UxR/8kWb
         NHuq0FurjW8AW7hlgZRQ4DfJaVOI4QUWofTQQvS4iudEKhz5ZMIJXe3GQWXYn0bt8E0+
         PBqz1v4YPNS+P8BBfqvI2g4GlS3yWG0gdqe705pTE+YakxJxgvT6iSBiJaIp1wCmk8nO
         cpzIujo7yi2bjoh0eRCh6nSfgoqr6kqxa9Aa/amZxxu4g0NxoQD54HCQYPPd75GqA1J1
         nDAolp2DYMe2xHX89SClcXpeex7qr58sTpR1aAKPdE3vxJfZkKSduu9qWxSLjuyYK7ht
         ZivQ==
X-Gm-Message-State: AOAM5329g1lE8Hqre5lBK0OJdYrvOq/wqNbvPAVZTIGXQbATlfz5nH27
        zhBoaIgVSktRpNC/v377r+C1Ix+LkA==
X-Google-Smtp-Source: ABdhPJwxbanwesgn/W1Wk639iMVs3dz+D5GBhnB2Y0dX/VfTkAYTB4EguI+MLsLJdXY/BZM8w0/ILA==
X-Received: by 2002:a9d:61c7:: with SMTP id h7mr4857303otk.21.1634094531056;
        Tue, 12 Oct 2021 20:08:51 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id l45sm2488680ooi.30.2021.10.12.20.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 20:08:50 -0700 (PDT)
Received: (nullmailer pid 3858823 invoked by uid 1000);
        Wed, 13 Oct 2021 03:08:49 -0000
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Russell King <linux@armlinux.org.uk>
In-Reply-To: <20211013011622.10537-16-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com> <20211013011622.10537-16-ansuelsmth@gmail.com>
Subject: Re: [net-next PATCH v6 15/16] dt-bindings: net: dsa: qca8k: convert to YAML schema
Date:   Tue, 12 Oct 2021 22:08:49 -0500
Message-Id: <1634094529.487895.3858822.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 03:16:21 +0200, Ansuel Smith wrote:
> From: Matthew Hagan <mnhagan88@gmail.com>
> 
> Convert the qca8k bindings to YAML format.
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> Co-developed-by: Ansuel Smith <ansuelsmth@gmail.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.txt     | 245 ------------
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 362 ++++++++++++++++++
>  2 files changed, 362 insertions(+), 245 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.txt
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/dsa/qca8k.yaml:362:7: [error] no new line character at the end of file (new-line-at-end-of-file)

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dt.yaml: switch@10: 'oneOf' conditional failed, one must be fixed:
	'ports' is a required property
	'ethernet-ports' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/qca8k.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1540096

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

