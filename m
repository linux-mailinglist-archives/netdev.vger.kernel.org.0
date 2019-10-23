Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407EDE1010
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 04:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388931AbfJWCfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 22:35:48 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45816 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732408AbfJWCfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 22:35:48 -0400
Received: by mail-oi1-f193.google.com with SMTP id o205so16026430oib.12
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 19:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ktEuedfpIjUmz+yMKqtIGu1YXNfclZtdt8H19wjAiOI=;
        b=OkGz6hXoaDIIwaY2mSoPqFvWpkbOjChm0izoEtX6GXw4BbNKoPmOLEat6gh2uw8uXQ
         Y9qqTF4FZgzahEjke7LZ0CsSri1w0dnnnoes2VMy5FF5Dz5wtKH974uNEOuhQZTt1+Q7
         cko7n3FfmDPqtivUxzjGkP7mKhPnbfuQ8izONziJ9vvJnd3rGosDdYsRtKlmR1s4L+l/
         xy/OB+3Y08nzhSVyHFpukaflyQ8B/jRkxnFxnPU3u4Kwm0Xv9VobNtLsb4zQxtoW7XNI
         NKAIDxyR5CKgWjpgB3hOIzLdWufzTqeNPXGXuN5kuzWbE+NLLMjuEVQxuf1xFqrVm8Tx
         GMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ktEuedfpIjUmz+yMKqtIGu1YXNfclZtdt8H19wjAiOI=;
        b=jsjL5rmdu8gmkVB9guzRl5cA+AoLVVqH2tW23NnlCXIGqcIPgyjrqkYZBd2ZSV/Cn4
         K3/yvFh1g9jYnU9l9Q7DXXVR00qxBrTQ321QYwoe50Ruek7fi7HJwoGyCnNWDufwM8fk
         O1mHD/Bi/4uSxUl/kMJ1S132aIBukW9MPatzEPu8lWdEFDZG2h/IcmwSRYLMHzdwEXAi
         PQOP4ngQJHGp2f2g8zr5xtB8nxzdSeo8xDXcCtuSLqYNBwPEYYaqc/WAYQnlmvQ1Gb7Y
         jtoF0JXfxI/pDaxUupU0OTXwUyFr10AsqxZnWi7Z7IOwj6laBiGZJm/f6wGsZxN+F2we
         iIfA==
X-Gm-Message-State: APjAAAU9ya/ZY7qO3YQf3SVInD4KTPzfIIAYYA/oKU2TqHf8dE+HDFgn
        P3/BUj8xQgU+GHmAek4tajBdepgnS7gujLuJOE4=
X-Google-Smtp-Source: APXvYqxpTdoZyPRVm/Dp6CtJ3qhXozFyJ8zLuK+udFmwW6GgQInxuO+J3tzMQGSGgIszcw1hGc4XEu7PKhxsNQNmaLY=
X-Received: by 2002:aca:b503:: with SMTP id e3mr5666301oif.177.1571798146577;
 Tue, 22 Oct 2019 19:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com>
 <CAMDZJNWD=a+EBneEU-qs3pzXSBoOdzidn5cgOKs-y8G0UWvbnA@mail.gmail.com>
 <CAOrHB_BqGdFmmzTEPxejt0QXmyC_QtAXG=S8kzKi=3w-PacwUw@mail.gmail.com>
 <CAMDZJNXdu3R_GkHEBbwycEpe0wnwNmGzHx-8gUxtwiW1mEy7uw@mail.gmail.com> <CAOrHB_DdMX7sZkk79esdZkmb8RGaX_XiMAxhGz1LgWx50eFD9g@mail.gmail.com>
In-Reply-To: <CAOrHB_DdMX7sZkk79esdZkmb8RGaX_XiMAxhGz1LgWx50eFD9g@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 23 Oct 2019 10:35:09 +0800
Message-ID: <CAMDZJNVfyzmnd4qhp_esE-s3+-z8K=6tBP63X+SCEcjBon60eQ@mail.gmail.com>
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

