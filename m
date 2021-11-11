Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD65744D8B8
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhKKPA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:00:28 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:38833 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbhKKPAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:00:23 -0500
Received: by mail-ot1-f45.google.com with SMTP id z2-20020a9d71c2000000b0055c6a7d08b8so9249893otj.5;
        Thu, 11 Nov 2021 06:57:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=k+ivML6yp1mJQtYfp7G9jU0X3RF9IdCXVUkTDOyaGng=;
        b=i6QMsnEeKLqGFMq8zDMpPJcl6pttoZGx9HSBLyYfQ8CALETjd1Ko4LLBra30ZIG5jC
         Rp+WvVlEAWLGdQ038upAKNPLL+mfwKanuDaOKpzCafxY9jfQFB0i6u5+2+DK9Vhtkh+D
         bwWN6tnA/VpGv+o3TJnEJsb0LlFwA+OeDZ3DBwV3GiPyeKWbSCv4AoDcmMWH8Ck74ZD7
         d3i6tEFsWWQCscTMCqrTKU2WPi0d3we2UyLuHhZpCViuvNSodHzmVljPndAzBeAYrst5
         9lnW2jag8AYpn4j/nRd4I7SfPt6MRrsQcvYLjeuq0dH17LOjTRrFQnlxedCNHm0N4K0i
         5afQ==
X-Gm-Message-State: AOAM532DdQCp9tCMS5D2Xdqm0MnP4APpr/DnIyWocJWeSFKPZs1PdPKP
        JRiusKvrDFyt+bM1c/LuvZjOsCf0dw==
X-Google-Smtp-Source: ABdhPJwrOF1c4/+j2nTSweytZpGQaZ8+UidW8m08ah6e3aO9H6fIVOzm3E4fb5t/DH3r5j3yRTPxjg==
X-Received: by 2002:a9d:6752:: with SMTP id w18mr4874984otm.13.1636642653683;
        Thu, 11 Nov 2021 06:57:33 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id p14sm559651oov.0.2021.11.11.06.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 06:57:33 -0800 (PST)
Received: (nullmailer pid 3774087 invoked by uid 1000);
        Thu, 11 Nov 2021 14:57:26 -0000
From:   Rob Herring <robh@kernel.org>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     netdev@vger.kernel.org, Wells Lu <wells.lu@sunplus.com>,
        linux-kernel@vger.kernel.org, vincent.shih@sunplus.com,
        davem@davemloft.net, p.zabel@pengutronix.de,
        devicetree@vger.kernel.org, kuba@kernel.org, robh+dt@kernel.org
In-Reply-To: <321e3b1a7dfca81f3ffae03b11099e8efeef92fa.1636620754.git.wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com> <cover.1636620754.git.wells.lu@sunplus.com> <321e3b1a7dfca81f3ffae03b11099e8efeef92fa.1636620754.git.wells.lu@sunplus.com>
Subject: Re: [PATCH v2 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Thu, 11 Nov 2021 08:57:26 -0600
Message-Id: <1636642646.909645.3774086.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 17:04:20 +0800, Wells Lu wrote:
> Add bindings documentation for Sunplus SP7021.
> 
> Signed-off-by: Wells Lu <wells.lu@sunplus.com>
> ---
> Changes in V2
>  - Added mdio and phy sub-nodes.
> 
>  .../bindings/net/sunplus,sp7021-emac.yaml          | 152 +++++++++++++++++++++
>  MAINTAINERS                                        |   7 +
>  2 files changed, 159 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml:94:12: [warning] wrong indentation: expected 10 but found 11 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1553831

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

