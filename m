Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C424F27D1B9
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgI2OrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbgI2OrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 10:47:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA14DC061755;
        Tue, 29 Sep 2020 07:47:13 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id fa1so2803033pjb.0;
        Tue, 29 Sep 2020 07:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xCMmRdFPuhN2qImnWBsCU86bREiBavbtCu5EdzwVSCE=;
        b=JiiXv2Bgn5TNtu2w/e5ZrB4zgj27KckVM9iWpkA+8qmC1uA7tLYcfMT82ua1YK+9Vh
         8CiQoNXUKYTYmpiP2litlSYoeGy5nH77c1KzsFgsM3gmbcbDOaUC6NCjNbFACCGlDcwo
         1xaB4i0vC/LT15cbQyNPG9cpL4ynQyOlxKpiJGUSCjwTgZdnyRVHwPjCjUsaRvrRBz/8
         cmMrjdFiY6QSLsl2zgFdpyruD42PaeWKMEAmD+oOJtCfxScty9KPCQc6gsgDKtaBzDi7
         JymDu6vE+NIFFf6Vrf6IF1wC+EBYsiLKiM7eSBUluaKhGNZXMTqrSNj9EvIZ7Tyyn2Ty
         NRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xCMmRdFPuhN2qImnWBsCU86bREiBavbtCu5EdzwVSCE=;
        b=NZIWbc4nuSN2MLmBdxCTS2e78YH8fthM+YIi2JqhZiW1f4KMzE0Kq0dmYa8JOtUlZB
         jGAjjf50cVTJ893OyN40FQqknfAIw3SXzcRPYjTginuhFF1bhiFiSJfiu4rBqh5qYAGh
         ehpY0OMiIOT3uG8XLU/5oL53ZLF/7tGDCEvyT/QchXG5mq0SfYM3JCkYrEcoBACwcdKS
         X3g2TGymJIvhmFk6avkdA1khJpSw2dcTHgUr002CxgtPmsh+wGt5OkFt5UY6GYAEojjR
         hb54pjhQK01NdhsGgs7slOz2URrWAgTp4E1qA9wdJhf3Vjavf7DGxbLXrzqxgygIKRBU
         XMrg==
X-Gm-Message-State: AOAM532OG81VHTrktgYSYbCiFfCeTfeUuAONXYhHUnqmawRp8kFXeJs9
        K3Gb2laB/kcq6yXrFF45b90E4V1KJ9KxOuyuOHnOsghD06Dib50D
X-Google-Smtp-Source: ABdhPJyDon13aMP1KKu2EvXSDEjOrc59ekWTClm4T+KL5BtUJ0bBZ+zGJBCvotQqHs7M6oblVqax3kS2vU+4qFRZXnk=
X-Received: by 2002:a17:90a:b387:: with SMTP id e7mr4384202pjr.228.1601390833171;
 Tue, 29 Sep 2020 07:47:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com> <20200929134302.GF3950513@lunn.ch>
 <CAHp75VcMbNqizMnwz_SwBEs=yPG0+uL38C0XeS7r_RqFREj7zQ@mail.gmail.com> <20200929143239.GI3950513@lunn.ch>
In-Reply-To: <20200929143239.GI3950513@lunn.ch>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 29 Sep 2020 17:46:53 +0300
Message-ID: <CAHp75VfjOBDpuY_df1wdxUUfFQV_t_k2PjrwHjd0dvE3jojZ=w@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 5:32 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Sep 29, 2020 at 04:55:40PM +0300, Andy Shevchenko wrote:
> > On Tue, Sep 29, 2020 at 4:43 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > On Tue, Sep 29, 2020 at 10:47:03AM +0530, Calvin Johnson wrote:
> > > > On Fri, Sep 25, 2020 at 02:34:21PM +0100, Grant Likely wrote:
> >
> > ...
> >
> > > Newbie ACPI question: Does ACPI even support big endian CPUs, given
> > > its x86 origins?
> >
> > I understand the newbie part, but can you elaborate what did you mean
> > under 'support'?
> > To me it sounds like 'network stack was developed for BE CPUs, does it
> > support LE ones?'
>
> Does ACPI define the endianness of its tables? Is it written in the
> standard that they should be little endian?

5.2:
"All numeric values in ACPI-defined tables, blocks, and structures are
always encoded in little endian
format. Signature values are stored as fixed-length strings."

>  Does Tianocore, or any
> other implementations, have the needed le32_to_cpu() calls so that
> they can boot on a big endian CPU?

Not of my knowledge.

> Does it have a standardized way of
> saying a device is big endian, swap words around if appropriate when
> doing IO?

I guess this is not applicable to ACPI. Does Linux have a standardized way?
So, what did you mean under doing I/O? I mean in which context?

> Is it feasible to boot an ARM system big endian?

Not an ARM guy.

> Can i boot the same
> system little endian? The CPU should be able to do it, but are the
> needed things in the ACPI specification and implementation to allow
> it?

-- 
With Best Regards,
Andy Shevchenko
