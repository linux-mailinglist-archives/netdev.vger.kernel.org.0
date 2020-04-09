Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD6B1A3C04
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 23:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgDIVlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 17:41:47 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36575 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgDIVlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 17:41:47 -0400
Received: by mail-pj1-f65.google.com with SMTP id nu11so28207pjb.1
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 14:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RrRLlUuJMnJfwYJTvK2eu49g1IM+2aCCt5ehFOumNlc=;
        b=gN4VBkEkAa3dgIGm49jtmXXe4d37A4pJyVjBjXXdL4/vCzisSjR6g3F1Hh9tO+Z++x
         wt1yZyb4DiEaTkHVZPIf3D4Zb4PyRfN0FKJWcCk1Dvrch2GSecvx0KkXcINuLU0NI8ow
         2xT8zP8Brz3h0WKZ3qMijZv+hSnDUBtXPyBh9tJ5w7wCuac/edMD0CVYztKSj1qukfCm
         5YH5CTSPdK04+sbrZTsiRDgvAcs2AmW7N0lb7U6sMywi5h5+oEXD2VlQWMS685yY7jJc
         RkgkgrcaVqew8mOYp6E4nx0avEHhL9F3cI3zw/dTYndoWDcGyrSxXM/O6YYjHN6jsEnC
         lA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RrRLlUuJMnJfwYJTvK2eu49g1IM+2aCCt5ehFOumNlc=;
        b=czUvin8zbF0MFM6XXlJP1dXDH0hDmkx5PqHOlljaS4xFswUBV8+UeNm5jhyAjlYGHK
         mczwJBOAc18/3+MaO4vr9vDfSiTDZQ9KAkJTgRWIqzA/X92LCXSRSnEW06dCmOBEvjaq
         1ejGQ/2DaHVVUrctRAdPcbcPGq2737b7l2p5FBkxtEprwgbh83hBm+DwV8nT8/+g3IAg
         8tAj1lffaVlc7V8DR2lgK0a/6aON292RXjoP2zGTsx0DX1jvsP5Lwf4fKu004AoKTeMJ
         Q3R1f9LBn/qjihcYNIWN6/U4NqdPno5DlpoAIov1JtUHIf1W5gb1Pv/D9szQwlYgc65w
         E7Qg==
X-Gm-Message-State: AGi0PuZlgz+cbcrCMFFLahuAByr7vmwdRfXuzcEqMN7mfy3DY6Yk/mGK
        sSBLb7NgXTuC8ObQ6VGQiIXSYDFQ
X-Google-Smtp-Source: APiQypJRBqnWEmut/ZQBI6I5lMWfInvdYgBSfGV3YgEVv4mJVjm0MyoOBMHvxsxyAxNTnR0PJQpCmA==
X-Received: by 2002:a17:90a:3589:: with SMTP id r9mr1667346pjb.196.1586468506028;
        Thu, 09 Apr 2020 14:41:46 -0700 (PDT)
Received: from gmail.com (c-76-21-95-192.hsd1.ca.comcast.net. [76.21.95.192])
        by smtp.gmail.com with ESMTPSA id u13sm108571pjb.45.2020.04.09.14.41.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Apr 2020 14:41:45 -0700 (PDT)
Date:   Thu, 9 Apr 2020 14:41:42 -0700
From:   William Tu <u9012063@gmail.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Pravin Shelar <pshelar@ovn.org>, ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [ovs-dev] [PATCH net-next v1 1/3] net: openvswitch: expand the
 meters number supported
