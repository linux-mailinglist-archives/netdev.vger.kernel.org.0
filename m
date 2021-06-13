Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA423A5A99
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 23:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhFMVZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 17:25:00 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:42826 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhFMVY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 17:24:59 -0400
Received: by mail-qk1-f175.google.com with SMTP id q16so10678278qkm.9
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 14:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C1mExJCPgpNZd6cbu2tb/gKgZ1aY7W1ClExqPNOLIuM=;
        b=o6BAwb9ioitFPZC+O4R1JfrJ7u/Pry4ztI6ZM3Dp71fihRrQe9mbOsxp5FZk+oO01A
         U1MjiGhae9OU+m0eNPSaB+ibVPgbB8UnDKFm7xqDLH7wQ/p2t1fA3rcaZseHe4Pgt0Mc
         aQ8cbvrxihCZo6fmJIxMwIfTkkTMDKOqFWipfSZvQOrGS0YTwZ6F3CJ4ICV/DHN1yjML
         CzsW07h6O38Q6kRoQ6bq41WauJ9aYiUebkR/LKBxt9PDb4NScclamAxH8DWMv5QESy/5
         OiHg57McCFZFu8Lbies3hgXOww6VnzGY2NrW1/i+ukY3jk2mu7D1kNYGAFK+DTmJ2Q0a
         nWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C1mExJCPgpNZd6cbu2tb/gKgZ1aY7W1ClExqPNOLIuM=;
        b=ap39WkVGQbDQ8SGIj0r4LIG91KYrInO29XoivbvQRvyM6HbQIoH3F7m89qUPXoRRzd
         EyK30vZeKMqBRanO1x1MoBi15/f3HXArJGTZCMgRfEOKlbGdVAxXHG68xtSOFfhdpieu
         wxzVhURzBVyRrRGQC9aA6oq1yetDiSLIcUlzNmhMRLo+uzwPdkb5Icitr5KrEUTh/AEk
         LxXb2RZgi+nbArU/YrY/B0xbWEBQXIvQkHTfVtf0THiaipbO6r8RJJ34p9XyawdNFR0N
         wBSl56t69kYud+osbHAgQdaCVT50EcjUH2NQ+TJHWVD9VC8oqfoLtnBB+RhQq+QFRJ2P
         4Whw==
X-Gm-Message-State: AOAM5323FCk4AKx3RynMrXmwEIVOErb3UnTH3C4gnprpOjUeO1aq8m5L
        C9Ir9+UOjuwbIHLAkthVDyiccJ7dW4fyQzubWLFv0Q==
X-Google-Smtp-Source: ABdhPJy+BXBgTbT3yDL5YymQ1TbVkHw/a4ewerFPNMTywKSUAJlw1M8cD3FBM/LBbdaP7dDvdYFEE1w7FzuXyL75Uk4=
X-Received: by 2002:a37:a041:: with SMTP id j62mr13554877qke.155.1623619317071;
 Sun, 13 Jun 2021 14:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210613183520.2247415-1-mw@semihalf.com> <20210613183520.2247415-3-mw@semihalf.com>
 <YMZg27EkTuebBXwo@lunn.ch>
In-Reply-To: <YMZg27EkTuebBXwo@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Sun, 13 Jun 2021 23:21:44 +0200
Message-ID: <CAPv3WKfWqdpntPKknZ+H+sscyH9mursvCUwe8Q1DH-wGpsWknQ@mail.gmail.com>
Subject: Re: [net-next: PATCH 2/3] net: mvpp2: enable using phylink with ACPI
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

niedz., 13 cze 2021 o 21:47 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> > +static bool mvpp2_use_acpi_compat_mode(struct fwnode_handle *port_fwno=
de)
> > +{
> > +     if (!is_acpi_node(port_fwnode))
> > +             return false;
> > +
> > +     return (!fwnode_property_present(port_fwnode, "phy-handle") &&
> > +             !fwnode_property_present(port_fwnode, "managed") &&
> > +             !fwnode_get_named_child_node(port_fwnode, "fixed-link"));
>
> fixed-link and managed are not documented in
> Documentation/firmware-guide/acpi/dsd/phy.rst.

True. I picked the port type properties that are interpreted by
phylink. Basically, I think that everything that's described in:
devicetree/bindings/net/ethernet-controller.yaml
is valid for the ACPI as well - the kernel already is using 'fwnode_'
in most (if not all) cases.

Would you like me to add "managed" and "fixed-link"
description/examples to the mentioned file?

>
> Also, should you be looking for phy-mode?
>

In the beginning of the mvpp2_port_probe, there's:

        phy_mode =3D fwnode_get_phy_mode(port_fwnode);
        if (phy_mode < 0) {
                dev_err(&pdev->dev, "incorrect phy mode\n");
                err =3D phy_mode;
                goto err_free_netdev;
        }

So we won't reach further checks in case anything is wrong with it.

Best regards,
Marcin
