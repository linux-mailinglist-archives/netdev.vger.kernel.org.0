Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1823B3139
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhFXO1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhFXO1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:27:08 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913AEC061574;
        Thu, 24 Jun 2021 07:24:49 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id i17so6448775ilj.11;
        Thu, 24 Jun 2021 07:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5ookobeVhr64r1NaUzaLn/rFAOpu9+UYNo31Yeae0Iw=;
        b=cOHUdhaZootRKX2DAQO/73sxk9NheMXwv/iPVOtTNgTLrQuIJsvokK+CI4tVwvR1Sz
         jI5SElKgrVcsreuz/5Pg4LLYuVzDJXzlHaGIgoQK0y3caFGWvnn7JGqRs/j2oH7KTlX+
         jmHKGrq4iHSrsexRBELc8okQdiYNkROiDqYC7DDb10kAGnU08ncKsDckOZwrZ4whma8q
         2azwVUcdPJmlwlVQAa8No43suzN91CdWFMKoKUaWSLn1F0RA7MUfmm/dZWRNSMgFXjkf
         GsOVBdSb7lFZ3yicch2f3PtQLrB1+J3f5gb6Z6fQGU0tPypqEg2uKQf33z9Fuf8Yv7F4
         cTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5ookobeVhr64r1NaUzaLn/rFAOpu9+UYNo31Yeae0Iw=;
        b=mQRjNCleBQz9FnVeok5dzKmVwTpOh6hA7BxrGMbxg5wDnwPbMK0tpRJ/To40ZN0kzL
         6INjx2FBBVdJqukh/JsmP6R1/MBbOVpOuTpx2eUGOip+m0wivILBFj6mLkpt48YQNBQg
         DB17BMkaJWzMbZ2IeVvB1SUzwJi9nK5mRI06pWNxodvsaWzmtKc0UqzRfbJ8Kj4jLTiK
         EdLzphbgcotdM6NsQk0dZtfKvjiy7lQA3N931jVxddAFmTKOASHN+l4nWVx9oB2Kaw8k
         C/Cl3nFWxcVzh4wDoUVxkQFgIpZcsaUtghfHCMhgOXMJTzLY2cnKDTnwedkkTtSD4sKb
         XBXA==
X-Gm-Message-State: AOAM533gTJdhxH4JAy69LU/JWeZ1YQURjsBFQjJZS777t1UZrwFZ7qht
        jEQwCxfNxDVAAIlHJBWXbis=
X-Google-Smtp-Source: ABdhPJyroQNvPSwBQpM62epA8QpRYoa7bTKq3OmTZRvc4q+q8gxR4SaqQlc0gskGSWcab1KgNvJz9w==
X-Received: by 2002:a92:7f07:: with SMTP id a7mr3677588ild.202.1624544689070;
        Thu, 24 Jun 2021 07:24:49 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id v18sm1385869iom.5.2021.06.24.07.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:24:48 -0700 (PDT)
Date:   Thu, 24 Jun 2021 07:24:41 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eelco Chaudron <echaudro@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Message-ID: <60d495a914773_2e84a2082d@john-XPS-13-9370.notmuch>
In-Reply-To: <4F52EE5B-1A3F-46CE-9A39-98475CA6B684@redhat.com>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <863f4934d251f44ad85a6be08b3737fac74f9b5a.1623674025.git.lorenzo@kernel.org>
 <60d2744ee12c2_1342e208f7@john-XPS-13-9370.notmuch>
 <4F52EE5B-1A3F-46CE-9A39-98475CA6B684@redhat.com>
Subject: Re: [PATCH v9 bpf-next 08/14] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron wrote:
> 
> 
> On 23 Jun 2021, at 1:37, John Fastabend wrote:
> 
> > Lorenzo Bianconi wrote:
> >> From: Eelco Chaudron <echaudro@redhat.com>
> >>
> >> This change adds support for tail growing and shrinking for XDP multi-buff.
> >>
> >
> > It would be nice if the commit message gave us some details on how the
> > growing/shrinking works in the multi-buff support.
> 
> Will add this to the next rev.
> 
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >> ---
> >>  include/net/xdp.h |  7 ++++++
> >>  net/core/filter.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++
> >>  net/core/xdp.c    |  5 ++--
> >>  3 files changed, 72 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/net/xdp.h b/include/net/xdp.h
> >> index 935a6f83115f..3525801c6ed5 100644
> >> --- a/include/net/xdp.h
> >> +++ b/include/net/xdp.h
> >> @@ -132,6 +132,11 @@ xdp_get_shared_info_from_buff(struct xdp_buff *xdp)
> >>  	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
> >>  }
> >>
> >> +static inline unsigned int xdp_get_frag_tailroom(const skb_frag_t *frag)
> >> +{
> >> +	return PAGE_SIZE - skb_frag_size(frag) - skb_frag_off(frag);
> >> +}
> >> +
> >>  struct xdp_frame {
> >>  	void *data;
> >>  	u16 len;
> >> @@ -259,6 +264,8 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
> >>  	return xdp_frame;
> >>  }
> >>
> >> +void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
> >> +		  struct xdp_buff *xdp);
> >>  void xdp_return_frame(struct xdp_frame *xdpf);
> >>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
> >>  void xdp_return_buff(struct xdp_buff *xdp);
> >> diff --git a/net/core/filter.c b/net/core/filter.c
> >> index caa88955562e..05f574a3d690 100644
> >> --- a/net/core/filter.c
> >> +++ b/net/core/filter.c
> >> @@ -3859,11 +3859,73 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
> >>  	.arg2_type	= ARG_ANYTHING,
> >>  };
> >>
> >> +static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
> >> +{
> >> +	struct skb_shared_info *sinfo;
> >> +
> >> +	if (unlikely(!xdp_buff_is_mb(xdp)))
> >> +		return -EINVAL;
> >> +
> >> +	sinfo = xdp_get_shared_info_from_buff(xdp);
> >> +	if (offset >= 0) {
> >> +		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags - 1];
> >> +		int size;
> >> +
> >> +		if (unlikely(offset > xdp_get_frag_tailroom(frag)))
> >> +			return -EINVAL;
> >> +
> >> +		size = skb_frag_size(frag);
> >> +		memset(skb_frag_address(frag) + size, 0, offset);
> >> +		skb_frag_size_set(frag, size + offset);
> >> +		sinfo->data_len += offset;
> >
> > Can you add some comment on how this works? So today I call
> > bpf_xdp_adjust_tail() to add some trailer to my packet.
> > This looks like it adds tailroom to the last frag? But, then
> > how do I insert my trailer? I don't think we can without the
> > extra multi-buffer access support right.
> 
> You are right, we need some kind of multi-buffer access helpers.
> 
> > Also data_end will be unchanged yet it will return 0 so my
> > current programs will likely be a bit confused by this.
> 
> Guess this is the tricky part, applications need to be multi-buffer aware. If current applications rely on bpf_xdp_adjust_tail(+) to determine maximum frame length this approach might not work. In this case, we might need an additional helper to do tail expansion with multi buffer support.
> 
> But then the question arrives how would mb unaware application behave in general when an mb packet is supplied?? It would definitely not determine the correct packet length.

Right that was my conclusion as well. Existing programs might
have subtle side effects if they start running on multibuffer
drivers as is. I don't have any good ideas though on how
to handle this.

> 
> >> +	} else {
> 


