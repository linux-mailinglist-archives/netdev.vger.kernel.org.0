Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324EC71A12
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390540AbfGWOQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:16:34 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:39629 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbfGWOQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:16:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 051F82766;
        Tue, 23 Jul 2019 10:16:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 23 Jul 2019 10:16:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2rm5Ca
        KDnw7oUdMARQxvYBTdZoUSnzOX03A7LqdRLaE=; b=qU80VL7jfme7LHFiUA/vmx
        vnZQEEni/ZUPegjQCIxfAXAKGrnPmFVvsAHppsPAasixuwJmNkJdmp8aR41Ctt8M
        zy2Kj9ZJQMTwBqtG56ezANryKQMRWJDdznlIz0cVjlE+uICCE8csLnn7KLuAi/fn
        TPgjbepOIOyAuoDkmMjRhOZct/G5dVSslkrfaaC5WeVkDNlXP7nQpkVOfLD3h0mz
        74z57UA0AzecxhJix9BrywcgAoRKEapFnAUyiS2OaVKKcYISW4M96q7AzS68BNNF
        2jrsu0AxxnbalWj1x9rZ5LKd+Bir7Z+8kF/blpFM8sjOAmTU7bO1oN4bXloZy01g
        ==
X-ME-Sender: <xms:vBY3XV4FmcukVrO6Ccz65-dRIYtIZ9Vb22rgnJtOdn9POtDa1djzbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:vBY3XZMFCzUforrEFJkW6qOi8bRMUweIFmJfjWPnG5SnxTYZaRyJpg>
    <xmx:vBY3XSfnwwvPOTx59RobOxaE1oAfPWYTBb0MoLUXU_keNtw5aPweRA>
    <xmx:vBY3XbcWB00jCzPLgwnsVnEDF_g-yjU5ScwNK-YE9f6FDefmrBmXAg>
    <xmx:vBY3XRBVKsaeujX70hGFc_hHBYSg0A3JPO00WGWAYTuFaVyUk3dZdg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A61518005C;
        Tue, 23 Jul 2019 10:16:27 -0400 (EDT)
Date:   Tue, 23 Jul 2019 17:16:25 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 10/12] drop_monitor: Add packet alert mode
Message-ID: <20190723141625.GA8972@splinter>
References: <20190722183134.14516-1-idosch@idosch.org>
 <20190722183134.14516-11-idosch@idosch.org>
 <20190723124340.GA10377@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723124340.GA10377@hmswarspite.think-freely.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 08:43:40AM -0400, Neil Horman wrote:
> On Mon, Jul 22, 2019 at 09:31:32PM +0300, Ido Schimmel wrote:
> > +static void net_dm_packet_work(struct work_struct *work)
> > +{
> > +	struct per_cpu_dm_data *data;
> > +	struct sk_buff_head list;
> > +	struct sk_buff *skb;
> > +	unsigned long flags;
> > +
> > +	data = container_of(work, struct per_cpu_dm_data, dm_alert_work);
> > +
> > +	__skb_queue_head_init(&list);
> > +
> > +	spin_lock_irqsave(&data->drop_queue.lock, flags);
> > +	skb_queue_splice_tail_init(&data->drop_queue, &list);
> > +	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
> > +
> These functions are all executed in a per-cpu context.  While theres nothing
> wrong with using a spinlock here, I think you can get away with just doing
> local_irqsave and local_irq_restore.

Hi Neil,

Thanks a lot for reviewing. I might be missing something, but please
note that this function is executed from a workqueue and therefore the
CPU it is running on does not have to be the same CPU to which 'data'
belongs to. If so, I'm not sure how I can avoid taking the spinlock, as
otherwise two different CPUs can modify the list concurrently.

> 
> Neil
> 
> > +	while ((skb = __skb_dequeue(&list)))
> > +		net_dm_packet_report(skb);
> > +}
