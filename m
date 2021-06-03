Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09ACE399DB6
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhFCJ2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:28:18 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:37634 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhFCJ2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 05:28:18 -0400
Received: by mail-pf1-f178.google.com with SMTP id y15so4446322pfl.4;
        Thu, 03 Jun 2021 02:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l4/ZEJJ31ozJEyCs+kGbSZH2zkdT9cJBOBcyJ9YhVcY=;
        b=Sk61fuP3Cd9J21TyhG6+KIXsm8Z6qdOrPdGOPCst9C9I6h6Gj3gjwAlGMMZjVUA16e
         2n7Jtg7iz64CBTrsmV3RTAODRQ/T0ETaHc1oksoyJxm1YjkFJd++AW9bTqmpG1p5fTMX
         er1lBxS7L/XSgLppQZOf172g0jqclN9pZS7ElDd1jf9cfYf80ycUQqPM/v/PRZzCRJaZ
         xK5R9I1oSvn9/WnbXTikoGtNl8gAFVrsG3JwU89GmM6iHQnbrhH86eJDELmbdVSm4Bvx
         UXqeGKriUVhDS2PYBs1eHL3r60fzl1oVMvy9ZfUAa+NXFiBA9uxOOPab3G7OWH9JMyAk
         TSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l4/ZEJJ31ozJEyCs+kGbSZH2zkdT9cJBOBcyJ9YhVcY=;
        b=GtVbf6g5+tgBOe8G9I0buURH+BeBcEIN7JFqVIPP1Erv7SLWMDvs+rQ2bNc4WnK4/+
         yBb1x3Kg2iPz+JmHXguLZfpan2ID6zT1GSYd8DEuu59Nswa4GNqP3bl3nKJ3poL7sBXo
         PgBChoLEKCUdi2arZqTzEEwC4vP4lx6wJMHp7Kz463z4yo82V40Ya7drLGv20YJWxAPy
         SaMlrqHPeeuk+otlIqizkOicGNk7VPBCAe8Q0Zy8beWyTGN5bOlXIjZGKb8va+518H+d
         92aqjhuuO+jCQEeJaXskXWAOSyFVC1sFQiGow+qhtevkeu5BHqgL9U6K+wvZQf3znr6Y
         TnjA==
X-Gm-Message-State: AOAM530PmjIgywtgCp6QOWFmRlNILcSbdTg9jP2wKT78hNZAYWl+cMsk
        I+XaMZQj6gimlIik/a4fMIZ5AuUDJLc0+8pBFRY=
X-Google-Smtp-Source: ABdhPJwGSZgtC7JFTyVTCDfWsj60TMbykpRhGWXOq27OyhFLx4mZrQNZb8Mlm4q7Z6T0Wn30p0THOj6LWxEqC3feclU=
X-Received: by 2002:a63:b507:: with SMTP id y7mr38636329pge.74.1622712318343;
 Thu, 03 Jun 2021 02:25:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210531132226.47081-1-andriy.shevchenko@linux.intel.com>
 <5dd2a42d-b218-0b23-aa14-7e5681e0fb3a@datenfreihafen.org> <CAHp75VdcFut0Tks3O=HJPLncebgDdfEv7Robm9ujG6yL+PT3OQ@mail.gmail.com>
 <bc7ad567-5dd4-3176-2b71-5dd36cc03875@datenfreihafen.org>
In-Reply-To: <bc7ad567-5dd4-3176-2b71-5dd36cc03875@datenfreihafen.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 3 Jun 2021 12:25:02 +0300
Message-ID: <CAHp75Vd76Xz1QCReedO=Fh09B34MViAcnDv2SwRsatWAdmgXPg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] mrf29j40: Drop unneeded of_match_ptr()
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wpan@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Ott <alan@signal11.us>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 12:23 PM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
> On 03.06.21 11:19, Andy Shevchenko wrote:
> > On Thu, Jun 3, 2021 at 11:35 AM Stefan Schmidt
> > <stefan@datenfreihafen.org> wrote:
> >> On 31.05.21 15:22, Andy Shevchenko wrote:
> >>> Driver can be used in different environments and moreover, when compiled
> >>> with !OF, the compiler may issue a warning due to unused mrf24j40_of_match
> >>> variable. Hence drop unneeded of_match_ptr() call.
> >>>
> >>> While at it, update headers block to reflect above changes.
> >
> > ...
> >
> >> I took the freedom to fix the typo in the subject line and add a better
> >> prefix:
> >>
> >> net: ieee802154: mrf24j40: Drop unneeded of_match_ptr()
> >
> > Right, thanks!
> >
> >> This patch has been applied to the wpan tree and will be
> >> part of the next pull request to net. Thanks!
> >
> > Btw, which tree are you using for wpan development? I see one with 6
> > weeks old commits, is that the correct one?
>
> I assume you mean this one:
> https://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git/

I think so.

> Its the correct one. I was a bit busy lately, but luckily ieee802154
> patches again net apply fine most of the time as well.
>
> I collected the piled up patches right now and will send a pull request
> after some testing later today. Once that is merged I will update my
> tree as well.

I see. Thanks for explaining your workflow.

-- 
With Best Regards,
Andy Shevchenko
