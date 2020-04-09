Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824611A3CD9
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 01:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgDIX3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 19:29:50 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33378 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgDIX3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 19:29:50 -0400
Received: by mail-qk1-f195.google.com with SMTP id v7so649994qkc.0
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 16:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vs87zv/iWBnClPXMz+jzKJQ2DRXy9nbM7aEmSyZ5V+c=;
        b=RWhGmB0PiitQrTBlCniHf3ni9W7nPwzMKNcBb3O5eoLjEyaaqFxG/uRik4h+3NMRjB
         IuksVP6RS0oblQEc9fSfNscnyAud0/n1nzfw6AaR2iT4jkpbiukpj+29tIZ6N1h1OGJi
         dWr8BZ8zKPGtm5mhTI99vBnacdWZ+V028VI4pBeiKjuix/RZ3b12ED4f1KnB74tiyI7/
         khG4ScdGJ9kMTKvkg8RU8simWA0ydrIcNpm29d+hCTPWwKOjF10PawSNXoGUMvYBKXOk
         eJC1PX7zRIqK6SZ8Ew1TJTubz0+/Y3GcWVqTi1sD81LYwboPEs4MFmNEAYsViDSLSGQC
         UDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vs87zv/iWBnClPXMz+jzKJQ2DRXy9nbM7aEmSyZ5V+c=;
        b=HN/4ovp40MUZxkvQydSiMuQB8wj7dc7B4YD5Zh/E25pjAVFxFexIHFmnTB3TYb00zm
         Ni+vc0QzNW8TPv0bmfnALYE1nh5thuGbaqkFuSmQ7DMAhGV+G7zBJwbTA0MtI7u25l4h
         HmUSu5oHYwgYk6fMaAl2lBQpCZa1JQiRxQruV+2ttPtb/ja3yGRsUm3b/Y06GuCE5yjf
         RJBAZwEc1z3KHzBpnhzNYV37OvUX8apjNw1chNk1ddJ0K5YxF+DOGVXnVpXVQQ4OIaM1
         uQMvzKbOgpbsrEtI9TLD1sP6gQUUGziI87yBBlNTw9M2NDdqlv6b5Ltmywlb/fDbqSbE
         2j6Q==
X-Gm-Message-State: AGi0PubzfMDyzwStgQfbniSsrXeSIm9rDBg+SMMweNlLVHNOtdaYkMTT
        nDPC6n2QdJE9jAoqkKKr7gdnWcf1zWfDADflaRySXBIP
X-Google-Smtp-Source: APiQypLRF0pHRHFLba/DYLrLeGU3vE0VoLb+bOjSVWiLApvGU/iC/st9fmyRACw12Zv5MoTdUPuhmmBGAjaWYKy3zv8=
X-Received: by 2002:a37:bc81:: with SMTP id m123mr1387455qkf.319.1586474987896;
 Thu, 09 Apr 2020 16:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_BZ2Sqjooc9u1osbrEsbL5w003CL54v_bd3YPcqkjOzjg@mail.gmail.com>
 <CAMDZJNV1+zA9EGRMDrZDBNxTg3fr+4ZeH7bcLgfVginx3p4Cww@mail.gmail.com>
 <CAOrHB_Bw1cUANoKe_1ZeGQkVVX6rj5YPTzzcNUjv3_KKRWehdQ@mail.gmail.com>
 <CAMDZJNWHaQ_fYPdjC0hhQZbr_vXReDXeA5TgFNHy8SG79SzU1g@mail.gmail.com>
 <20200408150916.GA54720@gmail.com> <CAMDZJNUHLM5nx_ek1uJO4MkPNDoD4Or+SZKVry0+dPkq--VGGg@mail.gmail.com>
 <20200409214142.GB85978@gmail.com>
In-Reply-To: <20200409214142.GB85978@gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 10 Apr 2020 07:29:11 +0800
Message-ID: <CAMDZJNX8v4_=0qzHTTS_9x=0bBoM=_ihpsTdaeSZ30n=DpR3bw@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v1 1/3] net: openvswitch: expand the
 meters number supported
