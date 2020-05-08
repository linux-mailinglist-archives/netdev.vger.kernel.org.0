Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458F61CA6A1
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 10:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgEHIyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 04:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgEHIyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 04:54:11 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27971C05BD0B;
        Fri,  8 May 2020 01:54:10 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l12so570849pgr.10;
        Fri, 08 May 2020 01:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Xw7bneDncMYCvfrqJQk2sk2OzlKsXn2ZHAE5/n/nUqU=;
        b=Yv1fksitw+AWzD0vX5DRmG7H3DzQ0ngiJoN/Ra8IcObAxgHNdO2oxChm5owTD6VbRJ
         2Yc/Jaltsgh6TuQl1+dSM9QjYZJ3nZNHZsJ7LC7zKZqDHQenuWtDe9vHJbEeMp4uygtx
         4ULbpY6M4vCCjaTstUru05lQHpg2weWFReX3gmLfhZmg2dPMs9mQHWb48lhRRKra7X0o
         RY3ByUXt4c6qPT9HY5OFZsaTINeq9KR3BQP/FdDgEP/utN3Js9F55JWR7AbRzPU7yauR
         pfuOF6ViVf419PaVTedq4jnFeqh+OTxH7mEOExAEakiVQyYlen9foGnqmLn+qkFP53vQ
         sKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Xw7bneDncMYCvfrqJQk2sk2OzlKsXn2ZHAE5/n/nUqU=;
        b=RrhN+UhbUt567VW086h+plTD8CXvYNyiNNJiLQzpyN+1dZ0mxd7//v6xoY1SPPa3k1
         QjyupYN/kc+4LOkj81I2M0244mVnsrvFFhi5QyCuUHSEy+/5rHQG7T6d3cMwVyRJhV0u
         LR06abRbMKscgVvMEMXLREaoi5oUf3vWF1OtxDVb7zx0dCR1X+spfYDH8lXDtECJsyKu
         A8q2YjpDt4TW55c/+8BvefLj2wlEhtvcSg5wfDo0IA3g/cFT3l2e+uIZ4WUi/I1XDlrY
         HmxkxFhxYMKq4yIUjSVRV03Nvh44lmjyslaa0NU7DrWpbm5H4TYPFg1AHNEYB+7Q2Dey
         j6kQ==
X-Gm-Message-State: AGi0PuZWHxPrh1RWmkjlNpeplDghqNdVERUzG44Bm3fQIwuBG+K/1tCL
        X7/92uFPH6Yq6sc2Sg2N6jo=
X-Google-Smtp-Source: APiQypJO/dtADwtpU8CPBwaXVW3np6XIDRWXsduTzJj8Rrr2pk98xyGATFoIgJlw5pCb+VkfSWnPjA==
X-Received: by 2002:a62:e211:: with SMTP id a17mr1791003pfi.250.1588928049517;
        Fri, 08 May 2020 01:54:09 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c1sm1124222pfo.152.2020.05.08.01.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 01:54:08 -0700 (PDT)
Date:   Fri, 8 May 2020 16:53:57 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [RFC PATCHv2 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200508085357.GC102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200424085610.10047-1-liuhangbin@gmail.com>
 <20200424085610.10047-2-liuhangbin@gmail.com>
 <87r1wd2bqu.fsf@toke.dk>
 <20200506091442.GA102436@dhcp-12-153.nay.redhat.com>
 <874kstmlhz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874kstmlhz.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 12:00:08PM +0200, Toke Høiland-Jørgensen wrote:
> > No, I haven't test the performance. Do you have any suggestions about how
> > to test it? I'd like to try forwarding pkts to 10+ ports. But I don't know
> > how to test the throughput. I don't think netperf or iperf supports
> > this.
> 
> What I usually do when benchmarking XDP_REDIRECT is to just use pktgen
> (samples/pktgen in the kernel source tree) on another machine,
> specifically, like this:
> 
> ./pktgen_sample03_burst_single_flow.sh  -i enp1s0f1 -d 10.70.2.2 -m ec:0d:9a:db:11:35 -t 4  -s 64
> 
> (adjust iface, IP and MAC address to your system, of course). That'll
> flood the target machine with small UDP packets. On that machine, I then
> run the 'xdp_redirect_map' program from samples/bpf. The bpf program
> used by that sample will update an internal counter for every packet,
> and the userspace prints it out, which gives you the performance (in
> PPS). So just modifying that sample to using your new multicast helper
> (and comparing it to regular REDIRECT to a single device) would be a
> first approximation of a performance test.

Thanks for this method. I will update the sample and do some more tests.
> 
> You could do something like:
> 
> bool first = true;
> for (;;) {
> 
> [...]
> 
>            if (!first) {
>    		nxdpf = xdpf_clone(xdpf);
>    		if (unlikely(!nxdpf))
>    			return -ENOMEM;
>    		bq_enqueue(dev, nxdpf, dev_rx);
>            } else {
>    		bq_enqueue(dev, xdpf, dev_rx);
>    		first = false;
>            }
> }
> 
> /* didn't find anywhere to forward to, free buf */
> if (first)
>    xdp_return_frame_rx_napi(xdpf);

I think the first xdpf will be consumed by the driver and the later
xdpf_clone() will failed, won't it?

How about just do a xdp_return_frame_rx_napi(xdpf) after all nxdpf enqueue?

> > @@ -3534,6 +3539,8 @@ int xdp_do_redirect(struct net_device *dev, struct
> > xdp_buff *xdp,
> >                   struct bpf_prog *xdp_prog)
> >  {
> >       struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> > +     bool exclude_ingress = !!(ri->flags & BPF_F_EXCLUDE_INGRESS);
> > +     struct bpf_map *ex_map = READ_ONCE(ri->ex_map);
>
> I don't think you need the READ_ONCE here since there's already one
> below?

BTW, I forgot to ask, why we don't need the READ_ONCE for ex_map?
I though the map and ex_map are two different pointers.

> >       struct bpf_map *map = READ_ONCE(ri->map);

Thanks
Hangbin
