Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027CB7AA6F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfG3OAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:00:45 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:35853 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbfG3OAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:00:44 -0400
Received: by mail-lf1-f44.google.com with SMTP id q26so44828250lfc.3;
        Tue, 30 Jul 2019 07:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bMy8+dulgQaBaijk1anMSQXHRDRkHWnBbw4vTm4odwg=;
        b=Pyq1/qjpp/VnceAmo91bY/5v35EmOlekZhGI+oMmsRxIqAvoPOD9Yo9OcSVVpWZHEf
         FMlqCrRAqSHFqN4Z4iSYPrN+f/ZqNM8iF8BXhr0ww6CrQsPfdzmmBSkR7kQD6I9IMXv8
         htF1xk2D3gMHeIBwHvfAjSs4ntFv5oY54sHfkucZjV1TESC3ZFlcJJvy+SwMqiFo7WI7
         5X87VF5aZLU/nMHMROQ5kcu2yaIR/kj96yVG9ggOS82VIpPeW+Qfh4HdsTN3w9JPBXt7
         quVkv+Div03d37lxJwvUbgHTjWRUaHOcEvKxoUGdqZv3wubjk8xv+qf5LKf95RjpyuCU
         jN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bMy8+dulgQaBaijk1anMSQXHRDRkHWnBbw4vTm4odwg=;
        b=O5jNJJ3eTBkPmFD0h5l69icm6IZAPvGzAjv0B3Ah5Vbvw3Uu5N8v1bT2C68jeHidor
         Tdw/a2F4trFkjU4YZKxGdm79okK9LNxs/nhprLSABJPk0OPi9r2NTCmoCiV1QZwrhY0Q
         3ilhBTeqJY8iwXEnQyRjJfAkRZNGqqgYHG6PRYpcactjIGeGLN4BzT7TACIpmR193tOW
         i0H2u7BuXxtwg8ETmu6YizXn4r/ShbhvYpA3XKQGcEb0FaYHwwUJf8NiS9348uQ1Xexl
         WiUGS4oMxt2YxUYB8tOGJ0A/lvAgFItDccMuuMKHSSie7NPT9UeflcR2o0Am+F5Te+yQ
         ZieA==
X-Gm-Message-State: APjAAAXi5lqnRzdKkI7q0hLv57F1ZhUOwzqsUYYAAHk7jIVNw1UVo25c
        IvzQOylZEoQiELUhmpBP4CWq2XC018elfZdQ/tE=
X-Google-Smtp-Source: APXvYqwFxU2aJZupq15tPMGGPhkUeiRbVX/Ny/AeH8PilgWZ6eMHMSsYLghdUHcVU7IvMo2OXna8FsoXwIfybTJwoN4=
X-Received: by 2002:ac2:5382:: with SMTP id g2mr53150361lfh.92.1564495242574;
 Tue, 30 Jul 2019 07:00:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190730100429.32479-1-h.feurstein@gmail.com> <20190730100429.32479-2-h.feurstein@gmail.com>
 <20190730134924.GH28552@lunn.ch>
In-Reply-To: <20190730134924.GH28552@lunn.ch>
From:   Hubert Feurstein <h.feurstein@gmail.com>
Date:   Tue, 30 Jul 2019 16:00:31 +0200
Message-ID: <CAFfN3gX3RMoe7_2EpoCtzO+gHTOxoH9j2WB7ZxuE6FKgPXK1fw@mail.gmail.com>
Subject: Re: [PATCH 1/4] net: dsa: mv88e6xxx: add support for MV88E6220
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

[...]
> Do the registers for the ports exist?
Yes, they do and they return sane values.

> > +     [MV88E6220] = {
> > +             .prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6220,
> > +             .family = MV88E6XXX_FAMILY_6250,
> > +             .name = "Marvell 88E6220",
> > +             .num_databases = 64,
> > +
> > +             /* Ports 2-4 are not routed to pins
> > +              * => usable ports 0, 1, 5, 6
> > +              */
> > +             .num_ports = 7,
>
> I'm wondering if we should add something like
>
>                 .invalid_port_mask = BIT(2) | BIT(3) | BIT(4)
>
Would make sense. I'll add it to the next series.

>
> and
>
>         /* Setup Switch Port Registers */
>         for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
> +               if (chip->info->invalid_port_mask & BIT(i) &&
> +                   !dsa_is_unused_port(ds, i))
> +                   return -EINVAL;
>                 if (dsa_is_unused_port(ds, i)) {
>                         err = mv88e6xxx_port_set_state(chip, i,
>                                                        BR_STATE_DISABLED);
>
>         Andrew

Hubert
