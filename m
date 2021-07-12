Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BFA3C64FA
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 22:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbhGLUak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 16:30:40 -0400
Received: from mail-il1-f182.google.com ([209.85.166.182]:38717 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhGLUaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 16:30:39 -0400
Received: by mail-il1-f182.google.com with SMTP id e2so4375615ilu.5;
        Mon, 12 Jul 2021 13:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IGUnB/IK895e75pARJYVX3y+icUY95HCtQq4FMsIGN4=;
        b=e9EhRFf/4gM8c4vucFjCYhYaqhPsaBC+r9g8fORnZ50pa7dUucBjDe531WyGuuv6pe
         cP0HpwVnZZEa9PMnP3mC7StayCANydS90PkNt2XFiW/gseVbwg95FL76AI+1g5FBxGq8
         xACCsKC0EMh3PdUj5ulfbz+freC6OL6BTIX7HY2wSNaSQiUAHhfDh8pMowMr0W9js33H
         VYiNAPpuWA3b1Vw6kW8cj0k4RvYrc22NMcdYk4aB53PD6AoKolnBK5RYEVWkBnqdg1Mz
         q7CgaLJO1hB1fmampuAHyurz7jq6rE0Rh9b0OPtFXXTe/oUf6pARN4LoirYzX31jQLUJ
         vaUg==
X-Gm-Message-State: AOAM532asfTk8oZCpVaSaHluO0mF5+A/TvfY2HKgyoQZ36wgae7OnQqZ
        hxc+qe4BzpNuCEx2Cbd26Q==
X-Google-Smtp-Source: ABdhPJxudGunpYFTzV+G3cetrv8mvUuT2Rt4oMVN1NQ3hHMT/LLQVnxP13B7CxT0O0tJjkZU3JIqJg==
X-Received: by 2002:a92:7d07:: with SMTP id y7mr464051ilc.68.1626121669140;
        Mon, 12 Jul 2021 13:27:49 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id n13sm8652239ilq.5.2021.07.12.13.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 13:27:48 -0700 (PDT)
Received: (nullmailer pid 2433490 invoked by uid 1000);
        Mon, 12 Jul 2021 20:27:47 -0000
Date:   Mon, 12 Jul 2021 14:27:47 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>, linux@dh-electronics.com,
        devicetree@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3] dt-bindings: net: ks8851: Convert to YAML schema
Message-ID: <20210712202747.GA2433402@robh.at.kernel.org>
References: <20210620210741.100206-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210620210741.100206-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Jun 2021 23:07:41 +0200, Marek Vasut wrote:
> Convert the Micrel KSZ8851 DT bindings to YAML schema.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: linux@dh-electronics.com
> Cc: netdev@vger.kernel.org
> To: devicetree@vger.kernel.org
> ---
> V2: - Explicitly state the bindings are for both SPI and parallel bus options
>     - Switch the license to (GPL-2.0-only OR BSD-2-Clause)
> V3: - Drop quotes, use enum: instead of oneOf+const
>     - Add reg: items list describing what each reg entry is
>     - Drop regulator.yaml reference
> ---
>  .../bindings/net/micrel,ks8851.yaml           | 97 +++++++++++++++++++
>  .../devicetree/bindings/net/micrel-ks8851.txt | 18 ----
>  2 files changed, 97 insertions(+), 18 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/micrel,ks8851.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/micrel-ks8851.txt
> 

Applied, thanks!
