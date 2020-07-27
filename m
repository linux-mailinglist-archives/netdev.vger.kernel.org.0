Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27D322F6B8
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbgG0Rd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgG0Rd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:33:26 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5960BC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:33:26 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c2so6896251edx.8
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XFy4EwbQ1hruQWfyvxwpSGaXyhWKJikN0d4fu77mACg=;
        b=RmPx0BV42vUOcwd6ebaLWVEV3xBH7X9PAQSv83L03SIFI38M/jJtJazZ3TwolatQ8y
         LW25YtGedcK6Lvbf2QFtQf1I7i6+e5kyKSkBS33TDbX4Zf1Rcshg6HmnH1xZp7VoOI6z
         orcmWNCVVVD2JEHaKhLaShcj/wUKD3V+H/9293vXHQORXdSJTWcW2O0hCp6mmaIomX8Y
         1tgbgL3iGQWANfdbxYof7ErgwrNtR+cWT2isVO2f4zInlZMplwNQNQI7enp5IsCTc2NU
         tjOGLzxcFujqeunVANKELdCFk9/mFnRj9SCE8RrQ8QMwaXL96FOgG1do4SaDKkfyx3R2
         nsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XFy4EwbQ1hruQWfyvxwpSGaXyhWKJikN0d4fu77mACg=;
        b=aB3sW0MnzpS3HvBYbyI4iZKPxs5cSiYBZbpUWns//mCZr0AvSLP+j5pQsWtYWFHq0f
         1/wmAmTE0O3rn9aODfFsg7nVHDXLX8ZrT+dB5Hy3ANq9LNZmG3rG/wFYaT52wlJF1IyC
         75hXp2OaP1e1BTFFUP9SUkArzvD1HgRKQlxUGuA7P3Rfy8040vDSv7UfCEmBlXGqNmdr
         K2UDeWP+F4CxPj+RFkifGM+vGuPPjHLICWKoPwMOhLA0ZvtUo5wwvjS60pJ8c1rrFIJY
         Cq2psyUiivihVVUfHGKY8lVuaAY3MzCEbj/GAALHqzCCnbcLbnULDdblEfBvUXzbGSaw
         vfbQ==
X-Gm-Message-State: AOAM533JwfkrdW3qCp4HKBrlyCvfbVnl+3porl+wTvfPQT1aZnEFFt+C
        R6xayW2PSQBDZI/iBDt+/GRb6E1yRr8Rr0AWjB2F02QG
X-Google-Smtp-Source: ABdhPJyCby+l6ZVi63IKbukfxKvjhl/3EyTd2nMQvtsiJ3YYTfQjolzylNOe+Otu/6trXR5xLKLWDz+9I1WIK/g2lUc=
X-Received: by 2002:a05:6402:b4b:: with SMTP id bx11mr21696778edb.286.1595871205077;
 Mon, 27 Jul 2020 10:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch> <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
In-Reply-To: <20200724191436.GH1594328@lunn.ch>
From:   Jon Nettleton <jon@solid-run.com>
Date:   Mon, 27 Jul 2020 19:32:48 +0200
Message-ID: <CABdtJHtpSGWBZh2A7XA8hMmRetow8XsHBUORLo-hD8Bn+WEmdw@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 9:14 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Hence my previous comment that we should consider this an escape
> > hatch rather than the last word in how to describe networking on
> > ACPI/SBSA platforms.
>
> One problem i have is that this patch set suggests ACPI can be used to
> describe complex network hardware. It is opening the door for others
> to follow and add more ACPI support in networking. How long before it
> is not considered an escape hatch, but the front door?
>
> For an example, see
>
> https://patchwork.ozlabs.org/project/netdev/patch/1595417547-18957-3-git-send-email-vikas.singh@puresoftware.com/
>
> It is hard to see what the big picture is here. The [0/2] patch is not
> particularly good. But it makes it clear that people are wanting to
> add fixed-link PHYs into ACPI. These are pseudo devices, used to make
> the MAC think it is connected to a PHY when it is not. The MAC still
> gets informed of link speed, etc via the standard PHYLIB API. They are
> mostly used for when the Ethernet MAC is directly connected to an
> Ethernet Switch, at a MAC to MAC level.
>
> Now i could be wrong, but are Ethernet switches something you expect
> to see on ACPI/SBSA platforms? Or is this a legitimate use of the
> escape hatch?

I think with the rise in adoption of Smart-NICs in datacenters there
will definitely be a lot more crossover between ACPI/SBSA and network
appliance oriented hardware.

-Jon
