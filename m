Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A456F2A173D
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 13:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgJaMQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 08:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbgJaMQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 08:16:19 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65B5C0613D5;
        Sat, 31 Oct 2020 05:16:19 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id v123so2233977ooa.5;
        Sat, 31 Oct 2020 05:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3IZQKufwOcxbgfNyN8LiifsxqO2FM7tzTmP6WflJFGk=;
        b=DlYohsrLV0bjqieNe2L7OCYR77e47fm9oLAnlze0cDMrNCa4ThthSlCGvGe2i1/YRY
         W20FMurKnp87uTiZTKvwLPu5/TojmFMtTKQQO1a1Md2p2v4atLSbMOzq3+MoOzDvw9Ns
         2Wv65JfQ1AQvn0fk/ck0NevyDZW6Bj5PXqQ9o9R9qhV8+jIqVDlub02Z7/dc1C+zxgyv
         kw2kl9+5htipt4ixQ3se2IB0KDJMhBgSo+ZKXumn+H1hCyUN3b0OEL1BTWlmH4oqq4pS
         6G7FQo5Zh6+FAMoOU8Ypg4QsZQq8XNFVZ8pqlKqQlt5P1MFoyokxmWZXzLIXl0YVKIll
         okhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3IZQKufwOcxbgfNyN8LiifsxqO2FM7tzTmP6WflJFGk=;
        b=aLPqMseSPSMtsnGO5A0/nqbCLUk37Qs9FbWrpTo1ITZJmjqyVIFkNIDojGE8Y0cL1X
         UTBuKWPB3Tkyf7ji34dxVF6be05/iVgD3GoSDF7s40Cu2xDjZvbRL25B+y1k3liZ50V9
         u/8VaYuANZ0lJcWYWS21amvFfGnsQx9zyL3gAeWaNzCHkfo8Y/253QvlVIywzjLkKcHr
         9jleMzeMoTkeszY86ERAlIrwjokmYnzPo4/R4M8atQXopBSj10l6ZtIHYdJpYNd4f3GJ
         yIocmtZctb1JV/Zk+S37q71FA1vPVazixIqVgc2FZeHUGl+loJi34HD0Cxotru1N0jpc
         jSEQ==
X-Gm-Message-State: AOAM533Yl4nsQutF7b8HCOG6HYnFKTWtrn/KrCbpqMaRE+ij2NcuLz+O
        jXw3UldnojJByBjRc+zd6rTE2o7FtwP+Lnle1bM=
X-Google-Smtp-Source: ABdhPJyOoDpUPtIiC+qPu+axZfUycYe94lvhxIoFbOqmYvuMLYWi77cRjrwCKouEB35H1iflD/4+ah9srUO46rWJTMk=
X-Received: by 2002:a4a:d104:: with SMTP id k4mr5512975oor.0.1604146579103;
 Sat, 31 Oct 2020 05:16:19 -0700 (PDT)
MIME-Version: 1.0
References: <20201022074551.11520-1-alexandru.ardelean@analog.com> <20201023224336.GF745568@lunn.ch>
In-Reply-To: <20201023224336.GF745568@lunn.ch>
From:   Alexandru Ardelean <ardeleanalex@gmail.com>
Date:   Sat, 31 Oct 2020 14:16:07 +0200
Message-ID: <CA+U=Dsr3pbZspQu13YmZSLthgCeMNx_7guWTwLtb8vETbVsT_A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] net: phy: adin: disable diag clock & disable
 standby mode in config_aneg
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 24, 2020 at 1:43 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Oct 22, 2020 at 10:45:50AM +0300, Alexandru Ardelean wrote:
> > When the PHY powers up, the diagnostics clock isn't enabled (bit 2 in
> > register PHY_CTRL_1 (0x0012)).
> > Also, the PHY is not in standby mode, so bit 13 in PHY_CTRL_3 (0x0017) is
> > always set at power up.
> >
> > The standby mode and the diagnostics clock are both meant to be for the
> > cable diagnostics feature of the PHY (in phylib this would be equivalent to
> > the cable-test support), and for the frame-generator feature of the PHY.
> >
> > In standby mode, the PHY doesn't negotiate links or manage links.
> >
> > To use the cable diagnostics/test (or frame-generator), the PHY must be
> > first set in standby mode, so that the link operation doesn't interfere.
> > Then, the diagnostics clock must be enabled.
> >
> > For the cable-test feature, when the operation finishes, the PHY goes into
> > PHY_UP state, and the config_aneg hook is called.
> >
> > For the ADIN PHY, we need to make sure that during autonegotiation
> > configuration/setup the PHY is removed from standby mode and the
> > diagnostics clock is disabled, so that normal operation is resumed.
> >
> > This change does that by moving the set of the ADIN1300_LINKING_EN bit (2)
> > in the config_aneg (to disable standby mode).
> > Previously, this was set in the downshift setup, because the downshift
> > retry value and the ADIN1300_LINKING_EN are in the same register.
> >
> > And the ADIN1300_DIAG_CLK_EN bit (13) is cleared, to disable the
> > diagnostics clock.
> >
> > Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

So, then re-send for this or just this patch ping?
Naturally, this is for net-next.
I don't mind doing either way.

Thanks
Alex

>
>     Andrew
