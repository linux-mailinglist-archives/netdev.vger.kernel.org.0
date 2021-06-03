Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C120E3998A3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 05:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFCDiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 23:38:51 -0400
Received: from mail-oo1-f45.google.com ([209.85.161.45]:46844 "EHLO
        mail-oo1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFCDir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 23:38:47 -0400
Received: by mail-oo1-f45.google.com with SMTP id x22-20020a4a62160000b0290245cf6b7feeso1079315ooc.13
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 20:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+4S5cillMkGmkj7CPEP2zgPOj2VGFqFoGJmjqdd2zV8=;
        b=aQM7zJy7YlA9JBm6g0Mgqd0CGswohBU7MYinOtdzgNvmdeObhb60HOrs+T9esuZe8q
         YaGQYQY8A6oYL81SlTOngsSPhWDeU5rYPNrvhbPCLBJrcpaCrULhD8XCKmyg2R9Q6WtB
         9F5mET5iB27AmuBDeQTYiwNIPSQhEu9ztV8Af4HaUlg6uqHxT0S+50P19i05rl0YVW0Y
         r66QA90r3vqwNi1fqQhCYlCxJFyW+XQpOTgOvapzn8XlCw6udhv64VSaNnWO1NKEGUhH
         EeGWORTAUFMQPA7C7LI4YHNI8IVL6b65tg4usPd1lePpi+u5oAVH15W5gncyNmiJ2UiF
         Ay8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+4S5cillMkGmkj7CPEP2zgPOj2VGFqFoGJmjqdd2zV8=;
        b=rtuMmotMmD+JzKteOd7GXp5p//SIHceTO0z46sx6Ys+6LiOFMY2OtuPp1CuelQWRe7
         J4SjSuyK8FHRT7Fk3S8DPN9wTWWEhiLGrAxHb+gBRqpvTvoissjhEmHO6mXaSuqlLIMD
         IRFz435dRXha8Q438kXidwsa+h+ugkjs8+jQ/hfJ3KqRcS0TIj0Dcmr1iLmPOpD2XXxk
         oRQdTw+0dDBjpl6NuyzA9gIahfQrKLPqjfNGGip2mKsTvgxrwi5jd5KxH32Ac+hZAp6V
         qCzYgc/sj2SkhGe5amGpVgFzaDm/BZSFR6DNkqpMjCnz34D9jV84ZoN2hm8XObweSTm9
         2QRQ==
X-Gm-Message-State: AOAM532uGokZ8gARbVw/89Gv63q9B5cppNBFPrCtqYbdyPvHf+gnCVNr
        pSEORxKc3KZsjlT54oJcK9o=
X-Google-Smtp-Source: ABdhPJzUUo7EnGVf9BcjXbq44ZT04LL9Jo+2UawM21bCpyevq0FXTmlMuzqz5TEpasrdfRH6mkaB9Q==
X-Received: by 2002:a4a:b4cd:: with SMTP id g13mr26865927ooo.4.1622691110616;
        Wed, 02 Jun 2021 20:31:50 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id w200sm91493oie.10.2021.06.02.20.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 20:31:50 -0700 (PDT)
Subject: Re: [PATCH net-next v4 0/5] Support for the IOAM Pre-allocated Trace
 with IPv6
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tom@herbertland.com
References: <20210527151652.16074-1-justin.iurman@uliege.be>
 <85a22702-da46-30c2-46c9-66d293d510ff@gmail.com>
 <1049853171.33683948.1622305441066.JavaMail.zimbra@uliege.be>
 <cc16923b-74bc-7681-92c7-19e84a44c0e1@gmail.com>
 <1439349685.35359322.1622462654030.JavaMail.zimbra@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e619169e-adfe-4b77-b359-6378c83b3ce3@gmail.com>
Date:   Wed, 2 Jun 2021 21:31:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1439349685.35359322.1622462654030.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/21 6:04 AM, Justin Iurman wrote:
>>> Actually, February 2021 is the last update. The main draft
>>> (draft-ietf-ippm-ioam-data) has already come a long way (version 12) and has
>>> already been Submitted to IESG for Publication. I don't think it would hurt
>>
>> when the expected decision on publication?
> 
> Hard to tell precisely, a couple weeks probably. There are still some comment/discuss to clear and our next IETF working group meeting is in July. However, it shouldn't be a concern (see below).\

Ok.

> 
>> that much to have it in the kernel as we're talking about a stable
>> draft (the other one is just a wrapper to define the encapsulation of
>> IOAM with IPv6) and something useful. And, if you think about Segment
>> Routing for IPv6, it was merged in the kernel when it was still a draft.
>>
>> The harm is if there are any changes to the uapi.
> 
> Definitely agree. But, I can assure you there won't be any uapi change at this stage. None of the comment/discuss I mentioned above are about this at all. Headers definition and IANA codes are defined for a long time now and won't change anymore.
> 

Please add tests to tools/testing/selftests/net to cover the
functionality added.
