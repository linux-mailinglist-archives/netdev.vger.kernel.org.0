Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C60F261F06
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbgIHT6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731533AbgIHT6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 15:58:02 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A4FC061573;
        Tue,  8 Sep 2020 12:58:01 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so57595pff.6;
        Tue, 08 Sep 2020 12:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=t1FFZYa1Mtu/BUWpW5DmxBtlSdSmEJ+N7+ptNlY0L1k=;
        b=l/IX42nqAeUXFd1LGaglx6+FphFwAArzrYFQ3IXIJcYHK/nL6eiMulZUgLHUXHQSS4
         RsXM3woch0grLGh8gZmiy6+5blKSVtZr4iKP24MsT0rJXn0m3QCVi5mIbJKOg+6lUkNm
         NyAkS8bxRXziCAve2E5DAhBp/gnG3MkMjcY+Fv1vpM/JI01aRmtiLmKYOnlZxP7wwEmy
         K17KGTo9/QQ/WEacmPAN13fELIc3qRggDNn/zJpg+CA37dvHuU15PHLDP0xyVH3SfiLn
         2hatHzfG3KtdbfKqb6sf7SlaJ7NrMuttDjkfjaeTWfT2a4Mr3cAUYrqwUDioixqJBcOI
         46/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=t1FFZYa1Mtu/BUWpW5DmxBtlSdSmEJ+N7+ptNlY0L1k=;
        b=GK3xPFAkIXWoX1JYKJydk9OZR+JFOK0s4mGGtk8VjSdtLtvpBZm6hibus3o3zSx5uY
         gt6Xn37o60j3k6Iec5Sj88M5Idw6sQdgRFBRIbTuEyKPAoLULPu78iZ2dM9xi40Sd4ME
         eYCjqA4nSegQrujbZN5fFU6KMRzFgpOt80xwyucLBo2nQBw7d1ItBSTsrn3VdZQsRJu/
         hy4tonjVAeCgEcpIyz4xum2Q7boKWOcAH6lH9xASmYRyKB6XPi9wPfeMaUo+3szvchuT
         PfWnS5g+eUc20NG5Bb3LgPPqIsKloK68eHU8gQ3LDEoQrnqjHCAotA7xoMS+FRdqUpoW
         XzIw==
X-Gm-Message-State: AOAM532j+6RRt4ZqboeD/X54hMCFb+oS+XL/s3XxuMa7NcgeU4eMn8Hf
        J5ElLGE+0NbERicpb6e+Fo0=
X-Google-Smtp-Source: ABdhPJx5JUcRUiJx0UFIXo/tai4m2m5SELTkT6kz+6nENwQyPoLFOtULQFfVKI3hVQod1gdtw74Paw==
X-Received: by 2002:a62:55c5:: with SMTP id j188mr351992pfb.103.1599595081401;
        Tue, 08 Sep 2020 12:58:01 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l5sm115122pgm.80.2020.09.08.12.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 12:58:00 -0700 (PDT)
Date:   Tue, 08 Sep 2020 12:57:50 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        edumazet@google.com
Message-ID: <5f57e23e513b2_10343208e0@john-XPS-13-9370.notmuch>
In-Reply-To: <20200906133617.GC2785@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
 <5f51e2f2eb22_3eceb20837@john-XPS-13-9370.notmuch>
 <20200904094511.GF2884@lore-desk>
 <5f525be3da548_1932208b6@john-XPS-13-9370.notmuch>
 <20200906133617.GC2785@lore-desk>
Subject: Re: [PATCH v2 net-next 6/9] bpf: helpers: add
 bpf_xdp_adjust_mb_header helper
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> > Lorenzo Bianconi wrote:
> > > > Lorenzo Bianconi wrote:
> 
> [...]
> 
> > > > > + *	Description
> > > > > + *		Adjust frame headers moving *offset* bytes from/to the second
> > > > > + *		buffer to/from the first one. This helper can be used to move
> > > > > + *		headers when the hw DMA SG does not copy all the headers in
> > > > > + *		the first fragment.
> > > 
> > > + Eric to the discussion
> > > 

[...]

