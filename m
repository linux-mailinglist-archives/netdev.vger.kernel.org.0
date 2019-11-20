Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60881032BA
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 06:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfKTFHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 00:07:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46081 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfKTFHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 00:07:45 -0500
Received: by mail-wr1-f67.google.com with SMTP id b3so26517541wrs.13
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 21:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CsQZiKVbBPsbLmt+OUP4P8aJLF2PFIPiOCWrAq5fOe8=;
        b=SzWTvvJNxnq2u6n0u5oXwgJkOZWbCqb+L/VEqVZr6smjDc12jwyXNF0WNKoTQdBXQp
         Nda2JX3KnxPu3R4rN3XArHI7Isyk9GV+75B13euMp63T1/OxEkewKJRwxfFIpwxzbUhG
         lKtmSD/ujHVo4tqJRrUYFSz4CmFpPY/X28jFRH6hmsTO5BCyReVOS3f+5P3cB/f/0d4n
         4F6shFW7CNMOwt9pBE6+Dd0UzO3J6lSPPSmJr7FePOE3nirka8z4qXW5gQFaNXcNJjVW
         /7fd3tVn7tEPkc/YTUwsiadJ+nDkm/agCMl+EhAfu8kaQFAJZKhuZdcBteooy1B/3b4y
         jg2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CsQZiKVbBPsbLmt+OUP4P8aJLF2PFIPiOCWrAq5fOe8=;
        b=MDao78BSC4zczqKeOOsM9BC4NPC+OholgS4Fu31sKmeYeTn71AtdZDdLP9aMvSWvAr
         zBKihdmpSjy30w/008WyA95Kzdmx3vfddWI33gWfeXMQ7N06r3v4vV//6pzhFx0LRG/b
         wYMy/3PFPnuPeEr6NjuX7GCdRFYvX8hSCWAFkyzdkMPVUGKPmW3lzCIhszu12NwJxUOJ
         RMzdXAtQDlZRzbbPMFUeDnKcOxicCQjG1oUfFcFvvOBG8+richOM9V40/TFXKxmGBlOK
         LT1UlXUgoP/oawiXZVQkTBL5mC/g9/MgM+5Lr6HqkZpKQIwwwy6gjwmbgWM805jfilK7
         PeTQ==
X-Gm-Message-State: APjAAAUjuo0elutcJEcqI/paXV1EH5X4u4z4cloQGCuAxzY/7l5LCGKi
        3lsGpF3Ax5j+6L8jXEQdDSz6z+ZSVaK+xJKmKKM=
X-Google-Smtp-Source: APXvYqy5A8gIq7Ki191ISPQ6LKNdxslvX/jNe+yKclHUvLN0i5jxIcdeWs5TR95vT7ybC758dDWqL+9xBsufxxLu31M=
X-Received: by 2002:adf:df0b:: with SMTP id y11mr758894wrl.282.1574226462644;
 Tue, 19 Nov 2019 21:07:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574155869.git.lucien.xin@gmail.com> <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
 <20191119161241.5b010232@cakuba.netronome.com>
In-Reply-To: <20191119161241.5b010232@cakuba.netronome.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 20 Nov 2019 13:08:39 +0800
Message-ID: <CADvbK_d8XrsVJvdwemxjTEQbA-MAcOeERtJ3GTPtUmZ_6foEdw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: sched: add vxlan option support to act_tunnel_key
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 8:12 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 19 Nov 2019 17:31:46 +0800, Xin Long wrote:
> > @@ -54,6 +55,7 @@ static int tunnel_key_act(struct sk_buff *skb, const struct tc_action *a,
> >  static const struct nla_policy
> >  enc_opts_policy[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1] = {
>
> [TCA_TUNNEL_KEY_ENC_OPTS_UNSPEC] =
>         { .strict_start_type = TCA_TUNNEL_KEY_ENC_OPTS_VXLAN, }
>
> >       [TCA_TUNNEL_KEY_ENC_OPTS_GENEVE]        = { .type = NLA_NESTED },
> > +     [TCA_TUNNEL_KEY_ENC_OPTS_VXLAN]         = { .type = NLA_NESTED },
> >  };
Agree, this one is necessary.

> >
> >  static const struct nla_policy
> > @@ -64,6 +66,11 @@ geneve_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX + 1] = {
> >                                                      .len = 128 },
> >  };
> >
> > +static const struct nla_policy
> > +vxlan_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX + 1] = {
>
> [TCA_TUNNEL_KEY_ENC_OPT_VXLAN_UNSPEC] =
>         { .strict_type_start = TCA_TUNNEL_KEY_ENC_OPT_VXLAN_UNSPEC + 1, }
>
> > +     [TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]         = { .type = NLA_U32 },
> > +};
> > +
But vxlan_opt_policy is a new policy, and it will be parsed by
nla_parse_nested()
where NL_VALIDATE_STRICT has been used.

.strict_type_start is used for setting NL_VALIDATE_STRICT for some new
option appending on an old policy.

So I think .strict_type_start is not needed here.

> >  static int
> >  tunnel_key_copy_geneve_opt(const struct nlattr *nla, void *dst, int dst_len,
> >                          struct netlink_ext_ack *extack)
