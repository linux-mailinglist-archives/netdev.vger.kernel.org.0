Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F9ED08E5
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 09:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbfJIHzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 03:55:32 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40935 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfJIHzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 03:55:31 -0400
Received: by mail-ed1-f65.google.com with SMTP id v38so1130211edm.7
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 00:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h1xNn8hBRUwBsZNX3MMVSts/H8ea/HSVD1R64rUVtQY=;
        b=AI3C6SaTmclfzhgNnSfMCIsBfVgCk210st/MgxOkxUom3+Bpk/4LJj5y2GQjhPlZj2
         jw83QLoR6xxW58cScq6tF7D+BU2FSpFENnivvFiRfd7TPsH5sLNyO+w1iTYCnaU/opDk
         rkhVttvw4yvkNWItAlWzw8W7ILdcnst+gRjnPMGcv33WYW5+c5LecQb3wpk0LkdzyRYa
         UEAsEuius/Q2Z3uURUakMFiBe9c18znMCf+443+ncTc2Eo5kKpwi0MhSLkgFO6nxycUs
         YsKCRpu+ZpDuALQIzOKEA/GIyQbMAJ0waXmjjQKMCuI7wo2dJHZ+xcK3CXo6HjPexLH7
         NBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h1xNn8hBRUwBsZNX3MMVSts/H8ea/HSVD1R64rUVtQY=;
        b=bWCcSS6wAfABk2ydnBk8SUPPS7USbKPmSzDNg91wLvjb9FibYknd3UBAnigdf/Bu1K
         K+T4wNvmfYNhT2cBSNAqairfHp+ijYS0H9O9sPY+FO6KJNs/5ijB3L3U83Qk0ZCXei3h
         CQ6ydV60cJczZWO145qO/Fapfov8mvbFKy8QGU1tPE9YfTYxncTIRsjeD5uY6W49ImAO
         SUlcoLoSgLP0YA+L9nk3RJidtIU/n4rE+sq/CX9bRTMvMxcT34spWv/vnZp2OkWCQFZb
         lF6suowJrJ2Ll4tAMBxqw4JfvpwFyM74X18Poba7efZYUa5hcr7iKrg2LLB+3Cw3HVXR
         jGVg==
X-Gm-Message-State: APjAAAUnDFidf6xsL3anY+ywXawMGnm3b/SIJo9FStvOmuCIxBVkk69f
        zJGPrImuK2ep0TQHwBM/fI6XTQ==
X-Google-Smtp-Source: APXvYqyUysvzCu3s/X7N9Sz7HQXnhWNi2nSaQ7ZLvTAcBSzjU4P+mZoDP5l0f0TKaaT/WuWG0nwvuQ==
X-Received: by 2002:a05:6402:150f:: with SMTP id f15mr1798046edw.240.1570607729513;
        Wed, 09 Oct 2019 00:55:29 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id m5sm157491ejc.70.2019.10.09.00.55.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Oct 2019 00:55:28 -0700 (PDT)
Date:   Wed, 9 Oct 2019 09:55:27 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        u9012063@gmail.com
Subject: Re: [PATCHv2 net-next 2/6] lwtunnel: add LWTUNNEL_IP_OPTS support
 for lwtunnel_ip
Message-ID: <20191009075526.fcx5wqmotzq5j5bj@netronome.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
 <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 11:16:12PM +0800, Xin Long wrote:
> This patch is to add LWTUNNEL_IP_OPTS into lwtunnel_ip_t, by which
> users will be able to set options for ip_tunnel_info by "ip route
> encap" for erspan and vxlan's private metadata. Like one way to go
> in iproute is:
> 
>   # ip route add 1.1.1.0/24 encap ip id 1 erspan ver 1 idx 123 \
>       dst 10.1.0.2 dev erspan1
>   # ip route show
>     1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 \
>       tos 0 erspan ver 1 idx 123 dev erspan1 scope link
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Hi Xin,

thanks for your patch.

While I have no objection to allowing options to be set, as per the sample
ip commands above, I am concerned that the approach you have taken exposes
to userspace the internal encoding used by the kernel for these options.

This is the same concerned that was raised by others when I posed a patch
to allow setting of Geneve options in a similar manner. I think what is
called for here, as was the case in the Geneve work, is to expose netlink
attributes for each option that may be set and have the kernel form
these into the internal format (which appears to also be the wire format).

> ---
>  include/uapi/linux/lwtunnel.h |  1 +
>  net/ipv4/ip_tunnel_core.c     | 30 ++++++++++++++++++++++++------
>  2 files changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
> index de696ca..93f2c05 100644
> --- a/include/uapi/linux/lwtunnel.h
> +++ b/include/uapi/linux/lwtunnel.h
> @@ -27,6 +27,7 @@ enum lwtunnel_ip_t {
>  	LWTUNNEL_IP_TOS,
>  	LWTUNNEL_IP_FLAGS,
>  	LWTUNNEL_IP_PAD,
> +	LWTUNNEL_IP_OPTS,
>  	__LWTUNNEL_IP_MAX,
>  };
>  
> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> index 10f0848..d9b7188 100644
> --- a/net/ipv4/ip_tunnel_core.c
> +++ b/net/ipv4/ip_tunnel_core.c
> @@ -218,6 +218,7 @@ static const struct nla_policy ip_tun_policy[LWTUNNEL_IP_MAX + 1] = {
>  	[LWTUNNEL_IP_TTL]	= { .type = NLA_U8 },
>  	[LWTUNNEL_IP_TOS]	= { .type = NLA_U8 },
>  	[LWTUNNEL_IP_FLAGS]	= { .type = NLA_U16 },
> +	[LWTUNNEL_IP_OPTS]	= { .type = NLA_BINARY },
>  };

...
