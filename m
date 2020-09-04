Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9612825CF05
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 03:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbgIDBOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 21:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgIDBOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 21:14:03 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F32C061244;
        Thu,  3 Sep 2020 18:14:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ls14so2284901pjb.3;
        Thu, 03 Sep 2020 18:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YkS9vhKPKAw6RjcjTEgk5HWgCQT97Dc2N2xVUa7XHi4=;
        b=vIFIF0xrBJ1WGS7yrNrjIIcP3sI8cvnXlDPdbh5sgsjibYQCD68OF9a3SN5/e+++XJ
         mPzouIxfRAF0DOH5rSyyCeFlSSttnXeTjAABWBQDNqvur3xdrKCW1JDIR0yF37pl4gJr
         Lwrk/OziIctZA4wiOQP5KGSZoVrKgOYbuQtbcZyXfPkcbTFkKTJHelzCjdBE7wwZPht1
         bv5ukFtOnrR4DYDqs6vlSqJtbefYbrz6CFFbL8F/ncsyhyGtRarTsR4oVp18qlSw49Zw
         lXCm6d31XyifvpHaLV1gdKGs5KioFd8jnYNBPRfte53z4Iay0yTHOvxA1cGIFiFA4S/b
         XWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YkS9vhKPKAw6RjcjTEgk5HWgCQT97Dc2N2xVUa7XHi4=;
        b=hLuKB500iD0rdAZeoddxDvnZUO+VDORoNku6ZeIVT/xJSweca14I9ZT/b8fJzkq3Bl
         wemzsCjLCHjsdvi1HkE0cHHGiNFGb9sOTc0zZA0NI4dr2iM5ZVr7aH7EFbS54hRcYdx7
         GyUbw/Y7K52vd1NsAODEKDFwqr8J/iEETsSaG+X0algqAX7u8CkWc+gNIGXMm+XFHl+r
         ROuLf0dpw14HGHjClBH4mP0qDWeLH82WNH5P9QfqrzSVCklpLK8TBleNsrKhR/4akoGd
         ow8aYU3JPe+GtbQell+doQt4w+FJfbzm3Zi4DrJYl1A0MHfWHTQAgHh+xTbZ9d0slz/y
         06zQ==
X-Gm-Message-State: AOAM53185dVwE1ZPgCiJkQvBEB8+8bdZsay188KnkFyzBhQsLfiIq7aL
        yMd+KAVDQDBU3+ExuCqHCerYwJZw1JY=
X-Google-Smtp-Source: ABdhPJwGZKJ/3peHoisdOLl362rs5lweom6mZEBbTIQq05wxeqhS5IJy3hTL1EWAjy6qFBMwjVTGAg==
X-Received: by 2002:a17:90a:ae0d:: with SMTP id t13mr5951077pjq.52.1599182041715;
        Thu, 03 Sep 2020 18:14:01 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8159])
        by smtp.gmail.com with ESMTPSA id y79sm4234713pfb.45.2020.09.03.18.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 18:14:00 -0700 (PDT)
Date:   Thu, 3 Sep 2020 18:13:58 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: Re: [PATCH v2 net-next 6/9] bpf: helpers: add
 bpf_xdp_adjust_mb_header helper
Message-ID: <20200904011358.kbdxf4awugi3qwjl@ast-mbp.dhcp.thefacebook.com>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 10:58:50PM +0200, Lorenzo Bianconi wrote:
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

wait a sec. Are you saying that multi buffer XDP actually should be skb based?
If that's what mvneta driver is doing that's fine, but that is not a
reasonable requirement to put on all other drivers.
