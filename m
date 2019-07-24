Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060D3728D8
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 09:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfGXHKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 03:10:18 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:51387 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbfGXHKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 03:10:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4D8241DA7;
        Wed, 24 Jul 2019 03:10:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 24 Jul 2019 03:10:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=b28QAi
        DOjEYmMsvQIJ4I4kU/uO0JOJlmwN/C+rndo1M=; b=l58HWELEYwd3k2NG4gMl+x
        kllW9LMAOPvCOR9MHeo2374zr0Iod6ol4w7zgYdXmAEgI3ZEAsDDPoyuvamHB7Wa
        XYAv3iVFW+s4+W8/5+8qdFNz8tZVFkeuNm8+N5u6s1OM+mo9sfSaJhfeqIKYR1wB
        KCy5Yx8cZcMeUs4UscL53lY0nesYJI/1F6uncy5N/HZvL5wnzY5YqlNf2jBhHuRG
        MxpcwtupDprHrXBOqBo3TDr3T64/KXMbyHxArt7+32A9HHXDwRDd36r2URm124Ih
        BsZkCJIYTPH0JOPjCv4t7kMRhClEhM+czHuNriuNz4Jh95Skoyx4FDOlkUICTEtA
        ==
X-ME-Sender: <xms:VgQ4XbFZsChzkMKw1ttm3WgqkMhMrCpfHyHDh-qiPVquILG12lZZ2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeelgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:VgQ4XfwtqaIst_jh_ttW71pA30J-quPeqc4xUnkeE2OBHANE1gq7DA>
    <xmx:VgQ4XagEJ2I3fbk1OdhY6GptZ4RjnJqgPoa89VGYzNriYswTQ984kg>
    <xmx:VgQ4XSxvdrwPOqF_HsJ2iDmHwUKpOMhPi2meh3eJEdbRnh1FIqNj8Q>
    <xmx:WAQ4XXknqS-gc05u3R1QaLcCUc3wKSCXpPJC_SfkYjOvXLtyLECM_w>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 024513800A2;
        Wed, 24 Jul 2019 03:10:13 -0400 (EDT)
Date:   Wed, 24 Jul 2019 10:10:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 10/12] drop_monitor: Add packet alert mode
Message-ID: <20190724071012.GA5159@splinter>
References: <20190722183134.14516-1-idosch@idosch.org>
 <20190722183134.14516-11-idosch@idosch.org>
 <20190723124340.GA10377@hmswarspite.think-freely.org>
 <20190723141625.GA8972@splinter>
 <20190723151431.GA8419@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723151431.GA8419@localhost.localdomain>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 11:14:31AM -0400, Neil Horman wrote:
> On Tue, Jul 23, 2019 at 05:16:25PM +0300, Ido Schimmel wrote:
> > On Tue, Jul 23, 2019 at 08:43:40AM -0400, Neil Horman wrote:
> > > On Mon, Jul 22, 2019 at 09:31:32PM +0300, Ido Schimmel wrote:
> > > > +static void net_dm_packet_work(struct work_struct *work)
> > > > +{
> > > > +	struct per_cpu_dm_data *data;
> > > > +	struct sk_buff_head list;
> > > > +	struct sk_buff *skb;
> > > > +	unsigned long flags;
> > > > +
> > > > +	data = container_of(work, struct per_cpu_dm_data, dm_alert_work);
> > > > +
> > > > +	__skb_queue_head_init(&list);
> > > > +
> > > > +	spin_lock_irqsave(&data->drop_queue.lock, flags);
> > > > +	skb_queue_splice_tail_init(&data->drop_queue, &list);
> > > > +	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
> > > > +
> > > These functions are all executed in a per-cpu context.  While theres nothing
> > > wrong with using a spinlock here, I think you can get away with just doing
> > > local_irqsave and local_irq_restore.
> > 
> > Hi Neil,
> > 
> > Thanks a lot for reviewing. I might be missing something, but please
> > note that this function is executed from a workqueue and therefore the
> > CPU it is running on does not have to be the same CPU to which 'data'
> > belongs to. If so, I'm not sure how I can avoid taking the spinlock, as
> > otherwise two different CPUs can modify the list concurrently.
> > 
> Ah, my bad, I was under the impression that the schedule_work call for
> that particular work queue was actually a call to schedule_work_on,
> which would have affined it to a specific cpu.  That said, looking at
> it, I think using schedule_work_on was my initial intent, as the work
> queue is registered per cpu.  And converting it to schedule_work_on
> would allow you to reduce the spin_lock to a faster local_irqsave

Yes, this can work, but I'm not sure we can justify it. The CPU that is
dropping packets is potentially very busy processing all incoming
packets and with schedule_work_on() we force the same CPU to be used to
allocate and prepare the netlink messages. With schedule_work() the
system can choose an idle CPU and better utilize system resources. Also,
the scope of the lock is very limited and it is only ever contended by
at most two CPUs: The CPU the list belongs to and the CPU executing the
work item.

I will limit the number of skbs we can enqueue, add a counter to see how
many packets we tail drop and benchmark both approaches.

Thanks!
