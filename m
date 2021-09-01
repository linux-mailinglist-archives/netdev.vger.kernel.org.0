Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54723FD1DB
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 05:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241783AbhIADhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 23:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241772AbhIADhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 23:37:38 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88C2C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:36:41 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g14so992842pfm.1
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AruAYqXi8gav6JhXWlfazOuSDB0qGQ4MeVGH3pBInAQ=;
        b=MBTUPtOAKEVnZHcVMX8P0o4dkip44D72HvEJ26PjwAuxbrNs+Qww2Cn77nocEURYNq
         MibOH4cMa+lJkMvqkaWEAX1VLReeIOxWrc3tLt7gdWyjz0TJOKt3yZkPG/6R7s2EO1j/
         wvZYSagcQJejwt+BizLfriJdk6gMwz5JBId3tSEaD+qUHlvdzURqFoyIZut4uqZaK7Iq
         ZfXpcu7o7aFkQyjJ4ZQIPkCpqI0YY+UvW0HsgBPHMcukwIw6+gBkRFS7NhorcLYCQUkQ
         8I9GO7Dl7B8mMk8Qr12qZ8rVi/OMN3r5kKE1HTAKSFCjo6iMo/f5i2tNL5810W7cfXGs
         5B2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AruAYqXi8gav6JhXWlfazOuSDB0qGQ4MeVGH3pBInAQ=;
        b=SILbBFnoSeDs5Rr6twI7A/gQjHGwvakHJxlp+llm53EsBmfAOghhLF+JP2L4uxZ7Ng
         ffmrZpYPDUN36LVzB6rp/6POogcD4Kd4BnE/9mUREM6riwo9cxq/v/4ycROs7RD3S/za
         PG6RzPNIyRrcJbol2EaYAAUs2uSuNrKC+8jS2nRKnMJhG5HgHD/q+n8ppdnwKoVDFAYA
         TjlNwU3SGyHNrJEzINruAkfgPPZ2EzdDizK16XyMzhY0gc5ysTqOSf9jkXOLF053MDCf
         VarKex7Lor+AttlU02MJD+RtLAXDg1suAoMEo75lX/VP8pKgeyjn92MDYgCCfk78ouBn
         V4qA==
X-Gm-Message-State: AOAM532MuD97JWfAfyBD6R54n6JTAMJi6Cno7/p+lnFXp6Wn/B9NNWhD
        TdPVKA5kvBmYfO9Jmd90UCM=
X-Google-Smtp-Source: ABdhPJzYQbiB9vO2ehxCRlCfwPM1eegxUsnYXHktkocpCIaf8gMDpkTIRoIcmvu4Ntw3abFU63n3Lg==
X-Received: by 2002:a63:ed47:: with SMTP id m7mr30139582pgk.194.1630467401278;
        Tue, 31 Aug 2021 20:36:41 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id c68sm3550925pfc.150.2021.08.31.20.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 20:36:40 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 07/19] bridge: vlan: add global
 mcast_snooping option
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210828110805.463429-1-razor@blackwall.org>
 <20210828110805.463429-8-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <52857ec7-48fc-b22c-de20-e751d51e612e@gmail.com>
Date:   Tue, 31 Aug 2021 20:36:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210828110805.463429-8-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/21 4:07 AM, Nikolay Aleksandrov wrote:
> @@ -397,6 +400,12 @@ static int vlan_global_option_set(int argc, char **argv)
>  			if (vid_end != -1)
>  				addattr16(&req.n, sizeof(req),
>  					  BRIDGE_VLANDB_GOPTS_RANGE, vid_end);
> +		} else if (strcmp(*argv, "mcast_snooping") == 0) {
> +			NEXT_ARG();
> +			if (get_u8(&val8, *argv, 0))
> +				invarg("invalid mcast_snooping", *argv);
> +			addattr8(&req.n, 1024,
> +				 BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING, val8);
>  		} else {
>  			if (matches(*argv, "help") == 0)
>  				NEXT_ARG();

How did you redo this patch set where 06 uses strcmp for the help line
and yet patches 7-17 all have matches?

Fixed those up given where we are with 5.14 cycle and applied to
iproute2-next.
