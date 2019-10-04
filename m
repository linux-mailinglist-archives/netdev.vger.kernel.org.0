Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC37BCBF69
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389907AbfJDPjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:39:48 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45371 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389669AbfJDPjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:39:47 -0400
Received: by mail-io1-f65.google.com with SMTP id c25so14411619iot.12
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 08:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hnw/V2iXHeGye8yYG7l4OLcUanWG78b5/DAcyjmnqb0=;
        b=r2NjmvQ3RTYYG5H/evZz3cpYIDXpNoNXLz9DTlTcbNjIfeo8vc+g3wJ5aHbjFKLRAd
         t77D8Kf241XtkQvWWovg8EkZtCi+VET416cUEXD5npA2aPlbtj2AUXUinKTBec3TLER2
         naiIxSiJ9XZhD9OeUJZpxO943Kh8aWf7iEMAQ1ONK/ApgEK/lJfPz+9B+COGgFi6DhHU
         GN6x6AhDVvREWajvK+GTFiFqYIQMkpiflnebKoFguldFscbhkhx7K7Bhz3X+TWxVjN3v
         EqCRkNoVHG8gly/bHieXbkys352Dv0xxaXEARwGY36uUnw5PWCKr/aOewU8FoxkMIP+8
         ofbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hnw/V2iXHeGye8yYG7l4OLcUanWG78b5/DAcyjmnqb0=;
        b=Ds4lZy6yBYfgSD1N6408clq/+0pDmGyArw+pm1SfOMU3qVgL5cj4lZIQZdZ1p25KiP
         ebITbt/thNpBvlpBUck0AjZXMXnkt9+10MzecJRajIuO2kHzQfKsZMpCXkbg4bfrNSyc
         bLqxuw3Mb0OijNMHY0KYahM3Q5p5GiTGny9B15iwI2TOQElLEwPlnAIxbq9Kzpg5Sse9
         2hVK505hdfiC+l+2Qh+RM3vMTwS0SkfCrmZbtOxoLzR/xPO/h313W6k6D7RouSzPrOZ5
         CV6HgPQxphE25VMCL4+1AQmyvRXLzX4VGmFvfdWauIzSPs8QBf4GwKEULoAD717JumOO
         qv0Q==
X-Gm-Message-State: APjAAAVWDpk88LsTq0jKI1YjTqaqBRFgAXN2TjWiQKH4JrzUDd700FLj
        j5CDWHc5gedKz26Lpl7njxs2HWWnJ5EO5hKjoT/HadwB
X-Google-Smtp-Source: APXvYqz6mEAmuvq75xJIxinbQ1XMSYYB3oVvngt3Ku1zp22OOlWXCRSXGQq7te1A8SDNEid9zqoSQSBdL5wOJIMPFVc=
X-Received: by 2002:a02:9002:: with SMTP id w2mr1935492jaf.140.1570203586148;
 Fri, 04 Oct 2019 08:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
 <vbfk19lokwe.fsf@mellanox.com> <CAK+XE=mjARd+DodNg9Sn4C+gg6dMTmvdNrKtEYhsLGVqtGrysw@mail.gmail.com>
 <vbfimp5oig9.fsf@mellanox.com>
