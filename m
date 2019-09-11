Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966D2AFB8F
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfIKLkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:40:02 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33304 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfIKLkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 07:40:02 -0400
Received: by mail-qt1-f196.google.com with SMTP id r5so24823084qtd.0;
        Wed, 11 Sep 2019 04:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=02aihXja284pbHw6Y7cb4oikypS3Tqv6XvGRsMJSOOE=;
        b=X6MhGCf+Dg3iPT/QKVLKBqFuz6OfWBLGaEq55dvHMYpgq+kgIXE/UxqXGtcbzgGee0
         myEyxVSRbTXKNe04N/qKKfWsBH9sBeUOvew61rhz7GG+rAHtpV9eRYr2ffE5ZLE3BSHf
         81Kz6byL4AR0jGaJ414Rc9nHKYoO3mZoGMhRNCJwKH+L9Jd52u5yBNUPv4FSyCc8LISD
         cSTI0NXsxHhwRnUq7xxPLlNCOvn4FG5vD0JnLJiuM7sImyUoPFm1qaBE2JqP0JfZ2zI3
         lTispFcDYefT9hjSSuVetwwH+F++ZLm7NpCmamEd7HfxMAVqfvD4WlCzyPZOxbusIRaa
         DF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=02aihXja284pbHw6Y7cb4oikypS3Tqv6XvGRsMJSOOE=;
        b=pcbuB/1vMWJkBxgRMmyK/xZPE0qVZP4QDOmCGUOa8Bjs0MHEJihTNWoKeljwNeu1D8
         ZZmGgxFnpa66DZQQW+uYwC9OsRA8Ok/O75w6QCGM7M9x4mUvW/66jRdPE7bNKRufTg35
         ohQuH3P9eOi1iZeAWcRxUCKLvZaoPfcqE3q4EzKxWDjfI6ac02q/9PycoZn2VeH1YJrG
         2/EJt0ze8FrypSTXp/uFuJM6px+5NMeioiBKQSaogEifeOA12C2JjDD1I3pJXHYsRg+V
         j5MMTxLxCV9OMJrhEdPb4hFBfKWtMr8zg6wT6XgEhby5A65ZYk0PUsd/0/C2/8ICAguD
         6Zzg==
X-Gm-Message-State: APjAAAWoOFi39sQTBVovYKKgVtExU/R1LPjKWYeQ7W8p0Hzp0t6hf3iO
        ++enO5U28Ky/PHBtAGRSdWjwA+MfWYc22g+rHxG/EWKXYZ7qCA==
X-Google-Smtp-Source: APXvYqzxCgIxRf8FhCijOGxwxw3mpS0Qmd0vx1KZDn85ap8XUByuk6vdrres0E7Po7lqZsJNJpWN3wGy2yIYOJXxd7I=
X-Received: by 2002:a0c:9846:: with SMTP id e6mr21943255qvd.114.1568202000956;
 Wed, 11 Sep 2019 04:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190910092731.GA173476@LGEARND20B15> <61418cb7514460e24bfcd431eee9c540e795fcbc.camel@mellanox.com>
In-Reply-To: <61418cb7514460e24bfcd431eee9c540e795fcbc.camel@mellanox.com>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Wed, 11 Sep 2019 20:39:56 +0900
Message-ID: <CADLLry7io3DwrjWU2n9eiFGsA0sseniQYhMRHmR7SjV6pLnk3w@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5: Declare 'rt' as corresponding enum type
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is good to hear that similar patch was submitted.
Thanks for notification.

Thanks,
Austin Kim

2019=EB=85=84 9=EC=9B=94 11=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 2:59, S=
aeed Mahameed <saeedm@mellanox.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Tue, 2019-09-10 at 18:27 +0900, Austin Kim wrote:
> > When building kernel with clang, we can observe below warning
> > message:
> >
> > drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1080:9:
> > warning: implicit conversion from enumeration type 'enum
> > mlx5_reformat_ctx_type'
> > to different enumeration type 'enum mlx5dr_action_type' [-   Wenum-
> > conversion]
> >       rt =3D MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
> >                                 ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1082:9:
> > warning: implicit conversion from enumeration type 'enum
> > mlx5_reformat_ctx_type'
> > to different enumeration type 'enum mlx5dr_action_type' [-   Wenum-
> > conversion]
> >       rt =3D MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL;
> >         ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1084:51:
> > warning: implicit conversion from enumeration type 'enum
> > mlx5dr_action_type'
> > to different enumeration type 'enum mlx5_reformat_ctx_type'
> > [-  Wenum-conversion]
> >       ret =3D mlx5dr_cmd_create_reformat_ctx(dmn->mdev, rt, data_sz,
> > data,
> >          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            ^~
> >
> > Declare 'rt' as corresponding enum mlx5_reformat_ctx_type type.
> >
> > Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> Hi Austin, Thanks for the patch:
>
> We already have a similar patch queued for submission.
> https://patchwork.ozlabs.org/patch/1158175/
>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git
> > a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
> > index a02f87f..7d81a77 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
> > @@ -1074,7 +1074,7 @@ dr_action_create_reformat_action(struct
> > mlx5dr_domain *dmn,
> >       case DR_ACTION_TYP_L2_TO_TNL_L2:
> >       case DR_ACTION_TYP_L2_TO_TNL_L3:
> >       {
> > -             enum mlx5dr_action_type rt;
> > +             enum mlx5_reformat_ctx_type rt;
> >
> >               if (action->action_type =3D=3D DR_ACTION_TYP_L2_TO_TNL_L2=
)
> >                       rt =3D MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
