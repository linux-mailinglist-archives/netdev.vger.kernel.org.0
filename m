Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E021085E2
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 01:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfKYAKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 19:10:04 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41761 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfKYAKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 19:10:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id t8so5557625plr.8
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 16:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JgZnwZeBR/Y89F+hyutv5KMqnorFmVJ+r4V4LZ05jDA=;
        b=xi7diBAk0sfzHcj4bk1glp40O9a1WY71PCyClwGU8HVovJHtHhekMHz/O9v7DDPliQ
         DY+K2mSbOOouGcdZsxBDUFz5bnOiQanZ2JAjBsxKTwB+MWnEXwpl2oDS2/IBYkdgHTeA
         w/LJPqFMC3jeIdmdMLkQROpLsIEB+GUV0pi0qwTivPh/a2v8sEwBiGyl78flC8ImXyrs
         Z7fBAKYKLSCAGYa+mNRVE+vkxaAc2O/PBRmMUlQ9ovEWF+gPGKuWJuv6bBopzE04CXW7
         oaL0hxDU7RA5yCnU63jtGS8+7SVG8WrHafJVq3ZTBymkgbu50yED5ZjZWCixKWCK77Sh
         h9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JgZnwZeBR/Y89F+hyutv5KMqnorFmVJ+r4V4LZ05jDA=;
        b=TGe1xqI7IZxgP5UH6truG8lbEEOzu+hX3wp1gw0X8Qmlq9bBs2y8u1CdxmGkzwzXig
         HXYh2wA2U3F/yWQmlN+M1/36IttgNz2Ahp4lDupzZpj+C6cqs4W4/5o1nmOUm+JUJbMH
         fFWXy+tVncODBsG+DjYeaBkkNnED2g68ddfS87MXbm4/ZBxqlCAhEs5MirOQKhbi534z
         JJU8PVMwQTmL+TNZMPr4V6vqUrzFzT87UhbEJHXuNYvY2thncSapQJz58OGjOWGaFkMn
         e6hgT+/Ti9rwUheTT6ZbejXOLRrxXqJnRv8GbRdKUWsCJ4HQZxfPH2T2NjLh1Fz0Ao6i
         Ez8w==
X-Gm-Message-State: APjAAAV7IaY2o+Jyz6lC9QefE0IpODpa0Jw2zzLfTZcD5GpfA1RcYsCM
        wNRasGvEoO6pbRQMhiBzIYaXcghXmU4=
X-Google-Smtp-Source: APXvYqy9A6ELAcDtYfsu0JWvPE8Rq4RF/8GKFcQLQfYn1KDLbsUFVA08Rnx/7wjhbCnosBg8bygH6g==
X-Received: by 2002:a17:902:ba82:: with SMTP id k2mr26231891pls.238.1574640601675;
        Sun, 24 Nov 2019 16:10:01 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id l13sm5540311pjq.18.2019.11.24.16.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 16:10:01 -0800 (PST)
Date:   Sun, 24 Nov 2019 16:09:55 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: Fix a documentation bug wrt.
 ip_unprivileged_port_start
Message-ID: <20191124160955.3cf26f53@cakuba.netronome.com>
In-Reply-To: <CANP3RGcWkz+oR3qW4FAsijPSMrAGtUpcdfSbXvpcR9rT-=qQpA@mail.gmail.com>
References: <20191122221204.160964-1-zenczykowski@gmail.com>
        <20191123181749.0125e5e5@cakuba.netronome.com>
        <CANP3RGcWkz+oR3qW4FAsijPSMrAGtUpcdfSbXvpcR9rT-=qQpA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Nov 2019 01:16:35 -0800, Maciej =C5=BBenczykowski wrote:
> > Since this is a documentation _bug_ :) we probably need a Fixes tag.
> > The mistake is almost 3 years old, could be worth giving the backport
> > bots^W folks a chance to pick it up.
> >
> > Is this all the way from 4548b683b781 ("Introduce a sysctl that
> > modifies the value of PROT_SOCK.") ? =20
>=20
> Yes, indeed.
> That commit adds the documentation itself, and:
>=20
> // ipv4_local_port_range()
> -               if (range[1] < range[0])
> +               /* Ensure that the upper limit is not smaller than the lo=
wer,
> +                * and that the lower does not encroach upon the privileg=
ed
> +                * port limit.
> +                */
> +               if ((range[1] < range[0]) ||
> +                   (range[0] < net->ipv4.sysctl_ip_prot_sock))
>=20
> and
>=20
> // ipv4_privileged_ports()
>=20
> +       pports =3D net->ipv4.sysctl_ip_prot_sock;
> +
> +       ret =3D proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> +
> +       if (write && ret =3D=3D 0) {
> +               inet_get_local_port_range(net, &range[0], &range[1]);
> +               /* Ensure that the local port range doesn't overlap with =
the
> +                * privileged port range.
> +                */
> +               if (range[0] < pports)
> +                       ret =3D -EINVAL;
> +               else
> +                       net->ipv4.sysctl_ip_prot_sock =3D pports;
> +       }
>=20
> Anyway, I guess this means this commit should have:
>=20
> Fixes: 4548b683b781 ("Introduce a sysctl that modifies the value of PROT_=
SOCK.")
>=20
> (which is in v4.10-rc4-733-g4548b683b781)
>=20
> Should I resubmit with the new tag, or will you just pick it up?

Thanks for the tag, now that you showed me the code I'm not 100% sure
the doc is correct :S

The first unprivileged port has to be lower than the
ip_local_port_range, IOW ip_local_port_range must fall=20
into unprivileged range entirely.

So does "It may not overlap with the ip_local_port_range." really
express that? Should it say something like "ip_local_port_range must
fall into the unprivileged range" or "It must be lower or equal to start
of ip_local_port_range" or "Unprivileged port range must contain
ip_local_port_range" or...
