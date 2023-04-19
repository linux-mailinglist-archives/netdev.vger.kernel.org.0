Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DAF6E7581
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjDSIlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbjDSIlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:41:14 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25536A4E
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:41:12 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-7606d44dbb5so346233639f.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681893672; x=1684485672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5zwwsv1p5D/gRlxt0eU/wzMw2WWxeFb5WeQDYnHVYU=;
        b=ndg0x1pDT4hSebBTYGx6yd+uiKYB07UmuUuMMHBZ2lgSYxjL8paMi9AJHCLV2aO9Hr
         6bhgN5OSk5155IdRgMFSdELWjCQt+4M9hCMPUdeVZeEcdc93J+jqHn+1YtJQHp/inMfs
         aeuNDvZcGrX3mnI5hgStg6sgCaUDqgN6yrX6tVbgmH1msuY8AlqG0l7m9674GH/2e8a2
         URWunaXK86lgNeVxGwOB/Sghuz0th0LgwG7m2Z4aX5ICauRRsryXfQjqjQz94uQBuyri
         KGRD7gfybFuEjWBFV5CM+1ChjrJ5scr5Bzkx43Flacm2p4QdG2gRWmi36M0znSGh8J4g
         N3qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681893672; x=1684485672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5zwwsv1p5D/gRlxt0eU/wzMw2WWxeFb5WeQDYnHVYU=;
        b=hyt7zuPl4NcD8uZnsddVsCMocr+VoLoDaYU4yQs79CDN+haKOSGokJrEZn5a9JV6jB
         5Tuw6TkFwBo4U3s1aWdEj9HUJvJyt7MFJ4fEVyStJ3w9nMKfYjOgDKz1oj2euUL1p4cc
         TCkXivxmTETb26FB7h5kLEMntw0hjer16wjkRg+EaDzsuFCxthaD1MTscARo2Ppc9FkE
         IBmlCPkvrKinzcDI0ZyvJVbs3CEzeYcswUbJKvElb+ziNvrBeJ4XKG5xhXn7fmTQzlUJ
         TzNg86lln2no2Gxwj5WAcD3ryFp6UlZznkCg9Y/oTdiX+psN60qwUIlTKq7NVO5fE3Eq
         u2cg==
X-Gm-Message-State: AAQBX9dKbqoo6Y3a+65ESIISyOFzSbPfqMN1S5FUTOTV5xHVdwuiUT0o
        Cqt2OTIFR35WlAGoi/Hell4DDvJ940zkcyOOLi1LjA==
X-Google-Smtp-Source: AKy350bnTfsp6ZaN6t74b/ECtx4wPwi+yVhBT4Au3SRjcvGrmJmiEAyFYeXYb03kPd6QJD26k+p1etFw3JQc422u9ZE=
X-Received: by 2002:a6b:d911:0:b0:745:70d7:4962 with SMTP id
 r17-20020a6bd911000000b0074570d74962mr3501152ioc.0.1681893672148; Wed, 19 Apr
 2023 01:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <202304162125.18b7bcdd-oliver.sang@intel.com> <20230418164133.GA44666@unreal>
 <509b08bd-d2bf-eaa8-6c49-c0860d1adbe0@kernel.org> <20230419055916.GB44666@unreal>
In-Reply-To: <20230419055916.GB44666@unreal>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 19 Apr 2023 10:41:00 +0200
Message-ID: <CANn89iLbHDjBZZT1ZOms3Ak0D0V4JTnyeEWZ26Eoc3v9PsGs6g@mail.gmail.com>
Subject: Re: [linux-next:master] [net] d288a162dd: canonical_address#:#[##]
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        Wangyang Guo <wangyang.guo@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, oe-lkp@lists.linux.dev,
        lkp@intel.com, Linux Memory Management List <linux-mm@kvack.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        steffen.klassert@secunet.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 7:59=E2=80=AFAM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Tue, Apr 18, 2023 at 02:43:02PM -0600, David Ahern wrote:
> > On 4/18/23 10:41 AM, Leon Romanovsky wrote:
> > > Hi,
> > >
> > > I came to the following diff which eliminates the kernel panics,
> > > unfortunately I can explain only second hunk, but first is required
> > > too.
> > >
> > > diff --git a/net/core/dst.c b/net/core/dst.c
> > > index 3247e84045ca..750c8edfe29a 100644
> > > --- a/net/core/dst.c
> > > +++ b/net/core/dst.c
> > > @@ -72,6 +72,8 @@ void dst_init(struct dst_entry *dst, struct dst_ops=
 *ops,
> > >         dst->flags =3D flags;
> > >         if (!(flags & DST_NOCOUNT))
> > >                 dst_entries_add(ops, 1);
> > > +
> > > +       INIT_LIST_HEAD(&dst->rt_uncached);
> >
> > d288a162dd1c73507da582966f17dd226e34a0c0 moved rt_uncached from rt6_inf=
o
> > and rtable to dst_entry. Only ipv4 and ipv6 usages initialize it. Since
> > it is now in dst_entry, dst_init is the better place so it can be
> > removed from rt_dst_alloc and rt6_info_init.
>
> This is why I placed it there, but the rt_uncached list is initialized
> in xfrm6 right before first call to rt6_uncached_list_add().
>
>    70 static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device =
*dev,
>    71                           const struct flowi *fl)
>    72 {
> ...
>    92         INIT_LIST_HEAD(&xdst->u.rt6.dst.rt_uncached);
>    93         rt6_uncached_list_add(&xdst->u.rt6);
>
> My silly explanation is that xfrm6_dst_destroy() can be called before xfr=
m6_fill_dst().
>
> Thanks
>
> >

Please take a look at the fix that was sent yesterday :

https://patchwork.kernel.org/project/netdevbpf/patch/20230418165426.1869051=
-1-mbizon@freebox.fr/

Thanks.
