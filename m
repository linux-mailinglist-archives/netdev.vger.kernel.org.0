Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C541F5886
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 18:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgFJQGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 12:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727813AbgFJQGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 12:06:44 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB877C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 09:06:43 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g28so2573089qkl.0
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 09:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=50PX8qK4T1iv6JqM7pFOdpjLhNtOB+QoAu5D63W+6Mw=;
        b=OHPghzVBaArOrbnO+AMX0wh/JVgJAV1YhgDhmVPsFX9lenE5jGRaOp2y1zIsdEJyIC
         nMeWCZVlF7pnFRUbVvcE5+KGPbKkDf2nCo3Cf6eLhDtG8irZLVMQAT49Q7+4aWQVOMEh
         BkaqjPN+kDLu6VWf6z9WvjLZVrD4fgttNADUASppi3DGW5uZf9/Sh+L7jgUIb0WFzBsc
         JUc8Q6CqaZ4k2gq6n/dnvFqLxBxXEH84lKsiYGfqKcvIiCr7P5/VwjeX4l97XNJ23mnN
         7BFyfNr1iY7nCeHKLeb7alFqTmNX7rf30Ct4DHx/1+6JAlgWSygKJLsGtURbHzcMRBSL
         SMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=50PX8qK4T1iv6JqM7pFOdpjLhNtOB+QoAu5D63W+6Mw=;
        b=h4fGp1ypznTehgZa8auQTBedmyajGKSyQenc8EZO68pdkjFl9g+cUG+7dZ9M+ofZQN
         SS/21ljnklcYQ8XCKV6kttV3NLBW/UDc1nAUR2uYAaZlwgtIA7KfH06voCOBiv+D228x
         +tfHPVuePZ9gYyeV+L77Y795hYMcBn1xALxJgagScFRK2HQnQzxhOdmeOnv0OZ/6hqLC
         A7jRmp78kE+8B6m7KnujJXGxKBvWt/4cv88EQYPYSrpBSYDFXhgQ+iJ3rLKSnF0WE+b/
         KSDsRCAFnHJjp5Eb/lmAuVlVBJGhzacny70EgqdQfFaSKId3kbZE3Wxr1A7BeNJcDJ/V
         KWpw==
X-Gm-Message-State: AOAM533y7j8i5ATUEYmdO3KB28d59W2ns0sORN4I7rwXNCdN9kuJ6xGb
        OmD16jqZUfD2srPSwjAc1y8=
X-Google-Smtp-Source: ABdhPJxCLwZuPMAK7f2N193l42excZPrkKLgAOePfF9cjswQFgsPmjQwNgCpZbWdn8lFxD7JGLC0rA==
X-Received: by 2002:ae9:dd02:: with SMTP id r2mr3528310qkf.179.1591805203117;
        Wed, 10 Jun 2020 09:06:43 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:7d55:1130:4e46:eb98? ([2601:282:803:7700:7d55:1130:4e46:eb98])
        by smtp.googlemail.com with ESMTPSA id x66sm88869qkb.33.2020.06.10.09.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 09:06:42 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next 1/2] ipnexthop: support for fdb nexthops
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        nikolay@cumulusnetworks.com
References: <1591674383-20545-1-git-send-email-roopa@cumulusnetworks.com>
 <1591674383-20545-2-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c72763ac-98a4-1bac-85aa-fd17985fc916@gmail.com>
Date:   Wed, 10 Jun 2020 10:06:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1591674383-20545-2-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/20 9:46 PM, Roopa Prabhu wrote:
> @@ -70,6 +71,12 @@ static int nh_dump_filter(struct nlmsghdr *nlh, int reqlen)
>  			return err;
>  	}
>  
> +	if (filter.fdb) {
> +		addattr_l(nlh, reqlen, NHA_FDB, NULL, 0);

missing 'err = '
> +		if (err)
> +			return err;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -131,6 +138,7 @@ static int ipnh_flush(unsigned int all)
>  		filter.groups = 1;
>  		filter.ifindex = 0;
>  		filter.master = 0;
> +		filter.fdb = 1;

This should not be needed. The point of this block is to flush groups
first and then standalone nexthops on a second pass. Adding fdb = 1 here
means only fdb groups are flushed in the first round.


