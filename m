Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD907A108
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 08:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfG3GFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 02:05:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37058 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfG3GFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 02:05:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so39232838wrr.4
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 23:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7D7Tjwk/HO6/4Yt/x6Nc/qQhUHHBVP+CTGXJ6DRqToo=;
        b=UTVTdiwwoOhD+NJTGTteF9N4+sD54qiJsYYu/CA4RzuCjAJzhqI0NGj2379bbVXfsn
         Rg1ffY/NiyO1SVA677TlBwnYQcHShdEgLeTYpckovmdm7zm0U53R+D+DdQogHL5e2Bpc
         DTvzbiMxLjLq43AqhauRI4ND3eUWVM0RLCcbrGxsrSTCfG2MPte/MUWCOYryja/5CaKC
         6Uo8cmv8wpZjP522gGR9mQ51obokG1131PkN2z06aWxoq0StvsVPjT41B9SIYK1gcmDq
         F9oGsV0yKZhuzk9OabzTAG8Tl1jAYC1X6xBzTT38KW/lqDPJrj4U/GykgleIkJ52yuFu
         Prng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7D7Tjwk/HO6/4Yt/x6Nc/qQhUHHBVP+CTGXJ6DRqToo=;
        b=nMVT8r6xK19ZXdtFi/OfdfCW/tiWs6TXFqYEmiK8pHeU7ymmKHtN3MKlwQ8XKwKL4X
         HQKsgGJ6qQDG8yIexoplkWCjvT4d0TXsOOX1EAQasF2q9am6+izgaL/j+3MBce9FDReO
         mT/TviHk+5M3SkCRLhd7o/QshX7THeLJ3mOzrIRVkGTFoPdIMrnwYhXoeOCAqHjrMH3n
         kVug2sd3++du6BBE+KK8EksmH3IU8ubd/+P+8cDcr2qwdK3Ki+i2gBZeVxuIB2VC0ITn
         pXOCg+FlZXl1yPsc+hbXqIL3CxaVsTVhR4VzuE5cAje6m0QyWtUjnoJG5NDjyVSprcyq
         aZJA==
X-Gm-Message-State: APjAAAV7L5Z7Tdyn5mNOpOVTXH9HW0VhqC2K3o1Llr9CW1KYubFN2Hj4
        7SReyGy4AauHNbw+4BIsRBI=
X-Google-Smtp-Source: APXvYqzHzwfOHjE5w06CfCAdbY9+ZP/oSDdf6xorhmOfTcQ+M/uviuDsMokdgc5I+fgIj5M8X7L7ig==
X-Received: by 2002:a5d:6583:: with SMTP id q3mr31671708wru.184.1564466748587;
        Mon, 29 Jul 2019 23:05:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o6sm131074586wra.27.2019.07.29.23.05.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 23:05:48 -0700 (PDT)
Date:   Tue, 30 Jul 2019 08:05:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 1/3] net: devlink: allow to change namespaces
Message-ID: <20190730060547.GA2312@nanopsycho.orion>
References: <20190727094459.26345-1-jiri@resnulli.us>
 <20190727094459.26345-2-jiri@resnulli.us>
 <20190729.105216.2073541569967891866.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729.105216.2073541569967891866.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 29, 2019 at 07:52:16PM CEST, davem@davemloft.net wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Sat, 27 Jul 2019 11:44:57 +0200
>
>> +	if ((netns_pid_attr && (netns_fd_attr || netns_id_attr)) ||
>> +	    (netns_fd_attr && (netns_pid_attr || netns_id_attr)) ||
>> +	    (netns_id_attr && (netns_pid_attr || netns_fd_attr))) {
>> +		NL_SET_ERR_MSG(info->extack, "multiple netns identifying attributes specified");
>> +		return ERR_PTR(-EINVAL);
>> +	}
>
>How about:
>
>	if (!!a + !!b + !!c > 1) {
>	...

I just copied the logic from the existing code. But sure :)


>
>> +
>> +	if (netns_pid_attr) {
>> +		net = get_net_ns_by_pid(nla_get_u32(netns_pid_attr));
>> +	} else if (netns_fd_attr) {
>> +		net = get_net_ns_by_fd(nla_get_u32(netns_fd_attr));
>> +	} else if (netns_id_attr) {
>> +		net = get_net_ns_by_id(sock_net(skb->sk),
>> +				       nla_get_u32(netns_id_attr));
>> +		if (!net)
>> +			net = ERR_PTR(-EINVAL);
>> +	}
>> +	if (IS_ERR(net)) {
>
>I think this is going to be one of those cases where a compiler won't be able
>to prove that 'net' is guaranteed to be initialized at this spot.  Please
>rearrange this code somehow so that is unlikely to happen.

It does not complain though. The function cannot be entered unless at
least one is. I'll check again.


>
>Thanks.
