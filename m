Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69C022F737
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgG0SAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:00:23 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:34203 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729442AbgG0SAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:00:22 -0400
Received: by mail-il1-f194.google.com with SMTP id t4so13871808iln.1;
        Mon, 27 Jul 2020 11:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7vqLtE+18UbhSTTrH5MjquKB/P1P5y0eQhhXXEsXF7Q=;
        b=HP3BIR0YH98NFbjrBFBoLhQmwBmTr5H9RGKbe0pXHf+NzmehDlD4aZzi8f4dHcaEec
         9ZaaaQ8wEdlvfwRyqbz2IpvJup2+4UpsEePF/IBvxfqQMF3GJuCWlsFtOPyZikxtrT+L
         AZj1cwk4KZbK504zbUsM3P4AqQk2/lKKxvweV34V38Y/L+Y534u7XU2UNw9GfXawQWr3
         /C/qaIoVjG+pPAnTcsiV/ENWCjP8sdp5fKjhYH7KPOlDmaMN5hUpLUXrWI9hhxsqs5su
         pkmz39brZ2/TY0zp2n/yPvLznTR3DHyNEaElubIHYikGubxfJj0Q3HCGCfC92un0YwSe
         8O1Q==
X-Gm-Message-State: AOAM531Lm+fRMK5iaAYfu7llHSmY8wlJhbvIo08VNr7zthjCk3lcsARM
        dfpkBNLLukp+IfKau1pdKQ==
X-Google-Smtp-Source: ABdhPJyEDYFRNS10MlKlunEMF0DLu52hlPyHh5CsToUd24icdl0qh75GW2KSI/zZk21eo+pL3o2FmA==
X-Received: by 2002:a92:890d:: with SMTP id n13mr7018282ild.5.1595872821846;
        Mon, 27 Jul 2020 11:00:21 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id d9sm8970935ios.33.2020.07.27.11.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 11:00:21 -0700 (PDT)
Received: (nullmailer pid 615014 invoked by uid 1000);
        Mon, 27 Jul 2020 18:00:20 -0000
Date:   Mon, 27 Jul 2020 12:00:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     vineetha.g.jaya.kumaran@intel.com
Cc:     hock.leong.kweh@intel.com, boon.leong.ong@intel.com,
        netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        devicetree@vger.kernel.org, kuba@kernel.org, robh+dt@kernel.org,
        weifeng.voon@intel.com, davem@davemloft.net
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add bindings for Intel Keem Bay
Message-ID: <20200727180020.GA614403@bogus>
References: <1595672279-13648-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
 <1595672279-13648-2-git-send-email-vineetha.g.jaya.kumaran@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595672279-13648-2-git-send-email-vineetha.g.jaya.kumaran@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jul 2020 18:17:58 +0800, vineetha.g.jaya.kumaran@intel.com wrote:
> From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
> 
> Add Device Tree bindings documentation for the ethernet controller
> on Intel Keem Bay.
> 
> Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
> ---
>  .../devicetree/bindings/net/intel,dwmac-plat.yaml  | 121 +++++++++++++++++++++
>  1 file changed, 121 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@40027000: clock-names:1: 'ptp_ref' was expected
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@40027000: clock-names:2: 'tx_clk' was expected
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@40027000: compatible: ['st,stm32-dwmac', 'snps,dwmac-4.10a'] is not valid under any of the given schemas (Possible causes of the failure):
	/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@40027000: compatible:0: 'st,stm32-dwmac' is not one of ['intel,keembay-dwmac']



See https://patchwork.ozlabs.org/patch/1336225

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.