On Tue, Oct 22, 2019 at 2:58 PM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Sun, Oct 20, 2019 at 10:02 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Sat, Oct 19, 2019 at 2:12 AM Pravin Shelar <pshelar@ovn.org> wrote:
> > >
> > > On Thu, Oct 17, 2019 at 8:16 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > On Fri, Oct 18, 2019 at 6:38 AM Pravin Shelar <pshelar@ovn.org> wrote:
> > > > >
> > > > > On Wed, Oct 16, 2019 at 5:50 AM <xiangxia.m.yue@gmail.com> wrote:
> > > > > >
> > > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > >
> > > > > > When we destroy the flow tables which may contain the flow_mask,
> > > > > > so release the flow mask struct.
> > > > > >
> > > > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > Tested-by: Greg Rose <gvrose8192@gmail.com>
> > > > > > ---
> > > > > >  net/openvswitch/flow_table.c | 14 +++++++++++++-
> > > > > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> > > > > > index 5df5182..d5d768e 100644
> > > > > > --- a/net/openvswitch/flow_table.c
> > > > > > +++ b/net/openvswitch/flow_table.c
> > > > > > @@ -295,6 +295,18 @@ static void table_instance_destroy(struct table_instance *ti,
> > > > > >         }
> > > > > >  }
> > > > > >
> > > > > > +static void tbl_mask_array_destroy(struct flow_table *tbl)
> > > > > > +{
> > > > > > +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> > > > > > +       int i;
> > > > > > +
> > > > > > +       /* Free the flow-mask and kfree_rcu the NULL is allowed. */
> > > > > > +       for (i = 0; i < ma->max; i++)
> > > > > > +               kfree_rcu(rcu_dereference_raw(ma->masks[i]), rcu);
> > > > > > +
> > > > > > +       kfree_rcu(rcu_dereference_raw(tbl->mask_array), rcu);
> > > > > > +}
> > > > > > +
> > > > > >  /* No need for locking this function is called from RCU callback or
> > > > > >   * error path.
> > > > > >   */
> > > > > > @@ -304,7 +316,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
> > > > > >         struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
> > > > > >
> > > > > >         free_percpu(table->mask_cache);
> > > > > > -       kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
> > > > > > +       tbl_mask_array_destroy(table);
> > > > > >         table_instance_destroy(ti, ufid_ti, false);
> > > > > >  }
> > > > >
> > > > > This should not be required. mask is linked to a flow and gets
> > > > > released when flow is removed.
> > > > > Does the memory leak occur when OVS module is abruptly unloaded and
> > > > > userspace does not cleanup flow table?
> > > > When we destroy the ovs datapath or net namespace is destroyed , the
> > > > mask memory will be happened. The call tree:
> > > > ovs_exit_net/ovs_dp_cmd_del
> > > > -->__dp_destroy
> > > > -->destroy_dp_rcu
> > > > -->ovs_flow_tbl_destroy
> > > > -->table_instance_destroy (which don't release the mask memory because
> > > > don't call the ovs_flow_tbl_remove /flow_mask_remove directly or
> > > > indirectly).
> > > >
> > > Thats what I suggested earlier, we need to call function similar to
> > > ovs_flow_tbl_remove(), we could refactor code to use the code.
> > > This is better since by introducing tbl_mask_array_destroy() is
> > > creating a dangling pointer to mask in sw-flow object. OVS is anyway
> > > iterating entire flow table to release sw-flow in
> > > table_instance_destroy(), it is natural to release mask at that point
> > > after releasing corresponding sw-flow.
> > I got it, thanks. I rewrite the codes, can you help me to review it.
> > If fine, I will sent it next version.
> > >
> > >
> Sure, I can review it, Can you send the patch inlined in mail?
>
> Thanks.
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 5df5182..5b20793 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -257,10 +257,75 @@ static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
        __table_instance_destroy(ti);
 }

