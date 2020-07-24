Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CAD22CF32
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 22:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgGXUMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 16:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgGXUMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 16:12:31 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB052C0619D3;
        Fri, 24 Jul 2020 13:12:31 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so5998881pgq.1;
        Fri, 24 Jul 2020 13:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EjQZfJPvrEhOrgi5StMMr7gYrhKuKg6ktfwJiCk7lLY=;
        b=frk+u3/ZKFyP46C3xYdGaqUBLIHK3it67RtUUx66M41w0hRUsoIufyKmumEE83df8r
         2Cmk/cd/BQ64rvqWOO6iBC/NJV0c1fcUTq2dwrjDOcovdeUOIWtOx0cNpBYOYJinT6TP
         +ZZF5jnPYWJcd0s8L2dBvAeKwDzltirTRk1Y6q/1mIdMXbMV5FFkSAu2fNtgUUWZm5gv
         eSCiYJEMPLCFIz7adD1lxFnbXizvuEbYhA/7b15do5RkBzgoEbBJLk3eZthmXgUEl+gm
         BaYc9314/ueQ/yPSIBlSqaVgEg7WHNl19eAKXup8NmnAq3Eq6LcDq4YT3TvVmFKIBoSX
         B4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EjQZfJPvrEhOrgi5StMMr7gYrhKuKg6ktfwJiCk7lLY=;
        b=pYeY7Qsl71fv1auFnrv6OmbFLrYI5XN391IjttZPBvAOhwBRAZG8MXLI3h9ME6ywqo
         ML53ISiwQmvXK/dapMxy+66scvodN+93s3O1NyJsLCWD1AbsDUwdYsp9Bsdsdah+/+3t
         Zzm49Db5Aoq6FDX94rMbQbblCYoyLniXZCU+lC1MkO1SGA+WVV2PjWyfac+8CIBzw/Kc
         e2u8H4uNrmK+ucALCAYwjSS/hHB5nEhHjEtVH7axX9sQemX8sHIvUFXO4F7i6Yi0EuAq
         U1CycuiAssUGmlCb/4qV4oL8M1LCvght4xoYBQCnqyJ+lqM2ocY/0Z+HalOdWM6kgjdn
         /mow==
X-Gm-Message-State: AOAM533t0yppiZaAhdmvIQz9hGnPKaXzhAFG0AVNCpGEVsYqB0a8yDcg
        8qDdQREBEVjEXjPY4I2vsMNlHLytuxgasD5tph7/JXth
X-Google-Smtp-Source: ABdhPJwJAAxB5seehmqilD3u7UYLaPX4caecXVXLy4YwHyMz3rDJCNB31NqTIRMm+dZX+wb9adiTP+HtlVjAZfthANY=
X-Received: by 2002:aa7:8bcb:: with SMTP id s11mr10096246pfd.170.1595621551288;
 Fri, 24 Jul 2020 13:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch> <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <a95f8e07-176b-7f22-1217-466205fa22e7@gmail.com> <20200724192008.GI1594328@lunn.ch>
In-Reply-To: <20200724192008.GI1594328@lunn.ch>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 24 Jul 2020 23:12:15 +0300
Message-ID: <CAHp75VdsGsTNc-SYRbM6-HHXSoDdLTqBrvJwyugjUR6HTxwDyA@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 10:20 PM Andrew Lunn <andrew@lunn.ch> wrote:

> I think we need to NACK all attempts to add ACPI support to phylib and
> phylink until an authoritative ACPI Linux maintainer makes an
> appearance and actively steers the work. And not just this patchset,
> but all patchsets in the networking domain which have an ACPI
> component.

It's funny, since I see ACPI mailing list and none of the maintainers
in the Cc here...
I'm not sure they pay attention to some (noise-like?) activity which
(from their perspective) happens on unrelated lists.


-- 
With Best Regards,
Andy Shevchenko
