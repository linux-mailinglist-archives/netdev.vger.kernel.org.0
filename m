Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F7D25DD29
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgIDPX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730220AbgIDPX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 11:23:26 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB4DC061244;
        Fri,  4 Sep 2020 08:23:25 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q3so1297654pls.11;
        Fri, 04 Sep 2020 08:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=BNzxX5yswr/CKFrK+Jwu1Ic66M3652mEwr8rk1bhwog=;
        b=fnjWtVukf5lII0b5cqY6J6XJoFvaNpudxzWbcHy9zX8EV73fQyh78Ay9kOxsmkX0/6
         AaSbccEdP6qs3YT+ZP9h5M1z+MvcaayomJOmDnrQxjICYtckosQQHEwmLd11R8dze7RM
         VJDO0yP0OilYFpo/azBF/2pThtwPb7pgKLl3rEJkXmG1FEdNSg5NWaRPcDNWNFwk/PXQ
         db9w6X4zLfdRGBWXCUUHSBXseiCwz9PR1dHx2VRGoJVKD6MzTOEsJPT96pQbELuNwWfq
         w6y7Y2zoMfuygMbKnQfwcn70ulxOShO6MUd/PBAHJOshn4658phuYJ0+Vi7PfmPHeTBQ
         43/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=BNzxX5yswr/CKFrK+Jwu1Ic66M3652mEwr8rk1bhwog=;
        b=J9faq/i4RCDbxH494gl8dpcmQhA5fIKkMY/a0UIKO8B0kq0nad6BwBY2wFf5CSC+l+
         9b0rjQ372njRa/3VhQhW3y1k+k6R40akTvKOQSfb6eGTI+aqjuJCRiNItp838aulRo9v
         /jvfD2ulF/0pBmWzyswzK0bqIr77BiYPj8Wo29tam2ucOLutysr+b6ELJCjbJISO2nrd
         i4LxkrxJyWsmFIHYzL8F55JEwcPcSljbW2JC0W53A0I5yYt7efjt3aiQGmSN/s1Aj6/2
         +U5CFhMsz55SvFlblFre7z3vqQm81SvVPeBJwKu5e70RzJgoCf8MIOjp2F5QI+w5/tWJ
         eWAw==
X-Gm-Message-State: AOAM531t3Sc1qoH4N/xFdbwJoKQ+ziSCOhqniD4uXRtNN/oVsTq2hvJ2
        ODcv1OP13nRcF2OkDrFICRM=
X-Google-Smtp-Source: ABdhPJym5zbHJRnph18F3FfJegDw5GrsuE7LozSWuSscmaAmWFbBPvurKFpfjpv9qJSqe1EZGRdspA==
X-Received: by 2002:a17:90a:ead8:: with SMTP id ev24mr8709451pjb.89.1599233004357;
        Fri, 04 Sep 2020 08:23:24 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k5sm5840378pjq.5.2020.09.04.08.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 08:23:23 -0700 (PDT)
