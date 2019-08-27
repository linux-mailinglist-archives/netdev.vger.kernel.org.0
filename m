Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3389F206
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbfH0SEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:04:11 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55125 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfH0SEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:04:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id t6so36429wmj.4;
        Tue, 27 Aug 2019 11:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eeXEbfNVRk3oAI90JXSVwlfA1/Luk09oyGiJ2cBc090=;
        b=l566AOedLj0sB7R/r792xeSKSmRuOoMdg8f4HcHV4zqE7Gg4OKGl3l2zYNO2TUnQCS
         xmf1PvlYP1YUT8spw0jt3HYVNRPl1DGjaDgCGaWamEdecsqMFilYE8HIViJ1muZzANSy
         P56mTbNqBdM4AIphIL8jFa+L+FXI5l9HCeZ2XmAH0dHxW8oL/AgJ+y/DZlZRefBbRUjK
         JI82IZWyA5KLN2orqEZ3dh///GFWAYiBqHxcZ9vEQNqMAajI5Rq5kcEvBgHwAdrNtGyr
         AEnyjui9UyAkgr4EsIMw/IIPRZEQgYp3wenSQ9YhwsnCTEGlNneRXXvAx1YstOS20FM3
         SegQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eeXEbfNVRk3oAI90JXSVwlfA1/Luk09oyGiJ2cBc090=;
        b=ZN4xEVjB80+neuY4X/M9T88Y/KZSmlDw4pKLw76Xi1wCKkrUDrjzRJrvWPR9BO4gfv
         Kj38F2dpxguHoVk/v1bKANpl0ELyMbYtv9R1/BIkclQex3A7ndAmQ+gtl7asnceuWaie
         uxKlM39yXojs1wbH1mO9RbHmrP/55yxeFtMGOFCCYjrST98JYIoYZAlQUnf9NG2iq3l8
         qXZq+SrwD35ruZAQjBGH/Izq4Xt9Ge5gbdCbUjoJ31Wen5k4HRuSB2vCHK6XPqaxyyrI
         zZX0p1A+bWSKH35og8WrieiBkfAnLe91ShfC41nUux887ATCUekT65h/1DLMfbJEp6ma
         PoGQ==
X-Gm-Message-State: APjAAAU1oKUlB23LzUeS7FxaIA//f0aiCOjjjpk+Chxrape6PW4kWSW5
        b/HPk9ZHP+S+imLH48EsSII=
X-Google-Smtp-Source: APXvYqy/OaFb4S1R0xj6XUxUdfkuBIgwYGte/KsTRxDbfjz/vjDAgNOk4eIBQjude9QoVCn6hCdKQw==
X-Received: by 2002:a1c:a481:: with SMTP id n123mr164017wme.123.1566929048457;
        Tue, 27 Aug 2019 11:04:08 -0700 (PDT)
Received: from [192.168.8.147] (212.160.185.81.rev.sfr.net. [81.185.160.212])
        by smtp.gmail.com with ESMTPSA id a203sm140208wme.11.2019.08.27.11.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2019 11:04:08 -0700 (PDT)
Subject: Re: [PATCH bpf-next v3 7/7] selftests/bpf: support
 BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Song Liu <songliubraving@fb.com>
References: <20190725225231.195090-1-sdf@google.com>
 <20190725225231.195090-8-sdf@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c1cec8df-e3c5-8d34-c3b3-44eae4f10e9b@gmail.com>
