Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA00AD2693
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbfJJJp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:45:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51414 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfJJJp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 05:45:26 -0400
Received: by mail-wm1-f66.google.com with SMTP id 7so6196970wme.1
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 02:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=71nqkzTyWCRhqIWzEuuvzydYqPqmpoziOgNrs1ENsyI=;
        b=ZpbTMoB6ItgIbRQipNVCGYhM4Fm8JQlS9dnPu+CiNh1EUznTkqlq2Qgxd6Xg0/Pjw+
         c6PQll6ysi4A3SQy/6SKTtJbsWVoAVCD3Y6dioH9t0Wu9NNwWIrzHZniUsRtGwlZ0OaC
         6I+2oF981r4yR94jYfIs6j1addn7V41007wgCCOZIUo8TGRd9SFIWlNqRvN4MOoRUZf+
         LzGmGea3pQC/YKQ/lJ7EREWBqg25M8JX8V6tJbKW4UaRjb9JfxJuz00Bk0lxupC77AQV
         l1XGwFCd5CFM63Fm6lrnAZWIigSGZCn7RbYyZLvrk2CB8mukGITN1bdiG+JG4l5Lkboh
         DowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=71nqkzTyWCRhqIWzEuuvzydYqPqmpoziOgNrs1ENsyI=;
        b=Zukn+CELYYu4PSnWCty/KA4YzmTAI0wEnyWPyr4r7iZPwFNQkMNLGYS/f6nAQyJcEe
         slhUxqxD29sec7TjMhqsdkFavHXom2/yR8jKCF7b5oS9vRuVtB6Ut8XppEwc6WN51TqW
         Wb8etC3hdblV8dKv9NhZyDW48JtniCSx9cEsVz8/704yhcZjJIuRDQCm9NGPYDp8CIKJ
         DSXuyzHsD79vD757SIxjH4q/ikIqOIeyDtX8LWidbOCR09EK94t6PflRZnQhrQEzJcpt
         kEb1VGEFNvZHPtv9J/U44vRMrjLvX5OieKC4xIRbKW7kzvNHm5pGAXW4tRJ6tN1lMEU+
         lijQ==
X-Gm-Message-State: APjAAAXEFLboqTFdcplcV5RTW/YRbE31E30DGPJ9iBzHnQfYqGCME0eG
        QLu+VBhPGrRCoryQBgExytlsncapCTdJmLY3U0k=
X-Google-Smtp-Source: APXvYqyMZW0yl+xcTVovDpEaSHLk8/znUwIX+MGmPLjj5s/2PnD/qiEyQeffV5lt6UDELot++jgXubhgtyjamj8HxIY=
X-Received: by 2002:a1c:8157:: with SMTP id c84mr6691915wmd.56.1570700724064;
 Thu, 10 Oct 2019 02:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570547676.git.lucien.xin@gmail.com> <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
 <20191009075526.fcx5wqmotzq5j5bj@netronome.com>
In-Reply-To: <20191009075526.fcx5wqmotzq5j5bj@netronome.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 10 Oct 2019 17:45:14 +0800
Message-ID: <CADvbK_fpJiVOb0LC9YAHmr-_9nZB85w6Rwf0=FXX4ziyJ9B=3A@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 2/6] lwtunnel: add LWTUNNEL_IP_OPTS support for lwtunnel_ip
To:     Simon Horman <simon.horman@netronome.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 3:55 PM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Tue, Oct 08, 2019 at 11:16:12PM +0800, Xin Long wrote:
> > This patch is to add LWTUNNEL_IP_OPTS into lwtunnel_ip_t, by which
> > users will be able to set options for ip_tunnel_info by "ip route
> > encap" for erspan and vxlan's private metadata. Like one way to go
> > in iproute is:
> >
> >   # ip route add 1.1.1.0/24 encap ip id 1 erspan ver 1 idx 123 \
> >       dst 10.1.0.2 dev erspan1
> >   # ip route show
> >     1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 \
> >       tos 0 erspan ver 1 idx 123 dev erspan1 scope link
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Hi Xin,
>
> thanks for your patch.
>
> While I have no objection to allowing options to be set, as per the sample
> ip commands above, I am concerned that the approach you have taken exposes
> to userspace the internal encoding used by the kernel for these options.
>
> This is the same concerned that was raised by others when I posed a patch
> to allow setting of Geneve options in a similar manner. I think what is
> called for here, as was the case in the Geneve work, is to expose netlink
> attributes for each option that may be set and have the kernel form
> these into the internal format (which appears to also be the wire format).
Understand.

Do you think if it's necessary to support for setting these options
by ip route command?

or if yes, should we introduce a global lwtun_option_ops_list where
geneve/vxlan/erspan could register their own option parsing functions?

>
> > ---
> >  include/uapi/linux/lwtunnel.h |  1 +
> >  net/ipv4/ip_tunnel_core.c     | 30 ++++++++++++++++++++++++------
> >  2 files changed, 25 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
> > index de696ca..93f2c05 100644
> > --- a/include/uapi/linux/lwtunnel.h
> > +++ b/include/uapi/linux/lwtunnel.h
> > @@ -27,6 +27,7 @@ enum lwtunnel_ip_t {
> >       LWTUNNEL_IP_TOS,
> >       LWTUNNEL_IP_FLAGS,
> >       LWTUNNEL_IP_PAD,
> > +     LWTUNNEL_IP_OPTS,
> >       __LWTUNNEL_IP_MAX,
> >  };
> >
> > diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> > index 10f0848..d9b7188 100644
> > --- a/net/ipv4/ip_tunnel_core.c
> > +++ b/net/ipv4/ip_tunnel_core.c
> > @@ -218,6 +218,7 @@ static const struct nla_policy ip_tun_policy[LWTUNNEL_IP_MAX + 1] = {
> >       [LWTUNNEL_IP_TTL]       = { .type = NLA_U8 },
> >       [LWTUNNEL_IP_TOS]       = { .type = NLA_U8 },
> >       [LWTUNNEL_IP_FLAGS]     = { .type = NLA_U16 },
> > +     [LWTUNNEL_IP_OPTS]      = { .type = NLA_BINARY },
> >  };
>
> ...
