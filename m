Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0A120393B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgFVO1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729498AbgFVO1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:27:04 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8C1C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 07:27:03 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id p20so18155623ejd.13
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 07:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2lL1SuxbSfLbrjqAUhc2M9pezrQZtlHWXhMmnFl9PW4=;
        b=Av8kQEruZpIUM3H3FHOROjOEqadC3vVfQI2bNgvUgU9qju8ASxmDIX+o0DY7kbdHw7
         f0p6Nd5j4ke1dB8orpLmMOdhhPobSDlRma7MwAov0jmQF44tnOydQzvxjas14VK8juDa
         0lwvWK1lo33Aya9o19BFQjGkpNmuu1+et0iEqxOpVXhoTiWA2FckCzJLjhJw/u431XgA
         QGMQFqyhNcw945ekjKR57ja9aN+e9P2ju4JlXwk5xQGIWdGT/VhWui0d2Qht5dRlfbRs
         jG0juGkcr+t6jmzToqrZoyNbSvfJrB2RE7Bh4GCbrkyUEsqJJy77O5YTVCcNkIvliXEF
         rIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=2lL1SuxbSfLbrjqAUhc2M9pezrQZtlHWXhMmnFl9PW4=;
        b=Ic+cKwOyfsjpz1vS2Hw97VrMnjpZgPxF0iyd6PwPJPr5agmbfLXls+H+3wKZBREsiO
         DPBTzT3pxwECOpuAob2KWAcnDkMXmp2L0EnPHy8KZe1YHCYGsCf9zFB2MVNAXyGK0PEi
         8H1MCCUO9NBSxxHC8uSkIDMC6+XVX9uNrQILpLtmPWNjpeUcnKPMrxZ5OHNEx/YlFNgB
         cqK7xm26rzRxE7CvFjYvjvBDYtvA20gA1fF315gv4GXeTtMFeG09rciLE0SvHhzUuwhd
         H3mK7DY8mOF9c4PRe4WukWXj8BBkeMEOJfNKst3jVrmnzAAZi5xE5PWIXAivC89NvXvE
         J0ww==
X-Gm-Message-State: AOAM531jY4ETipGwvf2McW0Jca0FRaqb6oSAKid9laR+6MHb1xOZ/+Hk
        1h/jWsKFbkqLq8v9tu0fbvYuTM6xHTq+SBLKsrYpvg==
X-Google-Smtp-Source: ABdhPJwFMu+N0sF+nePFCPxamnkXSqDA23IzOacuZrXVmYLoade8FMIJodAu2JcDrSP3IimxuyiWlbKD6E8FGWqxY0I=
X-Received: by 2002:a17:906:4554:: with SMTP id s20mr15534218ejq.241.1592836022456;
 Mon, 22 Jun 2020 07:27:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:3a1b:0:0:0:0:0 with HTTP; Mon, 22 Jun 2020 07:27:01
 -0700 (PDT)
X-Originating-IP: [5.35.13.201]
In-Reply-To: <20200622152828.368748ba@carbon>
References: <1592817672-2053-1-git-send-email-kda@linux-powerpc.org>
 <1592817672-2053-3-git-send-email-kda@linux-powerpc.org> <20200622115804.3c63aba9@carbon>
 <CAOJe8K28RQuiAKADY2pgad8qAzVXYxYcZnb8m0AJGSZTnAfJqA@mail.gmail.com> <20200622152828.368748ba@carbon>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 22 Jun 2020 17:27:01 +0300
