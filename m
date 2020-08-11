Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC80241FAB
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 20:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgHKS2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 14:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgHKS2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 14:28:16 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343F2C061787
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 11:28:16 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k8so3784893wma.2
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 11:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nazLfjeHIm0CIJ86cp1U5OrCy+yCaz0xLbKkAoevkG4=;
        b=iiA8txfUaJMI1jTicmhP2KFThzv4LMSTKgw/wYwwTbEYQt/AQ1C9o4n60LjavxkRkV
         TQg0eLGyfDVH7nVGMl+VbyIm6jueILkIqbC/ZzC/MtZOLNbbdo44OS1QJVp3nDF9nc2V
         cbT6btxCXWc9BJ8YoF1fn4YE070zhDeNDv2thif3XZFvIDjjZuRB1NTkbFDrkDqyYhnA
         ED7uQ9DwA52Qc14KCQGVVxzDK95on5z2t1Jgz11mMMCQZY0XTl0qj75/PR0ihxzEm74+
         gUddiu9ZVxuikkXNDwgcVH41GVQa8kHBQfrycMwIbvkPFmrBdEe/wYyroimTiKXvolRF
         09fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nazLfjeHIm0CIJ86cp1U5OrCy+yCaz0xLbKkAoevkG4=;
        b=OSXEpUzPQDR9iv0AX+01UDMb2Rbz3nOam5E0PjhQP3O9UhhyO3dqZsPjdi517Tc0fK
         iIkwPvr0SqcPfML4Usp9XyxU2ERC9fD4Wjea79//wem+RebEyPnqxWxXKPoaa6OgS7E2
         GJS3+d/lkCoGX32fmzIJ56csA7MYKnBbH5l/gc5VwEzPUUpWivSmbvw7dV4Ggmi4Nd+/
         ECVpo/80ElKErgBdftE6P7eos6S73vgaVGJv50hg6yvGrQPP7WVqCSEB42Y1K5QOi8Y6
         QQnU4m+GB83umt7b7BB/lSlWYXuzfO1IqEFIpKCXm5GWA4MziNsw4C1qqxM04FhncXy7
         Jn2w==
X-Gm-Message-State: AOAM532FIcLGIb8Oz8FeTjQZxYso7Yt5r2j//QvqFasEt3OJszuN+iEF
        edYQSaVTxe5s34+1a1ubckqv7fXYbEXzULYv1CLS
X-Google-Smtp-Source: ABdhPJz+PvMify1pGrVbQeyMI2tNhi9anNMz9m9stI84KLSO5Q8qG2GVYs3WoNjjPlMtX2swM1hMfyZbYhu3BZzc8ZQ=
X-Received: by 2002:a7b:c765:: with SMTP id x5mr4886729wmk.14.1597170494689;
 Tue, 11 Aug 2020 11:28:14 -0700 (PDT)
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
From:   =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>
Date:   Tue, 11 Aug 2020 11:28:03 -0700
Message-ID: <CA+Sh73M=Wwf=tzcb7WeSbLFzaARAvgCC1CFaZKKEA5kr17_BAw@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
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
>
> >
> > >
> > > > Have you tried my patch which is supposed to address this double-free?
> > > I don't reproduce it. but your patch does not avoid ruc usage warning
> > > and ASSERT_OVSL.
> >
> > Sure, I never intend to fix anything else but double-free. The $subject is
> > about double free, I double checked. ;)
> >
> > Thanks.
>
>
>
> --
> Best regards, Tonghao

Cong and Tonghao, thanks for your patches. I cannot repro the double
free with either of them, and the "suspicious RCU usage" and the
ASSERT_OVSL warnings are also gone with Tonghao's patch.

Tonghao, from your sequence above it looks like it should fix the
https://elixir.bootlin.com/linux/v5.5.17/source/kernel/rcu/tree.c#L2239
warning, correct?