Message-ID: <20200409214142.GB85978@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_BZ2Sqjooc9u1osbrEsbL5w003CL54v_bd3YPcqkjOzjg@mail.gmail.com>
 <CAMDZJNV1+zA9EGRMDrZDBNxTg3fr+4ZeH7bcLgfVginx3p4Cww@mail.gmail.com>
 <CAOrHB_Bw1cUANoKe_1ZeGQkVVX6rj5YPTzzcNUjv3_KKRWehdQ@mail.gmail.com>
 <CAMDZJNWHaQ_fYPdjC0hhQZbr_vXReDXeA5TgFNHy8SG79SzU1g@mail.gmail.com>
 <20200408150916.GA54720@gmail.com>
 <CAMDZJNUHLM5nx_ek1uJO4MkPNDoD4Or+SZKVry0+dPkq--VGGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMDZJNUHLM5nx_ek1uJO4MkPNDoD4Or+SZKVry0+dPkq--VGGg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 11:59:25PM +0800, Tonghao Zhang wrote:
> On Wed, Apr 8, 2020 at 11:09 PM William Tu <u9012063@gmail.com> wrote:
> >
> > On Wed, Apr 01, 2020 at 06:50:09PM +0800, Tonghao Zhang wrote:
> > > On Tue, Mar 31, 2020 at 11:57 AM Pravin Shelar <pshelar@ovn.org> wrote:
> > > >
> > > > On Sun, Mar 29, 2020 at 5:35 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > >
> > > > > On Mon, Mar 30, 2020 at 12:46 AM Pravin Shelar <pshelar@ovn.org> wrote:
> > > > > >
> > > > > > On Sat, Mar 28, 2020 at 8:46 AM <xiangxia.m.yue@gmail.com> wrote:
> > > > > > >
> > > > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > >
> > > > > > > In kernel datapath of Open vSwitch, there are only 1024
> > > > > > > buckets of meter in one dp. If installing more than 1024
> > > > > > > (e.g. 8192) meters, it may lead to the performance drop.
> > > > > > > But in some case, for example, Open vSwitch used as edge
> > > > > > > gateway, there should be 200,000+ at least, meters used for
> > > > > > > IP address bandwidth limitation.
> > > > > > >
> > > > > > > [Open vSwitch userspace datapath has this issue too.]
> > > > > > >
> > > > > > > For more scalable meter, this patch expands the buckets
> > > > > > > when necessary, so we can install more meters in the datapath.
> > > > > > >
> > > > > > > * Introducing the struct *dp_meter_instance*, it's easy to
> > > > > > >   expand meter though change the *ti* point in the struct
> > > > > > >   *dp_meter_table*.
> > > > > > > * Using kvmalloc_array instead of kmalloc_array.
> > > > > > >
> > > > > > Thanks for working on this, I have couple of comments.
> > > > > >
> > > > > > > Cc: Pravin B Shelar <pshelar@ovn.org>
> > > > > > > Cc: Andy Zhou <azhou@ovn.org>
> > > > > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > > ---
> > > > > > >  net/openvswitch/datapath.h |   2 +-
> > > > > > >  net/openvswitch/meter.c    | 168 ++++++++++++++++++++++++++++++-------
> > > > > > >  net/openvswitch/meter.h    |  17 +++-
> > > > > > >  3 files changed, 153 insertions(+), 34 deletions(-)
> > > > > > >
> > > > > > > diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> > > > > > > index e239a46c2f94..785105578448 100644
> > > > > > > --- a/net/openvswitch/datapath.h
> > > > > > > +++ b/net/openvswitch/datapath.h
> > > > > > > @@ -82,7 +82,7 @@ struct datapath {
> > > > > > >         u32 max_headroom;
> > > > > > >
> > > > > > >         /* Switch meters. */
> > > > > > > -       struct hlist_head *meters;
> > > > > > > +       struct dp_meter_table *meters;
> > > > > > >  };
> > > > > > >
> > > > > > >  /**
> > > > > > > diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> > > > > > > index 5010d1ddd4bd..98003b201b45 100644
> > > > > > > --- a/net/openvswitch/meter.c
> > > > > > > +++ b/net/openvswitch/meter.c
> > > > > > > @@ -47,40 +47,136 @@ static void ovs_meter_free(struct dp_meter *meter)
> > > > > > >         kfree_rcu(meter, rcu);
> > > > > > >  }
> > > > > > >
> > > > > > > -static struct hlist_head *meter_hash_bucket(const struct datapath *dp,
> > > > > > > +static struct hlist_head *meter_hash_bucket(struct dp_meter_instance *ti,
> > > > > > >                                             u32 meter_id)
> > > > > > >  {
> > > > > > > -       return &dp->meters[meter_id & (METER_HASH_BUCKETS - 1)];
> > > > > > > +       u32 hash = jhash_1word(meter_id, ti->hash_seed);
> > > > > > > +
> > > > > > I do not see any need to hash meter-id, can you explain it.
> > > > > >
> > > > > > > +       return &ti->buckets[hash & (ti->n_buckets - 1)];
> > > > > > >  }
> > > > > > >
> > > > > > >  /* Call with ovs_mutex or RCU read lock. */
> > > > > > > -static struct dp_meter *lookup_meter(const struct datapath *dp,
> > > > > > > +static struct dp_meter *lookup_meter(const struct dp_meter_table *tbl,
> > > > > > >                                      u32 meter_id)
> > > > > > >  {
> > > > > > > +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> > > > > > >         struct dp_meter *meter;
> > > > > > >         struct hlist_head *head;
> > > > > > >
> > > > > > > -       head = meter_hash_bucket(dp, meter_id);
> > > > > > > -       hlist_for_each_entry_rcu(meter, head, dp_hash_node,
> > > > > > > -                               lockdep_ovsl_is_held()) {
> > > > > > > +       head = meter_hash_bucket(ti, meter_id);
> > > > > > > +       hlist_for_each_entry_rcu(meter, head, hash_node[ti->node_ver],
> > > > > > > +                                lockdep_ovsl_is_held()) {
> > > > > > >                 if (meter->id == meter_id)
> > > > > > >                         return meter;
> > > > > > >         }
> > > > > > > +
> > > > > > This patch is expanding meter table linearly with number meters added
> > > > > > to datapath. so I do not see need to have hash table. it can be a
> > > > > > simple array. This would also improve lookup efficiency.
> > > > > > For hash collision we could find next free slot in array. let me know
> > > > > > what do you think about this approach.
> > > > > Hi Pravin
> > > > > If we use the simple array, when inserting the meter, for hash collision, we can
> > > > > find next free slot, but one case, when there are many meters in the array.
> > > > > we may find many slot for the free slot.
> > > > > And when we lookup the meter, for hash collision, we may find many
> > > > > array slots, and
> > > > > then find it, or that meter does not exist in the array, In that case,
> > > > > there may be a lookup performance
> > > > > drop.
> > > > >
> > > > I was thinking that users can insure that there are no hash collision,
> > > > but time complexity of negative case is expensive. so I am fine with
> > > > the hash table.
> >
> > IIUC, there will be hash collision. meter id is an 32-bit value.
> > Currenly in lib/dpif-netdev.c, MAX_METERS = 65536.
> Hi, William
> but id-pool makes sure the meter id is from 0, 1, 2, 3 ... n, but not n, m, y.
> so if we alloc 1024 meters, the last meter id should be 1023, and then
> use the simple array to expand the meter is better ?
> 

I see, so you want to set the # of hash bucket = max # of meter id,
so there is no hash collision, (with the cost of using more memory)
I don't have strong opinion on which design is better. Let's wait for
Pravin's feedback.

William

> > I think what Pravin suggest is to use another hash function to make
> > the hash table more condense. Ex: hash1 and hash2.
> > For lookup, if hash1(key) misses, then try hash2(key).
> >
> > William
> >
> > > Hi Pravi
> > > I check again the meter implementation of ovs, ovs-vswitchd use the id-pool to
> > > get a valid meter-id which passed to kernel, so there is no hash collision. You
> > > are right. we use the single array is the better solution.
> > > > > For hash meter-id in meter_hash_bucket, I am not 100% sure it is
> > > > > useful. it just update
> > > > > hash_seed when expand meters. For performance, we can remove it. Thanks.
> > > > ok.

