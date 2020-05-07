Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6BC1C8015
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 04:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgEGCmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 22:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726625AbgEGCmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 22:42:02 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A5DC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 19:42:02 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id fu13so1945162pjb.5
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 19:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I/eCHNKi9wkby6SPWUg39vUKZpyXpuIo6pEQnWN892k=;
        b=DQBwFoSHoC9cgNcneAbor5aihyp2MZAufbHmu8Gwh1H0a6hLJYE3fgst5M2vty8Mc9
         pe20C9+ATdisCDDhrMBVKHOs7DY56ERJb1UEXXdIR7CvWLUIpIUwv4UC6N8InyEGYvt3
         XjjgIpshYemlxnudxBgKak9TxeD1cyzjBjDweZMXAS53RWSVbjjCM2/CuiwcOOr2YSua
         SNZSW05kQLzbPZNkiybcu53OqTd3o8XoNdCJig1c3gPOsgGvQrm9Cz/i6nGY0FvHbxAT
         KQMxv4uA2Xm/LKP2znpS3lHW9w/+7ZOwqC7lbdruWUSnq6p8GtVET2HdM9LB4kAL7CYj
         cHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I/eCHNKi9wkby6SPWUg39vUKZpyXpuIo6pEQnWN892k=;
        b=FmszMgowVGWY3Da544LoIgy0jOXaWwXxh6Hone8PZEvAk55MYxpzKLpvVcvfnnJ6On
         r+XFn3Gnil91JTDwNVulU+AT7wZC4QSSgb66EOoY0xCZgqv6psZ5DkrqiPo3U7KEXRaA
         0umfcugZc64Bc0d76RH6lh+KYgBN86yt/jNGTc1rRI/SyCPmI5pnUSPqTPoxh6grMlga
         j0iOXzbzsavnm76lhfh5pncqF4bZxaKVqRqaoaxttwVerxCMjvRb+TwjNly2PRkJFzdG
         Q/zOJeIn462g3pivuti2r6c83+o5qi5FTLy41SfOa28OeQhWO6qlbJFo1cVQMvzgJ4e7
         Ng9A==
X-Gm-Message-State: AGi0PuZJvTv2a5/OYhfo6JUsE76NZWCyAbo+HAL6bj/f02Q8pBEB7CXu
        JUk/e6v9mbKAD7lSfTzABwg=
X-Google-Smtp-Source: APiQypKfJeDa6qvGEiUwHymPpL/b9ph6DRuUqMtVZsZ0/ndaJ6tGDDGRXTSnVAyvz2hSd/ZlIq92Qg==
X-Received: by 2002:a17:90a:a78f:: with SMTP id f15mr12631150pjq.120.1588819322119;
        Wed, 06 May 2020 19:42:02 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w75sm3170123pfc.156.2020.05.06.19.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 19:42:01 -0700 (PDT)
