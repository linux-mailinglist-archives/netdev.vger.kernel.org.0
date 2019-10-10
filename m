Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52667D311E
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfJJTHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:07:25 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40632 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfJJTHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 15:07:25 -0400
Received: by mail-pf1-f196.google.com with SMTP id x127so4490244pfb.7;
        Thu, 10 Oct 2019 12:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MhM3MBjIsBv2BuvleyV0+fZkJP95V4tElogDTT0aEDU=;
        b=eOm5xohcrYsAp/Ik2r4XySQQBw5UGfIqQxtFAxWf7Sbkjki7F5v4yhATwiC+ECfy2T
         PHWLOH+QmDqOSJwGt9VyzrmOrRxTvjb0m9DpBuQNWT1ahEiXVHEpGMi906zR3TsxpXeL
         9o4CO8woahF6dvqVrz2d97ldu0xQtPwYQP/jTakjfmFHGl9WdQ5Qe7iQ9JbInX4FWAFr
         BUtp7EE6gMW2Ob5CjQ23Wa3izsERv9fDS1Eg6NGug+CBRquslCvWnoM3+zp+Cb0IT+0g
         6LzWWUyw9BwgZIxakByNaeVygLucrIHROj66aLYYTFPgnxlFvEMCCYy7btCIdSjPDlWm
         inmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MhM3MBjIsBv2BuvleyV0+fZkJP95V4tElogDTT0aEDU=;
        b=UoxDjEOd8EfqlDJ5vlhsTyQqzo5J4UVRE7yC8jug/rh0ijql3A2RSvF73TafinUB9x
         DYFf9I/0k9qfwU9g6qj14TwOuJ0Fm4UfoT8AZ7BOlW5HEMwW/KDwbxFB4/dM48z1nqeX
         aQvEIoPri0vzo9f4mLuomurHT9AnPENd/mtgrPz50og+9HxTFHREzaAzppPlFlq24jNW
         Gg7d2OygDWXWWm8AGeyY9nDV+bMysASuZFVB9PuobrJgmX2mW/Kf9Xu5wwQr6zBn/m12
         s3zy7zrBsy7jVT8+a2r90vMhE0jqf4O22Muv1HZvmE5gZcrhWQNTDfEjixMWCbE781y7
         mc+w==
X-Gm-Message-State: APjAAAUnPrAupJBcroiVLtioKmIQQnAB6V3K5b7jC92e5EO5vY+BltXw
        rLTbFyBb8QTS6/rXsmkDIzWrsQA3
X-Google-Smtp-Source: APXvYqyJadDsxdAWbNL7hbFzJd0GYo2e0EgwO1cf2mtmq1qnQmInZvTSv1IdIgm8gGISRaNex4kkFQ==
X-Received: by 2002:a63:151d:: with SMTP id v29mr12544719pgl.366.1570734444471;
        Thu, 10 Oct 2019 12:07:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f66f])
        by smtp.gmail.com with ESMTPSA id b5sm5400551pgb.68.2019.10.10.12.07.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 12:07:23 -0700 (PDT)
Date:   Thu, 10 Oct 2019 12:07:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        edumazet@google.com
Subject: Re: [PATCH v2 bpf-next 12/12] selftests/bpf: add kfree_skb raw_tp
 test
Message-ID: <20191010190634.lpxo5n5qpef3nwdj@ast-mbp.dhcp.thefacebook.com>
References: <20191010041503.2526303-1-ast@kernel.org>
 <20191010041503.2526303-13-ast@kernel.org>
 <20191010110729.GA21703@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010110729.GA21703@splinter>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 02:07:29PM +0300, Ido Schimmel wrote:
> On Wed, Oct 09, 2019 at 09:15:03PM -0700, Alexei Starovoitov wrote:
> > +SEC("raw_tracepoint/kfree_skb")
> > +int trace_kfree_skb(struct trace_kfree_skb *ctx)
> > +{
> > +	struct sk_buff *skb = ctx->skb;
> > +	struct net_device *dev;
> > +	int ifindex;
> > +	struct callback_head *ptr;
> > +	void *func;
> > +
> > +	__builtin_preserve_access_index(({
> > +		dev = skb->dev;
> > +		ifindex = dev->ifindex;
> 
> Hi Alexei,
> 
> The patchset looks very useful. One question: Is it always safe to
> access 'skb->dev->ifindex' here? I'm asking because 'dev' is inside a
> union with 'dev_scratch' which is 'unsigned long' and therefore might
> not always be a valid memory address. Consider for example the following
> code path:
> 
> ...
> __udp_queue_rcv_skb(sk, skb)
> 	__udp_enqueue_schedule_skb(sk, skb)
> 		udp_set_dev_scratch(skb)
> 		// returns error
> 	...
> 	kfree_skb(skb) // ebpf program is invoked
> 
> How is this handled by eBPF?

Excellent question. There are cases like this where the verifier cannot possibly
track semantics of the kernel code and union of pointer with scratch area
like this. That's why every access through btf pointer is a hidden probe_read.
Comparing to old school tracing all memory accesses were probe_read
and bpf prog was free to read anything and page fault everywhere.
Now bpf prog will almost always access correct data. Yet corner cases like
this are inevitable. I'm working on few ideas how to improve it further
with btf-tagged slab allocations and kasan-like memory shadowing.

Your question made me thinking whether we have a long standing issue
with dev_scratch, since even classic bpf has SKF_AD_IFINDEX hack
which is implemented as:
    *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, dev),
                          BPF_REG_TMP, BPF_REG_CTX,
                          offsetof(struct sk_buff, dev));
    /* if (tmp != 0) goto pc + 1 */
    *insn++ = BPF_JMP_IMM(BPF_JNE, BPF_REG_TMP, 0, 1);
    *insn++ = BPF_EXIT_INSN();
    if (fp->k == SKF_AD_OFF + SKF_AD_IFINDEX)
            *insn = BPF_LDX_MEM(BPF_W, BPF_REG_A, BPF_REG_TMP,
                                offsetof(struct net_device, ifindex));

That means for long time [c|e]BPF code was checking skb->dev for NULL only.
I've analyzed the code where socket filters can be called and I think it's good
there. dev_scratch is used after sk_filter has run.
But there are other hooks: lwt, various cgroups.
I've checked lwt and cgroup inet/egress. I think dev_scratch should not be
used in these paths. So should be good there as well.
But I think the whole idea of aliasing scratch into 'dev' pointer is dangerous.
There are plenty of tracepoints that do skb->dev->foo. Hard to track where
everything is called.
I think udp code need to move this dev_scratch into some other place in skb.