Message-ID: <CAOJe8K0ix1RHUv4o=MquEJ4o2_F06Uyr9KFNTMatE8PAgDrUbw@mail.gmail.com>
Subject: Re: [PATCH net-next v10 2/3] xen networking: add basic XDP support
 for xen-netfront
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> On Mon, 22 Jun 2020 15:45:46 +0300
> Denis Kirjanov <kda@linux-powerpc.org> wrote:
>
>> On 6/22/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>> >
>> > On Mon, 22 Jun 2020 12:21:11 +0300 Denis Kirjanov
>> > <kda@linux-powerpc.org>
>> > wrote:
>> >
>> >> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>> >> index 482c6c8..1b9f49e 100644
>> >> --- a/drivers/net/xen-netfront.c
>> >> +++ b/drivers/net/xen-netfront.c
>> > [...]
>> >> @@ -560,6 +572,65 @@ static u16 xennet_select_queue(struct net_device
>> >> *dev, struct sk_buff *skb,
>> >>  	return queue_idx;
>> >>  }
>> >>
>> >> +static int xennet_xdp_xmit_one(struct net_device *dev, struct
>> >> xdp_frame
>> >> *xdpf)
>> >> +{
>> >> +	struct netfront_info *np = netdev_priv(dev);
>> >> +	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
>> >> +	unsigned int num_queues = dev->real_num_tx_queues;
>> >> +	struct netfront_queue *queue = NULL;
>> >> +	struct xen_netif_tx_request *tx;
>> >> +	unsigned long flags;
>> >> +	int notify;
>> >> +
>> >> +	queue = &np->queues[smp_processor_id() % num_queues];
>> >> +
>> >> +	spin_lock_irqsave(&queue->tx_lock, flags);
>> >
>> > Why are you taking a lock per packet (xdp_frame)?
>> Hi Jesper,
>>
>> We have to protect shared ring indices.
>
> Sure, I understand we need to protect the rings.
>
> What I'm asking is why are doing this per-packet, and not once for the
> entire bulk of packets?

Now I see. I believe we can. Do you think it will give performance
from the cache perspective?
>
> (notice how xennet_xdp_xmit gets a bulk of packets)
>
>> >
>> >> +
>> >> +	tx = xennet_make_first_txreq(queue, NULL,
>> >> +				     virt_to_page(xdpf->data),
>> >> +				     offset_in_page(xdpf->data),
>> >> +				     xdpf->len);
>> >> +
>> >> +	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
>> >> +	if (notify)
>> >> +		notify_remote_via_irq(queue->tx_irq);
>> >> +
>> >> +	u64_stats_update_begin(&tx_stats->syncp);
>> >> +	tx_stats->bytes += xdpf->len;
>> >> +	tx_stats->packets++;
>> >> +	u64_stats_update_end(&tx_stats->syncp);
>> >> +
>> >> +	xennet_tx_buf_gc(queue);
>> >> +
>> >> +	spin_unlock_irqrestore(&queue->tx_lock, flags);
>> >
>> > Is the irqsave/irqrestore variant really needed here?
>>
>> netpoll also invokes the tx completion handler.
>
> I forgot about netpoll.
>
> The netpoll code cannot call this code path xennet_xdp_xmit /
> xennet_xdp_xmit_one, right?
>
> Are the per-CPU ring queue's shared with normal network stack, that can
> be called from netpoll code path?

I meant that both xennet_start_xmit and xennet_poll_controller call
xennet_tx_buf_gc

>
>   queue = &np->queues[smp_processor_id() % num_queues];
>
>
>> >
>> >> +	return 0;
>> >> +}
>> >> +
>> >> +static int xennet_xdp_xmit(struct net_device *dev, int n,
>> >> +			   struct xdp_frame **frames, u32 flags)
>> >> +{
>> >> +	int drops = 0;
>> >> +	int i, err;
>> >> +
>> >> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
>> >> +		return -EINVAL;
>> >> +
>> >> +	for (i = 0; i < n; i++) {
>> >> +		struct xdp_frame *xdpf = frames[i];
>> >> +
>> >> +		if (!xdpf)
>> >> +			continue;
>> >> +		err = xennet_xdp_xmit_one(dev, xdpf);
>> >> +		if (err) {
>> >> +			xdp_return_frame_rx_napi(xdpf);
>> >> +			drops++;
>> >> +		}
>> >> +	}
>> >> +
>> >> +	return n - drops;
>> >> +}
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
>
