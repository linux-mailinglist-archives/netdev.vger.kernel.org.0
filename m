Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B297225C580
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgICPfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgICPfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 11:35:52 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F70C061244;
        Thu,  3 Sep 2020 08:35:52 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p37so2442019pgl.3;
        Thu, 03 Sep 2020 08:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dGY7hs5cfgBT9KAfFf+SDGAzVg53J8xbuNflx2RbbMI=;
        b=tcVvXI2IMkSj2iECOiY04GisiyBFCXXMXcHeXn1F3pDysU8yU5gr1Ozzz5bVnqOXjN
         Fh8xESkYnfzRQ1hf9bPKhBFJwhOg2M5mgBi03LGHMPMJSHZytHfXPnAONPiaAlK59wCn
         xuP7SGcvuNS6stZTjXx3VOalCGvDo+/kjjeroCl5YMMB+7wjSQ8eQA311ZYP2NFjPVzx
         G72qePOjkgsRw6NlTh6RNt+sCy4QqDxxF+4anLPGm+QYQyzYNSs7fOHGk9kHMliZSeGK
         TkRzBYtAOH0qTiZtpZBpW0TMXwiloDssSAZlbOFiV+/9FkfDIm2Rs8/bfDA7+RDjGqCA
         qhaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dGY7hs5cfgBT9KAfFf+SDGAzVg53J8xbuNflx2RbbMI=;
        b=QoHylULY3rVjqsUlJZ9Y0rSpZiudCa8qpFeNJLzcR9gdaTOhimSe5t3jXOAVXqRIWa
         0P0O3dYurQBrB6butc4WPBsd6JkDjwDwfzzW7gzvv8gD43kNW7K69crajtyaa7ZDGqLE
         J4CV4RzWcvd9fV7Ym9nAmv6R7UR4SdyZ8LTQGwMZ3M/bE6icn2nghtjSorHR3uX6ngfl
         50Rt/feggGi4tJxINiCkUHRoG0CsayLTQpZVAQnDi48K2cs4c4TVkSC7/ENy2vLVdQNL
         Kbtxwujat7jgw514YT2EkVuynTSuXMpDXxNtubV8j1+6xcmSdSykFCr2Q5c2gPBBDxTr
         5vOw==
X-Gm-Message-State: AOAM530Opg3/NMN3rzPXoCmN4AWnTnPd1i3TAuuB6jLbokVHncnFrp/s
        a4fF8X/MYpZlHQRPO5zfcFd+dNJZEIIrfb/kHkKyYOl5lqN+wiw8
X-Google-Smtp-Source: ABdhPJwDybWElbO0XCzQwfjoJ05bAOdoZDBKiX0vvFFdHObiFFUsMI/h6NPVkUvOpOqeD9PkVhXVneMU3Lhyag5xxjc=
X-Received: by 2002:a63:c543:: with SMTP id g3mr3490616pgd.203.1599147351884;
 Thu, 03 Sep 2020 08:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200902150442.2779-1-vadym.kochan@plvision.eu>
 <20200902150442.2779-2-vadym.kochan@plvision.eu> <CA+FuTSfMRhEZ5c2CWaN_F3ASDgvV7eQ4q6zVuY-FvgLqsqYecw@mail.gmail.com>
In-Reply-To: <CA+FuTSfMRhEZ5c2CWaN_F3ASDgvV7eQ4q6zVuY-FvgLqsqYecw@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 3 Sep 2020 18:35:34 +0300
Message-ID: <CAHp75VcmPnmgxgE+NCTN71Wq17LQjjx8cJOR34AmuLuRFQ4cRg@mail.gmail.com>
Subject: Re: [PATCH net v6 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 6:23 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
> On Wed, Sep 2, 2020 at 5:37 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:

...

> > +static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
> > +{
> > +       if (!is_valid_ether_addr(addr))
> > +               return -EADDRNOTAVAIL;
> > +
> > +       if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))
>
> Why ETH_ALEN - 1?

We even have a lot of helpers specifically for ethernet MACs.
Starting from [1] till almost the end of the file. Here [2] can be
used (or its unaligned counterpart).

[1]: https://elixir.bootlin.com/linux/latest/source/include/linux/etherdevice.h#L67
[2]: https://elixir.bootlin.com/linux/latest/source/include/linux/etherdevice.h#L67

> > +               return -EINVAL;
> > +
> > +       return 0;
> > +}

> > +       memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
>
> Is addr_len ever not ETH_ALEN for this device?

And if it is ETH_ALEN, here is [3].
[3]: https://elixir.bootlin.com/linux/latest/source/include/linux/etherdevice.h#L287

-- 
With Best Regards,
Andy Shevchenko
