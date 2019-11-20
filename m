Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5ED103391
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 06:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfKTFOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 00:14:05 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53359 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfKTFOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 00:14:05 -0500
Received: by mail-wm1-f67.google.com with SMTP id u18so5613069wmc.3
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 21:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=his8lKo9hSH/XwYSk9rUBhNb2CWrxWuRbEzCXHEu4gs=;
        b=OwEhPHZG1R4/gDe1G9+pSYLXHvYacEBrmFFLKZ7GBmfeZPweIc3cVbf/DG8//cp+9z
         qVvffCFPvh+MN6fRLLdLj8kPMLMeD3HLkGJ1xSa2tFdJAe3ijIhjrcnP6MCQd68H16Qf
         9zx6+C2F7z6BzK9dXW6OGlwv8c2Qpi+GOVIdjKPOCnBW+s3AI8FK9omvEwIMZeTH2xth
         am2/oDgfa73jN8V0s/hPOis4xnYzi6yZNHGlmJGRBjaW4eKt5GQ3ZXhODonTx97lju96
         ugtm4dFmMZqjE5VC5se08IhcuE4XGLnAZmzmbx6D+pGrnD+hpf7J5nJvMJno9PCzsYlG
         9lpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=his8lKo9hSH/XwYSk9rUBhNb2CWrxWuRbEzCXHEu4gs=;
        b=dXf9H4ks3UhyHMlnM6NXIG+6pZ8uNNHd4XtYz08ECV/WnXS/Cf7mJ3QQ/8+PHvyzWM
         CBHQpaELdWvT/FxqtFz8OLJ+negIfSXHAgMweSnw0+dhs/kdZtRN2CzHdDsNv0yEw5+K
         jUarSTvvSevdI9c4tPIZTohZxy9bZFALR8COrlsjW0r0A85KsKHNK1yMj/tBYkQeYpM3
         GiGocob+YcGEmg3yGbTHrGr22KhFxPXVCwni+ahSLqoYWUgKsPUFaR3d2/xzkvqEsRpV
         X3AMhJK8mhzrUWl4Pz2ynFN0vijf+BIlBM1ExkpozQHBcHNcxrkL/+cKLdtH8/Yvw2ra
         YyUQ==
X-Gm-Message-State: APjAAAVQ/fVQ3MnzvpD+9UsEVFfS+EbdzOlgoA6xnq4pJefGbhiciNIL
        1yKWtREkvrt28rutQ+xlfh1+u/t38Z+BUmYPggg=
X-Google-Smtp-Source: APXvYqwNdgeAj62u1OIM4ZH6Myi46IZp91Mpt/J/PwumYXy2YjoFOf4SGP39SS3l/H14ZyPGZZprpjkZ+1V/lSFqYQU=
X-Received: by 2002:a1c:3b08:: with SMTP id i8mr918652wma.56.1574226843058;
 Tue, 19 Nov 2019 21:14:03 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574155869.git.lucien.xin@gmail.com> <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
 <a84fb50a28d9a931e641924962eb05e8cfca12bf.1574155869.git.lucien.xin@gmail.com>
 <20191119162724.2ea1d240@cakuba.netronome.com>
In-Reply-To: <20191119162724.2ea1d240@cakuba.netronome.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 20 Nov 2019 13:15:00 +0800
Message-ID: <CADvbK_cuyBZW5D0PnkQrEQaOQVrWbt3DLdaOMvQkRgEh40NfOQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: sched: add erspan option support to act_tunnel_key
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 8:27 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 19 Nov 2019 17:31:47 +0800, Xin Long wrote:
> > @@ -149,6 +159,49 @@ tunnel_key_copy_vxlan_opt(const struct nlattr *nla, void *dst, int dst_len,
> >       return sizeof(struct vxlan_metadata);
> >  }
> >
> > +static int
> > +tunnel_key_copy_erspan_opt(const struct nlattr *nla, void *dst, int dst_len,
> > +                        struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX + 1];
> > +     int err;
> > +
> > +     err = nla_parse_nested(tb, TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX, nla,
> > +                            erspan_opt_policy, extack);
> > +     if (err < 0)
> > +             return err;
> > +
> > +     if (!tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER]) {
> > +             NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option ver");
> > +             return -EINVAL;
> > +     }
> > +
> > +     if (dst) {
> > +             struct erspan_metadata *md = dst;
> > +
> > +             nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER];
> > +             md->version = nla_get_u8(nla);
> > +
> > +             if (md->version == 1 &&
> > +                 tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX]) {
> > +                     nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX];
> > +                     md->u.index = nla_get_be32(nla);
> > +             } else if (md->version == 2 &&
> > +                        tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR] &&
> > +                        tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID]) {
> > +                     nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR];
> > +                     md->u.md2.dir = nla_get_u8(nla);
> > +                     nla = tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID];
> > +                     set_hwid(&md->u.md2, nla_get_u8(nla));
> > +             } else {
> > +                     NL_SET_ERR_MSG(extack, "erspan ver is incorrect or some option is missed");
>
> I think s/missed/missing/
ah right.

>
> But I think it'd be better if the validation was done also when dst is
> not yet allocated. I don't think it matters today, just think it'd be
> cleaner.
sure, I can improve in that way.

>
> > +                     return -EINVAL;
> > +             }
> > +     }
> > +
> > +     return sizeof(struct erspan_metadata);
> > +}
> > +
> >  static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
> >                               int dst_len, struct netlink_ext_ack *extack)
> >  {
> > @@ -190,6 +243,18 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
> >                       opts_len += opt_len;
> >                       type = TUNNEL_VXLAN_OPT;
> >                       break;
> > +             case TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN:
> > +                     if (type) {
> > +                             NL_SET_ERR_MSG(extack, "Wrong type for erspan options");
>
> Wrong or duplicate, right? If I'm reading this right unlike for Geneve
> opts there can be only one instance of opts for other types.
yes, 'Duplicate' is better,
will change to "Duplicate type for erspan options", as well as for vxlan.

Thanks.

>
> > +                             return -EINVAL;
> > +                     }
> > +                     opt_len = tunnel_key_copy_erspan_opt(attr, dst,
> > +                                                          dst_len, extack);
> > +                     if (opt_len < 0)
> > +                             return opt_len;
> > +                     opts_len += opt_len;
> > +                     type = TUNNEL_ERSPAN_OPT;
> > +                     break;
> >               }
> >       }
> >
