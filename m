Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1744659CC
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 00:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343755AbhLAXap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 18:30:45 -0500
Received: from mail-oi1-f179.google.com ([209.85.167.179]:34396 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353785AbhLAXa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 18:30:28 -0500
Received: by mail-oi1-f179.google.com with SMTP id t19so51927134oij.1;
        Wed, 01 Dec 2021 15:27:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2XpzWSMwpfWYAEZjhebV2bsYQbm7/G+56K6lGyktFJ4=;
        b=QVRZblBgDVd01O+lejwhgmyIf1EtTqN44JReUaqUiLVr1/KTcgLwum1lnwwswv1tTb
         uNSc0b9mqTMcGP/G30iS9KYJmTvYNeclBfHVFnmaqkXxpVM+lhK3/VZf2xc0ZHU+yWcS
         bcQc1kYaUUDiJH4BYDkIaxrjwpDjlS/v1dNhIYptWBLdAicpR5y5H7iypV+3CUgHN9NI
         Beas2rHWUHRroA8hGaWslE4pT7jiZxp9Dxa8B9bDkBhGs1Va5Gb1Nd8Dbrxw3AtM/fLu
         8dhrH2yl5Tgg3iwSdBhKyZAiqHjqn8JrgkDOn72xVtBkboIUBQDZIQNsye1OiYhGsvuW
         Ekow==
X-Gm-Message-State: AOAM530BT6817Cy62nyhmXNDwr3xISqpy57QgFpcN2QBWeVQduMBYAp5
        y2u1v7/zm7/bgEi8KhCdnA==
X-Google-Smtp-Source: ABdhPJw8iglqmrPXHFMZVORsqgGAa/Y7c4xYMqz1Mqf3yi17HeEEiDGeniBjjMnPhEFDTYPni2ns+w==
X-Received: by 2002:a05:6808:1411:: with SMTP id w17mr1463263oiv.10.1638401226699;
        Wed, 01 Dec 2021 15:27:06 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id s6sm696691ois.3.2021.12.01.15.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 15:27:05 -0800 (PST)
Received: (nullmailer pid 3185396 invoked by uid 1000);
        Wed, 01 Dec 2021 23:27:05 -0000
Date:   Wed, 1 Dec 2021 17:27:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     devicetree@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-kernel@vger.kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] dt-bindings: net: cdns,macb: Convert to json-schema
Message-ID: <YagEyIjyxezA3PGS@robh.at.kernel.org>
References: <104dcbfd22f95fc77de9fe15e8abd83869603ea5.1637927673.git.geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104dcbfd22f95fc77de9fe15e8abd83869603ea5.1637927673.git.geert@linux-m68k.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 12:57:00 +0100, Geert Uytterhoeven wrote:
> Convert the Cadence MACB/GEM Ethernet controller Device Tree binding
> documentation to json-schema.
> 
> Re-add "cdns,gem" (removed in commit a217d8711da5c87f ("dt-bindings:
> Remove PicoXcell bindings")) as there are active users on non-PicoXcell
> platforms.
> Add missing "ether_clk" clock.
> Add missing properties.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  .../devicetree/bindings/net/cdns,macb.yaml    | 162 ++++++++++++++++++
>  .../devicetree/bindings/net/macb.txt          |  60 -------
>  2 files changed, 162 insertions(+), 60 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/cdns,macb.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/macb.txt
> 

Applied, thanks!
