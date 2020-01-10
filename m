Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DEA13692D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 09:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgAJIwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 03:52:02 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45894 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbgAJIwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 03:52:02 -0500
Received: by mail-qt1-f195.google.com with SMTP id w30so1244792qtd.12
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 00:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HmA7ZmCnOGjp9yx369kZ6qOfHwaMP7kUtPkpzYHz27c=;
        b=F1aiGDhsoRJECfWCtS4AgWxHSATp6M/CCwgNY+z6d+9QlHsahSHcSVccWRPVY4mAds
         K4xjUraY87zT1HT4KOMp8CyANULJiDXFiWkOe4O8G/UZGtXqy/JdYOTwgerv6tMjGhAr
         zwnZ2tdqlXA2esxe03GjQeq0xWBdiwe+BB6Q1pDI6zr97+FOgZEjT3GqdC6nSp6ADsDl
         FKKSVkSypGIUsU4ymzSYY+tzT4KZvFaIm/GFxLwwCOJSu7U1INF0XW7WfZAwvrgGeR5+
         RXNb4eBOiD1RhYVOiypQZy8/LbamQNSyceLn3wH9Ac1kOId+fEkqkZvqKGoRNJ6ZlC2H
         5R+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HmA7ZmCnOGjp9yx369kZ6qOfHwaMP7kUtPkpzYHz27c=;
        b=OF67UQ2LciFF+ZLwY9gwgxQiuRO+hvXa2QTlk9IahKx4fvwl81uOLzgBcpQga3GKtn
         ZrAS7/fgl+djYZE11WlxmoFaOPibhT2kjOXYWv/0fbBmCIXwBgcivfQGLXeRP80mwWTp
         CJygjT3o1i+5ApLHr1sdRfpHKSvVGsrnmetJGXD56q0rC5sUklvhx7i62czOSdwLX9pI
         ENinvugCW2VjFDGQqXr5LPhCQXSDPSWjCdBSsKCRgqyXDq8iv3NsZ8ZIaI4159Ydyldr
         OcdBX2M5Y817qMdT6QG1dr2jcBjNak87kE1cFR+aU2SQ1BsVXIceTo0epZTCecj5yu+U
         0mwA==
X-Gm-Message-State: APjAAAUYkco/SEGw3ZWZ/fOkvbKYpoU7fLJLMu0jj6wWrUp8yhmvVlLf
        QPjBDFOHlcffx8xDvkoFD22fTFE69DzyAnNEmQw=
X-Google-Smtp-Source: APXvYqwaL6DkbNzh8q3WA8AzKGSMoVCB/N+u5hRPa/VIAqK9JDr8ZS+F+fW1djGFvA+i21xdE2GtHbGENe1xv0t4AqQ=
X-Received: by 2002:aed:2b04:: with SMTP id p4mr1391061qtd.270.1578646321040;
 Fri, 10 Jan 2020 00:52:01 -0800 (PST)
MIME-Version: 1.0
References: <20200109192317.4045173-1-jonathan.lemon@gmail.com>
In-Reply-To: <20200109192317.4045173-1-jonathan.lemon@gmail.com>
From:   Jack Wang <xjtuwjp@gmail.com>
Date:   Fri, 10 Jan 2020 09:51:50 +0100
Message-ID: <CAD+HZHVJ-H=9VgvyzdPV-g2vnkJscJCY63Bjb-0dhDLw4Gp_8Q@mail.gmail.com>
Subject: Re: [PATCH net-next] mlx4: Bump up MAX_MSIX from 64 to 128
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, tariqt@mellanox.com, davem@davemloft.net,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Lemon <jonathan.lemon@gmail.com> =E4=BA=8E2020=E5=B9=B41=E6=9C=889=
=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=889:47=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On modern hardware with a large number of cpus and using XDP,
> the current MSIX limit is insufficient.  Bump the limit in
> order to allow more queues.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Reveiwed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
