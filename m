Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158894749CE
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhLNRjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:39:25 -0500
Received: from mail-oi1-f176.google.com ([209.85.167.176]:36427 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbhLNRjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 12:39:24 -0500
Received: by mail-oi1-f176.google.com with SMTP id t23so28155508oiw.3;
        Tue, 14 Dec 2021 09:39:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O0xCXgIG7KmD+MIqqHCpMghuSId2pal3UJtMVD2ehNo=;
        b=edp+7nwlzwfcOMFnx3bHtT16TVJj1Hp0OYqz0LSLbc0pKrl+0ha2t3BFKcfXDoV7zd
         xoT/2Ax9xxhD2dXOJrLGQ0g6atqI5zvz/BwmVZtdsY2bawSAbPuxXmJanUIGqgI97osF
         5r6ih7qXsgCIwFIp+8Ps9Y8qQHTQm91lar+0ObkKYwiOSqr6QnJI2zd+4eORlUW0hxyP
         cGTI7Jq9PfBmM8LoeReght9DHasLcLRuIBmv4JWFmFRKLxj0+VSloAHgiO8ylmFUK2qm
         euWbwaBorqBro64IdghMt6ah8LYbBJMeMTfRc3aXT0tWMjZm51wPZ6zQ1DdnS4D39bWX
         IZ8A==
X-Gm-Message-State: AOAM533Sd5oWko38Ak8dJs+5nBknxkO+xNXHe5z73B+8zt/fHr2IFML8
        sb0kFRy9KbCGdA/XckakmQ==
X-Google-Smtp-Source: ABdhPJxAM3rZCbW8t+Gi0ZQoRDmlqN/q9GMHRgQuQlbzGPkx3MEK6e1ZRopuv0dobsoLP6qspurRvQ==
X-Received: by 2002:a05:6808:bc3:: with SMTP id o3mr33306166oik.151.1639503563866;
        Tue, 14 Dec 2021 09:39:23 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id i16sm95832oig.15.2021.12.14.09.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 09:39:23 -0800 (PST)
Received: (nullmailer pid 3607204 invoked by uid 1000);
        Tue, 14 Dec 2021 17:39:22 -0000
Date:   Tue, 14 Dec 2021 11:39:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, f.fainelli@gmail.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        vivien.didelot@gmail.com, devicetree@vger.kernel.org,
        robh+dt@kernel.org, vladimir.oltean@nxp.com, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v4 02/10] dt-bindings: net: lan966x: Extend with
 the analyzer interrupt
Message-ID: <YbjWyqP11d+dDFK2@robh.at.kernel.org>
References: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
 <20211213101432.2668820-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213101432.2668820-3-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Dec 2021 11:14:24 +0100, Horatiu Vultur wrote:
> Extend dt-bindings for lan966x with analyzer interrupt.
> This interrupt can be generated for example when the HW learn/forgets
> an entry in the MAC table.
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
