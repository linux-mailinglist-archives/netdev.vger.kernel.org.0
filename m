Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069DA3EC27B
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238349AbhHNLry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238215AbhHNLry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:47:54 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5A6C061764;
        Sat, 14 Aug 2021 04:47:25 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lo4so23054005ejb.7;
        Sat, 14 Aug 2021 04:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6fVxHAvWlssbPGnAjACjDDC6cX/QS/Q7T20gaYnDfwY=;
        b=nXar+Fb6Z41qkO+UfRLNSH4MzJUD/CFBMJmYmxVqrQgPdUt9UWL9KCO4Q3LKHF4WcR
         Uh9N0zy7cwDvk2TP/wopizmOcvurlKx3brV3a9nJdGE9haNegYwvtaQDAf57zeG1GpQH
         gMMBv6jbhFaCOzzcanypWHj7yMb4VtRi5FU7LoFshtzVC+nHtne1+S6W5whBUuylmeiA
         wjfH6qd2WFPX49hC8XngkrIFtwGMVZMib2WMvtgNjadY8m8ZBYvr5bwloD3pSjsS0Qk+
         bAYaXQTc6MHe+QrtYLL/7hbZ6WWQdnrBnM1vZ9pWbJnkSIPmNuJwALJ2Un/zXe/Vj4Hu
         FD3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6fVxHAvWlssbPGnAjACjDDC6cX/QS/Q7T20gaYnDfwY=;
        b=MkMQQFADtYXn/3bG+PyvOL2VPMwThgnMpSX5rUptNey2ZFBD6B0qTLwFTFWEExg9/Z
         dzc18VIKawacOwP4QP+LfrI93z+nFuCZxJ7ehB0YGwkgnpjMhPmSZ9HOs9dvB31G+Eqi
         n42648PTYG6gUNNoO41kTe6GtpVAuoDiRgRANkUSukXjrthYcjee5cwp1O6NryFAybDu
         C5nBuE7Nj1vzLq+3D85Ighm26kMRedQMNgNf8cxHF3XXV1ssbNXkFl65SO/utQWyYLaE
         ac6dDiS35KT48s1w1UraOlAXBBYWHYGCzCpx/AvuVy18nedTNj/b8+OZTABVUQLJtvMl
         Q1nQ==
X-Gm-Message-State: AOAM532hK2fp3aZec5sIPrDP3lt+NZ6Tdr51U9sy9Uc6PC6QdDXqJprQ
        qzzRMTqA0Bq669Uash+ejuo=
X-Google-Smtp-Source: ABdhPJzKGyZWzbhTFdFDXEKgUPm/21rGlLcpUIMuecj78Sz8Sf5MiwhW6Ny8EzWonSMWqIzdIiL09A==
X-Received: by 2002:a17:906:fcd7:: with SMTP id qx23mr7171164ejb.267.1628941643732;
        Sat, 14 Aug 2021 04:47:23 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id f20sm1698383ejz.30.2021.08.14.04.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 04:47:23 -0700 (PDT)
Date:   Sat, 14 Aug 2021 14:47:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 10/10] docs: devicetree: add
 documentation for the VSC7512 SPI device
Message-ID: <20210814114721.ncxi6xwykdi4bfqy@skbuf>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-11-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814025003.2449143-11-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 07:50:03PM -0700, Colin Foster wrote:
> +* phy_mode = "sgmii": on ports 0, 1, 2, 3

> +			port@0 {
> +				reg = <0>;
> +				ethernet = <&mac>;
> +				phy-mode = "sgmii";
> +
> +				fixed-link {
> +					speed = <100>;
> +					full-duplex;
> +				};
> +			};

Your driver is unconditionally setting up the NPI port at gigabit and
you claim it works, yet the device tree sees a 100Mbps fixed-link? Which
one is right, what speed does the port operate at?
