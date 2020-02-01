Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E215C14F973
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 19:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgBAScs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 13:32:48 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37446 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbgBAScs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 13:32:48 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so4143384plz.4;
        Sat, 01 Feb 2020 10:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=blF6V5alk7Jq+4TBtrqoD97Q5tLdXXilJ+9XsNdtvwA=;
        b=r4temlDuJ+IocrSNbznR1vDRdgbdVxEbVj/WCT55tgJDEV8v1SGw3hCDkXUGMrd7Na
         S6SWJXMl/IvH+EKQgOw1MasPqEpy4Q/tuEzYc5JW8p9SgTDEs862D3GKX7S1DotCbhQy
         04Wj4qz99I5bOTnyV1x0L9Y1bg1K4FT/88p6ZPa9+bMtgRO0FLLGo5SZ6G9epzsdCsD6
         NAKjDd/bybnfskWNSICBFxDbJhWyJFv8e34/zPCDozmYskiobKEUlXHJ1VDhGjYxns00
         x2EtJlcj7D01OSKZlv64rVv1LiORhfvBZGc5UQAJF2zKSRrhZMaNMbqe/POcFSUldtTk
         6ipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=blF6V5alk7Jq+4TBtrqoD97Q5tLdXXilJ+9XsNdtvwA=;
        b=Jo9/BDpJ/PJ36qYOnp81VhsaTI+GkNC+uOjON84VvDrtdyKwHm2rX7BG0Yr1I2CPD/
         pO9AOKn+72TyKQn9fvpzKFv/Oks+rByeqjnRWvtmzEm0jm9F3sZWGeSS4RFf77IKbZWD
         +ZYMWq/jyO78Y9eQSesk8vPl+5eOrNN2POUJUKm2Yw87F4ZNJewMMHWOXx0bIDb2fBGa
         sZTj4x+Xvfexic6oar9kaqaWBYSRhcZpO3QFF1NSE/PWNGL5s0QrAQPekHzjYoYnYCeb
         PKPf66dVvwqioIUN7NjVSH1/AnICmR9ifDFamhaQlpClRWMSdiCnxLDqLlZArY0gQw7S
         aQeQ==
X-Gm-Message-State: APjAAAW7/mVy39w5RU8uiN1b/algCs/reWX4F9IJCEzLGjaeWSsdfAMw
        7QqIgWMYkLBIByxlB6RbifPYYadpTw8b8I0nKhU=
X-Google-Smtp-Source: APXvYqyTK+mzHkNsFj2GnomGkQetY/mLfY/6pj9+IAdoYahCK1YkXrgElHPMTIlTQbpO+xewmCg8Sdy84eolmJft+ps=
X-Received: by 2002:a17:902:be05:: with SMTP id r5mr4881893pls.255.1580581966519;
 Sat, 01 Feb 2020 10:32:46 -0800 (PST)
MIME-Version: 1.0
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
 <CAHp75Veb1fUkKyJ1_q=iXq=aFqtFrGoVMzoCk15CGaqmARUB+w@mail.gmail.com> <alpine.DEB.2.21.2002011541360.24739@felia>
In-Reply-To: <alpine.DEB.2.21.2002011541360.24739@felia>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 1 Feb 2020 20:32:35 +0200
Message-ID: <CAHp75VeWPQhjfMK9i-Bzbyoc=h71PhHShf17HTE0eRF=eURM5g@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>, Arnd Bergmann <arnd@arndb.de>,
        "isdn4linux@listserv.isdn4linux.de" 
        <isdn4linux@listserv.isdn4linux.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 1, 2020 at 4:46 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> On Sat, 1 Feb 2020, Andy Shevchenko wrote:
> > On Saturday, February 1, 2020, Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:

> Interesting... I did not know about that script.
>
> On the current master and next-20200131, it reports:
>
> Odd non-pattern line 'Documentation/devicetree/bindings/media/ti,cal.yaml'
> for 'TI VPE/CAL DRIVERS' at ./scripts/parse-maintainers.pl line 147,
> <$file> line 16777.
>
> I will send a patch to the TI VPE/CAL DRIVERS maintainers to fix that as
> well.

There is a patch waiting:
https://lore.kernel.org/linux-media/20200128145828.74161-1-andriy.shevchenko@linux.intel.com/

-- 
With Best Regards,
Andy Shevchenko
