Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AE625D1AA
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgIDGrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgIDGrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 02:47:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEC1C061245;
        Thu,  3 Sep 2020 23:47:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gl3so1581033pjb.1;
        Thu, 03 Sep 2020 23:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=c3EdcW4niTZCUgW9IzFjwDW/Nou8CPbVYFkuuUMbov4=;
        b=RB3PRvTKxUXP9lekLzlkuLv4jJHWoZqm700pWWYMO0712gbjXS+S0Y++o+ssl460tF
         EdZCmRmGd8ReuqjtwQL1J6zaIGdbuP20rxHlUf5NSVkYVRJabggZJBXRVEFcKKdThwC0
         rf+v35e/wDrWYTvKuW057ZYdGSzfHz0OfWDsSz3basGI17n/2vKRO06TdLCxLwzvhImT
         hs9+iwWbpOKpKjuGr7lr/i3lHpbd6gO0F9RhCVICOmkUO+rTLlTsxAV9N7vPXXjD2IS1
         wijcQ6ohtM9Hb9oIXuLJ83N3INKslrHeOnTW1jvheXkjYvU/qyYu0ZiTGMA1PSZL1UR0
         ljYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=c3EdcW4niTZCUgW9IzFjwDW/Nou8CPbVYFkuuUMbov4=;
        b=tIFXNhMCrsgQM5CahdK88dsVypVsKgItxkUEKwyBgEc7FVh7rYbiylhUHaaR1St5Sq
         JfOS6okOxWundYCHxPzArb6c5w26fe9GFipK7LRgS7O52KV5QGuqAUkxqx9+Q1l782iO
         nfHL59W7k1qCROB1FEb+YqpRTnqE14M42LvORMD4KgQvKQejYNbf//U2q3w6+fZ34prE
         LOn6+kk5Fl4ZMj0pD77fvM0sRd0zU+W+FZD8MvOsyWV2v/hl0vzzNXAksW6OxMBLOAgz
         q2xhmXxffFuP0ZYXY61VqmwvFShcNzccHSHaKbwhvGGDM5RowdReA04mSRDaWYVoCVQY
         vwrQ==
X-Gm-Message-State: AOAM530w2q48pnK3DSyYDw6hhQYKLkz/pujhe26pheAQ8gPy3fKYLjsT
        fDfqwYSefvNAxw/Om9/2PmA=
X-Google-Smtp-Source: ABdhPJy0HALIGzFtr/DDrVBxDdDYratUTk/xTrBvary6sAGNZIeyg7eVx9/9XK1zQrjV7Ke8SxfDHQ==
X-Received: by 2002:a17:90b:3891:: with SMTP id mu17mr6588766pjb.160.1599202042924;
        Thu, 03 Sep 2020 23:47:22 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v4sm4461643pjy.45.2020.09.03.23.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 23:47:22 -0700 (PDT)
