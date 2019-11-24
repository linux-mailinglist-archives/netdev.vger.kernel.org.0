Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D559108292
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 10:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKXJQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 04:16:50 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:44976 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfKXJQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 04:16:50 -0500
Received: by mail-ua1-f66.google.com with SMTP id d6so520854uam.11
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 01:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ngUmOy4rs6BjKho/GZYeFMglW7CX36DubM6EXGSGwv0=;
        b=gdht9d1Z+xz/kWaJxOKTf48DSDs73yCcufiyFvljwkP18DETcbbhMOCyTBVzbGWcjv
         wEokWTd2t9/Uj2EyxTNzKBkScwYdvvWiX5iVQOrjhGoYuHiGZUuZXQAIK2qrOZm9jzMv
         nmqz7fp0fRdRjC+YMQlH7wZRwXFhv2C6S4Wm+LyfVvukb2avg4IK7CLLt3ue4fLfn8AC
         NB7106B/PrEzuz8WAWgXGhShZrWPPzytCTKTMLGD3DwLdPz4Wf7ygCXOIFeM21IQPr5y
         mr50AotgMd6lWjfna942REbAVQPWyUyiNsnrmfX7i4hrjmHZoO/zRpks8pfJu/ReQrGT
         +hNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ngUmOy4rs6BjKho/GZYeFMglW7CX36DubM6EXGSGwv0=;
        b=IW9ubSYWBHn8WLiivM/aY5uRyj2TnrAsBDLlnEi60Hp+ARJLCoKats8x06VjBrj8ay
         pgTXNmiHsf8ZW7NC9MCQX6L3fopERHFK5uT5pvg9y/vSDSP0/UQq8LCKQ+tOLmNYfBho
         0WiIHLpKlcmlkgQZbtOcwyzUOcd4J3YsvYUGBDFn3+ZZBjAC1LL1NdrPI57mLP3y6HhA
         LXiy/BaTg89nZsNnPVtOmR26GwTQfOEmmBUkpiV58tLdATlpa3UP9HqFjK7RFnlRtnfR
         e2tR80saTrH54bMBsO2RPlHvRU3PhPSh11cdd0LEPrZgRn/sdbf76S5OCXolItEe77XE
         ELUA==
X-Gm-Message-State: APjAAAV2W4NjFUyntfF3ZBkU1NYDdLOJN9s1tiE4rXajtVO44kgeyVfw
        qGl+LUAWfH3Nhnz1N7WohFylmPVF41QZNIQ40l5bGw==
X-Google-Smtp-Source: APXvYqxweXEJa1C3CcqDomVPfDKFXr4tWSdvOOHzLtaRUxKWRhNANOSSGol5YK9+Su4I/LNNjPcitPn5DFk0MkVb890=
X-Received: by 2002:ab0:189a:: with SMTP id t26mr15019592uag.87.1574587007544;
 Sun, 24 Nov 2019 01:16:47 -0800 (PST)
MIME-Version: 1.0
References: <20191122221204.160964-1-zenczykowski@gmail.com> <20191123181749.0125e5e5@cakuba.netronome.com>
In-Reply-To: <20191123181749.0125e5e5@cakuba.netronome.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sun, 24 Nov 2019 01:16:35 -0800
Message-ID: <CANP3RGcWkz+oR3qW4FAsijPSMrAGtUpcdfSbXvpcR9rT-=qQpA@mail.gmail.com>
Subject: Re: [PATCH] net: Fix a documentation bug wrt. ip_unprivileged_port_start
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Since this is a documentation _bug_ :) we probably need a Fixes tag.
> The mistake is almost 3 years old, could be worth giving the backport
> bots^W folks a chance to pick it up.
>
> Is this all the way from 4548b683b781 ("Introduce a sysctl that
> modifies the value of PROT_SOCK.") ?

Yes, indeed.
That commit adds the documentation itself, and:

// ipv4_local_port_range()
-               if (range[1] < range[0])
+               /* Ensure that the upper limit is not smaller than the lower,
+                * and that the lower does not encroach upon the privileged
+                * port limit.
+                */
+               if ((range[1] < range[0]) ||
+                   (range[0] < net->ipv4.sysctl_ip_prot_sock))

and

// ipv4_privileged_ports()

+       pports = net->ipv4.sysctl_ip_prot_sock;
+
+       ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+
+       if (write && ret == 0) {
+               inet_get_local_port_range(net, &range[0], &range[1]);
+               /* Ensure that the local port range doesn't overlap with the
+                * privileged port range.
+                */
+               if (range[0] < pports)
+                       ret = -EINVAL;
+               else
+                       net->ipv4.sysctl_ip_prot_sock = pports;
+       }

Anyway, I guess this means this commit should have:

Fixes: 4548b683b781 ("Introduce a sysctl that modifies the value of PROT_SOCK.")

(which is in v4.10-rc4-733-g4548b683b781)

Should I resubmit with the new tag, or will you just pick it up?
