Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D8F434D69
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 16:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhJTOYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 10:24:51 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:36555 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhJTOYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 10:24:50 -0400
Received: by mail-oi1-f181.google.com with SMTP id u69so9853434oie.3;
        Wed, 20 Oct 2021 07:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IzAnrV6/peuFgeN4i6pPMNcPWiS8ja/WjUYjReEgoJ8=;
        b=enZwmAkqVGOZovhv8B04kgeo4dwwaW1FUF/aAeN2QpxelWZZtxnGfx1GebCIWgcuqs
         2afl8LwE8q1ZTUpeSCERn0AgbcMyP9MJEu35TnBrjMuNscI+BxeCG+bwFDlPwuIKzHD6
         JQ046QYqZ9HDcOOjJKXbkaDsSDNhAGtnVFFVEv3+vR71MU/kfAtmE2TUBtbELYQ5MpCF
         xKukn5cIFjoAu07TeSH7cX8+lOruq3WZnr2AMXcBddTymkFEvPO3bDFVg9v3QvOTFHzA
         75t0AAgMDPsBq58uDW9BhkTSbInFrVlf7I5Ta3FIc2M233ov+sdY+Ga065zBkqSs6Xke
         QmHQ==
X-Gm-Message-State: AOAM530eo77jkLEEYr/2e2Gub4NMTpQ086NTJMbQMQOJCdEefyXcFbiP
        JW20HcaPUgYcETV+GmG8JQ==
X-Google-Smtp-Source: ABdhPJwuFXF4Y0pxuI20pnX5+EsjXLqQ515YB0tsPuZSFImLatZVfsh2sGIls2R7dpSxpkHbcIr3eg==
X-Received: by 2002:a05:6808:181c:: with SMTP id bh28mr9638219oib.12.1634739755989;
        Wed, 20 Oct 2021 07:22:35 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id e22sm499384otp.0.2021.10.20.07.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 07:22:35 -0700 (PDT)
Received: (nullmailer pid 2303575 invoked by uid 1000);
        Wed, 20 Oct 2021 14:22:34 -0000
Date:   Wed, 20 Oct 2021 09:22:34 -0500
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     linux-renesas-soc@vger.kernel.org, linux-wireless@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-omap@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        David Lechner <david@lechnology.com>, netdev@vger.kernel.org,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 3/3] dt-bindings: net: ti,bluetooth: Convert to
 json-schema
Message-ID: <YXAmKuyIP7Jr8kLF@robh.at.kernel.org>
References: <cover.1634646975.git.geert+renesas@glider.be>
 <c1814db9aff7f09ea41b562a2da305312d8df2dd.1634646975.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1814db9aff7f09ea41b562a2da305312d8df2dd.1634646975.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 14:43:13 +0200, Geert Uytterhoeven wrote:
> Convert the Texas Instruments serial-attached bluetooth Device Tree
> binding documentation to json-schema.
> 
> Add missing max-speed property.
> Update the example.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I listed David as maintainer, as he wrote the original bindings.
> Please scream if not appropriate.
> ---
>  .../devicetree/bindings/net/ti,bluetooth.yaml | 91 +++++++++++++++++++
>  .../devicetree/bindings/net/ti-bluetooth.txt  | 60 ------------
>  2 files changed, 91 insertions(+), 60 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,bluetooth.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/ti-bluetooth.txt
> 

Applied, thanks!
