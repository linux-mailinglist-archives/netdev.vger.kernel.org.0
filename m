Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7548D221A48
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgGPCqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgGPCqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 22:46:36 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19752C061755;
        Wed, 15 Jul 2020 19:46:36 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g67so4098203pgc.8;
        Wed, 15 Jul 2020 19:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Uzn9PWVj4WS08RyvZ3rZ6i+MQl/MospPRV6X8a72+XI=;
        b=ZjtkaWExqHD3WVnf7gYkKwcr4vEObP3tgfFu0uQsBRxgqDT0wK5JARW8jmVqa7nIi6
         E/HT8vc4Wyx6XT5wVQU09+x9Qirns7pDI/FXdH7W+6wBR6j/BvI6V8wxYtlW7BqIDyKe
         D7l38H/sNQEdo8gj0hzrMnS1Mew4mJYrVzsIq7OrHr1DtX0uo6oxgNGaUsEhLBxHinOr
         nlXXW/dB0lULwFzdg1Qdc9blWk2ZDKdvAZ8UA/4RD+gVx4kmT11MjIEAkzYx5OvTDuhC
         Vamj59kUqK8EJnLphUKN/Kh/Q+9Pnq8SBHAfa9Axb1w82du1UbrNOOKkYCXtJwFOjl5v
         KCFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Uzn9PWVj4WS08RyvZ3rZ6i+MQl/MospPRV6X8a72+XI=;
        b=ZbtVzTjjupfl3MpTjEd0qlvFLjP9pHhh02YyD9NHTX2Kh43Apa/2jSF8foWv15Lmvu
         4hm2VPbGkp7TR1x+XqasCTaRBhfhSALCg/ILQvTSsGiQ+dW3EU0Po+4LmtJ9tV9kjRmF
         x/BhnDRQPt1I07r8LcsHGSaOF4R697cuVjZkibcM/SZA3h6kmFMgTPygmO2eJws0D8A2
         b9XAqP5uy0yFfsKE4kC0gDHdNCTucNBKB9HvEZ5UCkTCGp7lusF5xlKitYLjVPeoojlz
         5ZT4RYLUF+B86h8Ygh7JULFamL4mzPLJlXgBegcARAmWuF7kLzGaPqtgxb/PtOvkegU4
         RBoA==
X-Gm-Message-State: AOAM530PIDEydnDczSCsBYFng6nv8Xcjd9NnTihd5vBnmChri4Z6WR1l
        8sCvffTHppafPwRNutgs5p5XNTxY5Q0=
X-Google-Smtp-Source: ABdhPJyVh5qP4hKcAtn/RRlZ0B+Q8cFmjmFBXI1DPqQvA2V9K0iwFzc+UZwLiRuZJhJLjB8D0jCEwA==
X-Received: by 2002:a63:3681:: with SMTP id d123mr2434098pga.317.1594867595645;
        Wed, 15 Jul 2020 19:46:35 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id q7sm3285863pfn.23.2020.07.15.19.46.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Jul 2020 19:46:35 -0700 (PDT)
Date:   Thu, 16 Jul 2020 08:16:27 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     zhouxudong199 <zhouxudong8@huawei.com>
Cc:     wensong@linux-vs.org, horms@verge.net.au, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        rose.chen@huawei.com, zhaowei23@huawei.com
Subject: Re: [PATCH v2] ipvs: clean code for ip_vs_sync.c
Message-ID: <20200716024627.GC14742@blackclown>
References: <1594864671-31512-1-git-send-email-zhouxudong8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594864671-31512-1-git-send-email-zhouxudong8@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 01:57:51AM +0000, zhouxudong199 wrote:
> v1 -> v2:
> add missing spaces after Signed-off-by and ipvs: in the subject. 
> i=0 changed to i = 0.  
>

You should write the version changes after "---" and before the first
diff.

Also, looking at your patch I think your commit message should be
something like this :

"Use appropriate spaces around operators."

> Signed-off-by: zhouxudong199 <zhouxudong8@huawei.com>
> ---
>  net/netfilter/ipvs/ip_vs_sync.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index 605e0f6..885bab4 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -1077,10 +1077,10 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
>  	struct ip_vs_protocol *pp;
>  	struct ip_vs_conn_param param;
>  	__u32 flags;
> -	unsigned int af, state, pe_data_len=0, pe_name_len=0;
> -	__u8 *pe_data=NULL, *pe_name=NULL;
> -	__u32 opt_flags=0;
> -	int retc=0;
> +	unsigned int af, state, pe_data_len = 0, pe_name_len = 0;
> +	__u8 *pe_data = NULL, *pe_name = NULL;
> +	__u32 opt_flags = 0;
> +	int retc = 0;
>  
>  	s = (union ip_vs_sync_conn *) p;
>  
> @@ -1089,7 +1089,7 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
>  		af = AF_INET6;
>  		p += sizeof(struct ip_vs_sync_v6);
>  #else
> -		IP_VS_DBG(3,"BACKUP, IPv6 msg received, and IPVS is not compiled for IPv6\n");
> +		IP_VS_DBG(3, "BACKUP, IPv6 msg received, and IPVS is not compiled for IPv6\n");
>  		retc = 10;
>  		goto out;
>  #endif
> @@ -1129,7 +1129,7 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
>  			break;
>  
>  		case IPVS_OPT_PE_NAME:
> -			if (ip_vs_proc_str(p, plen,&pe_name_len, &pe_name,
> +			if (ip_vs_proc_str(p, plen, &pe_name_len, &pe_name,
>  					   IP_VS_PENAME_MAXLEN, &opt_flags,
>  					   IPVS_OPT_F_PE_NAME))
>  				return -70;
> @@ -1155,7 +1155,7 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
>  	if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
>  		pp = ip_vs_proto_get(s->v4.protocol);
>  		if (!pp) {
> -			IP_VS_DBG(3,"BACKUP, Unsupported protocol %u\n",
> +			IP_VS_DBG(3, "BACKUP, Unsupported protocol %u\n",
>  				s->v4.protocol);
>  			retc = 30;
>  			goto out;
> @@ -1232,7 +1232,7 @@ static void ip_vs_process_message(struct netns_ipvs *ipvs, __u8 *buffer,
>  		msg_end = buffer + sizeof(struct ip_vs_sync_mesg);
>  		nr_conns = m2->nr_conns;
>  
> -		for (i=0; i<nr_conns; i++) {
> +		for (i = 0; i < nr_conns; i++) {
>  			union ip_vs_sync_conn *s;
>  			unsigned int size;
>  			int retc;
> @@ -1444,7 +1444,7 @@ static int bind_mcastif_addr(struct socket *sock, struct net_device *dev)
>  	sin.sin_addr.s_addr  = addr;
>  	sin.sin_port         = 0;

I think you missed this one.
should be
-        sin.sin_port         = 0;
+	 sin.sin_port = 0

Thanks and Cheers,
Suraj Upadhyay.

> -	return sock->ops->bind(sock, (struct sockaddr*)&sin, sizeof(sin));
> +	return sock->ops->bind(sock, (struct sockaddr *)&sin, sizeof(sin));
>  }
>  
>  static void get_mcast_sockaddr(union ipvs_sockaddr *sa, int *salen,
> -- 
> 2.6.1.windows.1
> 
> 
