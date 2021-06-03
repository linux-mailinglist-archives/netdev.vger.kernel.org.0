Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F1B399D9B
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFCJWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCJWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 05:22:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06597C06174A;
        Thu,  3 Jun 2021 02:20:12 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v13so2555766ple.9;
        Thu, 03 Jun 2021 02:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BogpqCOUCey2alE1P/oF0fJr06ZHXOEm/gnc1w6+dGw=;
        b=oRq4uPqpjKfqi00/x+r3zKPWwxr092s9U9SMGSFhRN3tMhU6VpwA/k3BuOLdjBOYth
         nUdmcWhsL3mehyfF2ui2DjNB/mI4VaYkg78liLYLRHGhiBHKGXf0EhJXgMxT9Ynm7/s3
         h/itEZXAnWtKKKh1H7nrNNZtC4WDuXqcI3RxEYdWIXUanM6LnmHK8JudsQNNOyIH7l/L
         znjlrL4YISkmzjFKK3+B2NJekfTQzwlUFk1OTvcucs6RJ9BGS4+WCtU3Qt8tWr/iIz8Q
         J059fNeGhbAJplkqFoCYvapfHPII7AhJZkBZSHTDy+mZU7wRHHu0ivnA+fl25N3h2CH+
         ms0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BogpqCOUCey2alE1P/oF0fJr06ZHXOEm/gnc1w6+dGw=;
        b=D+RQm2iYTUI6BwxLuybOdYyRzbX3Yfo8cGDp746AsdMp8WtggX31k8KHRN8Vv9XawL
         KbPYpmy6YGUOMezmtzY8tp4gEcDWL6tP0cT2kIW00qEHhTk2KYbG+9sCqjGWn+i9IBAy
         slYlICHeYqjKRaYZRZgm0Ph7f5hwUk6ZibVxkFDEci3sseW9UCXznuh8+BQWMV86EnaI
         6h4o9vHd6qzzIS+0TEMJfqJCjEtSc7y01/o4GvM3cI6sMQd5Gs71IsZTaM6sCdqqjtLo
         DtW0UbdFxTZUEIgNfteobe6bKetKp9sj3FynSNDsd0XndEvqyjSyRLm+rZYHTshc+1qA
         /bRw==
X-Gm-Message-State: AOAM530do4dGstzZBpu0MF32blUGbF0lDtXgwM7rh4tY9Mk+beTns6Lr
        xO0Tmbx+btp2j4LCd3whZeCTMafB9EzoFUATXfsmMpM7ZCE=
X-Google-Smtp-Source: ABdhPJws9BMrj0ZBR0gjYZu9DoW0oS7QU5smzz6VfwvJ++cAaP6R3RpbO0mPZRKjcg0epixcuBLPxnoX2SUeUjiElKM=
X-Received: by 2002:a17:90a:af8b:: with SMTP id w11mr35557628pjq.228.1622712011449;
 Thu, 03 Jun 2021 02:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210531132226.47081-1-andriy.shevchenko@linux.intel.com> <5dd2a42d-b218-0b23-aa14-7e5681e0fb3a@datenfreihafen.org>
In-Reply-To: <5dd2a42d-b218-0b23-aa14-7e5681e0fb3a@datenfreihafen.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 3 Jun 2021 12:19:55 +0300
Message-ID: <CAHp75VdcFut0Tks3O=HJPLncebgDdfEv7Robm9ujG6yL+PT3OQ@mail.gmail.com>
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

On Thu, Jun 3, 2021 at 11:35 AM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
> On 31.05.21 15:22, Andy Shevchenko wrote:
> > Driver can be used in different environments and moreover, when compiled
> > with !OF, the compiler may issue a warning due to unused mrf24j40_of_match
> > variable. Hence drop unneeded of_match_ptr() call.
> >
> > While at it, update headers block to reflect above changes.

...

> I took the freedom to fix the typo in the subject line and add a better
> prefix:
>
> net: ieee802154: mrf24j40: Drop unneeded of_match_ptr()

Right, thanks!

> This patch has been applied to the wpan tree and will be
> part of the next pull request to net. Thanks!

Btw, which tree are you using for wpan development? I see one with 6
weeks old commits, is that the correct one?

-- 
With Best Regards,
Andy Shevchenko
