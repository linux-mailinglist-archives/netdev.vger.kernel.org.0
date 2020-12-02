Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D972CC29B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgLBQnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgLBQnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:43:04 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93345C0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 08:42:24 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id f11so2207715oij.6
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 08:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ku8Inho4/IuHIbeiZZRCyslcn5gccpnyDReDJ96Z7l8=;
        b=VnAmm4wC0gHBgkdouRvIcHmedX7tWplonUxcQMDuv/yzFZbyd3MdnJbzcZ66I8KZg2
         x7Thre3f0Tu+0403rS/nzkpgDEuA2yYOrBbuUMY7C5TnPr9hCwIjbTrpnxSJcr18HSJc
         k959FOSSOufhGZV/uJFd4ejUV8Jh7AQRr5tbAHubDd6q3bd0gGvQ/7G5JUCUllGOdI/9
         O7r9BhueFlEfYHmIjQEeLCa9pscs25zoXIb355DBo3Om6k1Po6/Jrhwq0KLhpEq65Udj
         7tRfVmnR3RrjcvrjYa6ffqEt5/FEVJWuyTukS9lEdcfGFHqlzBhLs6/E+cTV/3Jl9pj9
         7p0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ku8Inho4/IuHIbeiZZRCyslcn5gccpnyDReDJ96Z7l8=;
        b=BIGwOL/lqFKdnJSCIeNbsfumUKyBsq4Nc4K35rIxLa9ClZwlh6kSD7nUwZh15IqL7d
         pjc8GJnC0p4WDSr7odmQD0FerESJ/1ak8nRsQf7xASHlkS4ZSdm6aumKbYzi1zKFKCQp
         ylxlftwOgq0nOuFtGJJzYf3bCFSfzeOnDG2Mvm95CdvBuPrmXUN01BZntTsMYxNi8lp0
         BxrYQQLJdqCol0TqBe8inKaNmxaxMqUo0Vydj8bVzPaUwkL7IU6MetvI2+huGbwnerRy
         OSBw0Z95RklF0KXiw4b9GUQbGdJO/VLzvwWJvTMHfEYgIf6wXpdgviquBf4x6Fzwu+xN
         9XOA==
X-Gm-Message-State: AOAM531KLkYH7DCDjrdjyYbcUMV13vYk/E5OVvsKaXC9J3iISheUiKVA
        F5cjPO0Rs8L2OrAkbaq7WWg=
X-Google-Smtp-Source: ABdhPJzFDSaIzi6Xl/XD7Zb9K68kmd/74rfOGovIfwrt8B/begNDgNNvVyUZ/azvLAA+2gcTcgIp7Q==
X-Received: by 2002:aca:d413:: with SMTP id l19mr2194606oig.100.1606927343872;
        Wed, 02 Dec 2020 08:42:23 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id n63sm468881oih.39.2020.12.02.08.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 08:42:23 -0800 (PST)
Subject: Re: [PATCH iproute2 v2] tc/mqprio: json-ify output
To:     Luca Boccassi <bluca@debian.org>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20201127152625.61874-1-bluca@debian.org>
 <20201128183015.15889-1-bluca@debian.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <77134dfe-8e5f-5bcc-25b4-dde91cf3492c@gmail.com>
Date:   Wed, 2 Dec 2020 09:42:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201128183015.15889-1-bluca@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/20 11:30 AM, Luca Boccassi wrote:
> @@ -287,9 +293,9 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  					return -1;
>  				*(min++) = rta_getattr_u64(r);
>  			}
> -			fprintf(f, "	min_rate:");
> +			open_json_array(PRINT_ANY, is_json_context() ? "min_rate" : "	min_rate:");
>  			for (i = 0; i < qopt->num_tc; i++)
> -				fprintf(f, "%s ", sprint_rate(min_rate64[i], b1));
> +				print_string(PRINT_ANY, NULL, "%s ", sprint_rate(min_rate64[i], b1));

close_json_array?

>  		}
>  
>  		if (tb[TCA_MQPRIO_MAX_RATE64]) {
> @@ -303,9 +309,9 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  					return -1;
>  				*(max++) = rta_getattr_u64(r);
>  			}
> -			fprintf(f, "	max_rate:");
> +			open_json_array(PRINT_ANY, is_json_context() ? "max_rate" : "	max_rate:");
>  			for (i = 0; i < qopt->num_tc; i++)
> -				fprintf(f, "%s ", sprint_rate(max_rate64[i], b1));
> +				print_string(PRINT_ANY, NULL, "%s ", sprint_rate(max_rate64[i], b1));
>  		}

close_json_array?

>  	}
>  	return 0;
> 

