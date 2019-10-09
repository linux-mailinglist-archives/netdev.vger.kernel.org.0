Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CDBD0EFD
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbfJIMlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:41:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53168 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbfJIMlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:41:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so2431287wmh.2
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 05:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lz2SWReAhGJvj++UJ2mj1dbALqNgMv8+AgoBUSPEhCw=;
        b=h8RDJ61rEy92tpnhmIcJF5CTStLZ0ORzD9GhuDXHGdBA7K9nElD0zn2ElKxSXvPHZ1
         t5YbgOXCzTVn5RROjtS3FXPSHOsRPciTlg0nB4OayCmn76NTYYxhqTMedLiIEav6iFqJ
         BsPHTqc1Y4q7prGUmMm2k1r82UFMDFnun8UrXcA2pJrnNMeOiVQk+DtpJM2Sb9opS4x2
         HxXoQqVtlQ7LK/QdDB4hMqjL9BQ5/paS4eKtzk/lODyovJfr2wHGZOpbqjEuNu4O4OIe
         jpzyT/lyMyi1jcqnp5kcrfhdJlwBhy012TqncSPSu7CB3prlEyOTsq2Kn597BuAuWkrX
         4GfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lz2SWReAhGJvj++UJ2mj1dbALqNgMv8+AgoBUSPEhCw=;
        b=NsfVZ5sWTjtegsmEH3C8O3s1gGd46mNiCARGUMko5WPQnqRXido9c5xi+w+cMx0SUt
         T5vR2EkR6rbN2CeR8J0x10nBDKsmw30zJMgSA3xjU1CkjAGPB5WrzKgBXFGNbynlPumF
         J+5wZ4oChHjVGt8tDQQsUakwVuoduc1yqwE6jC/VFosCXrlQ+8U2CW8VHyNKfhS4lM7H
         ibFZO3D6UwI9KHW8FZLQ5/ywRCXGurwppzyx3H7Rw6DQWatdabMLOSmdbIgQYt7c/IOW
         5UThEwvXPEMceT37Ie9lHWVOcRWg7bgMxZTKqRYlZL+Js1XVuomkki2T5l4R/yYeMQMO
         UGhA==
X-Gm-Message-State: APjAAAUivp041gk1iML0ckdRXXtkR1zEtBe+HqnJv7vDE8ZW9kwW5NQT
        Qu4vF1xjyGvu/YnOFcD+TZV8jw==
X-Google-Smtp-Source: APXvYqzrQOg7ONQdAUKBru86A/Ua5qQen8dYVmG/TWBbPm5i5WVT3LN5HQeEBslyASmZH+lW65GV1w==
X-Received: by 2002:a05:600c:cd:: with SMTP id u13mr2324762wmm.37.1570624902943;
        Wed, 09 Oct 2019 05:41:42 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id j18sm2236848wrs.85.2019.10.09.05.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:41:42 -0700 (PDT)
Date:   Wed, 9 Oct 2019 14:41:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, roopa@cumulusnetworks.com,
        dcbw@redhat.com, nikolay@cumulusnetworks.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        f.fainelli@gmail.com, stephen@networkplumber.org,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2-next v2 2/2] ip: allow to use alternative names
 as handle
Message-ID: <20191009124141.GI2326@nanopsycho>
References: <20191002105645.30756-1-jiri@resnulli.us>
 <20191002105645.30756-3-jiri@resnulli.us>
 <ad655086-3f95-3897-c93b-bf15a52c2903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad655086-3f95-3897-c93b-bf15a52c2903@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 07, 2019 at 11:52:46PM CEST, dsahern@gmail.com wrote:
>On 10/2/19 4:56 AM, Jiri Pirko wrote:
>> @@ -1106,7 +1106,8 @@ int iplink_get(char *name, __u32 filt_mask)
>>  
>>  	if (name) {
>>  		addattr_l(&req.n, sizeof(req),
>> -			  IFLA_IFNAME, name, strlen(name) + 1);
>> +			  !check_ifname(name) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
>
>If this trick works here ...
>
>> +			  name, strlen(name) + 1);
>>  	}
>>  	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK, filt_mask);
>>  
>> diff --git a/lib/ll_map.c b/lib/ll_map.c
>> index e0ed54bf77c9..04dfb0f2320b 100644
>> --- a/lib/ll_map.c
>> +++ b/lib/ll_map.c
>> @@ -70,7 +70,7 @@ static struct ll_cache *ll_get_by_name(const char *name)
>>  		struct ll_cache *im
>>  			= container_of(n, struct ll_cache, name_hash);
>>  
>> -		if (strncmp(im->name, name, IFNAMSIZ) == 0)
>> +		if (strcmp(im->name, name) == 0)
>>  			return im;
>>  	}
>>  
>> @@ -240,6 +240,43 @@ int ll_index_to_flags(unsigned idx)
>>  	return im ? im->flags : -1;
>>  }
>>  
>> +static int altnametoindex(const char *name)
>> +{
>> +	struct {
>> +		struct nlmsghdr		n;
>> +		struct ifinfomsg	ifm;
>> +		char			buf[1024];
>> +	} req = {
>> +		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
>> +		.n.nlmsg_flags = NLM_F_REQUEST,
>> +		.n.nlmsg_type = RTM_GETLINK,
>> +	};
>> +	struct rtnl_handle rth = {};
>> +	struct nlmsghdr *answer;
>> +	struct ifinfomsg *ifm;
>> +	int rc = 0;
>> +
>> +	if (rtnl_open(&rth, 0) < 0)
>> +		return 0;
>> +
>> +	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK,
>> +		  RTEXT_FILTER_VF | RTEXT_FILTER_SKIP_STATS);
>> +	addattr_l(&req.n, sizeof(req), IFLA_ALT_IFNAME, name, strlen(name) + 1);
>
>then why is altnametoindex even needed? why not just use the same check
>in the current ll_link_get?

Good point. Reworked. Thanks!


>
>> +
>> +	if (rtnl_talk_suppress_rtnl_errmsg(&rth, &req.n, &answer) < 0)
>> +		goto out;
>> +
>> +	ifm = NLMSG_DATA(answer);
>> +	rc = ifm->ifi_index;
>> +
>> +	free(answer);
>> +
>> +	rtnl_close(&rth);
>> +out:
>> +	return rc;
>> +}
>> +
>> +
>>  unsigned ll_name_to_index(const char *name)
>>  {
>>  	const struct ll_cache *im;
>> @@ -257,6 +294,8 @@ unsigned ll_name_to_index(const char *name)
>>  		idx = if_nametoindex(name);
>>  	if (idx == 0)
>>  		idx = ll_idx_a2n(name);
>> +	if (idx == 0)
>> +		idx = altnametoindex(name);
>
>And then this ordering does not need to be fixed (altname check should
>come before if_nametoindex.
>
>>  	return idx;
>>  }
>>  
>> 
>