Date:   Fri, 04 Sep 2020 08:23:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        edumazet@google.com
Message-ID: <5f525be3da548_1932208b6@john-XPS-13-9370.notmuch>
In-Reply-To: <20200904094511.GF2884@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
 <5f51e2f2eb22_3eceb20837@john-XPS-13-9370.notmuch>
 <20200904094511.GF2884@lore-desk>
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
> > > Introduce bpf_xdp_adjust_mb_header helper in order to adjust frame
> > > headers moving *offset* bytes from/to the second buffer to/from the
> > > first one.
> > > This helper can be used to move headers when the hw DMA SG is not able
> > > to copy all the headers in the first fragment and split header and data
> > > pages.
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  include/uapi/linux/bpf.h       | 25 ++++++++++++----
> > >  net/core/filter.c              | 54 ++++++++++++++++++++++++++++++++++
> > >  tools/include/uapi/linux/bpf.h | 26 ++++++++++++----
> > >  3 files changed, 95 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 8dda13880957..c4a6d245619c 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -3571,11 +3571,25 @@ union bpf_attr {
> > >   *		value.
> > >   *
> > >   * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
> > > - * 	Description
> > > - * 		Read *size* bytes from user space address *user_ptr* and store
> > > - * 		the data in *dst*. This is a wrapper of copy_from_user().
> > > - * 	Return
> > > - * 		0 on success, or a negative error in case of failure.
> > > + *	Description
> > > + *		Read *size* bytes from user space address *user_ptr* and store
> > > + *		the data in *dst*. This is a wrapper of copy_from_user().
> > > + *
> > > + * long bpf_xdp_adjust_mb_header(struct xdp_buff *xdp_md, int offset)
> > > + *	Description
> > > + *		Adjust frame headers moving *offset* bytes from/to the second
> > > + *		buffer to/from the first one. This helper can be used to move
> > > + *		headers when the hw DMA SG does not copy all the headers in
> > > + *		the first fragment.
> 
> + Eric to the discussion
> 
> > 
> > This is confusing to read. Does this mean I can "move bytes to the second
> > buffer from the first one" or "move bytes from the second buffer to the first
> > one" And what are frame headers? I'm sure I can read below code and work
> > it out, but users reading the header file should be able to parse this.
> 
> Our main goal with this helper is to fix the use-case where we request the hw
> to put L2/L3/L4 headers (and all the TCP options) in the first fragment and TCP
> data starting from the second fragment (headers split) but for some reasons
> the hw puts the TCP options in the second fragment (if we understood correctly
> this issue has been introduced by Eric @ NetDevConf 0x14).
> bpf_xdp_adjust_mb_header() can fix this use-case moving bytes from the second fragment
> to the first one (offset > 0) or from the first buffer to the second one (offset < 0).

Ah OK, so the description needs the information about how to use offset then it
would have been clear I think. Something like that last line "moving bytes from
the second fragment ...."

So this is to fixup header-spit for RX zerocopy? Add that to the commit
message then.

> 
> > 
> > Also we want to be able to read all data not just headers. Reading the
> > payload of a TCP packet is equally important for many l7 load balancers.
> > 
> 
> In order to avoid to slow down performances we require that eBPF sandbox can
> read/write only buff0 in a xdp multi-buffer. The xdp program can only
> perform some restricted changes to buff<n> (n >= 1) (e.g. what we did in
> bpf_xdp_adjust_mb_header()).
> You can find the xdp multi-buff design principles here [0][1]
> 
> [0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
> [1] http://people.redhat.com/lbiancon/conference/NetDevConf2020-0x14/add-xdp-on-driver.html - XDP multi-buffers section (slide 40)
> 
> > > + *
> > > + *		A call to this helper is susceptible to change the underlying
> > > + *		packet buffer. Therefore, at load time, all checks on pointers
> > > + *		previously done by the verifier are invalidated and must be
> > > + *		performed again, if the helper is used in combination with
> > > + *		direct packet access.
> > > + *
> > > + *	Return
> > > + *		0 on success, or a negative error in case of failure.
> > >   */
> > >  #define __BPF_FUNC_MAPPER(FN)		\
> > >  	FN(unspec),			\
> > > @@ -3727,6 +3741,7 @@ union bpf_attr {
> > >  	FN(inode_storage_delete),	\
> > >  	FN(d_path),			\
> > >  	FN(copy_from_user),		\
> > > +	FN(xdp_adjust_mb_header),	\
> > >  	/* */
> > >  
> > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 47eef9a0be6a..ae6b10cf062d 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -3475,6 +3475,57 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
> > >  	.arg2_type	= ARG_ANYTHING,
> > >  };
> > >  
> > > +BPF_CALL_2(bpf_xdp_adjust_mb_header, struct  xdp_buff *, xdp,
> > > +	   int, offset)
> > > +{
> > > +	void *data_hard_end, *data_end;
> > > +	struct skb_shared_info *sinfo;
> > > +	int frag_offset, frag_len;
> > > +	u8 *addr;
> > > +
> > > +	if (!xdp->mb)
> > > +		return -EOPNOTSUPP;

Not required for this patch necessarily but I think it would be better user
experience if instead of EOPNOTSUPP here we did the header split. This
would allocate a frag and copy the bytes around as needed. Yes it might
be slow if you don't have a frag free in the driver, but if user wants to
do header split and their hardware can't do it we would have a way out.

I guess it could be an improvement for later though.


> > > +
> > > +	sinfo = xdp_get_shared_info_from_buff(xdp);
> > > +
> > > +	frag_len = skb_frag_size(&sinfo->frags[0]);
> > > +	if (offset > frag_len)
> > > +		return -EINVAL;
> > 
> > What if we want data in frags[1] and so on.
> > 
> > > +
> > > +	frag_offset = skb_frag_off(&sinfo->frags[0]);
> > > +	data_end = xdp->data_end + offset;
> > > +
> > > +	if (offset < 0 && (-offset > frag_offset ||
> > > +			   data_end < xdp->data + ETH_HLEN))
> > > +		return -EINVAL;
> > > +
> > > +	data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
> > > +	if (data_end > data_hard_end)
> > > +		return -EINVAL;
> > > +
> > > +	addr = page_address(skb_frag_page(&sinfo->frags[0])) + frag_offset;
> > > +	if (offset > 0) {
> > > +		memcpy(xdp->data_end, addr, offset);
> > 
> > But this could get expensive for large amount of data? And also
> > limiting because we require the room to do the copy. Presumably
> > the reason we have fargs[1] is because the normal page or half
> > page is in use?
> > 
> > > +	} else {
> > > +		memcpy(addr + offset, xdp->data_end + offset, -offset);
> > > +		memset(xdp->data_end + offset, 0, -offset);
> > > +	}
> > > +
> > > +	skb_frag_size_sub(&sinfo->frags[0], offset);
> > > +	skb_frag_off_add(&sinfo->frags[0], offset);
> > > +	xdp->data_end = data_end;
> > > +
> > > +	return 0;
> > > +}
> > 
> > So overall I don't see the point of copying bytes from one frag to
> > another. Create an API that adjusts the data pointers and then
> > copies are avoided and manipulating frags is not needed.
> 
> please see above.

OK it makes more sense with the context. It doesn't have much if anything
to do about making data visible to the BPF program. This is about
changing the layout of the frags list.

How/when does the header split go wrong on the mvneta device? I guess
this is to fix a real bug/issue not some theoritical one? An example
in the commit message would make this concrete. Soemthing like,
"When using RX zerocopy to mmap data into userspace application if
a packet with [all these wild headers] is received rx zerocopy breaks
because header split puts headers X in the data frag confusing apps".

> 
> > 
> > Also and even more concerning I think this API requires the
> > driver to populate shinfo. If we use TX_REDIRECT a lot or TX_XMIT
> > this means we need to populate shinfo when its probably not ever
> > used. If our driver is smart L2/L3 headers are in the readable
> > data and prefetched. Writing frags into the end of a page is likely
> > not free.
> 
> Sorry I did not get what you mean with "populate shinfo" here. We need to
> properly set shared_info in order to create the xdp multi-buff.
> Apart of header splits, please consider the main uses-cases for
> xdp multi-buff are XDP with TSO and Jumbo frames.

The use case I have in mind is a XDP_TX or XDP_REDIRECT load balancer.
I wont know this at the driver level and now I'll have to write into
the back of every page with this shinfo just in case. If header
split is working I should never need to even touch the page outside
the first N bytes that were DMAd and in cache with DDIO. So its extra
overhead for something that is unlikely to happen in the LB case.

If you take the simplest possible program that just returns XDP_TX
and run a pkt generator against it. I believe (haven't run any
tests) that you will see overhead now just from populating this
shinfo. I think it needs to only be done when its needed e.g. when
user makes this helper call or we need to build the skb and populate
the frags there.

I think a smart driver will just keep the frags list in whatever
form it has them (rx descriptors?) and push them over to the
tx descriptors without having to do extra work with frag lists.

> 
> > 
> > Did you benchmark this?
> 
> will do, I need to understand if we can use tiny buffers in mvneta.

Why tiny buffers? How does mvneta layout the frags when doing
header split? Can we just benchmark what mvneta is doing at the
end of this patch series?

Also can you try the basic XDP_TX case mentioned above.
I don't want this to degrade existing use cases if at all
possible.

> 
> > 
> > In general users of this API should know the bytes they want
> > to fetch. Use an API like this,
> > 
> >   bpf_xdp_adjust_bytes(xdp, start, end)
> > 
> > Where xdp is the frame, start is the first byte the user wants
> > and end is the last byte. Then usually you can skip the entire
> > copy part and just move the xdp pointesr around. The ugly case
> > is if the user puts start/end across a frag boundary and a copy
> > is needed. In that case maybe we use end as a hint and not a
> > hard requirement.
> > 
> > The use case I see is I read L2/L3/L4 headers and I need the
> > first N bytes of the payload. I know where the payload starts
> > and I know how many bytes I need so,
> > 
> >   bpf_xdp_adjust_bytes(xdp, payload_offset, bytes_needed);
> > 
> > Then hopefully that is all in one frag. If its not I'll need
> > to do a second helper call. Still nicer than forcing drivers
> > to populate this shinfo I think. If you think I'm wrong try
> > a benchmark. Benchmarks aside I get stuck when data_end and
> > data_hard_end are too close together.
> 
> IIUC what you mean here is to expose L2/L3/L4 headers + some data to
> the ebpf program to perform like L7 load-balancing, right?

Correct, but with extra context I see in this patch you are trying
to build an XDP controlled header split. This seems like a different
use case from mine.

> Let's consider the Jumbo frames use-case (so the data are split in multiple
> buffers). I can see to issues here:
> - since in XDP we can't linearize the buffer if start and end are on the
>   different pages (like we do in bpf_msg_pull_data()), are we ending up
>   in the case where requested data are all in buff0? 

In this case I would expect either the helper returns how many bytes
were pulled in, maybe just (start, end_of_frag) or user can find
it from data_end pointer. Here end is just a hint.

> - if  start and end are in buff<2>, we should report the fragment number to the
>   ebpf program to "fetch" the data. Are we exposing too low-level details to
>   user-space?

Why do you need the frag number? Just say I want bytes (X,Y) if that
happens to be on buff<2> let the helper find it.

I think having a helper to read/write any bytes is important and
necessary, but the helper implemented in this patch is something
else. I get naming is hard what if we called it xdp_header_split().

> 
> Regards,
> Lorenzo
> 
> > 
> > Thanks,
> > John


