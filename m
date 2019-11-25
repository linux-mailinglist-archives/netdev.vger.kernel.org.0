Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8762F109457
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKYTmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:42:35 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:47097 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfKYTmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:42:35 -0500
Received: by mail-ed1-f68.google.com with SMTP id t11so13814873eds.13;
        Mon, 25 Nov 2019 11:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rf3FSO6RUL2bsEm6SKsnvhlblxptOIwHTATB1ub2D/4=;
        b=oSZsoT+f47GWVRRm3j7pkBFxUkbOyax80NZhlw5o2tcfTYK8m6gcG7oAsJ4KNb3Dzd
         p+GEpKoY1ufJmF6JVVgRMTT4QDkrbpz8utavFZE3LGRnn55EoSFKYHtCDRFDpjzfn/Jy
         ejNHceETPcc9zO0k3ZtK4HeDJ5F861+/0qLrt2cqeANxp38EW5uHpOZcDw7Axtzwiq26
         64MDwdAGMOCtVbYMd8tlB+/As4jZsiy83uLPTVLmfOh03k9FqYNs6OTwadYyQyBaquVH
         /qZqs0Dl43hCquTl9K3GKZcJ6d8ZpBWSi0uFs2JlXk637JrOdWcmeOVoNwj2TVDX/qBs
         YRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rf3FSO6RUL2bsEm6SKsnvhlblxptOIwHTATB1ub2D/4=;
        b=miyy/v90QrwLWfkbbJCQ1MZigF/tepgGUutvmNSBm5HkHpUKMxQv4XdkwJx1Ue+/zT
         myFiabC+iIenkpg/yfLYANn6I5gZwidcRxKDLrmtztIE80k2XUIIJpreRvtdSdq61lJm
         wDokUEENtyTsVEQXc4qcSaAl38Bh8OH1sRD8JEeUA9SKRkV71a/HZ2oHQf+qvHyy+6Lj
         5duuRuQmtcDC/9P6B7u37oqkb7zIQpeM6ebWvJVGarC0sYdyntiCKL+M0fqrzZfSTZ7x
         WycZraT1pds3MyjKC/ufkOLnppGUMB4mft8qgQSh0tG5dohX8fhQFYAbs/Rlo8BOlX2v
         TvlA==
X-Gm-Message-State: APjAAAWPDn+enVIZ05OrJ4AfsKiYNw0KcgDFYsmDi/Q9g82l9fJOkf56
        evMxOEDwhRxVQrJzVlR2DzzlEsr5OS189LIz18s=
X-Google-Smtp-Source: APXvYqyrTzA9w7jUCwyffl2Ii7h5REuqFEe9pHEjYqfkJ4Rk0ikLFyjWW95W5CsA4t+ayxFALMnt5vIEn160QKL2344=
X-Received: by 2002:a17:906:4910:: with SMTP id b16mr38694023ejq.133.1574710953610;
 Mon, 25 Nov 2019 11:42:33 -0800 (PST)
MIME-Version: 1.0
References: <3e9d6100-6965-da85-c310-6e1a9318f61d@huawei.com> <20191125124110.145595-1-maowenan@huawei.com>
In-Reply-To: <20191125124110.145595-1-maowenan@huawei.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 25 Nov 2019 21:42:22 +0200
Message-ID: <CA+h21hphrWr84wHGj1U4fVHd8OdmpGVPeouznCCPrZC05PLcig@mail.gmail.com>
Subject: Re: [PATCH net v3] net: dsa: ocelot: add dependency for NET_DSA_MSCC_FELIX
To:     Mao Wenan <maowenan@huawei.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 at 14:47, Mao Wenan <maowenan@huawei.com> wrote:
>
> If CONFIG_NET_DSA_MSCC_FELIX=y, and CONFIG_NET_VENDOR_MICROSEMI=n,
> below errors can be found:
> drivers/net/dsa/ocelot/felix.o: In function `felix_vlan_del':
> felix.c:(.text+0x26e): undefined reference to `ocelot_vlan_del'
> drivers/net/dsa/ocelot/felix.o: In function `felix_vlan_add':
> felix.c:(.text+0x352): undefined reference to `ocelot_vlan_add'
>
> and warning as below:
> WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
> Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] &&
> NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
> Selected by [y]:
> NET_DSA_MSCC_FELIX [=y] && NETDEVICES [=y] && HAVE_NET_DSA [=y]
> && NET_DSA [=y] && PCI [=y]
>
> This patch is to select NET_VENDOR_MICROSEMI and add dependency
> NET_SWITCHDEV, HAS_IOMEM for NET_DSA_MSCC_FELIX.
>
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---

NET_DSA already selects NET_SWITCHDEV
MSCC_OCELOT_SWITCH already selects HAS_IOMEM
As for NET_VENDOR_MICROSEMI, does anyone care what are the results
after Kconfig prints this?

WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
  Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] &&
NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
  Selected by [y]:
  - NET_DSA_MSCC_FELIX [=y] && NETDEVICES [=y] && HAVE_NET_DSA [=y] &&
NET_DSA [=y] && PCI [=y]

WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
  Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] &&
NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
  Selected by [y]:
  - NET_DSA_MSCC_FELIX [=y] && NETDEVICES [=y] && HAVE_NET_DSA [=y] &&
NET_DSA [=y] && PCI [=y]

WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
  Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] &&
NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
  Selected by [y]:
  - NET_DSA_MSCC_FELIX [=y] && NETDEVICES [=y] && HAVE_NET_DSA [=y] &&
NET_DSA [=y] && PCI [=y]

If yes. why?

It's like executing code after return.

>  v3: add depends on NET_SWITCHDEV and HAS_IOMEM.
>  v2: modify 'depends on' to 'select'.
>  drivers/net/dsa/ocelot/Kconfig | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
> index 0031ca814346..1ec2dfbd76ce 100644
> --- a/drivers/net/dsa/ocelot/Kconfig
> +++ b/drivers/net/dsa/ocelot/Kconfig
> @@ -2,6 +2,9 @@
>  config NET_DSA_MSCC_FELIX
>         tristate "Ocelot / Felix Ethernet switch support"
>         depends on NET_DSA && PCI
> +       depends on NET_SWITCHDEV
> +       depends on HAS_IOMEM
> +       select NET_VENDOR_MICROSEMI
>         select MSCC_OCELOT_SWITCH
>         select NET_DSA_TAG_OCELOT
>         help
> --
> 2.20.1
>

Regards,
-Vladimir
