Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADA33D3AF4
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 15:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbhGWMfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 08:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbhGWMfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 08:35:32 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F7CC061575;
        Fri, 23 Jul 2021 06:16:05 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id r26so2022970lfp.5;
        Fri, 23 Jul 2021 06:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G8MAzUmtAUyarwHICX8YROw4qZnz+cDz/I1mOWJQT1Q=;
        b=i1rNT6mGYqVmt+LvteSw2wAdA3p/5yy5LHoCPdkgYat55zWib+tSqde34QC3+ff/5u
         DpjybKdJymItrRrH2mvEAEvNKF6nj5vzd2XCPEhTKw37YL7PClcWQVRQV2NgbWq8sQEX
         yacO7tMUIsTngbvlwKxJ2hkndst00CoQlAXIy3FRtEfk67jBBDUpzYkZ3EXlwk/kThAU
         Z1U5YOG9M3999MrfCWeglw2JSLCN3kd/my68FntTTYqk/hfh91CwQRUx/IfyHb43vqfP
         LknmE2T3/15RtRSsIczEIOm+Nv+8aL3XgucgUooA2m5+iKeuljhL9tEr32UCOC87oZUK
         /Isg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G8MAzUmtAUyarwHICX8YROw4qZnz+cDz/I1mOWJQT1Q=;
        b=KLoiz3qgNAZ1XaAYklfs2FQXu7qGGjmK2zfmRIzSI2ck0BIzMsGTzehm21HpLjhNV0
         lqgY5A3nuJXVIhp9YQQz6BqY+Z8BF9Owz0AadnMUnWIYZTOWH9CMOP56U9q3wbG5OvDY
         o3HA6y+XyaDSE05UXQ69toPaDaeF8lZa5QcliiBo88vPgF8GlKqQZVdQWw4tnFoub5qz
         3kaaEwWPAJNwOrVbmsmRmppqZSwNc8S0jd1OGHGZ71LDRDjrejPeHX86yTEUF1pPWCRJ
         DVpBzODj0KBQHtYkaL9Nq7xXdipK6PiNr1thzLb18fP6MRgSHWE+XpBUaqTLyq2nm6Qs
         bRbA==
X-Gm-Message-State: AOAM531dzQMuwWdzegL403r1ZZriHpH3hX4G6d/vCn22OtsJAI+563vf
        F/2UXnrCW1PP0wb4+xQlEVOiImT78z9iBjNXNtU=
X-Google-Smtp-Source: ABdhPJwoumFiA6g3ll/fqh+vKDmIzrOxpZm+/YFZliWRKmwWR8BR0GyriA7tDaG2oWJ24JRBZv6pLAwRVZmp/eBZh0M=
X-Received: by 2002:a19:4341:: with SMTP id m1mr2909294lfj.443.1627046164068;
 Fri, 23 Jul 2021 06:16:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210723112835.31743-1-festevam@gmail.com> <20210723130851.6tfl4ijl7hkqzchm@skbuf>
In-Reply-To: <20210723130851.6tfl4ijl7hkqzchm@skbuf>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 23 Jul 2021 10:15:52 -0300
Message-ID: <CAOMZO5BRt6M=4WrZMWQjYeDcOXMSFhcfjZ95tdUkst5Jm=yB6A@mail.gmail.com>
Subject: Re: [PATCH net-next] ARM: dts: imx6qdl: Remove unnecessary mdio #address-cells/#size-cells
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimr,

On Fri, Jul 23, 2021 at 10:08 AM Vladimir Oltean <olteanv@gmail.com> wrote:

> Are you actually sure this is the correct fix? If I look at mdio.yaml, I
> think it is pretty clear that the "ethernet-phy" subnode of the MDIO
> controller must have an "@[0-9a-f]+$" pattern, and a "reg" property. If
> it did, then it wouldn't warn about #address-cells.

Thanks for reviewing it.

After double-checking I realize that the correct fix would be to pass
the phy address, like:

phy: ethernet-phy@1 {
reg = <1>;

Since the Ethernet PHY address is design dependant, I can not make the
fix myself.

I will try to ping the board maintainers for passing the correct phy address.

Thanks
