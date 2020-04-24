Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AD81B714C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgDXJ4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726839AbgDXJ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 05:56:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958BFC09B045;
        Fri, 24 Apr 2020 02:56:44 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o15so4416565pgi.1;
        Fri, 24 Apr 2020 02:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8g1Qeu2PJu2OXoQ3lMahtFGRconFZq/a+DVsXd6HwAs=;
        b=EDPb40iEk4xe3gjopzZRdm0PXV3UNcBpXaXQwvVkK6Gks2ubrPWTqneru4oMuXdOQ+
         m7wy7cLJ3DarRKECjTxse5/OCNU8WhkX9FzcjaAsbkcSJjgUqg9VujC2sVwjqPSN3tyA
         /ANiw4DBFT5aOy0Bku0574L44kTcWhA4BioScPGRYTP/Z9SKqeC8o8RzXN5EK6K83lym
         Xh7XjAfAxREZFaFXIbMziFSjKK1KTPY3/8ZZrPvK3zwGMd59OGKyaH/uAmT1ctyVznxb
         l1TOx83AIqjULTw+Oxi1uQKjo5n/eRoROEUseVnCN2ta84Kd6xXTNnPJLShRiFASMzbl
         azdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8g1Qeu2PJu2OXoQ3lMahtFGRconFZq/a+DVsXd6HwAs=;
        b=ewq+Cc8G8RZhoknsgZyzHiyOrvn6vqKnDO1pyQ/dPT/Ndt4hMnaTXW84GBEGmdtVlF
         Qf6l8pXJFuxDOCzlzJonYRnCRjU6BnfWmOAeahVxDDNn1to7mjOdYba/lCqiCuXtvlwf
         zGSW+pcnzmB1KUNeHjQF6tdwZhlQM4pj5fyJJqXspR0TUqC6AX4eV9yYixKeQ1bXb9Bh
         RQNfaELRsGjCWbIdYn6V+nW0QIJrJK48GyZGTimOYtwwFIWFcegqIcYfjdcuWklwqrl4
         UVSr7+hcoYfn2H60yrczeh0mfEt3cX+hYa4rwxbcsR+N/Pg3RQBY9gq5awPPuubLSxl3
         V71A==
X-Gm-Message-State: AGi0Pua9DD/qNKz34hkYEtenx4ycPHuO2bigPst+K+uF4XWpT7l0uLwG
        4OY9OR9PeLShf5sl3jlbwSIzeIEa6BDHbp/NLjs=
X-Google-Smtp-Source: APiQypJoSVO02AhLEULSq00w+T9tSO+dGfUkCB9MaeL3fJM2YBvorpMGA+TqH8RN4vRqzgEpcjgVuiAnEW+pfufBUxc=
X-Received: by 2002:a63:1d4:: with SMTP id 203mr8109776pgb.74.1587722204197;
 Fri, 24 Apr 2020 02:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200424031617.24033-1-calvin.johnson@oss.nxp.com> <20200424031617.24033-3-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200424031617.24033-3-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 24 Apr 2020 12:56:37 +0300
Message-ID: <CAHp75Vftq3OEEC5DfW8CgV4yQKZ3doD-r6khXxgn0oOmrLnLkA@mail.gmail.com>
Subject: Re: [net-next PATCH v1 2/2] phylink: introduce phylink_fwnode_phy_connect()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 6:17 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Define phylink_fwnode_phy_connect() to connect phy specified by
> a fwnode to a phylink instance. This function will handle both
> DT and ACPI nodes.

>  #include <linux/spinlock.h>
>  #include <linux/timer.h>
>  #include <linux/workqueue.h>
> +#include <linux/acpi.h>

Looks like broken order.

> +       if (is_of_node(fwnode)) {
> +       } else if (is_acpi_node(fwnode)) {
> +       }

I'm wondering if there is an API that allows you to drop all this
stuff. In property provider agnostic code we really don't want to see
this.

> +       if (!phy_dev)
> +               return -ENODEV;

-- 
With Best Regards,
Andy Shevchenko