Date:   Tue, 27 Aug 2019 20:04:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725225231.195090-8-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/26/19 12:52 AM, Stanislav Fomichev wrote:
> Exit as soon as we found that packet is encapped when
> BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP is passed.
> Add appropriate selftest cases.
> 
> v2:
> * Subtract sizeof(struct iphdr) from .iph_inner.tot_len (Willem de Bruijn)
> 
> Acked-by: Petar Penkov <ppenkov@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/flow_dissector.c | 64 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_flow.c  |  8 +++
>  2 files changed, 72 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> index ef83f145a6f1..700d73d2f22a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> @@ -41,6 +41,13 @@ struct ipv4_pkt {
>  	struct tcphdr tcp;
>  } __packed;
>  
> +struct ipip_pkt {
> +	struct ethhdr eth;
> +	struct iphdr iph;
> +	struct iphdr iph_inner;
> +	struct tcphdr tcp;
> +} __packed;
> +
>  struct svlan_ipv4_pkt {
>  	struct ethhdr eth;
>  	__u16 vlan_tci;
> @@ -82,6 +89,7 @@ struct test {
>  	union {
>  		struct ipv4_pkt ipv4;
>  		struct svlan_ipv4_pkt svlan_ipv4;
> +		struct ipip_pkt ipip;
>  		struct ipv6_pkt ipv6;
>  		struct ipv6_frag_pkt ipv6_frag;
>  		struct dvlan_ipv6_pkt dvlan_ipv6;
> @@ -303,6 +311,62 @@ struct test tests[] = {
>  		},
>  		.flags = BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL,
>  	},
> +	{
> +		.name = "ipip-encap",
> +		.pkt.ipip = {
> +			.eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> +			.iph.ihl = 5,
> +			.iph.protocol = IPPROTO_IPIP,
> +			.iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
> +			.iph_inner.ihl = 5,
> +			.iph_inner.protocol = IPPROTO_TCP,
> +			.iph_inner.tot_len =
> +				__bpf_constant_htons(MAGIC_BYTES) -
> +				sizeof(struct iphdr),
> +			.tcp.doff = 5,
> +			.tcp.source = 80,
> +			.tcp.dest = 8080,
> +		},
> +		.keys = {
> +			.nhoff = 0,
> +			.nhoff = ETH_HLEN,

clang emits a warning because nhoff is defined twice.

> +			.thoff = ETH_HLEN + sizeof(struct iphdr) +
> +				sizeof(struct iphdr),
> +			.addr_proto = ETH_P_IP,
> +			.ip_proto = IPPROTO_TCP,
> +			.n_proto = __bpf_constant_htons(ETH_P_IP),
> +			.is_encap = true,
> +			.sport = 80,
> +			.dport = 8080,
> +		},
> +	},
> +	{
> +		.name = "ipip-no-encap",
> +		.pkt.ipip = {
> +			.eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> +			.iph.ihl = 5,
> +			.iph.protocol = IPPROTO_IPIP,
> +			.iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
> +			.iph_inner.ihl = 5,
> +			.iph_inner.protocol = IPPROTO_TCP,
> +			.iph_inner.tot_len =
> +				__bpf_constant_htons(MAGIC_BYTES) -
> +				sizeof(struct iphdr),
> +			.tcp.doff = 5,
> +			.tcp.source = 80,
> +			.tcp.dest = 8080,
> +		},
> +		.keys = {
> +			.flags = BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP,
> +			.nhoff = ETH_HLEN,
> +			.thoff = ETH_HLEN + sizeof(struct iphdr),
> +			.addr_proto = ETH_P_IP,
> +			.ip_proto = IPPROTO_IPIP,
> +			.n_proto = __bpf_constant_htons(ETH_P_IP),
> +			.is_encap = true,
> +		},
> +		.flags = BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP,
> +	},
>  };
>  
>  static int create_tap(const char *ifname)
> diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
> index 7fbfa22f33df..08bd8b9d58d0 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_flow.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
> @@ -167,9 +167,15 @@ static __always_inline int parse_ip_proto(struct __sk_buff *skb, __u8 proto)
>  		return export_flow_keys(keys, BPF_OK);
>  	case IPPROTO_IPIP:
>  		keys->is_encap = true;
> +		if (keys->flags & BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP)
> +			return export_flow_keys(keys, BPF_OK);
> +
>  		return parse_eth_proto(skb, bpf_htons(ETH_P_IP));
>  	case IPPROTO_IPV6:
>  		keys->is_encap = true;
> +		if (keys->flags & BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP)
> +			return export_flow_keys(keys, BPF_OK);
> +
>  		return parse_eth_proto(skb, bpf_htons(ETH_P_IPV6));
>  	case IPPROTO_GRE:
>  		gre = bpf_flow_dissect_get_header(skb, sizeof(*gre), &_gre);
> @@ -189,6 +195,8 @@ static __always_inline int parse_ip_proto(struct __sk_buff *skb, __u8 proto)
>  			keys->thoff += 4; /* Step over sequence number */
>  
>  		keys->is_encap = true;
> +		if (keys->flags & BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP)
> +			return export_flow_keys(keys, BPF_OK);
>  
>  		if (gre->proto == bpf_htons(ETH_P_TEB)) {
>  			eth = bpf_flow_dissect_get_header(skb, sizeof(*eth),
> 