Subject: Re: [PATCHv2] erspan: Add type I version 0 support.
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net
References: <1588694706-26433-1-git-send-email-u9012063@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9a4d33eb-7429-b852-cfa9-b47838672f37@gmail.com>
Date:   Wed, 6 May 2020 19:41:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1588694706-26433-1-git-send-email-u9012063@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 9:05 AM, William Tu wrote:
> The Type I ERSPAN frame format is based on the barebones
> IP + GRE(4-byte) encapsulation on top of the raw mirrored frame.
> Both type I and II use 0x88BE as protocol type. Unlike type II
> and III, no sequence number or key is required.
> To creat a type I erspan tunnel device:
>   $ ip link add dev erspan11 type erspan \
>             local 172.16.1.100 remote 172.16.1.200 \
>             erspan_ver 0
> 
> Signed-off-by: William Tu <u9012063@gmail.com>
> ---
> v2:
>   remove the inline keyword, let compiler decide.
> v1:
> I didn't notice there is Type I when I did first erspan implementation
> because it is not in the ietf draft 00 and 01. It's until recently I got
> request for adding type I. Spec is below at draft 02:
> https://tools.ietf.org/html/draft-foschiano-erspan-02#section-4.1
> 
> To verify with Wireshark, make sure you have:
> commit ef76d65fc61d01c2ce5184140f4b1bba0019078b
> Author: Guy Harris <guy@alum.mit.edu>
> Date:   Mon Sep 30 16:35:35 2019 -0700
> 
>     Fix checks for "do we have an ERSPAN header?"
> ---
>  include/net/erspan.h | 19 +++++++++++++++--
>  net/ipv4/ip_gre.c    | 58 ++++++++++++++++++++++++++++++++++++++--------------
>  2 files changed, 60 insertions(+), 17 deletions(-)
> 
> diff --git a/include/net/erspan.h b/include/net/erspan.h
> index b39643ef4c95..0d9e86bd9893 100644
> --- a/include/net/erspan.h
> +++ b/include/net/erspan.h
> @@ -2,7 +2,19 @@
>  #define __LINUX_ERSPAN_H
>  
>  /*
> - * GRE header for ERSPAN encapsulation (8 octets [34:41]) -- 8 bytes
> + * GRE header for ERSPAN type I encapsulation (4 octets [34:37])
> + *      0                   1                   2                   3
> + *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
> + *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> + *     |0|0|0|0|0|00000|000000000|00000|    Protocol Type for ERSPAN   |
> + *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> + *
> + *  The Type I ERSPAN frame format is based on the barebones IP + GRE
> + *  encapsulation (as described above) on top of the raw mirrored frame.
> + *  There is no extra ERSPAN header.
> + *
> + *
> + * GRE header for ERSPAN type II and II encapsulation (8 octets [34:41])
>   *       0                   1                   2                   3
>   *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
>   *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> @@ -43,7 +55,7 @@
>   * |                  Platform Specific Info                       |
>   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   *
> - * GRE proto ERSPAN type II = 0x88BE, type III = 0x22EB
> + * GRE proto ERSPAN type I/II = 0x88BE, type III = 0x22EB
>   */
>  
>  #include <uapi/linux/erspan.h>
> @@ -139,6 +151,9 @@ static inline u8 get_hwid(const struct erspan_md2 *md2)
>  
>  static inline int erspan_hdr_len(int version)
>  {
> +	if (version == 0)
> +		return 0;
> +
>  	return sizeof(struct erspan_base_hdr) +
>  	       (version == 1 ? ERSPAN_V1_MDSIZE : ERSPAN_V2_MDSIZE);
>  }
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 029b24eeafba..e29cd48674d7 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -248,6 +248,15 @@ static void gre_err(struct sk_buff *skb, u32 info)
>  	ipgre_err(skb, info, &tpi);
>  }
>  
> +static bool is_erspan_type1(int gre_hdr_len)
> +{
> +	/* Both ERSPAN type I (version 0) and type II (version 1) use
> +	 * protocol 0x88BE, but the type I has only 4-byte GRE header,
> +	 * while type II has 8-byte.
> +	 */
> +	return gre_hdr_len == 4;
> +}
> +
>  static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
>  		      int gre_hdr_len)
>  {
> @@ -262,17 +271,26 @@ static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
>  	int len;
>  
>  	itn = net_generic(net, erspan_net_id);
> -
>  	iph = ip_hdr(skb);
> -	ershdr = (struct erspan_base_hdr *)(skb->data + gre_hdr_len);
> -	ver = ershdr->ver;
> -
> -	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
> -				  tpi->flags | TUNNEL_KEY,
> -				  iph->saddr, iph->daddr, tpi->key);
> +	if (is_erspan_type1(gre_hdr_len)) {
> +		ver = 0;
> +		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
> +					  tpi->flags | TUNNEL_NO_KEY,
> +					  iph->saddr, iph->daddr, 0);
> +	} else {
> +		ershdr = (struct erspan_base_hdr *)(skb->data + gre_hdr_len);
> +		ver = ershdr->ver;
> +		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
> +					  tpi->flags | TUNNEL_KEY,
> +					  iph->saddr, iph->daddr, tpi->key);
> +	}
>  
>  	if (tunnel) {
> -		len = gre_hdr_len + erspan_hdr_len(ver);
> +		if (is_erspan_type1(gre_hdr_len))
> +			len = gre_hdr_len;
> +		else
> +			len = gre_hdr_len + erspan_hdr_len(ver);
> +
>  		if (unlikely(!pskb_may_pull(skb, len)))
>  			return PACKET_REJECT;
>  
> @@ -665,7 +683,10 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
>  	}
>  
>  	/* Push ERSPAN header */
> -	if (tunnel->erspan_ver == 1) {
> +	if (tunnel->erspan_ver == 0) {
> +		proto = htons(ETH_P_ERSPAN);
> +		tunnel->parms.o_flags &= ~TUNNEL_SEQ;
> +	} else if (tunnel->erspan_ver == 1) {
>  		erspan_build_header(skb, ntohl(tunnel->parms.o_key),
>  				    tunnel->index,
>  				    truncate, true);
> @@ -1066,7 +1087,10 @@ static int erspan_validate(struct nlattr *tb[], struct nlattr *data[],
>  	if (ret)
>  		return ret;
>  
> -	/* ERSPAN should only have GRE sequence and key flag */
> +	if (nla_get_u8(data[IFLA_GRE_ERSPAN_VER]) == 0)

I do not see anything in the code making sure IFLA_GRE_ERSPAN_VER has been provided by the user ?




> +		return 0;
> +
> +	/* ERSPAN type II/III should only have GRE sequence and key flag */
>  	if (data[IFLA_GRE_OFLAGS])
>  		flags |= nla_get_be16(data[IFLA_GRE_OFLAGS]);
>  	if (data[IFLA_GRE_IFLAGS])
> @@ -1174,7 +1198,7 @@ static int erspan_netlink_parms(struct net_device *dev,
>  	if (data[IFLA_GRE_ERSPAN_VER]) {
>  		t->erspan_ver = nla_get_u8(data[IFLA_GRE_ERSPAN_VER]);
>  
> -		if (t->erspan_ver != 1 && t->erspan_ver != 2)
> +		if (t->erspan_ver > 2)
>  			return -EINVAL;
>  	}
>  
> @@ -1259,7 +1283,11 @@ static int erspan_tunnel_init(struct net_device *dev)
>  {
>  	struct ip_tunnel *tunnel = netdev_priv(dev);
>  
> -	tunnel->tun_hlen = 8;
> +	if (tunnel->erspan_ver == 0)
> +		tunnel->tun_hlen = 4; /* 4-byte GRE hdr. */
> +	else
> +		tunnel->tun_hlen = 8; /* 8-byte GRE hdr. */
> +
>  	tunnel->parms.iph.protocol = IPPROTO_GRE;
>  	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen +
>  		       erspan_hdr_len(tunnel->erspan_ver);
> @@ -1456,8 +1484,8 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
>  	struct ip_tunnel_parm *p = &t->parms;
>  	__be16 o_flags = p->o_flags;
>  
> -	if (t->erspan_ver == 1 || t->erspan_ver == 2) {
> -		if (!t->collect_md)
> +	if (t->erspan_ver <= 2) {
> +		if (t->erspan_ver != 0 && !t->collect_md)
>  			o_flags |= TUNNEL_KEY;
>  
>  		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
> @@ -1466,7 +1494,7 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
>  		if (t->erspan_ver == 1) {
>  			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
>  				goto nla_put_failure;
> -		} else {
> +		} else if (t->erspan_ver == 2) {
>  			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
>  				goto nla_put_failure;
>  			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
> 
