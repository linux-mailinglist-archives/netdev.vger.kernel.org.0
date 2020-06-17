Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C85E1FD3CC
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgFQRyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQRyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:54:36 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D59FC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:54:36 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e9so1642926pgo.9
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E3PsfAdT3o7M2lfT+L5thTPFgm5OSAGPLobmbmlTJOw=;
        b=XEhx3FKiMPYzTQnoy01N2dXxP+bv7YUq9qfgy3hZkStFXRbWAgiH2Whv1x6dy1wY1+
         r9KgxB2iHHkyPOQ3FIEfdUoPj3pbQ4QYIvD/560+jIq9P8DYDDGcmWAOfRvtuD6+1Ziy
         xeZ3Y1GMHTUHuYKSmYjtuBeFDL6wu2Sxm/jPZB83771xBhaTMDVzMrsF8R/N+qDygp9J
         yWIHcRYyyVMxi/jjAOeLimEEyddgytyc1Nf+jypDnSZjbHaCOP0XiwgladOT4x3NNHi6
         0oxfBEyj47gy+ycXVS/DGuv9Q0KBMxDxoaioLWEVntQXLIdKvEJ0fkpaLerr0v+eoI4r
         DW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E3PsfAdT3o7M2lfT+L5thTPFgm5OSAGPLobmbmlTJOw=;
        b=kih2LbWWQl05LSngkYop/WdrBJitJy5g9Q0QVuOxJTsGfud3BalcwzS9Ts1V7dcAQS
         YIJQW9OOZiOpypr/5p1V02t6DNU1yQTvfdgnQ/WATgXAkNcRbdSp8ap4mj19zg/Uqpep
         wktI3cMe6Uw+CC9PZ3TCIc/DdGDHdNnJ8pU2w6G7rqN8HcmHaldRYsrT0KD9Gtr2Xqzd
         z9/qcD6ndCSwTXIrf2cxzHz+tEflJbC8GFt0lOSAOUVzSwHd0OB+BRJixYv4fTnCshCu
         JVE1f3FspdIRAtyRinq4Vn+r/W2TnhX2rp9F7jC+UPUtatoEMnVOqEgfmeXNQlcBAek0
         9DDQ==
X-Gm-Message-State: AOAM531f4H7ytzssh7pYg608uRVQp6oewDCWNC08ruMwrvOeJizm4Rrg
        4rVVNpr+FyRjSLFLbQXrODnbIOgvd5/ttCd4nEE=
X-Google-Smtp-Source: ABdhPJwZr6I/64QGOpTw/PTSvDEaPMbc9ZpNhzHgCszoYOCuaIHbShv5OtYvvNo8peC3dov/U2MMjHaCGua89EDQYz8=
X-Received: by 2002:a62:3103:: with SMTP id x3mr7580815pfx.130.1592416475364;
 Wed, 17 Jun 2020 10:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-3-calvin.johnson@oss.nxp.com> <20200617174930.GU1551@shell.armlinux.org.uk>
In-Reply-To: <20200617174930.GU1551@shell.armlinux.org.uk>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 17 Jun 2020 20:54:23 +0300
Message-ID: <CAHp75VeP_+2wJUyMThNs6_AbbbVa8qV6KrLDbXD5BYiOkp13qg@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 8:49 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
> On Wed, Jun 17, 2020 at 10:45:34PM +0530, Calvin Johnson wrote:

...

> > -     ret = of_address_to_resource(np, 0, &res);
> > -     if (ret) {
> > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +     if (!res) {
> >               dev_err(&pdev->dev, "could not obtain address\n");
> > -             return ret;
> > +             return -EINVAL;
> >       }
>
> I think, as you're completely rewriting the resource handling, it would
> be a good idea to switch over to using devm_* stuff here.
>
>         void __iomem *regs;
>
>         regs = devm_platform_ioremap_resource(pdev, 0);
>         if (IS_ERR(regs))
{
>                 dev_err(&pdev->dev, "could not map resource: %pe\n",
>                         regs);

And just in case, this message is dup. The API has few of them
depending on the error conditions.

>                 return PTR_ERR(regs);
>         }


-- 
With Best Regards,
Andy Shevchenko
