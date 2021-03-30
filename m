Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1332434E9C9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhC3OB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbhC3OBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:01:05 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084A3C061574;
        Tue, 30 Mar 2021 07:01:05 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id q29so23869446lfb.4;
        Tue, 30 Mar 2021 07:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iGvgsuwp0I2eWhVopPVff/lvYMxLTVGwlh7RJ+U1pxk=;
        b=LY+1ete9iGAq1CfQSTDHPPtOdOE6NL84CvWmiYpYKXvryXMYuH+V6clockoWiNUwVT
         BC9/lhNuHysKbsNi12qKii1fU4Fw6G1s7bkvB3fMY76wTJ0x8wzL2/pdLvB3u+zc5QV2
         QfjiBj0AXZPAeKVb7/5txQ9KjVgPClPcH40UH8n70R0EDoq967sADJYb/NKavs9RzULT
         mY40XUPqqfSzeS99bmQShOaRFASO9HLJyctrdaIcxzygOVoB/+aWXl31Wo7xTZdEtwnP
         WtRwEM1Wr2+rqJuVCMx01TyZP97KxNa8tM8qZEWq10lOy/JSNNRZEzNAUCT8rzJgOLw1
         n3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iGvgsuwp0I2eWhVopPVff/lvYMxLTVGwlh7RJ+U1pxk=;
        b=oYgFeAvZk9M4ThYlCgnI2NJpf6G1da4IFTOkcInO9Yw0rGarJrOne6YF7v1qDQ6z4T
         6WPE+/9dB/6dZGaSR+wfUQbJn2Fzfey0c+Oo1r5E7LrRKjZZRUvm6RBiHZ8lhEuddWk0
         4zTGE6qioeuXrEn8EP1IPrCbgKdAcK1mYya2Hb0iBZqlF6bvNqTCdpIIWpH8yYEmhFyw
         QR7IIFzrHB+DKvA+XmXH6GkG9K2bNN9WcDX81KbqZEzMSK9ZccjSihvPMeSoH4ma5K1D
         V+DXMmmIy70uS8iaE3j9U5ybI4eEfVf3E9ILpa/TEgn/UiW4yLw0U4/roXs/182we6hq
         zJ3g==
X-Gm-Message-State: AOAM531biyryTCxmoH9SssAucKronp1/IoF55eHZimzNy5MDyAC/KEtf
        ULbqjydoMIRmrHCZMn82pl2OS5FNzQU7Ir2GZqU=
X-Google-Smtp-Source: ABdhPJz6UjK0KeCBOXEpqIJ1M3cCDq/D+oOAaM8FZNZkSrHEtC5otfRJWXtjp7CRoczojnwsa7duZkFDQvINHBOsaRI=
X-Received: by 2002:a19:f614:: with SMTP id x20mr19683060lfe.229.1617112863557;
 Tue, 30 Mar 2021 07:01:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210309112615.625-1-o.rempel@pengutronix.de>
In-Reply-To: <20210309112615.625-1-o.rempel@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 30 Mar 2021 11:00:52 -0300
Message-ID: <CAOMZO5CYquzd4BBZBUM6ufWkPqfidctruWmaDROwHKVmi3NX2A@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] remove different PHY fixups
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Tue, Mar 9, 2021 at 8:26 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> changes v2:
> - rebase against latest kernel
> - fix networking on RIoTBoard
>
> This patch series tries to remove most of the imx6 and imx7 board
> specific PHY configuration via fixup, as this breaks the PHYs when
> connected to switch chips or USB Ethernet MACs.
>
> Each patch has the possibility to break boards, but contains a
> recommendation to fix the problem in a more portable and future-proof
> way.

I think this series moves us in the right direction, even with the
possibility to break old dtb's.

Reviewed-by: Fabio Estevam <festevam@gmail.com>

Andrew, what do you think?

Thanks
