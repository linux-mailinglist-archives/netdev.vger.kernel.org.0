Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCFD24237E
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 02:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgHLAnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 20:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHLAnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 20:43:24 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2A4C06174A;
        Tue, 11 Aug 2020 17:43:23 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id a5so746899ioa.13;
        Tue, 11 Aug 2020 17:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0gxCB4LFN53sqzraQKq3UjqnGVcpUsM6dzmdWjPEs14=;
        b=AGwNrYDol6Qtfab4zHV6aV/y3MisWBpx2N2CEzY2APq2464W0eEnqfBhCjmuAZjADG
         Js1E0cqmmu811mG/+yLmTDePrk1iyuykjY+G34KjJvmHQtTOKXeN6oih4kJFPEGky2Vw
         E898E+UijVqxBPtt/65qEAXA9SO+Fa2/0SZ6/jQw6MVmnEh9Ylte4cxtiyPkoO7ZBRPH
         WdaeRNymra27WBeaMTdyhZJZbeWNXvcns8YTLopiZNacTgL8l9w+bFaINyCA7JLrzmAu
         5Y5l0Cvqu/ZMXCZuiRuNwjDlQmrqWOpH2GXsS1vYiyFaVw8lCcdyni2y4XZfxJmbpz02
         NnNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0gxCB4LFN53sqzraQKq3UjqnGVcpUsM6dzmdWjPEs14=;
        b=LLrCT2OeQwuo63gALe9mayXM9y6mpTy17VCR/ym+ibjnUuisyRg3YMyJnQSiDeEtf5
         ptAsQKqCIwdaxHyOk85bJpPYHSN7+kRsK/ZSkdPnvo72bsWUW3GMUjqjgNLpHyWphX6G
         2k0wMbqvV0zVQgydozs2SPMLx3cJhBCF+XsW7ML2w9kfsU6BZ6jZbYbO+80vNNcGkbJc
         STUMqQ57GIT/ks7rP6/EAAPFdZVUrEODshmn4ltO/pR1sDoBYIGD61d4luv6mA1tTvcU
         DlpZG3l0sFPboPU1YdCCD0Pse/S1abCwCfk03aNu6aQRDaEaLgcQWfIYp45Gxbx6v4Jp
         LBAA==
X-Gm-Message-State: AOAM533sbPTTiNTUIwDo84GUdGopULDwK4IXtT6zgEAK8CmT3ZARXg4b
        7dg9jTZLJ1mrLay2UjCXxkVqLpRn1R/hXGYd0ps=
X-Google-Smtp-Source: ABdhPJylObqqKs64qR0L8Wbrv0/Una9oMdhXKPYux6BBMYXRA+z0MUNupme7j/RsGqRvs58DUmc2GIXhcgrHHwyPiz8=
X-Received: by 2002:a05:6602:1d6:: with SMTP id w22mr9619879iot.64.1597193002988;
 Tue, 11 Aug 2020 17:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com> <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
 <20200807222015.GZ4295@paulmck-ThinkPad-P72> <20200810200859.GF2865655@google.com>
 <20200810202813.GP4295@paulmck-ThinkPad-P72> <CAMDZJNWrPf8AkZE8496g6v5GXvLUbQboXeAhHy=1U1Qhemo8bA@mail.gmail.com>
 <CAM_iQpXBHSYdqb8Q3ifG8uwa1YfJmGBexHC2BusRoshU0M5X5g@mail.gmail.com>
 <CAMDZJNU5Cpkcrn5sy=7u_vTGcdMjDfCqzSCJ0WLk-3M5RROh=Q@mail.gmail.com>
 <CAM_iQpVoHtQn07j9wHp7Qj3XkU8SYFdYzaexx6jeBH5mqYNw6A@mail.gmail.com> <CAMDZJNX2G2dOkqFv52ztBMM5CZCY4b0rSz-knv4GY2JP9kbDmg@mail.gmail.com>
In-Reply-To: <CAMDZJNX2G2dOkqFv52ztBMM5CZCY4b0rSz-knv4GY2JP9kbDmg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 11 Aug 2020 17:43:11 -0700
Message-ID: <CAM_iQpWTdfrPvYQNa5sbq44+a0Qu3R4qKu=dmErsHQMOJGXuOw@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>,
        Gregory Rose <gvrose8192@gmail.com>,
        bugs <bugs@openvswitch.org>, Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 10:59 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Tue, Aug 11, 2020 at 12:08 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, Aug 10, 2020 at 8:27 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > On Tue, Aug 11, 2020 at 10:24 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > On Mon, Aug 10, 2020 at 6:16 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > Hi all, I send a patch to fix this. The rcu warnings disappear. I
> > > > > don't reproduce the double free issue.
> > > > > But I guess this patch may address this issue.
> > > > >
> > > > > http://patchwork.ozlabs.org/project/netdev/patch/20200811011001.75690-1-xiangxia.m.yue@gmail.com/
> > > >
> > > > I don't see how your patch address the double-free, as we still
> > > > free mask array twice after your patch: once in tbl_mask_array_realloc()
> > > > and once in ovs_flow_tbl_destroy().
> > > Hi Cong.
> > > Before my patch, we use the ovsl_dereference
> > > (rcu_dereference_protected) in the rcu callback.
> > > ovs_flow_tbl_destroy
> > > ->table_instance_destroy
> > > ->table_instance_flow_free
> > > ->flow_mask_remove
> > > ASSERT_OVSL(will print warning)
> > > ->tbl_mask_array_del_mask
> > > ovsl_dereference(rcu usage warning)
> > >
> >
> > I understand how your patch addresses the RCU annotation issue,
> > which is different from double-free.
> >
> >
> > > so we should invoke the table_instance_destroy or others under
> > > ovs_lock to avoid (ASSERT_OVSL and rcu usage warning).
> >
> > Of course... I never doubt it.
> >
> >
> > > with this patch, we reallocate the mask_array under ovs_lock, and free
> > > it in the rcu callback. Without it, we  reallocate and free it in the
> > > rcu callback.
> > > I think we may fix it with this patch.
> >
> > Does it matter which context tbl_mask_array_realloc() is called?
> > Even with ovs_lock, we can still double free:
> >
> > ovs_lock()
> > tbl_mask_array_realloc()
> >  => call_rcu(&old->rcu, mask_array_rcu_cb);
> > ovs_unlock()
> > ...
> > ovs_flow_tbl_destroy()
> >  => call_rcu(&old->rcu, mask_array_rcu_cb);
> >
> > So still twice, right? To fix the double-free, we have to eliminate one
> > of them, don't we? ;)
> No
> Without my patch: in rcu callback:
> ovs_flow_tbl_destroy
> ->call_rcu(&ma->rcu, mask_array_rcu_cb);
> ->table_instance_destroy
> ->tbl_mask_array_realloc(Shrink the mask array if necessary)
> ->call_rcu(&old->rcu, mask_array_rcu_cb);
>
> With the patch:
> ovs_lock
> table_instance_flow_flush (free the flow)
> tbl_mask_array_realloc(shrink the mask array if necessary, will free
> mask_array in rcu(mask_array_rcu_cb) and rcu_assign_pointer new
> mask_array)
> ovs_unlock
>
> in rcu callback:
> ovs_flow_tbl_destroy
> call_rcu(&ma->rcu, mask_array_rcu_cb);(that is new mask_array)

Ah, I see, I thought the mask array was cached in caller and passed along,
it is in fact refetched via &dp->table.

Thanks.
