Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0864F0DE
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 00:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfFUWu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 18:50:27 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:42289 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfFUWu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 18:50:27 -0400
Received: by mail-io1-f44.google.com with SMTP id u19so2156081ior.9
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 15:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YCOzph2wGcYVLVaGle1iSXg6yQr7Owol90CS3p4g0kk=;
        b=cup4cG7uRhvGDZO/IXNJQx4J3IWOfmLjvViJ43dy2G68Wn0zkNCXSacMjJzYa8L2ob
         +Q59wKo1EnLlZ9xOaCPYUtZ9ppdwSzCW7fsTtH3SIEJZFbLRXOtldrjqF7SZUn5oxrpi
         iScX+1qkDITg3PSpJboR8fA+YPDb08rOG8X+w0zjDyCAIE7SBOCaBsYSM9QAiJtyndIB
         9BU/aXejUybKHtGv7QWqrUYt6E/KhuJ14wGR9MZg/eNFbAWnigSIR98mZ9fIzrppnFMC
         PwW9/pn+4ELHro2jKL5aInVIkUA4kg37bDvnS7TeFIaCHlEa7NusqHy+D+2ICJFpNog8
         otIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YCOzph2wGcYVLVaGle1iSXg6yQr7Owol90CS3p4g0kk=;
        b=Jcq3H4GiINiq0YgPyfqxyOir2e6XOGurfDxSav/1AlV7CX2dnlTNy9cXtSNXZGgBD1
         C9ihn7AdEsnnwYAmG8fA60jr89lNHbcrygeSN07Yeo5uJwXwxF2k2pzyeKcHpGxq79uF
         dITZGTjolQwQ/7kAOrqS8V3i4/clWBROXnGoNmtzpS+y3lQUrMTxfvLdRqHtgEkMeBJv
         oYg8Ctt09cr2tV/X+ll4vYlIjkf/LHcnmu8qsZWW6p9RHROoyyiWOEoAJvQmGCzcIUKQ
         gVZAUjGCpq07BEk/OG43DcdpNcnA/RLw/EnqA+lnVXcj0dTCaGbfNTkbQlq7VPkWzHp9
         hO0A==
X-Gm-Message-State: APjAAAVPFkvKRU6izhnJI2XVYF2KvR9FWs2/PD8LmCo0koQh1Mdt+92w
        /8oj/Eq1oQRVZxk+iz21A14UqXKx
X-Google-Smtp-Source: APXvYqwDRQqocusvzMV7SqwCW5L9YYRVxnwFPl+u8PpiUEb+yXNpmo29C3bBy1cz6xfviroNz8Nw0w==
X-Received: by 2002:a5d:8404:: with SMTP id i4mr1224594ion.146.1561157426531;
        Fri, 21 Jun 2019 15:50:26 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:563:6fa4:e349:a2f8? ([2601:284:8200:5cfb:563:6fa4:e349:a2f8])
        by smtp.googlemail.com with ESMTPSA id r5sm3251057iom.42.2019.06.21.15.50.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 15:50:25 -0700 (PDT)
Subject: Re: [iproute2-next v5] tipc: support interface name when activating
 UDP bearer
To:     Hoang Le <hoang.h.le@dektech.com.au>, dsahern@gmail.com,
        jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
References: <20190613080719.22081-1-hoang.h.le@dektech.com.au>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d4bef444-f009-5415-f27d-8cfde945ddab@gmail.com>
Date:   Fri, 21 Jun 2019 16:50:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190613080719.22081-1-hoang.h.le@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/19 2:07 AM, Hoang Le wrote:
> @@ -119,6 +121,74 @@ static int generate_multicast(short af, char *buf, int bufsize)
>  	return 0;
>  }
>  
> +static struct ifreq ifr = {};

you don't need to initialize globals, but you could pass a a struct as
the arg to the filter here which is both the addr buffer and the ifindex
of interest.

> +static int nl_dump_addr_filter(struct nlmsghdr *nlh, void *arg)
> +{
> +	struct ifaddrmsg *ifa = NLMSG_DATA(nlh);
> +	char *r_addr = (char *)arg;
> +	int len = nlh->nlmsg_len;
> +	struct rtattr *addr_attr;
> +
> +	if (ifr.ifr_ifindex != ifa->ifa_index)
> +		return 0;
> +
> +	if (strlen(r_addr) > 0)
> +		return 1;
> +
> +	addr_attr = parse_rtattr_one(IFA_ADDRESS, IFA_RTA(ifa),
> +				     len - NLMSG_LENGTH(sizeof(*ifa)));
> +	if (!addr_attr)
> +		return 0;
> +
> +	if (ifa->ifa_family == AF_INET) {
> +		struct sockaddr_in ip4addr;
> +		memcpy(&ip4addr.sin_addr, RTA_DATA(addr_attr),
> +		       sizeof(struct in_addr));
> +		if (inet_ntop(AF_INET, &ip4addr.sin_addr, r_addr,
> +			      INET_ADDRSTRLEN) == NULL)
> +			return 0;
> +	} else if (ifa->ifa_family == AF_INET6) {
> +		struct sockaddr_in6 ip6addr;
> +		memcpy(&ip6addr.sin6_addr, RTA_DATA(addr_attr),
> +		       sizeof(struct in6_addr));
> +		if (inet_ntop(AF_INET6, &ip6addr.sin6_addr, r_addr,
> +			      INET6_ADDRSTRLEN) == NULL)
> +			return 0;
> +	}
> +	return 1;
> +}
> +
> +static int cmd_bearer_validate_and_get_addr(const char *name, char *r_addr)
> +{
> +	struct rtnl_handle rth ={ .fd = -1 };

space between '={'

> +
> +	memset(&ifr, 0, sizeof(ifr));
> +	if (!name || !r_addr || get_ifname(ifr.ifr_name, name))
> +		return 0;
> +
> +	ifr.ifr_ifindex = ll_name_to_index(ifr.ifr_name);
> +	if (!ifr.ifr_ifindex)
> +		return 0;
> +
> +	/* remove from cache */
> +	ll_drop_by_index(ifr.ifr_ifindex);

why the call to ll_drop_by_index? doing so means that ifindex is looked
up again.

> +
> +	if (rtnl_open(&rth, 0) < 0)
> +		return 0;
> +
> +	if (rtnl_addrdump_req(&rth, AF_UNSPEC, 0) < 0) {

If you pass a filter here to set ifa_index, this command on newer
kernels will be much more efficient. See ipaddr_dump_filter.


> +		rtnl_close(&rth);
> +		return 0;
> +	}
> +
> +	if (rtnl_dump_filter(&rth, nl_dump_addr_filter, r_addr) < 0) {
> +		rtnl_close(&rth);
> +		return 0;
> +	}
> +	rtnl_close(&rth);
> +	return 1;
> +}

it would better to have 1 exit with the rtnl_close and return rc based
on above.
