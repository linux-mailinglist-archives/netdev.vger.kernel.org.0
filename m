Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72FA104A57
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 06:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfKUFo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 00:44:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35092 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfKUFo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 00:44:27 -0500
Received: by mail-wr1-f68.google.com with SMTP id s5so2840119wrw.2
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 21:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tbZ2DgkcDRtkpLeFa1Gfqy/VCJPAij8Ut2rHp19eQiY=;
        b=dPzN8IosrGrvaxcdw09VmpLKVkmmIYKjvMT2826iQXrVGjLNwvO+0HPNLYPtQggxbu
         M/tfP9plKDPTyNnytZBXXLgJHZLK3Z0fNwl9vi8pcAyFo0KfAEWn1+2j7BKPlgjFQZn8
         ctUsyihPAumcxkeVO5J8AV3B++7eXyO+v20d1hscSsRUR+AlOwwd1QXh9S2UoF2d6hI1
         zUVJzd+u5fxEGzxPjL/JbTpjgmxxsPUWSVOiuL0u3GbIEM+q/xOP7eqHqDLWF8hQqgr8
         Jl6MkSQiLHmBaQbFD/GkY2H+rGdLXQ4+YEhEVE10TWZj6QwemHHcOaG6Rmc1FvVvxhhR
         /vUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tbZ2DgkcDRtkpLeFa1Gfqy/VCJPAij8Ut2rHp19eQiY=;
        b=c9g+9A8GztX+eK5enxH5hk9zHbfYUcs45DBJmKtT7MRhWHZbgfAeGBT07vBcS/+maT
         LoP9mcG47qRqNCKnIwaOHpOOILAB2mprUyePUjluNsMPAVt5dXxkDypR1sXgcJHKDZEa
         LI9GeY54DsKmroUhMIehPMl6lupRJCnfxluz4XkApqn3+R6TD4KTXIoE24Q7vVRugbaD
         1hLZMmBZhR1Xt/o2wVFhxLilfLqRWt6zN1rMHNdbzGbXhej3Gr9229wz2kV6WvV2yfGu
         mWhYuYjwmbxt44kSkF1DEWoh26m7gkiPQrArgy/Oa7gOcVZJLBVVtqYB3lAbfSboJYpA
         DADQ==
X-Gm-Message-State: APjAAAUYGonbMyMFasmN6MwrKNa6CteFURUZmGXauRtHaLy2Tn9T0+mD
        rwaAaDUAaaU/gO28MRDcEJPTm5kFwionJzcB5Iw=
X-Google-Smtp-Source: APXvYqxViwv7J9VlCLk4BBXx4ZVYCmMC8sLUHR1QrDf40QSaGzjPnOIoMiXKax6nrfErZ9av5Co0G271833XJIQR358=
X-Received: by 2002:a05:6000:18c:: with SMTP id p12mr8078821wrx.154.1574315064932;
 Wed, 20 Nov 2019 21:44:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574155869.git.lucien.xin@gmail.com> <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
 <20191119161241.5b010232@cakuba.netronome.com> <CADvbK_d8XrsVJvdwemxjTEQbA-MAcOeERtJ3GTPtUmZ_6foEdw@mail.gmail.com>
 <20191120091704.2d10ab90@cakuba.netronome.com>
In-Reply-To: <20191120091704.2d10ab90@cakuba.netronome.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 21 Nov 2019 13:45:25 +0800
Message-ID: <CADvbK_dbT5XTtUvu6qhk8JvH3UQYJN8bOPMTqmvi3mCEn+Yt1g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: sched: add vxlan option support to act_tunnel_key
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 1:17 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 20 Nov 2019 13:08:39 +0800, Xin Long wrote:
> > > >  static const struct nla_policy
> > > > @@ -64,6 +66,11 @@ geneve_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX + 1] = {
> > > >                                                      .len = 128 },
> > > >  };
> > > >
> > > > +static const struct nla_policy
> > > > +vxlan_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX + 1] = {
> > >
> > > [TCA_TUNNEL_KEY_ENC_OPT_VXLAN_UNSPEC] =
> > >         { .strict_type_start = TCA_TUNNEL_KEY_ENC_OPT_VXLAN_UNSPEC + 1, }
> > >
> > > > +     [TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]         = { .type = NLA_U32 },
> > > > +};
> > > > +
> > But vxlan_opt_policy is a new policy, and it will be parsed by
> > nla_parse_nested()
> > where NL_VALIDATE_STRICT has been used.
> >
> > .strict_type_start is used for setting NL_VALIDATE_STRICT for some new
> > option appending on an old policy.
> >
> > So I think .strict_type_start is not needed here.
>
> Hm, that's what I thought but then we were asked to add it in
> act_mpls.c. I should've checked the code.
>
> Anyway, we should probably clean up act_mpls.c and act_ct.c so people
> don't copy it unnecessarily.
will send a cleanup, also for the one in net/ipv4/nexthop.c.
Thanks.