-static void table_instance_destroy(struct table_instance *ti,
-                                  struct table_instance *ufid_ti,
+static void tbl_mask_array_del_mask(struct flow_table *tbl,
+                                   struct sw_flow_mask *mask)
+{
+       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+       int i, ma_count = READ_ONCE(ma->count);
+
+       /* Remove the deleted mask pointers from the array */
+       for (i = 0; i < ma_count; i++) {
+               if (mask == ovsl_dereference(ma->masks[i]))
+                       goto found;
+       }
+
+       BUG();
+       return;
+
+found:
+       WRITE_ONCE(ma->count, ma_count -1);
+
+       rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
+       RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
+
+       kfree_rcu(mask, rcu);
+
+       /* Shrink the mask array if necessary. */
+       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
+           ma_count <= (ma->max / 3))
+               tbl_mask_array_realloc(tbl, ma->max / 2);
+}
+
+/* Remove 'mask' from the mask list, if it is not needed any more. */
+static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
+{
+       if (mask) {
+               /* ovs-lock is required to protect mask-refcount and
+                * mask list.
+                */
+               ASSERT_OVSL();
+               BUG_ON(!mask->ref_count);
+               mask->ref_count--;
+
+               if (!mask->ref_count)
+                       tbl_mask_array_del_mask(tbl, mask);
+       }
+}
+
+static void table_instance_remove(struct flow_table *table, struct
sw_flow *flow)
+{
+       struct table_instance *ti = ovsl_dereference(table->ti);
+       struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
+
+       BUG_ON(table->count == 0);
+       hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
+       table->count--;
+       if (ovs_identifier_is_ufid(&flow->id)) {
+               hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
+               table->ufid_count--;
+       }
+
+       /* RCU delete the mask. 'flow->mask' is not NULLed, as it should be
+        * accessible as long as the RCU read lock is held.
+        */
+       flow_mask_remove(table, flow->mask);
+}
+
+static void table_instance_destroy(struct flow_table *table,
                                   bool deferred)
 {
+       struct table_instance *ti = ovsl_dereference(table->ti);
+       struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
        int i;

        if (!ti)
@@ -274,13 +339,9 @@ static void table_instance_destroy(struct
table_instance *ti,
                struct sw_flow *flow;
                struct hlist_head *head = &ti->buckets[i];
                struct hlist_node *n;
-               int ver = ti->node_ver;
-               int ufid_ver = ufid_ti->node_ver;

-               hlist_for_each_entry_safe(flow, n, head, flow_table.node[ver]) {
-                       hlist_del_rcu(&flow->flow_table.node[ver]);
-                       if (ovs_identifier_is_ufid(&flow->id))
-                               hlist_del_rcu(&flow->ufid_table.node[ufid_ver]);
+               hlist_for_each_entry_safe(flow, n, head,
flow_table.node[ti->node_ver]) {
+                       table_instance_remove(table, flow);
                        ovs_flow_free(flow, deferred);
                }
        }
@@ -300,12 +361,9 @@ static void table_instance_destroy(struct
table_instance *ti,
  */
 void ovs_flow_tbl_destroy(struct flow_table *table)
 {
-       struct table_instance *ti = rcu_dereference_raw(table->ti);
-       struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
-
        free_percpu(table->mask_cache);
        kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
-       table_instance_destroy(ti, ufid_ti, false);
+       table_instance_destroy(table, false);
 }

 struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
@@ -400,10 +458,9 @@ static struct table_instance
*table_instance_rehash(struct table_instance *ti,
        return new_ti;
 }

-int ovs_flow_tbl_flush(struct flow_table *flow_table)
+int ovs_flow_tbl_flush(struct flow_table *table)
 {
-       struct table_instance *old_ti, *new_ti;
-       struct table_instance *old_ufid_ti, *new_ufid_ti;
+       struct table_instance *new_ti, *new_ufid_ti;

        new_ti = table_instance_alloc(TBL_MIN_BUCKETS);
        if (!new_ti)
@@ -412,16 +469,12 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
        if (!new_ufid_ti)
                goto err_free_ti;

-       old_ti = ovsl_dereference(flow_table->ti);
-       old_ufid_ti = ovsl_dereference(flow_table->ufid_ti);
+       table_instance_destroy(table, true);

-       rcu_assign_pointer(flow_table->ti, new_ti);
-       rcu_assign_pointer(flow_table->ufid_ti, new_ufid_ti);
-       flow_table->last_rehash = jiffies;
-       flow_table->count = 0;
-       flow_table->ufid_count = 0;
+       rcu_assign_pointer(table->ti, new_ti);
+       rcu_assign_pointer(table->ufid_ti, new_ufid_ti);
+       table->last_rehash = jiffies;

-       table_instance_destroy(old_ti, old_ufid_ti, true);
        return 0;

 err_free_ti:
@@ -700,69 +753,10 @@ static struct table_instance
*table_instance_expand(struct table_instance *ti,
        return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
 }

-static void tbl_mask_array_del_mask(struct flow_table *tbl,
-                                   struct sw_flow_mask *mask)
-{
-       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
-       int i, ma_count = READ_ONCE(ma->count);
-
-       /* Remove the deleted mask pointers from the array */
-       for (i = 0; i < ma_count; i++) {
-               if (mask == ovsl_dereference(ma->masks[i]))
-                       goto found;
-       }
-
-       BUG();
-       return;
-
-found:
-       WRITE_ONCE(ma->count, ma_count -1);
-
-       rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
-       RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
-
-       kfree_rcu(mask, rcu);
-
-       /* Shrink the mask array if necessary. */
-       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
-           ma_count <= (ma->max / 3))
-               tbl_mask_array_realloc(tbl, ma->max / 2);
-}
-
-/* Remove 'mask' from the mask list, if it is not needed any more. */
-static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
-{
-       if (mask) {
-               /* ovs-lock is required to protect mask-refcount and
-                * mask list.
-                */
-               ASSERT_OVSL();
-               BUG_ON(!mask->ref_count);
-               mask->ref_count--;
-
-               if (!mask->ref_count)
-                       tbl_mask_array_del_mask(tbl, mask);
-       }
-}
-
 /* Must be called with OVS mutex held. */
 void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
 {
-       struct table_instance *ti = ovsl_dereference(table->ti);
-       struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
-
-       BUG_ON(table->count == 0);
-       hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
-       table->count--;
-       if (ovs_identifier_is_ufid(&flow->id)) {
-               hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
-               table->ufid_count--;
-       }
-
-       /* RCU delete the mask. 'flow->mask' is not NULLed, as it should be
-        * accessible as long as the RCU read lock is held.
-        */
-       flow_mask_remove(table, flow->mask);
+       table_instance_remove(table, flow);
 }

 static struct sw_flow_mask *mask_alloc(void)
