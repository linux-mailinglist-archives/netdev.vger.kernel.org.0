Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBEE1C18BB
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgEAOtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729114AbgEAOtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 10:49:14 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56563C061A0C;
        Fri,  1 May 2020 07:49:14 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id x1so7637246ejd.8;
        Fri, 01 May 2020 07:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fxPFkW3QxOmRfYj2h3nMtAxuro0T/xEXMFbcE0LTrVU=;
        b=W3eBxkRVCUkRmVjaeZxdY0eWXI1WeV14Y3GZ6cGG6qX2rTNYODG/BhL8vEpRBcwaX8
         5zyBVQI+Panp/tiEK/dymKhhil24IaILyAaTbA3+8a3McJf9tacA3Zc7rwjq5i0wWM3R
         kNZhVSx8yndKHndGwo7LMgJt+4oODm4bGQ7Xu4rUIJQYPUR40Ev/Jg4FjzSM5/gEV5+x
         oQPS5n4+5GFiF2LMJceZVHlRYcpEj/Q9OldY0p8kPupcGJLxLMkoKGeFEXfmjNy1T8g+
         5HfzjwGCytspb5OaBLFNKMcAUGG9Oz5jmvrc5BifLpcq/oGghD/DAsv+kcGzitsc9hJ8
         702w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fxPFkW3QxOmRfYj2h3nMtAxuro0T/xEXMFbcE0LTrVU=;
        b=PNu1Nk0KoaPPBBdpL15G3DrF3oKx7knlcPdqKvJrROP4L3RoNZyItdDd9YPp/r0I2D
         7j6jMW/llYz4qfhYl6SqUQulWD87ryJzWhYyMxqDiH+mB9t05ZGAvXsGHDP7q/+G1Kjm
         urWA5bAGtKuHEg0SP629ogsnJcHmAFO6BvZ1lVBD2lsE2leAof1If7Twk+ez+sEj46Fd
         Y1BvXOvZGDL6RAPM6FiaPbwkdhGwFtKtMnke6T2bBxlRgb7GC8HS1YRedYc0WTM0wiA7
         ni7pgnKYvHLulHca7oL1IsWPATHTjzbQ5Kt7aKJ7YG2SfMJtXeHfwl2AYNDQCNr+GWZr
         h31w==
X-Gm-Message-State: AGi0PuaZq3OMGmiFun309hY8LSRPsgeHOyrB3vX53DEDXJMspXgWGBZP
        rF6Zz035nYW23sydtvQaDrBXffl6oGnG/spslyQ=
X-Google-Smtp-Source: APiQypI+1+VQOUh4IFgtlgbygkJrSop4NKMEXZUd+7VOMUopczAN+iZLGHuyibbdAMVPCjuSWytmI5hAyJGDHqrKplU=
X-Received: by 2002:a17:906:4048:: with SMTP id y8mr3549075ejj.258.1588344553010;
 Fri, 01 May 2020 07:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com> <20200429212933.GA76972@lunn.ch>
In-Reply-To: <20200429212933.GA76972@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 1 May 2020 16:49:02 +0200
Message-ID: <CAFBinCDAz48BKjvLHOmuHk6nME+vpCueFW14UWP1b8Ae_D1j5w@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/11] dwmac-meson8b Ethernet RX delay configuration
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Apr 29, 2020 at 11:29 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > - Khadas VIM2 seems to have the RX delay built into the PCB trace
> >   length. When I enable the RX delay on the PHY or MAC I can't get any
> >   data through. I expect that we will have the same situation on all
> >   GXBB, GXM, AXG, G12A, G12B and SM1 boards
>
> Hi Martin
>
> Can you actually see this on the PCB? The other possibility is that
> the bootloader is configuring something, which is not getting
> overridden when linux starts up.
at least it doesn't jump straight into my eye.
I checked in u-boot and Linux, and for both the RX delay is disabled
in the PHY as well as in the MAC.

The schematics of the Khadas VIM2 also show the the RX delay in the
PHY is turned off by pin-strapping, see page 7 on the right: [0]
It's the same for the Khadas VIM3 schematics, also on page 7: [1]
There are also high resolution images of the Khadas VIM3 online so you
can look at it yourself (I couldn't find any for the Khadas VIM2 which
is what I have): [2]

I agree that we need to get an answer to the RX delay question on the
arm64 SoCs.
If there's no way to find out from the existing resources then I can
contact Khadas and ask them about the PCB trace length on VIM2, VIM3
and VIM3L (these are the ones with RGMII PHYs).

For the older SoCs the RX delay has to be provided by either the MAC
or the PHY and right now we're not configuring it.
We cannot simply enable the RX delay at the PHY level because the
bootloader enables it in the MAC (so we have to turn it off there).
So it would be great if you could still review this series.


Martin


[0] https://dl.khadas.com/Hardware/VIM2/Schematic/VIM2_V12_Sch.pdf
[1] https://dl.khadas.com/Hardware/VIM3/Schematic/VIM3_V12_Sch.pdf
[2] https://forum.khadas.com/t/khadas-vim3-is-launching-on-24-june/4103
