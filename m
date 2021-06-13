Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF20E3A5A77
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 22:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhFMU4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 16:56:39 -0400
Received: from mail-qk1-f176.google.com ([209.85.222.176]:46866 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhFMU4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 16:56:38 -0400
Received: by mail-qk1-f176.google.com with SMTP id f70so21414106qke.13
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 13:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b2LNyJMlgo8nDWFIv/WryPH8LW1Bp7NMp73+XOWzCFs=;
        b=N3gO7o3p2ddc7C1GeTTDI+NXvU8mDLB4HhnqlB5oqxYT0JhGPWieQ+7D7qDTleRW2x
         i/FIi/NCug3H2zzS0ZVNjpEhK5RET6b0Nbf99uVzYsM8bZhKkNmZUKo1d0itD4hX8KhZ
         xT5W5ZFOBGYpe90Qhp5tguEb7ctxaJni1xJHthcLT536d4AGTBv1pfnxZZ2pK3KoCYD+
         4ce8N0DQJqUfGNRX/KLATfX2wYbss4G8piwvtaFMCzHiHFBL0BXAP8QwN7mGs2/wmqWm
         171xhGcURuXcn2YC74GjdgGpL8WebxFY4FtmMVYxaZNZZVAOgVkJhCWPZ8BXCNoA4cRM
         ovlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b2LNyJMlgo8nDWFIv/WryPH8LW1Bp7NMp73+XOWzCFs=;
        b=m82pw5OT2TcdQ1oCkUsSqjVIxFcd0SqDlGSbW+X//KoWEDBlwlwcrsafk5g+N/E/RT
         WrQSkORe/duiUTbQzhvuQQ1sW+imS8WMF63ZupD19DmZnqAksrmQH+NyQD8YSWGwwIpd
         HhfwoOzIsvDBCfO22UkMow2Jki47+EaWKtYcrHay5jpmzMi7rTnnoNCF7aOgw25YvOyl
         E+r6GRSzm1wHowNEhXAuQFPLJcR4NFdzelkd7ZQn5ewWqbO3FiT/WgW05/m/jjOuXwmS
         nJXfPPPps0VCUqBOA064RSqzl+DW1cnLnlB1nYnRDTKoL+aqK11w3nT8xcwRMd40oW1D
         nz4Q==
X-Gm-Message-State: AOAM5331EMQvT29cBWpcCJJY7ETB9TDSKGu4/NTqsDSwYa7sWCyC1hfR
        hG70xOfSGUlU3uAvULzJ8Oiuwd9kAXqQAwPlhTLQ+EivU3E=
X-Google-Smtp-Source: ABdhPJw2kCkDI6JEYN7MXTnB+/YKV4EIu/R+EOtJbKKXvfm7wCepn3Zo5golfiF4nYXhGaEtQ4kuK4mzBAlMskw170U=
X-Received: by 2002:a37:a041:: with SMTP id j62mr13477533qke.155.1623617616017;
 Sun, 13 Jun 2021 13:53:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210613183520.2247415-1-mw@semihalf.com> <20210613183520.2247415-3-mw@semihalf.com>
 <20210613184409.GQ22278@shell.armlinux.org.uk>
In-Reply-To: <20210613184409.GQ22278@shell.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Sun, 13 Jun 2021 22:53:23 +0200
Message-ID: <CAPv3WKf=ufQYS+yRNwkhU9RQiSc_sNxW_+GgSJEhLGtrqUWzPQ@mail.gmail.com>
Subject: Re: [net-next: PATCH 2/3] net: mvpp2: enable using phylink with ACPI
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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


niedz., 13 cze 2021 o 20:44 Russell King (Oracle)
<linux@armlinux.org.uk> napisa=C5=82(a):
>
> On Sun, Jun 13, 2021 at 08:35:19PM +0200, Marcin Wojtas wrote:
> >
> >       /* Phylink isn't used w/ ACPI as of now */
> > -     if (port_node) {
> > +     if (!mvpp2_use_acpi_compat_mode(port_fwnode)) {
>
> Does this comment need to be updated?
>

It does. I'll update in v2.

Thanks,
Marcin
