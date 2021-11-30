Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D46462A9A
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 03:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237659AbhK3CkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 21:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbhK3CkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 21:40:09 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11500C061746;
        Mon, 29 Nov 2021 18:36:51 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so28240748otj.7;
        Mon, 29 Nov 2021 18:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=D5Qw61WmuAj/yZDhi/A0/VNyCBrtN87SU10VbO44er4=;
        b=SLylTV1/Dr/0glxOCuNvB4fRMnD9BGxXeIIOHxWZK64w7G3XgItLJqZdpP+qSZmfSD
         S5dkB6jiCPz+DppG6cti58VcdaW8vVdhxPFOVUcAetqVc0Hni3wi0MowxGUNY27+JOMG
         owALRhUgLgmswLCPVu0sQYwGG4Qv540iZZ49Oj8UbQxyffuonqioQvCtE+2EjqR/qsfT
         AQWD3Vj7qbOZa0z41HMkSvsdVPC4qqUYxOqcSi9QOK2Tiy0Y35+YcJY6IaneYO/RpcC4
         jGrj5IOfY5tAaK/I+/FLlQw4m7pgFfSxGktcaPLugOvQM5YTMY5rEQa7bgjEKlfWbkut
         4Rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=D5Qw61WmuAj/yZDhi/A0/VNyCBrtN87SU10VbO44er4=;
        b=lnJ0AYyKYeWXhj8do8VbtW15LO8FVqkYq8sNQMJzpb1BSBBVk0i7twl/782obUem+f
         b+SlJXiWcHzA+90VGtlsr1tgQyYupbmazoDbzkyuoLKLe6u6z7PRiyLEvvGyVfvq2tan
         4UR0scGJEgwx6VcRtGnFoBFFOsTnCEqXDZIYwSvOp6pg/sAMRRKxrA5vbdcjuuvW2JTh
         T3K+CIs0MByk85EqegzMgqqRgyMRJiHlF2XFO9maR96FqgIzjb73I52AWMWjXD/0jBF3
         SLfMEa1rg7734rpD8FOtl/fGEhdJaNKcGEq/TQeoNxv1mK3F/jrfDVGCq44suA+UWqq2
         gB0g==
X-Gm-Message-State: AOAM531BFL0j0GIoSCT97ujMzRSakNwM2QqGXHUyX3QBlGU5yO58ZyMr
        3QLU9bhypyKOBodszDmLp80=
X-Google-Smtp-Source: ABdhPJwAB8aer13liJpqkRyfHbeZSflBDN+Fnw2AzwkjsdSAtn1sPGJsHlQ3ZEokrCc1yFs+5fXVgA==
X-Received: by 2002:a9d:6084:: with SMTP id m4mr35205706otj.324.1638239810501;
        Mon, 29 Nov 2021 18:36:50 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id s9sm3056211otg.42.2021.11.29.18.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 18:36:49 -0800 (PST)
Message-ID: <a4602b15-25b1-c388-73b4-1f97f6f0e555@gmail.com>
Date:   Mon, 29 Nov 2021 19:36:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 net-next 01/26] rtnetlink: introduce generic XDP
 statistics
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-2-alexandr.lobakin@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211123163955.154512-2-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/21 9:39 AM, Alexander Lobakin wrote:
> +static bool rtnl_get_xdp_stats_xdpxsk(struct sk_buff *skb, u32 ch,
> +				      const void *attr_data)
> +{
> +	const struct ifla_xdp_stats *xstats = attr_data;
> +
> +	xstats += ch;
> +
> +	if (nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_PACKETS, xstats->packets,
> +			      IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_BYTES, xstats->bytes,
> +			      IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_ERRORS, xstats->errors,
> +			      IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_ABORTED, xstats->aborted,
> +			      IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_DROP, xstats->drop,
> +			      IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_INVALID, xstats->invalid,
> +			      IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_PASS, xstats->pass,
> +			      IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_REDIRECT, xstats->redirect,
> +			      IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_REDIRECT_ERRORS,
> +			      xstats->redirect_errors,
> +			      IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_TX, xstats->tx,
> +			      IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_TX_ERRORS,
> +			      xstats->tx_errors, IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_XMIT_PACKETS,
> +			      xstats->xmit_packets, IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_XMIT_BYTES,
> +			      xstats->xmit_bytes, IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_XMIT_ERRORS,
> +			      xstats->xmit_errors, IFLA_XDP_XSTATS_UNSPEC) ||
> +	    nla_put_u64_64bit(skb, IFLA_XDP_XSTATS_XMIT_FULL,
> +			      xstats->xmit_full, IFLA_XDP_XSTATS_UNSPEC))
> +		return false;
> +
> +	return true;
> +}
> +

Another thought on this patch: with individual attributes you could save
some overhead by not sending 0 counters to userspace. e.g., define a
helper that does:

static inline int nla_put_u64_if_set(struct sk_buff *skb, int attrtype,
                                     u64 value, int padattr)
{
	if (value)
		return nla_put_u64_64bit(skb, attrtype, value, padattr);

	return 0;
}
