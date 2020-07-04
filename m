Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40B4214587
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 13:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgGDLlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 07:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgGDLlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 07:41:11 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B528C061794;
        Sat,  4 Jul 2020 04:41:11 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j19so9367253pgm.11;
        Sat, 04 Jul 2020 04:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=73HK164+x5FAxaDbC4Zvcu41NPAm1TqUuRv2JoFu+h4=;
        b=VY6yfc0HXQk+XYGXORLDWV/ESqqDcoZ2BUmV4VxB22eeUJ3ZppfrRXbKoxXLk4nWLn
         lrmx+/YTTd5fySmVtnxgCjCgkvo/Yo7x7ZvY1KUIR560VUDZVrPgYCXrPzMUw+rxTm1F
         FIuI9TP43DDz/uCCBkwYpO7u2ue3waqxp76oswJEadMA+C0/D/JRzxh3OXQnmIcrQpNG
         J5fwkTsYkmXlO5Bg6MC1guYeDqabmOBRzYGMDO5FjNDxIif3kAtMCPCQS8fUHNlPmbf+
         ztV4MOeAFwji67KuP+Bgm64UoowS//twc0klMCOGUQnoKujmwqemqoxhzF2si8Lev7GQ
         737A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=73HK164+x5FAxaDbC4Zvcu41NPAm1TqUuRv2JoFu+h4=;
        b=Y/8pWtr2m+edCfRLd1bzaQZ/wlBhYXDlixn7QP6ed3v/BXcq66z6pKr4+edVcY/Hwb
         GhLlaFg06QRmFjds9Jf5XIm0dmiNqKV70kxOFAi/UEYfKn8zPIQg5uf0fcePPWwDxcJs
         kQleW42a4TCAyZPWyS49hlHPRkrOS6/DEAC4Z6JZHrp33XaphqK8M8k0BGTy+k6YKVRp
         YeRO2H9oWgp6A28TUwe8fwffFP5GMQBgkTf7mOHigfCxW61EEdyMU2HKr4X/O50R0o09
         LpdHc1WlXNH6ZxWAb1sIAeMQh+92rVAA498beiwkXEbDu/1d+XJLkeF9P6ZCaefLLzqo
         VqAA==
X-Gm-Message-State: AOAM533+iGeKtcOAe/TX68xSjVHfcNdjy1OZ3brN9vE6Ram5xj8TS2GU
        +e2Xt1KFZk1MsSRUxfiHF211bYRuX71/sjOF6PHX+iXW
X-Google-Smtp-Source: ABdhPJzkBH27R+83QkLBn2fxgsGgG6b3CuuR6qdE98+6TJshy2GA2eAs7Gxu3/Rmi3QMLIYwxJssYTTAdHwERACETaA=
X-Received: by 2002:a63:ce41:: with SMTP id r1mr9300128pgi.203.1593862870758;
 Sat, 04 Jul 2020 04:41:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
 <20200701061233.31120-3-calvin.johnson@oss.nxp.com> <CAHp75VfxpogiUhiwGDaj3wT5BN7U4s9coMd3Rw10zX=sxSn6Lg@mail.gmail.com>
 <20200703113550.GA16676@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20200703113550.GA16676@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 4 Jul 2020 14:40:54 +0300
Message-ID: <CAHp75VfVO0vw3N18m5-9twPVTJVRd2cWQRmV3A37oCWmwJe8Pw@mail.gmail.com>
Subject: Re: [net-next PATCH v2 2/3] Documentation: ACPI: DSD: Document MDIO PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 2:36 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Wed, Jul 01, 2020 at 01:27:43PM +0300, Andy Shevchenko wrote:
> > On Wed, Jul 1, 2020 at 9:13 AM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:

...

> > > +                    Package (2) {"mdio-handle", Package (){\_SB.MDI0}}
> >
> > Reference as a package? Hmm... Is it really possible to have more than
> > one handle here?
>
> I didn't get your question here.

> But if it is about the reference as a package. We've other similar examples.
> One of them here:
> https://github.com/tianocore/edk2-platforms/blob/master/Silicon/Hisilicon/Hi1610/Hi1610AcpiTables/Dsdt/D03Hns.asl#L581

Thanks for this. It's not the line I was looking for, but I found
another example that answers my question, i.o.w. you may have several
references in one property.

-- 
With Best Regards,
Andy Shevchenko