> > > > > +BPF_CALL_2(bpf_xdp_adjust_mb_header, struct  xdp_buff *, xdp,
> > > > > +	   int, offset)
> > > > > +{
> > > > > +	void *data_hard_end, *data_end;
> > > > > +	struct skb_shared_info *sinfo;
> > > > > +	int frag_offset, frag_len;
> > > > > +	u8 *addr;
> > > > > +
> > > > > +	if (!xdp->mb)
> > > > > +		return -EOPNOTSUPP;
> > 
> > Not required for this patch necessarily but I think it would be better user
> > experience if instead of EOPNOTSUPP here we did the header split. This
> > would allocate a frag and copy the bytes around as needed. Yes it might
> > be slow if you don't have a frag free in the driver, but if user wants to
> > do header split and their hardware can't do it we would have a way out.
> > 
> > I guess it could be an improvement for later though.
> 
> I have no a strong opinion on this, I did it in this way to respect the rule "we
> do not allocate memory for XDP".
> 
> @Jesper, David: thoughts?

Consider adding a flags field to the helper so we could do this later with
a flag. Then users who want the alloc can set the flag and get it.

[...]

> 
> > 
> > How/when does the header split go wrong on the mvneta device? I guess
> > this is to fix a real bug/issue not some theoritical one? An example
> > in the commit message would make this concrete. Soemthing like,
> > "When using RX zerocopy to mmap data into userspace application if
> > a packet with [all these wild headers] is received rx zerocopy breaks
> > because header split puts headers X in the data frag confusing apps".
> 
> This issue does not occur with mvneta since the driver is not capable of
> performing header split AFAIK. The helper has been introduced to cover the
> "issue" reported by Eric in his NetDevConf presentation. In order to test the
> helper I modified the mventa rx napi loop in a controlled way (this patch can't
> be sent upstream, it is for testing only :))
> I will improve commit message in v3.

Ah ok so really there is no users for the helper then IMO just drop
the patch until we have a user then.

> 
> > 
> > > 
> > > > 
> > > > Also and even more concerning I think this API requires the
> > > > driver to populate shinfo. If we use TX_REDIRECT a lot or TX_XMIT
> > > > this means we need to populate shinfo when its probably not ever
> > > > used. If our driver is smart L2/L3 headers are in the readable
> > > > data and prefetched. Writing frags into the end of a page is likely
> > > > not free.
> > > 
> > > Sorry I did not get what you mean with "populate shinfo" here. We need to
> > > properly set shared_info in order to create the xdp multi-buff.
> > > Apart of header splits, please consider the main uses-cases for
> > > xdp multi-buff are XDP with TSO and Jumbo frames.
> > 
> > The use case I have in mind is a XDP_TX or XDP_REDIRECT load balancer.
> > I wont know this at the driver level and now I'll have to write into
> > the back of every page with this shinfo just in case. If header
> > split is working I should never need to even touch the page outside
> > the first N bytes that were DMAd and in cache with DDIO. So its extra
> > overhead for something that is unlikely to happen in the LB case.
> 
> So far the skb_shared_info in constructed in mvneta only if the hw splits
> the received data in multiple buffers (so if the MTU is greater than 1 PAGE,
> please see comments below). Moreover the shared_info is present only in the
> first buffer.

Still in a normal L2/L3/L4 use case I expect all the headers you
need to be in the fist buffer so its unlikely for use cases that
send most traffic via XDP_TX for example to ever need the extra
info. In these cases I think you are paying some penalty for
having to do the work of populating the shinfo. Maybe its measurable
maybe not I'm not sure.

Also if we make it required for multi-buffer than we also need
the shinfo on 40gbps or 100gbps nics and now even small costs
matter.

> 
> > 
> > If you take the simplest possible program that just returns XDP_TX
> > and run a pkt generator against it. I believe (haven't run any
> > tests) that you will see overhead now just from populating this
> > shinfo. I think it needs to only be done when its needed e.g. when
> > user makes this helper call or we need to build the skb and populate
> > the frags there.
> 
> sure, I will carry out some tests.

Thanks!

> 
> > 
> > I think a smart driver will just keep the frags list in whatever
> > form it has them (rx descriptors?) and push them over to the
> > tx descriptors without having to do extra work with frag lists.
> 
> I think there are many use-cases where we want to have this info available in
> xdp_buff/xdp_frame. E.g: let's consider the following Jumbo frame example:
> - MTU > 1 PAGE (so we the driver will split the received data in multiple rx
>   descriptors)
> - the driver performs a XDP_REDIRECT to a veth or cpumap
> 
> Relying on the proposed architecture we could enable GRO in veth or cpumap I
> guess since we can build a non-linear skb from the xdp multi-buff, right?

I'm not disputing there are use-cases. But, I'm trying to see if we
can cover those without introducing additional latency in other
cases. Hence the extra benchmarks request ;)

> 
> > 
> > > 
> > > > 
> > > > Did you benchmark this?
> > > 
> > > will do, I need to understand if we can use tiny buffers in mvneta.
> > 
> > Why tiny buffers? How does mvneta layout the frags when doing
> > header split? Can we just benchmark what mvneta is doing at the
> > end of this patch series?
> 
> for the moment mvneta can split the received data when the previous buffer is
> full (e.g. when we the first page is completely written). I want to explore if
> I can set a tiny buffer (e.g. 128B) as max received buffer to run some performance
> tests and have some "comparable" results respect to the ones I got when I added XDP
> support to mvneta.

OK would be great.

> 
> > 
> > Also can you try the basic XDP_TX case mentioned above.
> > I don't want this to degrade existing use cases if at all
> > possible.
> 
> sure, will do.

Thanks!
