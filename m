Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B85D464FDE
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 15:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350438AbhLAOiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:38:12 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:41504 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350334AbhLAOgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 09:36:52 -0500
Received: by mail-oi1-f169.google.com with SMTP id u74so48879766oie.8;
        Wed, 01 Dec 2021 06:33:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=4mVcnYqOvWqu8VcZ1MXpxqRjFIUZ505WaFehSXIj24Y=;
        b=e1oqoSquESnCRAju+77JedTCUEIUd8vJK/JdqnrFwLryTaD/lf2F5gzf8SkE84i/c0
         BOa7W9RN78B7jx1GbI4p556k1TD2VmjtfSTwuQWLLSWmv8ZPWJ2ZJ4+LBW4bzHzO788y
         Nan3eLTDWXucS4dMJx9SmL82bE20prN9zhCr/jThZQvDk9ip/V7IxcRVbZn6iweEu+bv
         8FXH2ZRi3rrFFd7edoX4OyilzROqAsk/bpuL/WDdeNfKifG9YDGeczOA5MtOMPfD9Q73
         i7uRPd/J8H837e6CECaid7KPm3+v15zrgH0BD7TtYqIEe8aVTKRZkLFQugmYvHajR7vP
         aP5g==
X-Gm-Message-State: AOAM5317Kro2adwELrSIBZnbu+klQ+xASH3XB7MdXi4+OnOl/JvuoXnB
        eqQGuM/P7EHCHYPRwcE27g==
X-Google-Smtp-Source: ABdhPJxjc985MIwhTdWCLcKMo32v7Tkz/if0R9oT3CwPoOgJQIdms4+/SKc/nMyXQkRrhPelOLqrPQ==
X-Received: by 2002:aca:3642:: with SMTP id d63mr6168003oia.95.1638369206746;
        Wed, 01 Dec 2021 06:33:26 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id r26sm217otn.15.2021.12.01.06.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 06:33:25 -0800 (PST)
Received: (nullmailer pid 1684352 invoked by uid 1000);
        Wed, 01 Dec 2021 14:33:22 -0000
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Ray Jui <rjui@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20211201041228.32444-8-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com> <20211201041228.32444-8-f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 7/7] dt-bindings: net: Convert iProc MDIO mux to YAML
Date:   Wed, 01 Dec 2021 08:33:22 -0600
Message-Id: <1638369202.222306.1684348.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 20:12:28 -0800, Florian Fainelli wrote:
> Conver the Broadcom iProc MDIO mux Device Tree binding to YAML.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../bindings/net/brcm,mdio-mux-iproc.txt      | 62 --------------
>  .../bindings/net/brcm,mdio-mux-iproc.yaml     | 80 +++++++++++++++++++
>  2 files changed, 80 insertions(+), 62 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.example.dt.yaml:0:0: /example-0/mdio-mux@66020000/mdio@0/pci-phy@0: failed to match any schema with compatible: ['brcm,ns2-pcie-phy']
Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.example.dt.yaml:0:0: /example-0/mdio-mux@66020000/mdio@7/pci-phy@0: failed to match any schema with compatible: ['brcm,ns2-pcie-phy']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1562000

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

