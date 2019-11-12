Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F515F956A
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLQSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:18:41 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34858 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLQSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 11:18:40 -0500
Received: by mail-ed1-f68.google.com with SMTP id r16so15414464edq.2
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 08:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1bjYfSS1LooZ1uXlHRIsjbM5+j3zgaXcgIqqFt5wzAw=;
        b=m9JPYNYZHLeRLsQShF0N2wQL0BDntGaemXucwi2gI6EwS2uKIek5gL8LoKJimbwLv1
         6DJm7ZRRVeSMfq9tUbn8DzY0Pz4BmMqMy1s0KWAeWdofScxJQxyxSjdSPaFlGoR2hfdX
         B3DlHm9nPq9lZK7LNmj3iEOEgMr8VGvoX6rK5PKOjP/s4UtCeGLgUMNov3ElAt5HFgHV
         SVEq5AH8oekLgmU991w4ynvl1Erw9hE2Ymmo1A/758v3t+uykZiFtvKrlDdIQWZqjGUA
         C4tkFWcOmZcolLrt27UvPTGsrXHIaMMdGaaj4PDxXT/KKqCDOedwP7EHpQjDbXpCLnLz
         U1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1bjYfSS1LooZ1uXlHRIsjbM5+j3zgaXcgIqqFt5wzAw=;
        b=eLtAXfNxfNn3ovIDJXbWQ0QInSl8n+ImZjVsnXK/Tlfm0P3hslHsr+WF4XB8SHcfdH
         WOLo11bfy4Kp3QT+QFGE4zocNK42PmlTVo23pCAtyVwlsX3c85jvqEJ4ErkV6wnsbsgD
         LEmm3RfCHnNteqWvB+S57/3on+8xeBv1o+gKztr2ce6laeckeiC7HknwEQHh0S2d3bcF
         jqmYG1al4zPM9QIVybigiu3ic0mw90Vr40KDh1CqIy3VcwOFDT0c4/H4C8wUUvtQCoP/
         w89o9TdWR327Mun9PTbNt6YylbSimxV3iDi/l0IBW8TNTgVZAkmOZ6CGDhrS5vMHHqc3
         RmrA==
X-Gm-Message-State: APjAAAX9QUWr9Kkwe0plyaGrcEKy9hwDxtiijdHaBt7YGxVsJtR0XNYZ
        Yfdy/qWMPVkTPsAa+Flb7/jeTv30QqWKxltGd8s=
X-Google-Smtp-Source: APXvYqyi0NUIpewtqhKNBLjtQy3ZtVbCn6q9J4mT0nZdK5BQ6TneU2aTfWZE37283c9WhVogD7CCf4Y1vo8bhPU4Tyw=
X-Received: by 2002:aa7:d44c:: with SMTP id q12mr33628091edr.108.1573575519179;
 Tue, 12 Nov 2019 08:18:39 -0800 (PST)
MIME-Version: 1.0
References: <20191112124420.6225-1-olteanv@gmail.com> <20191112124420.6225-9-olteanv@gmail.com>
 <20191112144251.GF10875@lunn.ch>
In-Reply-To: <20191112144251.GF10875@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 18:18:27 +0200
Message-ID: <CA+h21hpZMCRmw+sEPUeb_8TdxCcLNj16Uni-+bmA22+Sx5i1Sg@mail.gmail.com>
Subject: Re: [PATCH net-next 08/12] net: mscc: ocelot: publish structure
 definitions to include/soc/mscc/ocelot.h
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 16:42, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
>
> ..
>
> > +#else
> > +
> > +/* I/O */
> > +u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
> > +{
> > +     return 0;
> > +}
>
> These stubs are for when the core is missing? I don't think that makes
> sense. What use is a DSA or switchdev driver without the core? I would
> put in a hard dependency in the Kconfig, so the DSA driver can only be
> built when the core is available, and skip these stubs.
>
>       Andrew

Yes it doesn't make too much sense, I was on the fence about adding it
and then just decided to play on the safe side. I'll remove it.
