Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166AD21A508
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 18:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgGIQpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 12:45:16 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:46633 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGIQpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 12:45:16 -0400
Received: by mail-il1-f195.google.com with SMTP id a6so2556115ilq.13;
        Thu, 09 Jul 2020 09:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ckuJddeyQNpGCGzxrbrYjyShRH3Zbf5UZ94Sm2GBo2A=;
        b=nzgXQ/yuKgb+lVkHwlMW44PYzR153y756tYXm46Dokylznc4osbEx6a0nJZDJR0L9f
         xULQyNB6I8t0m4qet234N2udTvDF0UN3ZuKZ/n89YYyXxEY5Fzhi6Nmt70ibrdElOcev
         PE10wgLufvYQ+LizMiNVZv76E+awNe6gagLZbAZG4QsZTzXMF/4YoZXMnSSb0jRb9X0+
         ZFI8jPRuLFZF7qQwtRpCxDHjhB+R2lm2EotAI9oygmleVgzxH+YvrxwV8x2+kHTjZjMT
         BSmun/oVXRAuLFMZNi/cDDJJinMm1Hk3zZwV2WQLhe1GI9Px2L65PdztDoKTxwOEFz4h
         B6Rg==
X-Gm-Message-State: AOAM532gPAxZ2BZppsQUZtHS2WpHXm99PBmzgxU4OnOJtIuNXV5Kp4tZ
        f/zfw90DFZz1GVCyfRFRKg==
X-Google-Smtp-Source: ABdhPJwyGqJ0jD8YjRo2OQIOc4D+V5YTOxxXwyAoSn/CJwUlhPrkV6RADGPfwrh+1WVYpR9zTOkcgQ==
X-Received: by 2002:a92:d812:: with SMTP id y18mr37926511ilm.286.1594313114885;
        Thu, 09 Jul 2020 09:45:14 -0700 (PDT)
Received: from xps15 ([64.188.179.254])
        by smtp.gmail.com with ESMTPSA id c77sm2264678ill.13.2020.07.09.09.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 09:45:14 -0700 (PDT)
Received: (nullmailer pid 497532 invoked by uid 1000);
        Thu, 09 Jul 2020 16:45:10 -0000
Date:   Thu, 9 Jul 2020 10:45:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     vineetha.g.jaya.kumaran@intel.com
Cc:     boon.leong.ong@intel.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, mcoquelin.stm32@gmail.com,
        davem@davemloft.net, weifeng.voon@intel.com,
        hock.leong.kweh@intel.com, kuba@kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: Add bindings for Intel Keem Bay
Message-ID: <20200709164510.GA496369@bogus>
References: <1594097238-8827-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
 <1594097238-8827-2-git-send-email-vineetha.g.jaya.kumaran@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594097238-8827-2-git-send-email-vineetha.g.jaya.kumaran@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Jul 2020 12:47:17 +0800, vineetha.g.jaya.kumaran@intel.com wrote:
> From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
> 
> Add Device Tree bindings documentation for the ethernet controller
> on Intel Keem Bay.
> 
> Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
> ---
>  .../devicetree/bindings/net/intel,dwmac-plat.yaml  | 123 +++++++++++++++++++++
>  1 file changed, 123 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml: properties:clocks:maxItems: False schema does not allow 3
Documentation/devicetree/bindings/Makefile:20: recipe for target 'Documentation/devicetree/bindings/net/intel,dwmac-plat.example.dts' failed
make[1]: *** [Documentation/devicetree/bindings/net/intel,dwmac-plat.example.dts] Error 1
make[1]: *** Waiting for unfinished jobs....
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml: ignoring, error in schema: properties: clocks: maxItems
warning: no schema found in file: ./Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml: ignoring, error in schema: properties: clocks: maxItems
warning: no schema found in file: ./Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
Makefile:1347: recipe for target 'dt_binding_check' failed
make: *** [dt_binding_check] Error 2


See https://patchwork.ozlabs.org/patch/1324088

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.

