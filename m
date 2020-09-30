Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B903227EE0B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730984AbgI3P5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3P5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:57:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D7FC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 08:57:23 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d13so1354585pgl.6
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 08:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7CdSUa6gwbm3i4rRHa0hPNLFkGrth4qkywZppwPaGdc=;
        b=BpA3wpRe9YWqh0Y8t7YiHWBiZvQHYpq2TkgzPjTVzTeBJTrEfoww0E9j2baBc64WKG
         juvz5f1VNvlbZQskGgtY3xIVNgGiZyccdZdPsnQ3TkuDY5ZgL3f+KzrGbRlvnlZTvQl+
         oQWQ+kfiCWGEBb1lMDAeTx4JlL8w5DbqKnY67GWMKYklUF5jGVUdWwvN1Uoy/ur2qgGZ
         vhZKjW5tqhDMvleR7eYGjaMXsXLNutwnx70Olstn0krxMLKKSc/lI4/lDO1QWj5Y3SfP
         ChmrMe3L+F4A+3U2DHsPH4B/J7q9zyVDSx9lVZX+tUFWwC6TdRidJgujg38XI+0VQ7At
         Hm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7CdSUa6gwbm3i4rRHa0hPNLFkGrth4qkywZppwPaGdc=;
        b=jje3Ifbtt71z+qiYsw8MH0EVfEoZPJfiDf2tZJHmCCGKFIEdwuZBcT1rcFKUEfbwkN
         FEaaL4PSXn7KjLHTQmiG4AX+AZF8rU43hOJl6DuQn7wzy1zp3i030riy68/LM41PHdzj
         iFmfBwo9jFy1nVHp+gN8mJCvlGaJnjt+nCG6p3epMWFS0miTJeCpRlpxToGVsJ64aKXA
         DctRS+9TOCSR/jB+Kl6x0uMDvzQk+5RB+B0oBQBlCZbsNIfpeoLgRgiKSFzyBApPz3XI
         7ZC7XC5VXCXrId0E3+sFipfL0l37P90dmcMlpAv1hzAMYDRpWWIPwqeZXhKlZd0HqDHN
         U2HA==
X-Gm-Message-State: AOAM533KKEeg7CYlpc6aYaPxI9SzVzn0mbYl731WaPoHbFqGUzQ1zEii
        FXpXEoKHGMxDiBjW3O2bWTw=
X-Google-Smtp-Source: ABdhPJyUGWJXc2p9cwC5dEHatHescobkkX5hTSZFqbxPMcjL3bddVxH4jlATRvrIXtXJYroffUGIRg==
X-Received: by 2002:a62:52d3:0:b029:142:2501:3a00 with SMTP id g202-20020a6252d30000b029014225013a00mr2949539pfb.79.1601481442518;
        Wed, 30 Sep 2020 08:57:22 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id a27sm3110955pfk.52.2020.09.30.08.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 08:57:21 -0700 (PDT)
Subject: Re: [RESEND PATCH iproute2-next 2/2] tc: implement support for terse
 dump
To:     Vlad Buslov <vladbu@nvidia.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <20200930073651.31247-1-vladbu@nvidia.com>
 <20200930073651.31247-3-vladbu@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0d4e9eb2-ab6b-432c-9185-c93bbf927d1f@gmail.com>
Date:   Wed, 30 Sep 2020 08:57:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200930073651.31247-3-vladbu@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 12:36 AM, Vlad Buslov wrote:
> From: Vlad Buslov <vladbu@mellanox.com>
> 
> Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
> tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
> user requested it with following example CLI:
> 
>> tc -s filter show terse dev ens1f0 ingress

this should be consistent with ip command which has -br for 'brief'
output. so this should be

   tc -s -br filter show dev ens1f0 ingress

Other tc maintainers should weigh in on what data should be presented
for this mode.


> 
> In terse mode dump only outputs essential data needed to identify the
> filter and action (handle, cookie, etc.) and stats, if requested by the
> user. The intention is to significantly improve rule dump rate by omitting
> all static data that do not change after rule is created.
> 
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  tc/tc_filter.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tc/tc_filter.c b/tc/tc_filter.c
> index c591a19f3123..6a82f9bb42fb 100644
> --- a/tc/tc_filter.c
> +++ b/tc/tc_filter.c
> @@ -595,6 +595,7 @@ static int tc_filter_list(int cmd, int argc, char **argv)
>  		.t.tcm_parent = TC_H_UNSPEC,
>  		.t.tcm_family = AF_UNSPEC,
>  	};
> +	bool terse_dump = false;
>  	char d[IFNAMSIZ] = {};
>  	__u32 prio = 0;
>  	__u32 protocol = 0;
> @@ -687,6 +688,8 @@ static int tc_filter_list(int cmd, int argc, char **argv)
>  				invarg("invalid chain index value", *argv);
>  			filter_chain_index_set = 1;
>  			filter_chain_index = chain_index;
> +		} else if (matches(*argv, "terse") == 0) {
> +			terse_dump = true;
>  		} else if (matches(*argv, "help") == 0) {
>  			usage();
>  		} else {
> @@ -721,6 +724,15 @@ static int tc_filter_list(int cmd, int argc, char **argv)
>  	if (filter_chain_index_set)
>  		addattr32(&req.n, sizeof(req), TCA_CHAIN, chain_index);
>  
> +	if (terse_dump) {
> +		struct nla_bitfield32 flags = {
> +			.value = TCA_DUMP_FLAGS_TERSE,
> +			.selector = TCA_DUMP_FLAGS_TERSE
> +		};
> +
> +		addattr_l(&req.n, MAX_MSG, TCA_DUMP_FLAGS, &flags, sizeof(flags));
> +	}
> +
>  	if (rtnl_dump_request_n(&rth, &req.n) < 0) {
>  		perror("Cannot send dump request");
>  		return 1;
> 