To:     William Tu <u9012063@gmail.com>
Cc:     Pravin Shelar <pshelar@ovn.org>, ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 5:41 AM William Tu <u9012063@gmail.com> wrote:
>
> On Wed, Apr 08, 2020 at 11:59:25PM +0800, Tonghao Zhang wrote:
> > On Wed, Apr 8, 2020 at 11:09 PM William Tu <u9012063@gmail.com> wrote:
> > >
> > > On Wed, Apr 01, 2020 at 06:50:09PM +0800, Tonghao Zhang wrote:
> > > > On Tue, Mar 31, 2020 at 11:57 AM Pravin Shelar <pshelar@ovn.org> wrote:
> > > > >
> > > > > On Sun, Mar 29, 2020 at 5:35 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Mar 30, 2020 at 12:46 AM Pravin Shelar <pshelar@ovn.org> wrote:
> > > > > > >
> > > > > > > On Sat, Mar 28, 2020 at 8:46 AM <xiangxia.m.yue@gmail.com> wrote:
> > > > > > > >
> > > > > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > > >
> > > > > > > > In kernel datapath of Open vSwitch, there are only 1024
> > > > > > > > buckets of meter in one dp. If installing more than 1024
> > > > > > > > (e.g. 8192) meters, it may lead to the performance drop.
> > > > > > > > But in some case, for example, Open vSwitch used as edge
> > > > > > > > gateway, there should be 200,000+ at least, meters used for
> > > > > > > > IP address bandwidth limitation.
> > > > > > > >
> > > > > > > > [Open vSwitch userspace datapath has this issue too.]
> > > > > > > >
> > > > > > > > For more scalable meter, this patch expands the buckets
> > > > > > > > when necessary, so we can install more meters in the datapath.
> > > > > > > >
> > > > > > > > * Introducing the struct *dp_meter_instance*, it's easy to
> > > > > > > >   expand meter though change the *ti* point in the struct
> > > > > > > >   *dp_meter_table*.
> > > > > > > > * Using kvmalloc_array instead of kmalloc_array.
> > > > > > > >
> > > > > > > Thanks for working on this, I have couple of comments.
> > > > > > >
> > > > > > > > Cc: Pravin B Shelar <pshelar@ovn.org>
> > > > > > > > Cc: Andy Zhou <azhou@ovn.org>
> > > > > > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > > > ---
> > > > > > > >  net/openvswitch/datapath.h |   2 +-
> > > > > > > >  net/openvswitch/meter.c    | 168 ++++++++++++++++++++++++++++++-------
> > > > > > > >  net/openvswitch/meter.h    |  17 +++-
> > > > > > > >  3 files changed, 153 insertions(+), 34 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> > > > > > > > index e239a46c2f94..785105578448 100644
> > > > > > > > --- a/net/openvswitch/datapath.h
> > > > > > > > +++ b/net/openvswitch/datapath.h
> > > > > > > > @@ -82,7 +82,7 @@ struct datapath {
> > > > > > > >         u32 max_headroom;
> > > > > > > >
> > > > > > > >         /* Switch meters. */
> > > > > > > > -       struct hlist_head *meters;
> > > > > > > > +       struct dp_meter_table *meters;
> > > > > > > >  };
> > > > > > > >
> > > > > > > >  /**
> > > > > > > > diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> > > > > > > > index 5010d1ddd4bd..98003b201b45 100644
> > > > > > > > --- a/net/openvswitch/meter.c
> > > > > > > > +++ b/net/openvswitch/meter.c
> > > > > > > > @@ -47,40 +47,136 @@ static void ovs_meter_free(struct dp_meter *meter)
> > > > > > > >         kfree_rcu(meter, rcu);
> > > > > > > >  }
> > > > > > > >
> > > > > > > > -static struct hlist_head *meter_hash_bucket(const struct datapath *dp,
> > > > > > > > +static struct hlist_head *meter_hash_bucket(struct dp_meter_instance *ti,
> > > > > > > >                                             u32 meter_id)
> > > > > > > >  {
> > > > > > > > -       return &dp->meters[meter_id & (METER_HASH_BUCKETS - 1)];
> > > > > > > > +       u32 hash = jhash_1word(meter_id, ti->hash_seed);
> > > > > > > > +
> > > > > > > I do not see any need to hash meter-id, can you explain it.
> > > > > > >
> > > > > > > > +       return &ti->buckets[hash & (ti->n_buckets - 1)];
> > > > > > > >  }
> > > > > > > >
> > > > > > > >  /* Call with ovs_mutex or RCU read lock. */
> > > > > > > > -static struct dp_meter *lookup_meter(const struct datapath *dp,
> > > > > > > > +static struct dp_meter *lookup_meter(const struct dp_meter_table *tbl,
> > > > > > > >                                      u32 meter_id)
> > > > > > > >  {
> > > > > > > > +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> > > > > > > >         struct dp_meter *meter;
> > > > > > > >         struct hlist_head *head;
> > > > > > > >
> > > > > > > > -       head = meter_hash_bucket(dp, meter_id);
> > > > > > > > -       hlist_for_each_entry_rcu(meter, head, dp_hash_node,
> > > > > > > > -                               lockdep_ovsl_is_held()) {
> > > > > > > > +       head = meter_hash_bucket(ti, meter_id);
> > > > > > > > +       hlist_for_each_entry_rcu(meter, head, hash_node[ti->node_ver],
> > > > > > > > +                                lockdep_ovsl_is_held()) {
> > > > > > > >                 if (meter->id == meter_id)
> > > > > > > >                         return meter;
> > > > > > > >         }
> > > > > > > > +
> > > > > > > This patch is expanding meter table linearly with number meters added
> > > > > > > to datapath. so I do not see need to have hash table. it can be a
> > > > > > > simple array. This would also improve lookup efficiency.
> > > > > > > For hash collision we could find next free slot in array. let me know
> > > > > > > what do you think about this approach.
> > > > > > Hi Pravin
> > > > > > If we use the simple array, when inserting the meter, for hash collision, we can
> > > > > > find next free slot, but one case, when there are many meters in the array.
> > > > > > we may find many slot for the free slot.
> > > > > > And when we lookup the meter, for hash collision, we may find many
> > > > > > array slots, and
> > > > > > then find it, or that meter does not exist in the array, In that case,
> > > > > > there may be a lookup performance
> > > > > > drop.
> > > > > >
> > > > > I was thinking that users can insure that there are no hash collision,
> > > > > but time complexity of negative case is expensive. so I am fine with
> > > > > the hash table.
> > >
> > > IIUC, there will be hash collision. meter id is an 32-bit value.
> > > Currenly in lib/dpif-netdev.c, MAX_METERS = 65536.
> > Hi, William
> > but id-pool makes sure the meter id is from 0, 1, 2, 3 ... n, but not n, m, y.
> > so if we alloc 1024 meters, the last meter id should be 1023, and then
> > use the simple array to expand the meter is better ?
> >
>
> I see, so you want to set the # of hash bucket = max # of meter id,
> so there is no hash collision, (with the cost of using more memory)
Not really, there are 1024 buckets as default, and will expand to
1024*2, and then 1024*2*2  if necessary
if the most meter is deleted, we will shrink it.

> I don't have strong opinion on which design is better. Let's wait for
> Pravin's feedback.
>
> William
>
> > > I think what Pravin suggest is to use another hash function to make
> > > the hash table more condense. Ex: hash1 and hash2.
> > > For lookup, if hash1(key) misses, then try hash2(key).
> > >
> > > William
> > >
> > > > Hi Pravi
> > > > I check again the meter implementation of ovs, ovs-vswitchd use the id-pool to
> > > > get a valid meter-id which passed to kernel, so there is no hash collision. You
> > > > are right. we use the single array is the better solution.
> > > > > > For hash meter-id in meter_hash_bucket, I am not 100% sure it is
> > > > > > useful. it just update
> > > > > > hash_seed when expand meters. For performance, we can remove it. Thanks.
> > > > > ok.
>


-- 
Best regards, Tonghao
