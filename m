Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB9A11E0C3
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 10:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLMJaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 04:30:30 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52380 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfLMJa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 04:30:29 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so5540395wmc.2
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 01:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jZdCFyi3P0PE/gTzwArDJAX7Y5Yjkz7bthFAd9kSL8E=;
        b=vXhTJSwEs2tEqcb/W1Gixt5T1TWJyLh9ofXEc/v02oErGrluI4oixv9bY0AJ4TMlvq
         G0QeZqQQPyGHijsjDq63NRpzjQ+xgx2VzF4lwbhvzy6bK4y6Qh5/k1uTd5HjDx9pzn54
         0xDOtRV2Zdp8KEyIUXEOE3FGltLDsw4KJHojM28+gFt0mSUDfocWAldtbo8KJMAmjWVC
         h/LBCyT4R02G9C4cWL62vmZM80OOeDW+VlMJjVjDxBLF/d0CZaHpGvokUY8sFDwFmB7t
         eYcr5agT2xxCPCxDGN6ODzdCSR8/cni4r9gkLDNv86MiYRZ2YPMB+ZLoi0+z7Fx2qQNu
         nMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jZdCFyi3P0PE/gTzwArDJAX7Y5Yjkz7bthFAd9kSL8E=;
        b=YCcIvFBeZtRaUU1QXIoWvgGpbjHmLhBMQnYE3Vll2GD58S+YpjURHz91RA1+7I3A7i
         QonjjxYGWu3QfV/2xZvag4xhQYO0hKMchEtB1RsY/SZSWoZqqCQBDCn/K8nvQNzqOHXh
         ZNs9aahEIa+Zj4vqzvN2eHLaMqohdAe2LSlP69BZ4GsFt9yYgdUtLC5mQO9JeChvaDcU
         iA+x663Yb07bI+gcy7Jz7xkt4146evHJV52X3Wswy/oC6tyjkX3cdMG+e+CPplFWlEAa
         t8447ukhJqi/64i+exvwElvOBqNqrM9LzyiKQNqSWjOi+mnhuYDLOMYIwArex7pnuqae
         w2Ew==
X-Gm-Message-State: APjAAAUvMU5v3WmPNqzya3gBjuvDKxeF2qfFXMaD/L7gOwSnfWLV6dK0
        JSsjoxw9gn9llHI+4NzGcUxxEQ==
X-Google-Smtp-Source: APXvYqxtTiPkSq43+iaH2FYGWbq7cKMj7CBY86RoUBako+Un9sDcQ15tBHAMmrgcHuJO0XjYun9iog==
X-Received: by 2002:a1c:740b:: with SMTP id p11mr12928629wmc.78.1576229427548;
        Fri, 13 Dec 2019 01:30:27 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id x6sm9805907wmi.44.2019.12.13.01.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 01:30:27 -0800 (PST)
Date:   Fri, 13 Dec 2019 10:30:26 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/7] netfilter: nft_tunnel: parse ERSPAN_VERSION
 attr as u8
Message-ID: <20191213093026.GA27379@netronome.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
 <20191209200317.GA10466@netronome.com>
 <CADvbK_fJjN0MsYpmoJ+WD=rRNYub96+nHsv3EozHTj5MG2d1ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_fJjN0MsYpmoJ+WD=rRNYub96+nHsv3EozHTj5MG2d1ag@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 12:05:15PM +0800, Xin Long wrote:
> On Tue, Dec 10, 2019 at 4:03 AM Simon Horman <simon.horman@netronome.com> wrote:
> >
> > Hi Xin,
> >
> > On Sun, Dec 08, 2019 at 12:41:31PM +0800, Xin Long wrote:
> > > To keep consistent with ipgre_policy, it's better to parse
> > > ERSPAN_VERSION attr as u8, as it does in act_tunnel_key,
> > > cls_flower and ip_tunnel_core.
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/netfilter/nft_tunnel.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> > > index 3d4c2ae..f76cd7d 100644
> > > --- a/net/netfilter/nft_tunnel.c
> > > +++ b/net/netfilter/nft_tunnel.c
> > > @@ -248,8 +248,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
> > >  }
> > >
> > >  static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
> > > +     [NFTA_TUNNEL_KEY_ERSPAN_VERSION]        = { .type = NLA_U8 },
> > >       [NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]       = { .type = NLA_U32 },
> > > -     [NFTA_TUNNEL_KEY_ERSPAN_V2_DIR] = { .type = NLA_U8 },
> > > +     [NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]         = { .type = NLA_U8 },
> > >       [NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]        = { .type = NLA_U8 },
> > >  };
> > >
> > > @@ -266,7 +267,7 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
> > >       if (err < 0)
> > >               return err;
> > >
> > > -     version = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
> > > +     version = nla_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]);
> >
> > I have concerns about this change and backwards-compatibility with existing
> > users of this UAPI. Likewise, with other changes to the encoding of existing
> > attributes elsewhere in this series.
> userspace(nftables/libnftnl) is not ready for nft_tunnel, I don't
> think there will be
> any backwards-compatibility issue.
> 
> Pablo?

Thanks, I'm happy to defer to Pablo on this question.

> 
> >
> > >       switch (version) {
> > >       case ERSPAN_VERSION:
> > >               if (!tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX])
> > > --
> > > 2.1.0
> > >
