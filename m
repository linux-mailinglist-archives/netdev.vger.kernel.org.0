Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAA81EE440
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 14:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgFDMM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 08:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbgFDMMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 08:12:24 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9903C08C5C0;
        Thu,  4 Jun 2020 05:12:24 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i12so1066639pju.3;
        Thu, 04 Jun 2020 05:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LV1RNhMbKMwSSduuidhEVjpgyE+u5e6GQbhSj+aHirE=;
        b=l6vJPUKLnBT5PgBCCN0IZs2UA4Jg1z8WNxl5Y4aTZuUo/wh1IIFka9LingFNPxHz1q
         km7itzDEYolQWuWpSCmCcO3zXBBAZ/PIVJkzBc6LGDHPxIkB4iY3Xj6IkPLTENWO+D9n
         6Dt1g4Sz9UFON/t9aMXLBY+Q+5QJDZeyZhLvnwCBzTAvybPsaS52WkMarUvwgyv1Hx13
         BCj+vDbFEIZLWmUfjpZzbaIYCS2NF33fn24NLLvoe+fcbkk4Xz7CJeH9PLo7MRISR1vF
         fI7jVXETphjK7jCcBs7elCwja8ZJWyUCm1Q4mglBU477mFUUJxaonDpXk/+Q9PzV0QOx
         ha6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LV1RNhMbKMwSSduuidhEVjpgyE+u5e6GQbhSj+aHirE=;
        b=tPJLzevoshQ4iFkOXg5rgQW6iAuta/SExoqovbMDv9TWad8Xx0SvgZUI9TpRVupmeJ
         zYJX3IIx5r9NARQuaHjsaB03oMIAgqxT5DYz7pw77TIXyXCkKkWBPXiOE3Y6OLzkGvFD
         hbYiW12yCIhEuv4DkqqJrRWj298LsJx0+O+anck6LX7arb9WSYojx/KIUk24CRY+FKTV
         VX5FkqGBbuRUJFwBvV5T6UIVFx4wPUq+j7QFT1h043ZA3VItVWUeqdmpMfLxKS/9kTUZ
         mDe7EZ2aT/tSyun9hbEJZ+QmuQoqwjfusEBTJM2xato75o4ZmYEIxxpoQHec8Nd3TIP1
         earw==
X-Gm-Message-State: AOAM532IaTELbMXpV4lPQ0YpFT0wNh3a7DMF/Fbe0BSnVyNri2Ph42hO
        9/Z+X2ZXEs7uY8A8e1S6Jm8=
X-Google-Smtp-Source: ABdhPJxKGS66KrSf+QdLuzXITcqXHH2ngFZuHIXI0njwHs4UgrPdX7XLNrsLMoVuO8u3mr+7Jy49rQ==
X-Received: by 2002:a17:90a:43c7:: with SMTP id r65mr5552777pjg.76.1591272743860;
        Thu, 04 Jun 2020 05:12:23 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j186sm4495912pfb.220.2020.06.04.05.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 05:12:23 -0700 (PDT)
Date:   Thu, 4 Jun 2020 20:12:12 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200604121212.GM102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200526140539.4103528-1-liuhangbin@gmail.com>
 <87zh9t1xvh.fsf@toke.dk>
 <20200603024054.GK102436@dhcp-12-153.nay.redhat.com>
 <87img8l893.fsf@toke.dk>
 <20200604040940.GL102436@dhcp-12-153.nay.redhat.com>
 <871rmvkvwn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871rmvkvwn.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 11:44:24AM +0200, Toke Høiland-Jørgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> > Here is the test topology, which looks like
> >
> >  Host A    |     Host B        |        Host C
> >  eth0      +    eth0 - eth1    +        eth0
> >
> > I did pktgen sending on Host A, forwarding on Host B.
> > Host B is a Dell PowerEdge R730 (128G memory, Intel(R) Xeon(R) CPU E5-2690 v3)
> > eth0, eth1 is an onboard i40e 10G driver
> >
> > Test 1: add eth0, eth1 to br0 and test bridge forwarding
> > Test 2: Test xdp_redirect_map(), eth0 is ingress, eth1 is egress
> > Test 3: Test xdp_redirect_map_multi(), eth0 is ingress, eth1 is egress
> 
> Right, that all seems reasonable, but that machine is comparable to
> my test machine, so you should be getting way more than 2.75 MPPS on a
> regular redirect test. Are you bottlenecked on pktgen or something?

Yes, I found the pktgen is bottleneck. I only use 1 thread.
By using the cmd you gave to me
./pktgen_sample03_burst_single_flow.sh  -i eno1 -d 192.168.200.1 -m f8:bc:12:14:11:20 -t 4  -s 64

Now I could get higher speed.

> 
> Could you please try running Jesper's ethtool stats poller:
> https://github.com/netoptimizer/network-testing/blob/master/bin/ethtool_stats.pl

Nice tool.

> > I though you want me also test with bridge forwarding. Am I missing something?
> 
> Yes, but what does this mean:
> > (I use sample/bpf/xdp1 to count the PPS, so there are two modes data):
> 
> or rather, why are there two numbers? :)

Just as it said, to test bridge forwarding speed. I use the xdp tool
sample/bpf/xdp1 to count the PPS. But there are two modes when attach xdp
to eth0, general and driver mode. So there are 2 number..

Now I use the ethtool_stats.pl to count forwarding speed and here is the result:

With kernel 5.7(ingress i40e, egress i40e)
XDP:
bridge: 1.8M PPS
xdp_redirect_map:
  generic mode: 1.9M PPS
  driver mode: 10.4M PPS

Kernel 5.7 + my patch(ingress i40e, egress i40e)
bridge: 1.8M
xdp_redirect_map:
  generic mode: 1.86M PPS
  driver mode: 10.17M PPS
xdp_redirect_map_multi:
  generic mode: 1.53M PPS
  driver mode: 7.22M PPS

Kernel 5.7 + my patch(ingress i40e, egress veth)
xdp_redirect_map:
  generic mode: 1.38M PPS
  driver mode: 4.15M PPS
xdp_redirect_map_multi:
  generic mode: 1.13M PPS
  driver mode: 3.55M PPS

Kernel 5.7 + my patch(ingress i40e, egress i40e + veth)
xdp_redirect_map_multi:
  generic mode: 1.13M PPS
  driver mode: 3.47M PPS

I added a group that with i40e ingress and veth egress, which shows
a significant drop on the speed. It looks like veth driver is a bottleneck,
but I don't have more i40e NICs on the test bed...

Thanks
Hangbin

