Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7788DD6140
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 13:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfJNL0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 07:26:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33907 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfJNL0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 07:26:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id j11so19297287wrp.1
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 04:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3bIpauhmFzwNgeFSGmou1Sh5xrqleY4KalGU2c/dp9s=;
        b=b86bjh0HqRUPkD22hBkcGa1CSm9ngGMTrMRTbhJzXqS94ElISL2CdnXUQJRNtgfNdL
         WprTWbq6kGv2nAXNhDolvTDnwMO9KD8UpAvEycUHYW04GH4OozEqHrS+dk3/Z6QxSEM0
         P2Oap8+Mrk7Q/2etPY6IKMcCCSMuJOS/ufA+xaSa1wffRLYLYD4CjElpi0QRR8p667C2
         L3jOydnbvlVQyPWwULyWKPwMbjQjaxRCMSlGRJbnNYmAeaNPX3Z225iU4dH926fkqQ5k
         H/IwO3c/OrKfW24AwBO4g9d8EPLtxq7z10An0qSfshoHZtEJQapvU8+hWxdVCXEP+FF+
         gNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3bIpauhmFzwNgeFSGmou1Sh5xrqleY4KalGU2c/dp9s=;
        b=BH7GUcOTRGWT0mDGVN0F6j2iGcM/bNmknEOxT8GPSoJkyYohzn9M9/LYELgiYTYLQj
         goZCAIBfpDwhRLvjtwfX14vzqFXzg2YrwIWTLx0TnEnMgl2lxh+c2xymsR6owqKyZRGT
         i405+BdC2b+EyF7g2tuS2k3n5vX+qbxpyiUlFfjMD+n82O5oi1h5D92lH2cjFpr0CpVm
         oA3SmtscurHGrrPaMR6VKI+CL9FY6j/UeeJClNgJOlujJchKOUyjpwzccs052iaITgSI
         w8aZpwsIU5VyADHgaARewit1i/N3woq05dO9xmQBpHu2lYrC4DdJv1TrwIB7a1OAKd9x
         ua9A==
X-Gm-Message-State: APjAAAWK52PYvEuWWJkSeVKF2neIpkDcOgcYv7GyJW0J4TC7Soh0hz15
        TeBW9hTH5gmuYiOqkAuimW74GmFpa7Oruz4H2Mbj0w==
X-Google-Smtp-Source: APXvYqx8KwSSlnGjtmiInWd048+U4uw3IEQL6cJfEiaFgdqLdxiPp+JcvHL8i0drcHVpqIhjqijWXl318Yn/+Ne7ISU=
X-Received: by 2002:adf:fcc5:: with SMTP id f5mr24744561wrs.37.1571052381243;
 Mon, 14 Oct 2019 04:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570547676.git.lucien.xin@gmail.com> <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
 <20191009075526.fcx5wqmotzq5j5bj@netronome.com> <CADvbK_fpJiVOb0LC9YAHmr-_9nZB85w6Rwf0=FXX4ziyJ9B=3A@mail.gmail.com>
 <20191011053101.b42vazaowgsn2l6w@netronome.com>
In-Reply-To: <20191011053101.b42vazaowgsn2l6w@netronome.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 14 Oct 2019 19:26:27 +0800
Message-ID: <CADvbK_eM2=FJdTQ+z8xuhkgyrdNEtG23nR_qsrJ+faC8Txt91g@mail.gmail.com>
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

On Fri, Oct 11, 2019 at 1:31 PM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Thu, Oct 10, 2019 at 05:45:14PM +0800, Xin Long wrote:
> > On Wed, Oct 9, 2019 at 3:55 PM Simon Horman <simon.horman@netronome.com> wrote:
> > >
> > > On Tue, Oct 08, 2019 at 11:16:12PM +0800, Xin Long wrote:
> > > > This patch is to add LWTUNNEL_IP_OPTS into lwtunnel_ip_t, by which
> > > > users will be able to set options for ip_tunnel_info by "ip route
> > > > encap" for erspan and vxlan's private metadata. Like one way to go
> > > > in iproute is:
> > > >
> > > >   # ip route add 1.1.1.0/24 encap ip id 1 erspan ver 1 idx 123 \
> > > >       dst 10.1.0.2 dev erspan1
> > > >   # ip route show
> > > >     1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 \
> > > >       tos 0 erspan ver 1 idx 123 dev erspan1 scope link
> > > >
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > >
> > > Hi Xin,
> > >
> > > thanks for your patch.
> > >
> > > While I have no objection to allowing options to be set, as per the sample
> > > ip commands above, I am concerned that the approach you have taken exposes
> > > to userspace the internal encoding used by the kernel for these options.
> > >
> > > This is the same concerned that was raised by others when I posed a patch
> > > to allow setting of Geneve options in a similar manner. I think what is
> > > called for here, as was the case in the Geneve work, is to expose netlink
> > > attributes for each option that may be set and have the kernel form
> > > these into the internal format (which appears to also be the wire format).
> >
> > Understand.
> >
> > Do you think if it's necessary to support for setting these options
> > by ip route command?
> >
> > or if yes, should we introduce a global lwtun_option_ops_list where
> > geneve/vxlan/erspan could register their own option parsing functions?
>
> Hi Xin,
>
> In the case of Geneve the options are (now) exposed via tc cls_flower and
> act_tunnel rather than ip route. The approach taken was to create an
> ENC_OPTS attribute with a ENC_OPTS_GENEVE sub-attribute which in turn has
> sub-attributes that allow options to be described.
>
> The idea behind this design, as I recall, was to allow other options, say
> for VXLAN, to be added via a new sub-attribute of ENC_OPTS.  Without
> examining the details beyond your patch I think a similar approach would
> work well for options supplied via ip route.
Thanks, I will give it a try.
