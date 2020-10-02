Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938E2281CCA
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgJBURt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:17:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725792AbgJBURt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:17:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601669867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EEUOwZ0tWV1logok69UsC+MxMC9OHL/Bwty2qonClRw=;
        b=NkCWONlzobPHP6gYsx4eom4HRv+Z3F8uV8WtGh6lopLgvYDI2xZY80CTwW5b8McDU+Wu1R
        DaRO1e4m3z2RCR9E0S8fHqhXXG4TF86VMBT4gzmcj8YkMfd1ZTnDEhqUugFaotgkqEfR4x
        xNx23/qf4ndwflHpNuxs4sAonTBHFME=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-z5IqJTPyNw6TxVwolxrRyg-1; Fri, 02 Oct 2020 16:17:46 -0400
X-MC-Unique: z5IqJTPyNw6TxVwolxrRyg-1
Received: by mail-oo1-f72.google.com with SMTP id n19so1237329oof.4
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 13:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EEUOwZ0tWV1logok69UsC+MxMC9OHL/Bwty2qonClRw=;
        b=HKu2kqtuCU9km8+mlhxm/2CIatgzVqPNE8PRdIJgHEncti1RytwrMO1Czst9yCg0lP
         lYLBZ/dAeljvDiboWfbFtMDqUDJ8hlGzZ1J/TNHvqZYFd6GmbG9EFQ3fopt/X2ik1nM0
         BqeTVHUs1jy4N5CXXJmPIdb+ZJU24bIbgloJvbaNP1FL1y2p6ip6ft/Zx4f/0cSVE8Gz
         ikbn3TCR/Zw3Egl6LoZlZbe/cEteHf68YDjSTtY5nHNO59YSdVMA8Kug7P+guk/lRIe7
         Ex/POOBBV3/7tbwsWGa6pJDzA2Tlu/nAn2Se9GYfDtKCA6uVTP1HOBNrm3TdLZ32OX4c
         5HRQ==
X-Gm-Message-State: AOAM533ltZ/7QHvu5hO+3Kt8EfAT+OiH9Bn1hzGXEiR4GdO2Cptk4guU
        4tNDnDrErI5i9h6hMlfNMOoJ66towVAIV8gfvY8d4OPmzPftcoczPVXfMGGmF0/lIYibccHkDBc
        gEX0uUf9sSzHa0R1/rNCDwU8xFYOHTVaq
X-Received: by 2002:aca:4e06:: with SMTP id c6mr489537oib.120.1601669865239;
        Fri, 02 Oct 2020 13:17:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvdS35Ea37ROGo1fYbebLRZH1ABdflntD5YaM5bNZwtZgSOpxbSaOedhxZbd0qqjj2olyqKx8Kqwb0YkeFG3s=
X-Received: by 2002:aca:4e06:: with SMTP id c6mr489527oib.120.1601669865016;
 Fri, 02 Oct 2020 13:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201002174001.3012643-1-jarod@redhat.com> <20201002174001.3012643-6-jarod@redhat.com>
 <20201002180906.GG3996795@lunn.ch>
In-Reply-To: <20201002180906.GG3996795@lunn.ch>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Fri, 2 Oct 2020 16:17:34 -0400
Message-ID: <CAKfmpSd00=ryeznA3ubfMCmeiFAeo-jQhvT3fAgwJqbDEL7w_w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/6] bonding: update Documentation for
 port/bond terminology
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 2:09 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Oct 02, 2020 at 01:40:00PM -0400, Jarod Wilson wrote:
> > Point users to the new interface names instead of the old ones, where
> > appropriate. Userspace bits referenced still include use of master/slave,
> > but those can't be altered until userspace changes too, ideally after
> > these changes propagate to the community at large.
> >
> > Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> > Cc: Veaceslav Falico <vfalico@gmail.com>
> > Cc: Andy Gospodarek <andy@greyhouse.net>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Thomas Davis <tadavis@lbl.gov>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > ---
> >  Documentation/networking/bonding.rst | 440 +++++++++++++--------------
> >  1 file changed, 220 insertions(+), 220 deletions(-)
> >
> > diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> > index adc314639085..f4c4f0fae83b 100644
> > --- a/Documentation/networking/bonding.rst
> > +++ b/Documentation/networking/bonding.rst
> > @@ -167,22 +167,22 @@ or, for backwards compatibility, the option value.  E.g.,
> >
> >  The parameters are as follows:
> >
> > -active_slave
> > +active_port
>
> Hi Jarod
>
> It is going to take quite a while before all distributions user space
> gets updated. So todays API is going to live on for a few
> years. People are going to be search the documentation using the terms
> their user space uses, which are going to be todays terms, not the new
> ones you are introducing here. For that to work, i think you are going
> to have to introduce a table listing todays names and the new names
> you are adding, so search engines have some chance of finding this
> document, and readers have some clue as to how to translate from what
> their user space is using to the terms used in the document.

Hm. Would a simple blurb describing the when the changes were made and
why at the top of bonding.rst be sufficient? And then would the rest
of the doc remain as-is (old master/slave language), or with
terminology conversions?

-- 
Jarod Wilson
jarod@redhat.com

