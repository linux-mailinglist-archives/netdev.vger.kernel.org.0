Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231259D370
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfHZPy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:54:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40763 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbfHZPy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 11:54:27 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so12056894pfn.7
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 08:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TK33fm3+Zjerad8Yo6dDWElBrzGnYXzu+A5EmrXupOc=;
        b=mGYaAMArtjC7TCwufOuW8R0jtEOWbHzeJtW6JUL9wcWg7B3ev0p3KAT1FE6xNfsQug
         YhXdABgDUYIuumux76ZYUhv0hbkphmpCNuPWA7pk6HfV1DFqjU/c/7Yu3NPIF49HrbqT
         B9g9uiZAQVXRanGzWPXKpDmVOq9mBQo+csbC0HavyDEc/ebw4p0i7mC/k9Q/CmBAPdFi
         mDhoVyMoWXOrmjmr+ASy9st/1M2zwhYZ+AE8tAe2WSc4Mo0PTqdChLN8HQq97xu97kRs
         CYRFxfcSFXiEBxF12sTq0kZjc9p0LBJ8zDpFA6K+sKwbbTlggi8JiZ8iDNkjfMD0yZyn
         0qrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TK33fm3+Zjerad8Yo6dDWElBrzGnYXzu+A5EmrXupOc=;
        b=BLl/SgFAlfndyG1nDjkbQplEi12AfF/bs1N94adoQf1pb3Kv+Qn9Pkt+TUhHXnbl88
         yfz5R7JiOC9WwC+fYKC77qjAlzf76DFijdkWBDQZ0YXDFwOX0xKtrYvGccLpp9pAPDja
         KLr/nKIeuwbsTVi8twr6Kcz6W9ir8gx3xOhmI9yTMm1yQF64e592RjRQAG+m5QQ4IMwz
         LvqRoADFIjyJL6UoG/1Hq6qA1yjsA3xy/KO2cIbHwFgkdcXHNJF+cBvFXWwIRFTU920U
         b6MEX04NgPQGkC4QxXfeuqewO/e3Cyn5+XV14hm48xtX124vJzyKeG20C3URYWGY7ToK
         SIHQ==
X-Gm-Message-State: APjAAAX1kLgKZz7d7dBiA4BCKVg44TKXot2SM/zK8Q5uFh6N4EB3zuQI
        9dPSQ4fvuniR7BUIrLfOiSk=
X-Google-Smtp-Source: APXvYqyXcMxxNdxXqBCi4n0SIp7yMXilI0rpQ8mO8TGHFUCeYpESAEPplSmY82JBxVpJjYMkuzHB0w==
X-Received: by 2002:a65:68c8:: with SMTP id k8mr16836745pgt.192.1566834866802;
        Mon, 26 Aug 2019 08:54:26 -0700 (PDT)
Received: from localhost ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id e66sm18500005pfe.142.2019.08.26.08.54.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Aug 2019 08:54:26 -0700 (PDT)
Date:   Mon, 26 Aug 2019 17:54:20 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] samples: bpf: add max_pckt_size option at
 xdp_adjust_tail