Date:   Thu, 03 Sep 2020 23:47:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Message-ID: <5f51e2f2eb22_3eceb20837@john-XPS-13-9370.notmuch>
In-Reply-To: <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
Subject: RE: [PATCH v2 net-next 6/9] bpf: helpers: add
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
> Introduce bpf_xdp_adjust_mb_header helper in order to adjust frame
> headers moving *offset* bytes from/to the second buffer to/from the
> first one.
> This helper can be used to move headers when the hw DMA SG is not able
> to copy all the headers in the first fragment and split header and data
> pages.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/uapi/linux/bpf.h       | 25 ++++++++++++----
>  net/core/filter.c              | 54 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 26 ++++++++++++----
>  3 files changed, 95 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 8dda13880957..c4a6d245619c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3571,11 +3571,25 @@ union bpf_attr {
>   *		value.
>   *
>   * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
> - * 	Description
> - * 		Read *size* bytes from user space address *user_ptr* and store
> - * 		the data in *dst*. This is a wrapper of copy_from_user().
> - * 	Return
> - * 		0 on success, or a negative error in case of failure.
> + *	Description
> + *		Read *size* bytes from user space address *user_ptr* and store
> + *		the data in *dst*. This is a wrapper of copy_from_user().
> + *
> + * long bpf_xdp_adjust_mb_header(struct xdp_buff *xdp_md, int offset)
> + *	Description
> + *		Adjust frame headers moving *offset* bytes from/to the second
> + *		buffer to/from the first one. This helper can be used to move
> + *		headers when the hw DMA SG does not copy all the headers in
> + *		the first fragment.

This is confusing to read. Does this mean I can "move bytes to the second
buffer from the first one" or "move bytes from the second buffer to the first
one" And what are frame headers? I'm sure I can read below code and work
it out, but users reading the header file should be able to parse this.

Also we want to be able to read all data not just headers. Reading the
payload of a TCP packet is equally important for many l7 load balancers.

> + *
> + *		A call to this helper is susceptible to change the underlying
> + *		packet buffer. Therefore, at load time, all checks on pointers
> + *		previously done by the verifier are invalidated and must be
> + *		performed again, if the helper is used in combination with
> + *		direct packet access.
> + *
> + *	Return
> + *		0 on success, or a negative error in case of failure.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3727,6 +3741,7 @@ union bpf_attr {
>  	FN(inode_storage_delete),	\
>  	FN(d_path),			\
>  	FN(copy_from_user),		\
> +	FN(xdp_adjust_mb_header),	\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 47eef9a0be6a..ae6b10cf062d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3475,6 +3475,57 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
>  	.arg2_type	= ARG_ANYTHING,
>  };
>  
> +BPF_CALL_2(bpf_xdp_adjust_mb_header, struct  xdp_buff *, xdp,
> +	   int, offset)
> +{
> +	void *data_hard_end, *data_end;
> +	struct skb_shared_info *sinfo;
> +	int frag_offset, frag_len;
> +	u8 *addr;
> +
> +	if (!xdp->mb)
> +		return -EOPNOTSUPP;
> +
> +	sinfo = xdp_get_shared_info_from_buff(xdp);
> +
> +	frag_len = skb_frag_size(&sinfo->frags[0]);
> +	if (offset > frag_len)
> +		return -EINVAL;

What if we want data in frags[1] and so on.

> +
> +	frag_offset = skb_frag_off(&sinfo->frags[0]);
> +	data_end = xdp->data_end + offset;
> +
> +	if (offset < 0 && (-offset > frag_offset ||
> +			   data_end < xdp->data + ETH_HLEN))
> +		return -EINVAL;
> +
> +	data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
> +	if (data_end > data_hard_end)
> +		return -EINVAL;
> +
> +	addr = page_address(skb_frag_page(&sinfo->frags[0])) + frag_offset;
> +	if (offset > 0) {
> +		memcpy(xdp->data_end, addr, offset);

But this could get expensive for large amount of data? And also
limiting because we require the room to do the copy. Presumably
the reason we have fargs[1] is because the normal page or half
page is in use?

> +	} else {
> +		memcpy(addr + offset, xdp->data_end + offset, -offset);
> +		memset(xdp->data_end + offset, 0, -offset);
> +	}
> +
> +	skb_frag_size_sub(&sinfo->frags[0], offset);
> +	skb_frag_off_add(&sinfo->frags[0], offset);
> +	xdp->data_end = data_end;
> +
> +	return 0;
> +}

So overall I don't see the point of copying bytes from one frag to
another. Create an API that adjusts the data pointers and then
copies are avoided and manipulating frags is not needed.

Also and even more concerning I think this API requires the
driver to populate shinfo. If we use TX_REDIRECT a lot or TX_XMIT
this means we need to populate shinfo when its probably not ever
used. If our driver is smart L2/L3 headers are in the readable
data and prefetched. Writing frags into the end of a page is likely
not free.

Did you benchmark this?

In general users of this API should know the bytes they want
to fetch. Use an API like this,

  bpf_xdp_adjust_bytes(xdp, start, end)

Where xdp is the frame, start is the first byte the user wants
and end is the last byte. Then usually you can skip the entire
copy part and just move the xdp pointesr around. The ugly case
is if the user puts start/end across a frag boundary and a copy
is needed. In that case maybe we use end as a hint and not a
hard requirement.

The use case I see is I read L2/L3/L4 headers and I need the
first N bytes of the payload. I know where the payload starts
and I know how many bytes I need so,

  bpf_xdp_adjust_bytes(xdp, payload_offset, bytes_needed);

Then hopefully that is all in one frag. If its not I'll need
to do a second helper call. Still nicer than forcing drivers
to populate this shinfo I think. If you think I'm wrong try
a benchmark. Benchmarks aside I get stuck when data_end and
data_hard_end are too close together.

Thanks,
John