In-Reply-To: <vbfimp5oig9.fsf@mellanox.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Fri, 4 Oct 2019 16:39:35 +0100
Message-ID: <CAK+XE=nrzH8B=2GRcvmgOus67HSh_QXfBsawO_qicp8nSyZ_FA@mail.gmail.com>
Subject: Re: [RFC net-next 0/2] prevent sync issues with hw offload of flower
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 6:19 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Thu 03 Oct 2019 at 19:59, John Hurley <john.hurley@netronome.com> wrote:
> > On Thu, Oct 3, 2019 at 5:26 PM Vlad Buslov <vladbu@mellanox.com> wrote:
> >>
> >>
> >> On Thu 03 Oct 2019 at 02:14, John Hurley <john.hurley@netronome.com> wrote:
> >> > Hi,
> >> >
> >> > Putting this out an RFC built on net-next. It fixes some issues
> >> > discovered in testing when using the TC API of OvS to generate flower
> >> > rules and subsequently offloading them to HW. Rules seen contain the same
> >> > match fields or may be rule modifications run as a delete plus an add.
> >> > We're seeing race conditions whereby the rules present in kernel flower
> >> > are out of sync with those offloaded. Note that there are some issues
> >> > that will need fixed in the RFC before it becomes a patch such as
> >> > potential races between releasing locks and re-taking them. However, I'm
> >> > putting this out for comments or potential alternative solutions.
> >> >
> >> > The main cause of the races seem to be in the chain table of cls_api. If
> >> > a tcf_proto is destroyed then it is removed from its chain. If a new
> >> > filter is then added to the same chain with the same priority and protocol
> >> > a new tcf_proto will be created - this may happen before the first is
> >> > fully removed and the hw offload message sent to the driver. In cls_flower
> >> > this means that the fl_ht_insert_unique() function can pass as its
> >> > hashtable is associated with the tcf_proto. We are then in a position
> >> > where the 'delete' and the 'add' are in a race to get offloaded. We also
> >> > noticed that doing an offload add, then checking if a tcf_proto is
> >> > concurrently deleting, then remove the offload if it is, can extend the
> >> > out of order messages. Drivers do not expect to get duplicate rules.
> >> > However, the kernel TC datapath they are not duplicates so we can get out
> >> > of sync here.
> >> >
> >> > The RFC fixes this by adding a pre_destroy hook to cls_api that is called
> >> > when a tcf_proto is signaled to be destroyed but before it is removed from
> >> > its chain (which is essentially the lock for allowing duplicates in
> >> > flower). Flower then uses this new hook to send the hw delete messages
> >> > from tcf_proto destroys, preventing them racing with duplicate adds. It
> >> > also moves the check for 'deleting' to before the sending the hw add
> >> > message.
> >> >
> >> > John Hurley (2):
> >> >   net: sched: add tp_op for pre_destroy
> >> >   net: sched: fix tp destroy race conditions in flower
> >> >
> >> >  include/net/sch_generic.h |  3 +++
> >> >  net/sched/cls_api.c       | 29 ++++++++++++++++++++++++-
> >> >  net/sched/cls_flower.c    | 55 ++++++++++++++++++++++++++---------------------
> >> >  3 files changed, 61 insertions(+), 26 deletions(-)
> >>
> >> Hi John,
> >>
> >> Thanks for working on this!
> >>
> >> Are there any other sources for race conditions described in this
> >> letter? When you describe tcf_proto deletion you say "main cause" but
> >> don't provide any others. If tcf_proto is the only problematic part,
> >
> > Hi Vlad,
> > Thanks for the input.
> > The tcf_proto deletion was the cause from the tests we ran. That's not
> > to say there are not more I wasn't seeing in my analysis.
> >
> >> then it might be worth to look into alternative ways to force concurrent
> >> users to wait for proto deletion/destruction to be properly finished.
> >> Maybe having some table that maps chain id + prio to completion would be
> >> simpler approach? With such infra tcf_proto_create() can wait for
> >> previous proto with same prio and chain to be fully destroyed (including
> >> offloads) before creating a new one.
> >
> > I think a problem with this is that the chain removal functions call
> > tcf_proto_put() (which calls destroy when ref is 0) so, if other
> > concurrent processes (like a dump) have references to the tcf_proto
> > then we may not get the hw offload even by the time the chain deletion
> > function has finished. We would need to make sure this was tracked -
> > say after the tcf_proto_destroy function has completed.
> > How would you suggest doing the wait? With a replay flag as happens in
> > some other places?
> >
> > To me it seems the main problem is that the tcf_proto being in a chain
> > almost acts like the lock to prevent duplicates filters getting to the
> > driver. We need some mechanism to ensure a delete has made it to HW
> > before we release this 'lock'.
>
> Maybe something like:

Ok, I'll need to give this more thought.
Initially it does sound like overkill.

>
> 1. Extend block with hash table with key being chain id and prio
> combined and value is some structure that contains struct completion
> (completed in tcf_proto_destroy() where we sure that all rules were
> removed from hw) and a reference counter.
>

Maybe it could live in each chain rather than block to be more fine grained?
Or would this potentially cause a similar issue on deletion of chains?

> 2. When cls API wants to delete proto instance
> (tcf_chain_tp_delete_empty(), chain flush, etc.), new member is added to
> table from 1. with chain+prio of proto that is being deleted (atomically
> with detaching of proto from chain).
>
> 3. When inserting new proto, verify that there are no corresponding
> entry in hash table with same chain+prio. If there is, increment
> reference counter and wait for completion. Release reference counter
> when completed.

How would the 'wait' work? Loop back via replay flag?
It feels a bit like we are adding a lot more complexity to this and
almost hacking something in to work around a (relatively) newly
introduced problem.

>
> >
> >>
> >> Regards,
> >> Vlad
