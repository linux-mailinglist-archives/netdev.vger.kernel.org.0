Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6481D37E3
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgENRUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbgENRUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 13:20:45 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDF7C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 10:20:43 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id b71so4102496ilg.8
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 10:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zDpj6X02YNWJzxuOMR+V42uIE+YhhkIBci21m3AAt/M=;
        b=rXZO0q+XrlwWB7m/MiDeDcnwsfknbebAsjxWpc17K/Cy+Rox3RFLMqNk2H2U9uB42S
         Q1O0Tkjqbh9JQSfZpJsHCBqge+GqZ8dESZvBL2gzlCV6hAmgf/WtJBJNFQuCYIT3CiBx
         2uFRJJXnVghMFa3eIBjbmhxjQGxVDYx8u5GPi/gjN2tSFLtxlJ9Nq14b2Y0KD9h/XPZu
         SeXVXzvmgRDDeNtNmfMyvkBk0EITl1uIaLhp4qJO8XW1hO4Wx0xqQfQLllaRYW6pxfw7
         mzPnbES6Q4EojYcwkN5+x+FthMWji3G9J+kaf5zWnwDRlxqJGPjNKifVC5CJ3tk1KDqA
         pFbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zDpj6X02YNWJzxuOMR+V42uIE+YhhkIBci21m3AAt/M=;
        b=Cc0y3yke5WGrC+6rhmiiK1V5Zjwbb83fPN10uJ30G1zjrQinT11NH9ZEw5Th+LGgT1
         xJuLbliTqVi0+lGO5UaxqJDkXRQXwqCutuNH2oyKw/F7RRr6xj22YPOpjtmNTn0cKXk8
         mBoRwnUDLoFo6CN5nCURA4EcirJQZzVPSRzASuW/w2EsqgAG7+ldR3Rn7mGvVFitwuj9
         XNReRjAW4Tlb7U1iA7OXiVsFS/WvSo7PyXmYsyyVEsrwUHkqu+Jps73YiIBFLWP18pcY
         r6vG621f8i2+r8nsA4akD2iU7tBZqkZShbTdqBeJBWgU1bIX4c7Pf6Ff8gtDl4tfTJzw
         kpbQ==
X-Gm-Message-State: AOAM530uFC8rVelvAQy/0+E8hW/LKdxBgQkNeJJ/io+n2M3qhXFEBTQP
        hI18yH0WXCStNYGnibIzDZhvcsVuNjWXfCV5kldOqg==
X-Google-Smtp-Source: ABdhPJwhdwkv2qQCDyAysReOGfjGM0RMqXBGvQL+ChLTuDbPS6OZOVMDrxGx/BhpZSrNAa8+jlHhGkZPEsHAANt5H3k=
X-Received: by 2002:a92:dac8:: with SMTP id o8mr5450499ilq.189.1589476843040;
 Thu, 14 May 2020 10:20:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200514165938.21725-1-brgl@bgdev.pl> <8fc8ea34-a68c-8fbd-3821-d073c08444f8@gmail.com>
In-Reply-To: <8fc8ea34-a68c-8fbd-3821-d073c08444f8@gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Thu, 14 May 2020 19:20:32 +0200
Message-ID: <CAMRc=Mcp89E7f+PeVfhJ8iXXRZdG9c28_CzCeMpSJj=n5Gwo+w@mail.gmail.com>
Subject: Re: [PATCH] net: phy: mdio-moxart: remove unneeded include
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 14 maj 2020 o 19:13 Florian Fainelli <f.fainelli@gmail.com> napisa=C5=
=82(a):
>
>
>
> On 5/14/2020 9:59 AM, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > mdio-moxart doesn't use regulators in the driver code. We can remove
> > the regulator include.
> >
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian

Hi Andrew, Florian,

I noticed this by accident when I was looking at the PHY drivers to
see how they handle regulators supplying PHYs. In the case of the
MediaTek Pumpkin board I'm working on - the PHY is a Realtek RTL8201F
and it's supplied by a regulator that's enabled on boot by the
relevant PMIC driver. I'd like to model it in the device-tree but I'm
not sure what the correct approach is. Some ethernet drivers have a
phy-supply property but it looks wrong to me - IMO this should be
handled at the PHY driver level. Is it fine if I add a probe()
callback to the realtek driver and retrieve the "phy-supply" there?

Bart
