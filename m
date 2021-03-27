Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C5434B8CE
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 19:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhC0SNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 14:13:53 -0400
Received: from mail-oi1-f170.google.com ([209.85.167.170]:35398 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhC0SNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 14:13:47 -0400
Received: by mail-oi1-f170.google.com with SMTP id x2so9137887oiv.2;
        Sat, 27 Mar 2021 11:13:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/m822qwIfNMxw1ccD0nlRrn2NI1gk/a4me9EKJ2P4R8=;
        b=FTeJMYFmwQup5/Duz7FL9Z2+dwfbqGDHVpX/l2NQvLOEZj14+2HNaavbEYXeJ+rJ00
         L1wgz+JZvwq4N8OcaNNPKP7xP17fbksr05OoHpWMyl+vMZcjzPayqRrgeSnUMw72kVCP
         jc/7ow6Y45wZGP4AEZl3TEl2X/K3o75//l8NMqmeCO2oWavYCmftEyck04YnBZ96OcNe
         J+7Q48Ud243BoLBZtq3OhlsDLGYBDCSAb3ZEYpu4xl5Rp/ibg1ylXquDAkfWGu4sQNqX
         ELL6ATriIcHISWrkAY43AEI9r6AGAFQ55jyfpwtnHe7B2sO28GwLcV73UBp2jexks7PV
         kHAg==
X-Gm-Message-State: AOAM532ouvMww85y56LbrD3qlz9xpiotPQZP3qvXAelGd4Ir6wsOdPd9
        4mIPLkiYctu2EF83QBMoXGB/6nHoCA==
X-Google-Smtp-Source: ABdhPJx1BksOJTZRJ8FlZR+/7yom8NbvnCXKQr28Ibqm9wbOPue971JWZrBqL3xmIU4peXEUydwIZQ==
X-Received: by 2002:aca:dc87:: with SMTP id t129mr14143112oig.137.1616868826977;
        Sat, 27 Mar 2021 11:13:46 -0700 (PDT)
Received: from robh.at.kernel.org ([172.58.99.41])
        by smtp.gmail.com with ESMTPSA id a20sm2489163oia.49.2021.03.27.11.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 11:13:46 -0700 (PDT)
Received: (nullmailer pid 341302 invoked by uid 1000);
        Sat, 27 Mar 2021 18:13:43 -0000
Date:   Sat, 27 Mar 2021 12:13:43 -0600
From:   Rob Herring <robh@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: Document
 dsa,tag-protocol property
Message-ID: <20210327181343.GA339863@robh.at.kernel.org>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326105648.2492411-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 11:56:48AM +0100, Tobias Waldekranz wrote:
> The 'dsa,tag-protocol' is used to force a switch tree to use a
> particular tag protocol, typically because the Ethernet controller
> that it is connected to is not compatible with the default one.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index 8a3494db4d8d..5dcfab049aa2 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -70,6 +70,13 @@ patternProperties:
>                device is what the switch port is connected to
>              $ref: /schemas/types.yaml#/definitions/phandle
>  
> +          dsa,tag-protocol:

'dsa' is not a vendor.

> +            description:
> +              Instead of the default, the switch will use this tag protocol if
> +              possible. Useful when a device supports multiple protcols and
> +              the default is incompatible with the Ethernet device.
> +            $ref: /schemas/types.yaml#/definitions/string

You need to define the possible strings.

> +
>            phy-handle: true
>  
>            phy-mode: true
> -- 
> 2.25.1
> 
