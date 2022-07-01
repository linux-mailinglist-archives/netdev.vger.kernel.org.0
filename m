Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC97E563430
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbiGANNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiGANNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:13:52 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EBF44A1D;
        Fri,  1 Jul 2022 06:13:49 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g4so2396079pgc.1;
        Fri, 01 Jul 2022 06:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uuZ9PUmfOj4BndQIme+wRqpcIrzyVDnqBNHxIE6tjL0=;
        b=jK8Kdgwm6UeOa8FHlIgXUuXCakQLgPoeST98OFJQk6zqp2XC86OJ5bz7hHn90Bh7n6
         LofWkaARprzyu4hFUapMGVjIJS5RrzE6pQ1GTIlgmblf6VAh8sjqT4N95dq/avI/rNvM
         6z0HIIo9P/GgTieOWMQeQShkM3bwNEQTlDeMdXR2xaixTiRR9Qis+mpHNieTesmdJSct
         XsgeD/y8j/koVIwFJYwtwobUolY0L3Qw27mZDM9ZH3vPU8usbfX+5EStRpuxgvbfu5uM
         zthEEz5HGRpcNeI5QdchfJlhLMTtmZHPhOtL3cgapgYzLeUXwLrHjdNFzzbVzVpbO6if
         CUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uuZ9PUmfOj4BndQIme+wRqpcIrzyVDnqBNHxIE6tjL0=;
        b=HOM8Ydmf/4aF6VBkS9K/JH+C+DD6hu0dKSSBZR7GBUZeYxltv0eCXbuS3oCDNsH9fn
         AZe5vqOEGCQ+B1BOsV3ahD4Df6L+klStPnjgI1LQu0FT4gzm89kDwSdKjhdYIQ//j9Nh
         Bs3CVPGM+riy3ooY0/VgkQ4d+XA6jzIO+eL4q5LV3AOVEQLv6Jr9BwhdlucE1mQDdQNh
         5P+bILfHloxw8lNYEUl1JZ27CAkIhrhL/c9Yfu83vuMJnZ2C5hI3fE909w0HOUulrl2X
         jf+gR6qaLjidWxjWwAmd0hDVFAJqwq/GPwTDHssv3bGHasKvT8akM85fI35GV/lrXkj8
         h8ng==
X-Gm-Message-State: AJIora/44FntjIHxm5VhUPOkXuPwqY/lMsTObmHwHDHgIbC16rZpLAeb
        993/8WlooZESbCNpNUTcpIaGxHEwSw9VcsxOE0g=
X-Google-Smtp-Source: AGRyM1veESKzjKxU/8xARq15ZnhaDZr0aHpCdrEm4ggqP5YOwHEp2FsOJBnzNpOf3ozSSZULi7Kss7gR15qLuEYPBzo=
X-Received: by 2002:aa7:999a:0:b0:525:6023:8c03 with SMTP id
 k26-20020aa7999a000000b0052560238c03mr21204987pfh.86.1656681228125; Fri, 01
 Jul 2022 06:13:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220701042810.26362-1-lukas.bulwahn@gmail.com> <Yr7mcjRq57laZGEY@boxer>
In-Reply-To: <Yr7mcjRq57laZGEY@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 1 Jul 2022 15:13:36 +0200
Message-ID: <CAJ8uoz16yGJqYX2xOcczTGKFnG4joh8+f1uPGMAP4rmm3feYDQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: adjust XDP SOCKETS after file movement
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 2:38 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Fri, Jul 01, 2022 at 06:28:10AM +0200, Lukas Bulwahn wrote:
> > Commit f36600634282 ("libbpf: move xsk.{c,h} into selftests/bpf") moves
> > files tools/{lib =3D> testing/selftests}/bpf/xsk.[ch], but misses to ad=
just
> > the XDP SOCKETS (AF_XDP) section in MAINTAINERS.
> >
> > Adjust the file entry after this file movement.
> >
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > ---
> > Andrii, please ack.
> >
> > Alexei, please pick this minor non-urgent clean-up on top of the commit=
 above.
> >
> >  MAINTAINERS | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index fa4bfa3d10bf..27d9e65b9a85 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -22042,7 +22042,7 @@ F:    include/uapi/linux/xdp_diag.h
> >  F:   include/net/netns/xdp.h
> >  F:   net/xdp/
> >  F:   samples/bpf/xdpsock*
> > -F:   tools/lib/bpf/xsk*
> > +F:   tools/testing/selftests/bpf/xsk*
>
> Magnus, this doesn't cover xdpxceiver.
> How about we move the lib part and xdpxceiver part to a dedicated
> directory? Or would it be too nested from main dir POV?

Or we can just call everything we add xsk* something?

> >
> >  XEN BLOCK SUBSYSTEM
> >  M:   Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
> > --
> > 2.17.1
> >
