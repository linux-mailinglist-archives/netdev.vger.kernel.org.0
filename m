Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0854ECEEA5
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 23:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbfJGVwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 17:52:51 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40664 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbfJGVwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 17:52:51 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so7503029pll.7
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 14:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ju+4uMQSwRWJTlv+kgQG+VR5no+Pogf7ScKDRiiu5Cs=;
        b=inA7aytQ6ihOZFbqnUVjqvZ1yPZRQQmML3FOWYm3koLkRQUa5osKI0tgaCX4YOVZ1O
         kk/JqS3VJqoyYMXIOdhC3KDdCowRvnSXUL36Mqbbo/jcY11HeN+N7D6acKxn9KIHh73m
         l8sM9FQZd8BCRY7zhGh0IMNeDPJXGc2lOK4Uld9tNqUQv93rkRYsXjJ2yc0U2gbv5ONi
         +/PRhAFBsKQQsVVlmsvpnYcF+aBTP+99I0vMKbApglrihg/N7e6jR78fXeOlCbvk31fO
         4y+OfLDjRUYXHBsPTCn+azIuUQOIVmSV8YOfZI31V097yg/W5R3tTCfuF3DtNiGyAjbs
         IlgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ju+4uMQSwRWJTlv+kgQG+VR5no+Pogf7ScKDRiiu5Cs=;
        b=Mn0MBqO6yG/vr++GHxixnK4bCyA45OsynmGxuJdHLOHdaE8YU58wx0yq9y8EGSoYGr
         ByPq5dY2Cvoh+9ziINrb474yEHSC1qR9U6HOMx94P9GLVJKfDDQbLT1t9iLnaPubYe+a
         RUCQayyLyCrJ61f+LvMPpxy3pGdY851gIaX6HOWIwQas7GlbvtPTewNgF8TVDKJP6SXv
         dfCQqLSyXPuRqzslzrlZzPr6l/SCRNecA2v4PSoBOKzxs8e+7mhA4+EPF9GjjZb2QKca
         bzPp3nibnckXMfGpq5C3nCyPPufzEnspTaaQF/S6Cq39/b6JHL4RKJI2LPiRBgkiBWiZ
         dQkw==
X-Gm-Message-State: APjAAAUHafH/L5p7PJ2YkEgAs9NWkA1GfOF/KlJV1qgTOeZozWX9IHHH
        KZJ2mkZI/Yws9AvMdiq76Q0=
X-Google-Smtp-Source: APXvYqy+FTQQrYVawD+xoVCNz61W/olRCIJe41E8cLkv1NLS36Fh/HXZC9Emw922P6bWiX6wCawrWA==
X-Received: by 2002:a17:902:7796:: with SMTP id o22mr32148260pll.222.1570485170575;
        Mon, 07 Oct 2019 14:52:50 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:dc58:1abd:13a8:f485])
        by smtp.googlemail.com with ESMTPSA id w2sm14695147pfn.57.2019.10.07.14.52.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 14:52:49 -0700 (PDT)
Subject: Re: [patch iproute2-next v2 2/2] ip: allow to use alternative names
 as handle
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
References: <20191002105645.30756-1-jiri@resnulli.us>
 <20191002105645.30756-3-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ad655086-3f95-3897-c93b-bf15a52c2903@gmail.com>
Date:   Mon, 7 Oct 2019 15:52:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002105645.30756-3-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 4:56 AM, Jiri Pirko wrote:
> @@ -1106,7 +1106,8 @@ int iplink_get(char *name, __u32 filt_mask)
>  
>  	if (name) {
>  		addattr_l(&req.n, sizeof(req),
> -			  IFLA_IFNAME, name, strlen(name) + 1);
> +			  !check_ifname(name) ? IFLA_IFNAME : IFLA_ALT_IFNAME,

If this trick works here ...

> +			  name, strlen(name) + 1);
>  	}
>  	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK, filt_mask);
>  
> diff --git a/lib/ll_map.c b/lib/ll_map.c
> index e0ed54bf77c9..04dfb0f2320b 100644
> --- a/lib/ll_map.c
> +++ b/lib/ll_map.c
> @@ -70,7 +70,7 @@ static struct ll_cache *ll_get_by_name(const char *name)
>  		struct ll_cache *im
>  			= container_of(n, struct ll_cache, name_hash);
>  
> -		if (strncmp(im->name, name, IFNAMSIZ) == 0)
> +		if (strcmp(im->name, name) == 0)
>  			return im;
>  	}
>  
> @@ -240,6 +240,43 @@ int ll_index_to_flags(unsigned idx)
>  	return im ? im->flags : -1;
>  }
>  
> +static int altnametoindex(const char *name)
> +{
> +	struct {
> +		struct nlmsghdr		n;
> +		struct ifinfomsg	ifm;
> +		char			buf[1024];
> +	} req = {
> +		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
> +		.n.nlmsg_flags = NLM_F_REQUEST,
> +		.n.nlmsg_type = RTM_GETLINK,
> +	};
> +	struct rtnl_handle rth = {};
> +	struct nlmsghdr *answer;
> +	struct ifinfomsg *ifm;
> +	int rc = 0;
> +
> +	if (rtnl_open(&rth, 0) < 0)
> +		return 0;
> +
> +	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK,
> +		  RTEXT_FILTER_VF | RTEXT_FILTER_SKIP_STATS);
> +	addattr_l(&req.n, sizeof(req), IFLA_ALT_IFNAME, name, strlen(name) + 1);

then why is altnametoindex even needed? why not just use the same check
in the current ll_link_get?

> +
> +	if (rtnl_talk_suppress_rtnl_errmsg(&rth, &req.n, &answer) < 0)
> +		goto out;
> +
> +	ifm = NLMSG_DATA(answer);
> +	rc = ifm->ifi_index;
> +
> +	free(answer);
> +
> +	rtnl_close(&rth);
> +out:
> +	return rc;
> +}
> +
> +
>  unsigned ll_name_to_index(const char *name)
>  {
>  	const struct ll_cache *im;
> @@ -257,6 +294,8 @@ unsigned ll_name_to_index(const char *name)
>  		idx = if_nametoindex(name);
>  	if (idx == 0)
>  		idx = ll_idx_a2n(name);
> +	if (idx == 0)
> +		idx = altnametoindex(name);

And then this ordering does not need to be fixed (altname check should
come before if_nametoindex.

>  	return idx;
>  }
>  
> 

