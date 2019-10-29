Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4918AE8727
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 12:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfJ2LbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 07:31:20 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34970 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfJ2LbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 07:31:20 -0400
Received: by mail-oi1-f195.google.com with SMTP id n16so6346483oig.2
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 04:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N2Vs3cRRCc6B5vK67euaImf60RIslPFTMeoJVQCsjKA=;
        b=JebjQDXtvFYK/dXO6St7oLssHDJft9yXmCqh/8DABSWzkrd1Fp3TCbYcdSi85FHcf4
         iVQHZy7LxiSSvv47Lt0+xF9I1qUyAddtdj7FcwmQiPxsmS8brV9DvBY0bVD8xYIOCCv1
         dn+X5MdzcG6Dp8NeRoGf5pyE50xlada5clH24H9W/Hkjk8RPo8yS9UbkkANgwKlefpqx
         pk8IljRa+GJbQTemc0gpS/QS9F6BvCHuclV70KcrFH8uy2nOYCyGw2hy+Q6QWXuYNezC
         zHHvroNybmCa4U5LKm7h0zMoBsvqrbTJv+ookHYFWFjo1fNFq/2TxSxTjP6gdm0aQc8D
         Y04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N2Vs3cRRCc6B5vK67euaImf60RIslPFTMeoJVQCsjKA=;
        b=iEjK39CJ3b8dqSCZ0VTha9SH5WAk9Gpj+cT1KjU0VD8dpwl0eKSlIsLxvMaXkEGTeO
         ckHNpGD6y7xTXsOEFkgCN9xHVxyhXgYV+/9FtMHSa7E7aXHgv8pQSzW+lRJqEAxTjGQf
         IdLWqHmgesPKQgcX5+YorYDEynXoiuqkBgbZolim0d1Y0L94RccrY0l2qCSY9jVmmM3p
         uZKH2/pK2T7YSPNrRZJw88yGdNsEl/7sM9SQgCUCAjvaEyfV4kicJYx+oNWdfYVDAxXx
         v9LVXAb2l1hzlio7Ca455zV1RGhY+FatGbRkeDxgr3vy5cuwSv9u4BDhuORwq+LEUt96
         S9Ig==
X-Gm-Message-State: APjAAAVk5/iELTGamsNZXfFwlY7Q19D2708nRMH3UfonGfqjxNZbeanH
        Vb/E7WD6JowE7PPlemUQdtxOpKXIuW0RaDS8nIM=
X-Google-Smtp-Source: APXvYqy22d5E6+14qpzpvArfvgmmYL/W1BG634SoQee31VCd9KZsbQslS4px6uWQrszPxxgCh/IWoQnSPePZYv81P7Q=
X-Received: by 2002:aca:b503:: with SMTP id e3mr3624288oif.177.1572348679120;
 Tue, 29 Oct 2019 04:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com>
 <CAMDZJNWD=a+EBneEU-qs3pzXSBoOdzidn5cgOKs-y8G0UWvbnA@mail.gmail.com>
 <CAOrHB_BqGdFmmzTEPxejt0QXmyC_QtAXG=S8kzKi=3w-PacwUw@mail.gmail.com>
 <CAMDZJNXdu3R_GkHEBbwycEpe0wnwNmGzHx-8gUxtwiW1mEy7uw@mail.gmail.com>
 <CAOrHB_DdMX7sZkk79esdZkmb8RGaX_XiMAxhGz1LgWx50eFD9g@mail.gmail.com>
 <CAMDZJNVfyzmnd4qhp_esE-s3+-z8K=6tBP63X+SCEcjBon60eQ@mail.gmail.com>
 <CAOrHB_CnpcQoztqnfBkaDhTCK5nti8agtRmbbzZH+BfrPpiZ1g@mail.gmail.com>
 <CAMDZJNWeUoXD9SOBXfWes7Xk=BLRPs1iti+Kwz7YfC0NSE6oig@mail.gmail.com> <CAOrHB_BADQMdhFk4a8BJ0qaUeLf+2+H=cLf9q80U2g1AxewY2A@mail.gmail.com>
In-Reply-To: <CAOrHB_BADQMdhFk4a8BJ0qaUeLf+2+H=cLf9q80U2g1AxewY2A@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 29 Oct 2019 19:30:43 +0800
Message-ID: <CAMDZJNWzsP+sb+pXbxEXFpYQLy6TJQ_eqaseC8v5YNbFDA844Q@mail.gmail.com>
Subject: Re: [PATCH net-next v4 08/10] net: openvswitch: fix possible memleak
 on destroy flow-table
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 3:38 PM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Sun, Oct 27, 2019 at 11:49 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Thu, Oct 24, 2019 at 3:14 PM Pravin Shelar <pshelar@ovn.org> wrote:
> > >
> > > On Tue, Oct 22, 2019 at 7:35 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > On Tue, Oct 22, 2019 at 2:58 PM Pravin Shelar <pshelar@ovn.org> wrote:
> > > > >
> > > ...
> > >
> ...
> > > >  struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
> > > > @@ -400,10 +458,9 @@ static struct table_instance
> > > > *table_instance_rehash(struct table_instance *ti,
> > > >         return new_ti;
> > > >  }
> > > >
> > > > -int ovs_flow_tbl_flush(struct flow_table *flow_table)
> > > > +int ovs_flow_tbl_flush(struct flow_table *table)
> > > >  {
> > > > -       struct table_instance *old_ti, *new_ti;
> > > > -       struct table_instance *old_ufid_ti, *new_ufid_ti;
> > > > +       struct table_instance *new_ti, *new_ufid_ti;
> > > >
> > > >         new_ti = table_instance_alloc(TBL_MIN_BUCKETS);
> > > >         if (!new_ti)
> > > > @@ -412,16 +469,12 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
> > > >         if (!new_ufid_ti)
> > > >                 goto err_free_ti;
> > > >
> > > > -       old_ti = ovsl_dereference(flow_table->ti);
> > > > -       old_ufid_ti = ovsl_dereference(flow_table->ufid_ti);
> > > > +       table_instance_destroy(table, true);
> > > >
> > > This would destroy running table causing unnecessary flow miss. Lets
> > > keep current scheme of setting up new table before destroying current
> > > one.
> > >
> > > > -       rcu_assign_pointer(flow_table->ti, new_ti);
> ....
> ...
> >  /* Must be called with OVS mutex held. */
> >  void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
> >  {
> > @@ -752,17 +794,7 @@ void ovs_flow_tbl_remove(struct flow_table
> > *table, struct sw_flow *flow)
> >         struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
> >
> >         BUG_ON(table->count == 0);
> > -       hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
> > -       table->count--;
> > -       if (ovs_identifier_is_ufid(&flow->id)) {
> > -               hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
> > -               table->ufid_count--;
> > -       }
> > -
> > -       /* RCU delete the mask. 'flow->mask' is not NULLed, as it should be
> > -        * accessible as long as the RCU read lock is held.
> > -        */
> > -       flow_mask_remove(table, flow->mask);
> > +       table_instance_remove(table, ti, ufid_ti, flow, true);
> >  }
> Lets rename table_instance_remove() to imply it is freeing a flow.
hi Pravin, the function ovs_flow_free will free the flow actually. In
-ovs_flow_cmd_del
ovs_flow_tbl_remove
...
ovs_flow_free

In -table_instance_destroy
table_instance_remove
ovs_flow_free

But if rename the table_instance_remove, table_instance_flow_free ?
> Otherwise looks good.
