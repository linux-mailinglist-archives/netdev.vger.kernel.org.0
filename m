Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0117F3495CC
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhCYPkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhCYPkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 11:40:22 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F1FC06174A;
        Thu, 25 Mar 2021 08:40:22 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id bx7so2884438edb.12;
        Thu, 25 Mar 2021 08:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BVovXqBbk0wGC2HDbPVyA2PvUhMQtNnpOLKoi6ckjaU=;
        b=iFeLm+OF/avp81DNNgzalw+tsL7iEPbBLPRqw3QAv2eEf+f749073yoE76q/f4hx8P
         Vw24m/ksowquw8kplSXYB+L0ibKnbnILK1cPUwO73Rmg7ivRPbbM2XvMzdwn5Gp7y/XT
         xM6/pSXNvFwDpf8JI2yHsGLpuN4gJdQ3/ouesF9hmV4ZC6mZEjuNuFJuTHzqPjVoBN9X
         Y9SlykxFTTSawYVTtXAUUtmTUsHM4uZ6RWTtp7PzmePktV9KPzBPzmvhSCPiJUTUp2Pb
         Rs4Cz/vOU5uumF/DmWhE3FHqDX7ary5poTrZbTHlqXxfODwXPp1wgqZD266Mi++tcku2
         vp1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BVovXqBbk0wGC2HDbPVyA2PvUhMQtNnpOLKoi6ckjaU=;
        b=PtDeg7PGelUbJrRTyC6+tT9aWwlrvvCLOTFZwwZoJ1HaFJlsqs3CML3G4GEgTgbFKA
         /HU/Zx7ZhaItfvMMTk4Dt+3Yvq8RprLaj0mU9/G7ghgc5jMVwBXK9wCnHcjWfOI7N2bk
         YiEcR0p68mPa2NM1YGVcf/4wJD56vxfEhnmliJ3oHXeIHcAY+z2kYiJkMOkeq14l/Wct
         YKEIdQeysZhsilsb6wFW41Iy3fkhyr5579TQcDn7JwncgZbWhmMB3Jwsw3TTOdL87gBD
         iZXiTWMf3yN6A9nUWY5frF34Jbhv5I4BSMWEQQDsIiLSxXXE7TRlRo8yR+W9MAv16kx/
         1BlA==
X-Gm-Message-State: AOAM532R0XBduIYKeRKlux9fckXtKsctGPml7+P5/Pd+HLhHoBb6RTHY
        6UADAtgzZAZIc7SusiPReg3VYQ8We8L/r8P6YHg=
X-Google-Smtp-Source: ABdhPJxvxq8ahShyOo02COOTW4cd6bEFSU4bQBwGxzqlBBO4cZcfia1CXqKD5Wfaga/VcucZpJdv5Evt9QNBzFKwyo0=
X-Received: by 2002:aa7:c6da:: with SMTP id b26mr9920197eds.254.1616686820913;
 Thu, 25 Mar 2021 08:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210325124225.2760-1-linux.amoon@gmail.com> <4ce8997b-9f20-2c77-2d75-93e038eec6d8@gmail.com>
In-Reply-To: <4ce8997b-9f20-2c77-2d75-93e038eec6d8@gmail.com>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Thu, 25 Mar 2021 21:10:10 +0530
Message-ID: <CANAwSgS4SLdYwY9n6uNci+rgE1Q4UAzCy29gX+CL4patDgH15A@mail.gmail.com>
Subject: Re: [PATCHv1 0/6] Amlogic Soc - Add missing ethernet mdio compatible string
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner


On Thu, 25 Mar 2021 at 18:49, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 25.03.2021 13:42, Anand Moon wrote:
> > On most of the Amlogic SoC I observed that Ethernet would not get
> > initialize when try to deploy the mainline kernel, earlier I tried to
> > fix this issue with by setting ethernet reset but it did not resolve
> > the issue see below.
> >       resets = <&reset RESET_ETHERNET>;
> >       reset-names = "stmmaceth";
> >
> > After checking what was the missing with Rockchip SoC dts
> > I tried to add this missing compatible string and then it
> > started to working on my setup.
> >
> > Also I tried to fix the device tree binding to validate the changes.
> >
> > Tested this on my Odroid-N2 and Odroid-C2 (64 bit) setup.
> > I do not have ready Odroid C1 (32 bit) setup so please somebody test.
> >
>
> When working on the Odroid-C2 I did not have such a problem.
> And if you look at of_mdiobus_child_is_phy() and
> of_mdiobus_register_phy() you'll see that your change shouldn't be
> needed.
I will check this out, thanks for your inputs.
>
> Could you please elaborate on:
> - What is the exact problem you're facing? Best add a dmesg log.
   1> I am aware all the distro kernel I have tested ethernet will work file
   2> My issue is when I compile the mainline kernel with the default setting,
       Ethernet interface will not receive any DHCP IP address from the router
       Although the Ethernet interface comes up properly.
      This does not happen frequently but I observed this at my end.
  3> I tried to collect logs but I did not observe any kernel issue
like panic or warning.

> - Which kernel version are you using?
     I am using the mainline kernel with default settings.

-Anand
