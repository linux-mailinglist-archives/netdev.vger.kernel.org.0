Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28351C4CF0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 06:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEEEFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 00:05:16 -0400
Received: from mail-oo1-f66.google.com ([209.85.161.66]:37833 "EHLO
        mail-oo1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgEEEFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 00:05:14 -0400
Received: by mail-oo1-f66.google.com with SMTP id v6so18565oou.4;
        Mon, 04 May 2020 21:05:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6WQI3JSgZPOFGGzXwwk2K02/3Pv1yWZDzRlpx8k9vAU=;
        b=T+4oLveKdi8SLPO732OHxpXLgdVPQNat74wBHGmzc29OiSZ4K0hH5CxT8SgQmfpAzF
         wAGr/LXw6Qv+ISheetLCNqTlFxHcVYeZiHpX6fEcS9Wt+pFejupOu6tZv5ajTdOyr+3+
         qSc7LYQLYCHc0UE+Xr6C6HlQ6Sfwx7mun3u/dAC0BeRWUuulf3l28UK/RINJpxA5mb2S
         UI9T4LYk1cTvjiby8cZyqSjG6uBgyNhyGtDHIp4/JcWMx5/a3DkAgMLwikmRrChP+H56
         wWkOst6wdoSLFhvCRP5cO7gHFAWmlaEYj7cv6BQBRSf9Mkgww+DhaOaCyEx7RrLfWX8H
         /jVQ==
X-Gm-Message-State: AGi0PuaG9rFe1aKPz/VPNgE2mKSO7hCmTcqB8oyhbwMD3ZHKMKfMdOjP
        dR5YBDoER/H0G6XZcjB7yPzpEXs=
X-Google-Smtp-Source: APiQypLGue2T2PeYCGDsL7qgUIq2ihNupfk0d/AlfGZGSS8M6OljhlK0/aPRKFsxfJuayvNWzuXA4w==
X-Received: by 2002:a4a:92d1:: with SMTP id j17mr1338642ooh.13.1588651513417;
        Mon, 04 May 2020 21:05:13 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id e10sm260152oie.18.2020.05.04.21.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 21:05:12 -0700 (PDT)
Received: (nullmailer pid 30274 invoked by uid 1000);
        Tue, 05 May 2020 04:05:12 -0000
Date:   Mon, 4 May 2020 23:05:11 -0500
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, netdev@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nishanth Menon <nm@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH net-next 1/7] dt-binding: ti: am65x: document common
 platform time sync cpts module
Message-ID: <20200505040511.GB8509@bogus>
References: <20200501205011.14899-1-grygorii.strashko@ti.com>
 <20200501205011.14899-2-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501205011.14899-2-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 May 2020 23:50:05 +0300, Grygorii Strashko wrote:
> Document device tree bindings for TI AM654/J721E SoC The Common Platform
> Time Sync (CPTS) module. The CPTS module is used to facilitate host control
> of time sync operations. Main features of CPTS module are:
>   - selection of multiple external clock sources
>   - 64-bit timestamp mode in ns with ppm and nudge adjustment.
>   - control of time sync events via interrupt or polling
>   - hardware timestamp of ext. events (HWx_TS_PUSH)
>   - periodic generator function outputs (TS_GENFx)
>   - PPS in combination with timesync router
>   - Depending on integration it enables compliance with the IEEE 1588-2008
> standard for a precision clock synchronization protocol, Ethernet Enhanced
> Scheduled Traffic Operations (CPTS_ESTFn) and PCIe Subsystem Precision Time
> Measurement (PTM).
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |   7 +
>  .../bindings/net/ti,k3-am654-cpts.yaml        | 152 ++++++++++++++++++
>  2 files changed, 159 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml: $id: relative path/filename doesn't match actual path or filename
	expected: http://devicetree.org/schemas/net/ti,k3-am654-cpts.yaml#
Unknown file referenced: [Errno 2] No such file or directory: '/usr/local/lib/python3.6/dist-packages/dtschema/schemas/net/ti,am654-cpts.yaml'
Documentation/devicetree/bindings/Makefile:12: recipe for target 'Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dts' failed
make[1]: *** [Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dts] Error 255
make[1]: *** Waiting for unfinished jobs....
Makefile:1300: recipe for target 'dt_binding_check' failed
make: *** [dt_binding_check] Error 2

See https://patchwork.ozlabs.org/patch/1281460

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.
