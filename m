Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1BC48B24A
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349840AbiAKQfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240478AbiAKQfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:35:07 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5FCC06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:35:07 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id o7so23163936ioo.9
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6RGdTXpAQWi2JjLUrtmBswY1GUmt7yJz6Zok6n/v2fU=;
        b=JT2idHreqlkoMJn+3CKJWxto5IKN9t17fd5FblvgJihCdn2hzDdqVHvXZa5EIWX6ML
         mpsZVYnrPX3yeIz6RCeK0eOgPpxWlqivXEo5uTJTUnQEOcIbQac3cTOyFIxQmhyRbYwO
         Ngp8w5PNL7NFZelkDihtJCmkePR7+do1669JjynxvrqA7nC9L5DXjHEnlAei5z1wQzIG
         F/jdH0RjCElYGi8EnU7ncVEVAZYvjp48K1YrMnb2crNcXkd7qyJJE0lquZ5LR2cRSrc8
         gRFRwfnsknp5jwse2obS3WQGDT8hDbQ3JlXc7JnWjmD09wkNx+6f0QEVK5HvUQU6Cfr+
         1w3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6RGdTXpAQWi2JjLUrtmBswY1GUmt7yJz6Zok6n/v2fU=;
        b=a3ZxWY59wZzx7hlmaOK2AP7tgmwlVSsxAkdONHHhNBPVig7+sXvH6VvriR/MPETC6p
         zziWM0SI65wZtt5mlpmbg79jJNRZl3WY3NQRWRfFC7V4irIPZMuqukLTItRyiz+wQBMT
         p6RGU8Gf/Xfv4Mmk8jU2itBPiMhLa+gdh6d2l8MFKI1Pfuz30aSs6fpejouhS0NuXZhQ
         xwufFfmwoE1i61BVX1uNPGKS5FsXfzCiQwPlOWJs+7unGy4LXAb26cpFSJ/75r8Q6J6u
         UdNziIpv03VOYztlegylyMfL88sogMSsp9HzjIr3nea1o7wmMsWaZTtwKaXzx+PLSmx7
         5wog==
X-Gm-Message-State: AOAM5324gD2H/kdH3HSx8vwRO8GQ37kdziz21aI6/bGax9o9gz/l8WUA
        9uKRMVWylBgW9mlcCrJstj9lUAzl98Y=
X-Google-Smtp-Source: ABdhPJzt/S1kIUYV2YkzZ6Hl+wzOfw4t2Hl9xLTpDXXAk4iEErat+g9k8y6zhxCClMh2IzjaOWwmRQ==
X-Received: by 2002:a05:6638:1919:: with SMTP id p25mr2983330jal.16.1641918906686;
        Tue, 11 Jan 2022 08:35:06 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:d826:3ad7:a899:d318? ([2601:282:800:dc80:d826:3ad7:a899:d318])
        by smtp.googlemail.com with ESMTPSA id y15sm6556794iow.44.2022.01.11.08.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 08:35:06 -0800 (PST)
Message-ID: <acff5b79-2e5d-2877-0532-bb48608cc83b@gmail.com>
Date:   Tue, 11 Jan 2022 09:35:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH iproute2 v2] ip: Extend filter links/addresses
Content-Language: en-US
To:     Anton Danilov <littlesmilingcloud@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20220108195824.23840-1-littlesmilingcloud@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220108195824.23840-1-littlesmilingcloud@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/22 12:58 PM, Anton Danilov wrote:
> @@ -227,6 +227,28 @@ static int match_link_kind(struct rtattr **tb, const char *kind, bool slave)
>  	return strcmp(parse_link_kind(tb[IFLA_LINKINFO], slave), kind);
>  }
>  
> +static int match_if_type_name(unsigned short if_type, const char *type_name)
> +{
> +
> +	char *expected_type_name;
> +
> +	switch (if_type) {
> +	case ARPHRD_ETHER:
> +		expected_type_name = "ether";
> +		break;
> +	case ARPHRD_LOOPBACK:
> +		expected_type_name = "loopback";
> +		break;
> +	case ARPHRD_PPP:
> +		expected_type_name = "ppp";
> +		break;
> +	default:
> +		expected_type_name = "";
> +	}
> +
> +	return !strcmp(type_name, expected_type_name);

current 'type' filtering is the 'kind' string in the rtnl_link_ops --
bridge, veth, vlan, vrf, etc. You are now wanting to add 'exclude_type'
and make it based on hardware type. That is a confusing user api.

What type of interface filtering is motivating this change? e.g., link /
address lists but ignoring say vlan or veth devices?
