Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E68633AEF3
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 10:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCOJj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 05:39:29 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:18216 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhCOJjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 05:39:08 -0400
Date:   Mon, 15 Mar 2021 09:38:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615801146; bh=SnqNhZ8jhCbnZf+6aCb/UARYY/AXz744p1JflVY958M=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=YLTddrgfp3S/VtQaasYCODof0lpCpeNFQPdQa2SI1JBR1V7jSR+KBggIMkU2jg3Lj
         qfKcR5F9eA28y13jfcXt2vc5usvS0isFQmvO6aCFGnhwaqfDyHLmPav5LmM/weEUWA
         gMMKjA0lSyztoTFmhcH+cbAOac1b2X6oe4RZbS6fW5g/v9jxLd4Ay3WChxk+EgAX03
         bCQSqG4dO3aEOas+mqgKX9mhDK8oHz8LdS+YorQwe55aekoKPhsaTvLrvapaV0EEVI
         1+ncNzIKWnI6Z4g/G6xLmRQNxO6rljTi35eyxuA16aU2mYsOBRFx2ynNQ95QZO8iyP
         UCcQiWjXaKnnA==
To:     Vladimir Oltean <olteanv@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Wang Qing <wangqing@vivo.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v3 net-next 4/6] linux/etherdevice.h: misc trailing whitespace cleanup
Message-ID: <20210315093839.6510-1-alobakin@pm.me>
In-Reply-To: <20210314210453.o2dmnud45w7rabcw@skbuf>
References: <20210314111027.7657-1-alobakin@pm.me> <20210314111027.7657-5-alobakin@pm.me> <20210314210453.o2dmnud45w7rabcw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 14 Mar 2021 23:04:53 +0200

> On Sun, Mar 14, 2021 at 11:11:32AM +0000, Alexander Lobakin wrote:
> > Caught by the text editor. Fix it separately from the actual changes.
> >
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  include/linux/etherdevice.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> > index 2e5debc0373c..bcb2f81baafb 100644
> > --- a/include/linux/etherdevice.h
> > +++ b/include/linux/etherdevice.h
> > @@ -11,7 +11,7 @@
> >   * Authors:=09Ross Biro
> >   *=09=09Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
> >   *
> > - *=09=09Relocated to include/linux where it belongs by Alan Cox
> > + *=09=09Relocated to include/linux where it belongs by Alan Cox
> >   *=09=09=09=09=09=09=09<gw4pts@gw4pts.ampr.org>
> >   */
> >  #ifndef _LINUX_ETHERDEVICE_H
> > --
> > 2.30.2
> >
> >
>
> Your mailer did something weird here, it trimmed the trailing whitespace
> from the "-" line. The patch doesn't apply.

It's git-send-email + ProtonMail Bridge... Seems like that's the
reason why only this series of mine was failing Patchwork
everytime.

Much thanks for finding this out!
Al

