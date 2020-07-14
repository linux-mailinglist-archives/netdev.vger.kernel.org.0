Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C357821E60E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 05:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGNDBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 23:01:12 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35829 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgGNDBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 23:01:11 -0400
Received: by mail-io1-f68.google.com with SMTP id v8so15802533iox.2;
        Mon, 13 Jul 2020 20:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YxdsjHR7Y4qx5Rm04/llwJmikGRglY/mXvyLpbRKP1c=;
        b=pC9+/X8CkwQlyT2vxL7MGKdx0Y/jU8FDfxswvf6qLpwozvKAROZnKKrPEG0Z3NcPjx
         p+g8vt5jmd0Y9mC6rxWvz8fGfa/YP1gpeahhsgwRy2JdsJNaArB8zJ8aKGezge35PR+C
         04e1DkDih7T9WIXOMB2gqi6jDuBr+ajJsMZ12FPGEPC2qBgM6aG2954H97+MdWlLIBMr
         uSc4GkGCOLmG4MBkq6DjUZgDTYpbEWERamFdhosDkTBVF9e38ERoACrLv8oOhpJ6HAlS
         7NRCkJx7bXaSpT92aJYhtaj3fFes5/6vsplHxXh2ewRTxqXx9lH+II9Du70yVi9G6XIn
         E4ag==
X-Gm-Message-State: AOAM531a/91z6wWNEuJU5Mo2XuFgWC17jFBc1+0C4MbPEtXs5JxWONzi
        jsggnOEq51xsbPSJHxfzkA==
X-Google-Smtp-Source: ABdhPJxYEuEm58DHqmsQlEEOUXc8TrvWPoUsggxv41CEB6E5XyMR6KKi23TAe32xSTU+TmgLSAxB7A==
X-Received: by 2002:a6b:6508:: with SMTP id z8mr2910226iob.82.1594695670879;
        Mon, 13 Jul 2020 20:01:10 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id o2sm2017676ili.83.2020.07.13.20.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 20:01:10 -0700 (PDT)
Received: (nullmailer pid 1203440 invoked by uid 1000);
        Tue, 14 Jul 2020 03:01:09 -0000
Date:   Mon, 13 Jul 2020 21:01:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "David S . Miller" <davem@davemloft.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dan Murphy <dmurphy@ti.com>
Subject: Re: [PATCH v2 1/7] dt-bindings: net: ethernet-controller: Add
 internal delay properties
Message-ID: <20200714030109.GA1203390@bogus>
References: <20200706143529.18306-1-geert+renesas@glider.be>
 <20200706143529.18306-2-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706143529.18306-2-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Jul 2020 16:35:23 +0200, Geert Uytterhoeven wrote:
> Internal Receive and Transmit Clock Delays are a common setting for
> RGMII capable devices.
> 
> While these delays are typically applied by the PHY, some MACs support
> configuring internal clock delay settings, too.  Hence add standardized
> properties to configure this.
> 
> This is the MAC counterpart of commit 9150069bf5fc0e86 ("dt-bindings:
> net: Add tx and rx internal delays"), which applies to the PHY.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Commit 9150069bf5fc0e86 is part of next-20200629 and later.
> 
> v2:
>   - New.
> ---
>  .../bindings/net/ethernet-controller.yaml          | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
