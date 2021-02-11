Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7497E3191B2
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 18:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhBKR5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 12:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhBKRz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 12:55:28 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E64C0617AA;
        Thu, 11 Feb 2021 09:54:46 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id q9so5864839ilo.1;
        Thu, 11 Feb 2021 09:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/AfvkW3BT76jstfXfqadStre7RYjq2qJAUGIdvtsE0o=;
        b=f+hCJFDRzhWI/elLipi7vdDNwx+HQbZlId6DRBmB4xcQKVmJ7wQrECDDoIdTSXdd0P
         HCXfDml2Y5ocBIPcLi4EoyCh1pBJxUCAzmM4mcXwKlnvYMUEMyyABunjlVuk4dJ5tk8r
         zndoJWHLD+ZrAWHlrhoZKoQHNEoYn0Oayx4rCETACwfucAXbuFkguwxETd5E2gVEvPNP
         Qr1HH9ZIf/1h4zQ1OpfXbohycBqdwbFVps+KkuIT7ukEAhhKq33hfiTn726Dzoiph1Fo
         ZBfi3kRCxEwPnBlJq10cTER2VkIee5gSV4kkqVILrBzbHvNMo0ZChqPOIuwPZqwrSe6e
         n8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/AfvkW3BT76jstfXfqadStre7RYjq2qJAUGIdvtsE0o=;
        b=LyTWB/r1KD8tEiFwEJrLb4baf7Dr/OuLBaE4uH5vC92jhuCDOVI5NumCZRr0+FnIQo
         E3jHEPKmoWkp+fmgej4WKtMfGGlWmtK07CbMzsJL8+r/aclSnCKAnmGuV23dEVe59REI
         YPE7G4MCURdygeMjegXMKpdubT6QEEiP/sWHNz1qNDtvn0il2vuAMGs9bkgPk0NBi55b
         xOY31oqosf9+ivx3Z8S8MBjLQ+LgqzobWDIVGcZTWZHTyXu/ZU9jYOD8kcoDymZ43NQo
         EZ0UxshNx3qS0wWOEp/CC1jrcHBmzBLYg0I9KZbctXVCS7HRwEuxznPUky1jkGx/HVBD
         Jk7g==
X-Gm-Message-State: AOAM533lo5WmlSVLT+v7R0wUIro99liHNuvE6q8fYp65rOlhpW5AXGaq
        SoqqNFtmMjp0dWeCISgHFh0XKDC0ShsSYuYb2xA=
X-Google-Smtp-Source: ABdhPJzNdjPD6PmZQTb31bRfX5TO+6K+2/TyE3PIjf76PP+42Djm3qgWNK/gWF1tgvgGhKr4CVqbgdX3O/hGt+4W+k4=
X-Received: by 2002:a92:c090:: with SMTP id h16mr7020689ile.190.1613066086401;
 Thu, 11 Feb 2021 09:54:46 -0800 (PST)
MIME-Version: 1.0
References: <20210211160930.1231035-1-ztong0001@gmail.com> <dcb02f4e-2fad-b44f-9bc0-098cb654b145@gmail.com>
In-Reply-To: <dcb02f4e-2fad-b44f-9bc0-098cb654b145@gmail.com>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Thu, 11 Feb 2021 12:54:35 -0500
Message-ID: <CAA5qM4B4AF=5UaGVT+Jgww-7SKbnA0pJORgvv9E9a8HwVOUPFw@mail.gmail.com>
Subject: Re: [PATCH] enetc: auto select PHYLIB and MDIO_DEVRES
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the comments!
I have sent a revised patch.
- Tong

On Thu, Feb 11, 2021 at 12:38 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 2/11/21 8:09 AM, Tong Zhang wrote:
> > FSL_ENETC_MDIO use symbols from PHYLIB and MDIO_DEVRES, however they are
> > not auto selected.
> >
> > ERROR: modpost: "__mdiobus_register" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!
> > ERROR: modpost: "mdiobus_unregister" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!
> > ERROR: modpost: "devm_mdiobus_alloc_size" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!
> >
> > auto select MDIO_DEVRES and PHYLIB when FSL_ENETC_MDIO is selected.
>
> depends on MDIO_DEVRES && MDIO_BUS
>
> would be more appropriate because the symbols you reference are part of
> the MDIO bus layer, which happens to associated with PHYLIB depending on
> the configuration but as far as build goes you can separate the two.
> --
> Florian
