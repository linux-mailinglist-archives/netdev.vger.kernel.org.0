Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2863DE1B9
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 23:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhHBVeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 17:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbhHBVeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 17:34:07 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0A7C061764;
        Mon,  2 Aug 2021 14:33:57 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id hs10so24469792ejc.0;
        Mon, 02 Aug 2021 14:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ATw5EYpH3/Idu5ZcwPy1JrlUOwaplq6MdCPcpRbUk38=;
        b=HtdI5ha5zhXs7rFEfFBjv/2jwm28ie2ucE2m26JkiaXwuhOJW8G7+83hU6Ver5nDkT
         agxHcrm1rNg3VNAZOhY3PNeblYnXOdj22vCA1kZAOOP+KrLB8FQWkUBSJ1zYfah1Xj14
         xpPXBlpoaiphXUVIc5W/BtmfywC8xFWdPDmy2sbjFZK0Kp7+GqAHmh59CE/iGtsx3LNs
         NuH4eswla69vjPn5s1aP+oae7yogm2gYIni35Y8ceXhAy+T8AKmmemkhHmnq6kHNfYf7
         xNA/loMNg9+pwUeXDKQj7DLo4rENzrTXJ4m+sb2T0Ipx1WRYU/r6MrO42jDFyWRUAeMe
         59Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ATw5EYpH3/Idu5ZcwPy1JrlUOwaplq6MdCPcpRbUk38=;
        b=sMTbSSxb3D9odV8X/1vmBVtjQmTOmON4++FbhpHeh5o6IYzCc0XfyXfrOpDX7Gzgrj
         muI26Q3VdIHr4IEwQD+kmbaV0K+fWeE3nxdmA+Koa5yKa4ggR6YPyb+2Jjqfu/06GBbR
         w8DRD5ruYjLevAEqddgLvffb1xlFs7TqI0T/dT0m5J4SVfd38jO4Aj4+Aajq0T7hrIQ3
         +Bs3i3v/YI91xzOjwwJxhsQlPc6UHGFtMId0cAgxHIHJR4GEzlFFnW34F+2EXxF/Vs8Q
         pJNU/KtTKlSIgp9G32v8lWzd6rnvsVV9I4K6B7fBvTk7mLV/vPpBWsBPfToHbX2OnAII
         2djw==
X-Gm-Message-State: AOAM530nn4L2DkH6g/w3QuCY2jjgMse+NMtwO7lsCSFZdhZ8QiRjuLEW
        BPK/UyPimvdSf/4quaCGS2c=
X-Google-Smtp-Source: ABdhPJw53VBMEACoy13fvlsmSw3r2KCB5XFMMs9VlJyMCEpkOA+Z/cmvQ+0LZVSxC2LZqcNmlpg5tg==
X-Received: by 2002:a17:906:1f8b:: with SMTP id t11mr17436224ejr.131.1627940035595;
        Mon, 02 Aug 2021 14:33:55 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id i6sm6871695edt.28.2021.08.02.14.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:33:55 -0700 (PDT)
Date:   Tue, 3 Aug 2021 00:33:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210802213353.qu5j3gn4753xlj43@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <YQXJHA+z+hXjxe6+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQXJHA+z+hXjxe6+@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 01, 2021 at 12:05:16AM +0200, Andrew Lunn wrote:
> > So you support both the cases where an internal PHY is described using
> > OF bindings, and where the internal PHY is implicitly accessed using the
> > slave_mii_bus of the switch, at a PHY address equal to the port number,
> > and with no phy-handle or fixed-link device tree property for that port?
> > 
> > Do you need both alternatives? The first is already more flexible than
> > the second.
> 
> The first is also much more verbose in DT, and the second generally
> just works without any DT. What can be tricky with the second is
> getting PHY interrupts to work, but it is possible, the mv88e6xxx does
> it.

- The explicit phy-handle is more verbose as far as the DT description
  goes for one particular use case of indirect internal PHY access, but
  it also leads to less complex code (more uniform with other usage
  patterns in the kernel). What is tricky with an implicit phy-handle is
  trivial without it. This makes a difference with DM_DSA in U-Boot,
  where I would really like to avoid bloating the code and just support
  2 options for a DSA switch port: either a phy-handle or a fixed-link.
  These two are already "Turing-complete" (they can describe any system)
  so I only see the implicit phy-handle as a helping hand for a few lazy
  DT writers. Since I have been pushing back that we shouldn't bloat
  U-Boot with implicit phy-handle logic when it doesn't give a concrete
  benefit, and have gotten a push back in return that Linux does allow
  it and it would be desirable for one DT binding to cover all, I now
  need to promote the more generic approach for Linux going forward too.

- If the switch has the ability for its internal PHYs to be accessed
  directly over MDIO pins instead of using indirect SPI transfers, using
  a phy-handle is a generic way to handle both cases, while the implicit
  phy-handle does not give you that option.

- If there is complex pinmuxing in the SoC and one port can either be
  connected to an internal 100base-T1 or to a 100base-TX PHY, and this
  is not detectable by software, this cannot be dealt with using an
  implicit phy-handle if the 100base-T1 and 100base-TX PHYs are not at
  the same address.

- In general, if the internal PHYs are not at an MDIO address equal to
  the port number, this cannot be dealt with using the implicit
  phy-handle method.
