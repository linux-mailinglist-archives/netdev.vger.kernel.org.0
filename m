Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3D72A2272
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 00:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgKAXzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 18:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgKAXzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 18:55:46 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB6AC0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 15:55:44 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id z2so11361341ilh.11
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 15:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0bvVNl+CAzJQWM/F2enQD5qzCbEPVKEGPP3S4xOLldQ=;
        b=EuAaCpuZtMO6WXwuvkp3K8m3Tb++ytMaVJxkcnxG/ARh6bwJhv4bUV0Alt/FYrRSJZ
         shpXSPb2xBmEnZy2cSbQ/gnWMbUFzAX6fND34ozjXqASADflH2Zp1Dlux85u2IpfW4BB
         lNnkrJhtsaAuqetmDzyNIIOe7/cexKomWjTpEJ6yKuH2vTPvU6lbH6Q9GkhASZp4cM7+
         T/pU856WvudZfK0NAw923Y3vH9A1z2a5Uwe9d+AIPxih01xzg8P8/x49L2nqvQV/x4Gj
         kXZpIWnbXD4kw2Zr2ZiXRPQzHzKDCmYqjL0WIlJGeqC9d79eusbd/zPjEMoLIbQzpZkx
         3cqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0bvVNl+CAzJQWM/F2enQD5qzCbEPVKEGPP3S4xOLldQ=;
        b=sY5fAursB8GAX6hsk1jTjdFrPcvJOOY9pIFsfcDDktkJlTibPe3dbaEpp63sWMTPm2
         AqntaKPGg5e+bXdYEjeQ55TrgbqrWS2mF6eAOv9mnJTHm1D2/nPUKa3RLozmyJl9wMWP
         ejIWkLgqlkDm0GvCFZoFW97mzjYeE+m6UhMYjMQ4OTwmcLCsDLnaOJoq9DIMaSqWWl4J
         ThpHDrY00iNRGPlsANaNCMXyqAyWJ03kvafkj5kENWrUhxBhXwy4QT5G9YfmsUer3kv8
         +2Egv1sdgVg2juWx9g/KqtVvGhA1xuFkX17/evNV7YzaSAwA1KkuN93AL75aMZ/NT+cN
         78Cg==
X-Gm-Message-State: AOAM533s5fWRqQVIIjfsNqyQpEj8gpzZhNykm0fxGTJe9iG/Mh/oAT5N
        d2XdGopaZYAyT9eRN1mNipM=
X-Google-Smtp-Source: ABdhPJz3YOqZei+4kL/mz6CS6adjMJMZdztVKzWpjhwxjnb86Gv/5sQanLSqRGiUOUjOyNYwjAcZgg==
X-Received: by 2002:a92:dccb:: with SMTP id b11mr1011507ilr.6.1604274943765;
        Sun, 01 Nov 2020 15:55:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4ca9:ddcf:e3b:9c54])
        by smtp.googlemail.com with ESMTPSA id q1sm1145676iot.48.2020.11.01.15.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 15:55:43 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add
 print_on_off_bool()
To:     Petr Machata <me@pmachata.org>, David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>
References: <cover.1604059429.git.me@pmachata.org>
 <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org>
 <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com> <87o8kihyy9.fsf@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b0cc6bd4-e4e6-22ba-429d-4cea7996ccd4@gmail.com>
Date:   Sun, 1 Nov 2020 16:55:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87o8kihyy9.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/20 3:23 PM, Petr Machata wrote:
> 
> David Ahern <dsahern@gmail.com> writes:
> 
>> On 10/30/20 6:29 AM, Petr Machata wrote:
>>> diff --git a/lib/utils.c b/lib/utils.c
>>> index 930877ae0f0d..8deec86ecbcd 100644
>>> --- a/lib/utils.c
>>> +++ b/lib/utils.c
>>> @@ -1763,3 +1763,11 @@ int parse_on_off(const char *msg, const char *realval, int *p_err)
>>>
>>>  	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
>>>  }
>>> +
>>> +void print_on_off_bool(FILE *fp, const char *flag, bool val)
>>> +{
>>> +	if (is_json_context())
>>> +		print_bool(PRINT_JSON, flag, NULL, val);
>>> +	else
>>> +		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
>>> +}
>>>
>>
>> I think print_on_off should be fine and aligns with parse_on_off once it
>> returns a bool.
> 
> print_on_off() is already used in the RDMA tool, and actually outputs
> "on" and "off", unlike this. So I chose this instead.
> 
> I could rename the RDMA one though -- it's used in two places, whereas
> this is used in about two dozen instances across the codebase.
> 

yes, the rdma utils are using generic function names. The rdma version
should be renamed; perhaps rd_print_on_off. That seems to be once common
prefix. Added Leon.