Message-ID: <20190826175420.000021f3@gmail.com>
In-Reply-To: <20190826095722.28229-1-danieltimlee@gmail.com>
References: <20190826095722.28229-1-danieltimlee@gmail.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 18:57:22 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> to 600. To make this size flexible, a new map 'pcktsz' is added.
> 
> By updating new packet size to this map from the userland,
> xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.
> 
> If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> will be 600 as a default.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
>  samples/bpf/xdp_adjust_tail_user.c | 21 +++++++++++++++++++--
>  2 files changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> index 411fdb21f8bc..4d53af370b68 100644
> --- a/samples/bpf/xdp_adjust_tail_kern.c
> +++ b/samples/bpf/xdp_adjust_tail_kern.c
> @@ -25,6 +25,13 @@
>  #define ICMP_TOOBIG_SIZE 98
>  #define ICMP_TOOBIG_PAYLOAD_SIZE 92
>  
> +struct bpf_map_def SEC("maps") pcktsz = {
> +	.type = BPF_MAP_TYPE_ARRAY,
> +	.key_size = sizeof(__u32),
> +	.value_size = sizeof(__u32),
> +	.max_entries = 1,
> +};
> +
>  struct bpf_map_def SEC("maps") icmpcnt = {
>  	.type = BPF_MAP_TYPE_ARRAY,
>  	.key_size = sizeof(__u32),
> @@ -64,7 +71,8 @@ static __always_inline void ipv4_csum(void *data_start, int data_size,
>  	*csum = csum_fold_helper(*csum);
>  }
>  
> -static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
> +static __always_inline int send_icmp4_too_big(struct xdp_md *xdp,
> +					      __u32 max_pckt_size)
>  {
>  	int headroom = (int)sizeof(struct iphdr) + (int)sizeof(struct icmphdr);
>  
> @@ -92,7 +100,7 @@ static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
>  	orig_iph = data + off;
>  	icmp_hdr->type = ICMP_DEST_UNREACH;
>  	icmp_hdr->code = ICMP_FRAG_NEEDED;
> -	icmp_hdr->un.frag.mtu = htons(MAX_PCKT_SIZE-sizeof(struct ethhdr));
> +	icmp_hdr->un.frag.mtu = htons(max_pckt_size - sizeof(struct ethhdr));
>  	icmp_hdr->checksum = 0;
>  	ipv4_csum(icmp_hdr, ICMP_TOOBIG_PAYLOAD_SIZE, &csum);
>  	icmp_hdr->checksum = csum;
> @@ -118,14 +126,21 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
>  {
>  	void *data_end = (void *)(long)xdp->data_end;
>  	void *data = (void *)(long)xdp->data;
> +	__u32 max_pckt_size = MAX_PCKT_SIZE;
> +	__u32 *pckt_sz;
> +	__u32 key = 0;
>  	int pckt_size = data_end - data;
>  	int offset;
>  
> -	if (pckt_size > MAX_PCKT_SIZE) {
> +	pckt_sz = bpf_map_lookup_elem(&pcktsz, &key);
> +	if (pckt_sz && *pckt_sz)
> +		max_pckt_size = *pckt_sz;
> +
> +	if (pckt_size > max_pckt_size) {
>  		offset = pckt_size - ICMP_TOOBIG_SIZE;
>  		if (bpf_xdp_adjust_tail(xdp, 0 - offset))
>  			return XDP_PASS;
> -		return send_icmp4_too_big(xdp);
> +		return send_icmp4_too_big(xdp, max_pckt_size);
>  	}
>  	return XDP_PASS;
>  }
> diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
> index a3596b617c4c..dd3befa5e1fe 100644
> --- a/samples/bpf/xdp_adjust_tail_user.c
> +++ b/samples/bpf/xdp_adjust_tail_user.c
> @@ -72,6 +72,7 @@ static void usage(const char *cmd)
>  	printf("Usage: %s [...]\n", cmd);
>  	printf("    -i <ifname|ifindex> Interface\n");
>  	printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
> +	printf("    -P <MAX_PCKT_SIZE> Default: 600\n");
>  	printf("    -S use skb-mode\n");
>  	printf("    -N enforce native mode\n");
>  	printf("    -F force loading prog\n");
> @@ -85,9 +86,11 @@ int main(int argc, char **argv)
>  		.prog_type	= BPF_PROG_TYPE_XDP,
>  	};
>  	unsigned char opt_flags[256] = {};
> -	const char *optstr = "i:T:SNFh";
> +	const char *optstr = "i:T:P:SNFh";
>  	struct bpf_prog_info info = {};
>  	__u32 info_len = sizeof(info);
> +	__u32 max_pckt_size = 0;
> +	__u32 key = 0;
>  	unsigned int kill_after_s = 0;
>  	int i, prog_fd, map_fd, opt;
>  	struct bpf_object *obj;
> @@ -110,6 +113,9 @@ int main(int argc, char **argv)
>  		case 'T':
>  			kill_after_s = atoi(optarg);
>  			break;
> +		case 'P':
> +			max_pckt_size = atoi(optarg);
> +			break;
>  		case 'S':
>  			xdp_flags |= XDP_FLAGS_SKB_MODE;
>  			break;
> @@ -150,9 +156,20 @@ int main(int argc, char **argv)
>  	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
>  		return 1;
>  
> +	/* update pcktsz map */
>  	map = bpf_map__next(NULL, obj);
>  	if (!map) {
> -		printf("finding a map in obj file failed\n");
> +		printf("finding a pcktsz map in obj file failed\n");
> +		return 1;
> +	}
> +	map_fd = bpf_map__fd(map);

Consider using bpf_object__find_map_fd_by_name() here.

> +	if (max_pckt_size)
> +		bpf_map_update_elem(map_fd, &key, &max_pckt_size, BPF_ANY);
> +
> +	/* fetch icmpcnt map */
> +	map = bpf_map__next(map, obj);
> +	if (!map) {
> +		printf("finding a icmpcnt map in obj file failed\n");
>  		return 1;
>  	}
>  	map_fd = bpf_map__fd(map);

