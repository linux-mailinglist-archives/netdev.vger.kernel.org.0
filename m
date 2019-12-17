Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDC512329F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfLQQgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:36:45 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33123 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbfLQQgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 11:36:45 -0500
Received: by mail-qk1-f194.google.com with SMTP id d71so6903230qkc.0
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 08:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ilrPrGODat9njllzbpa2mFweinR9gf7X7kNZv6BES2U=;
        b=hv/TO69nSquJWgY0sgSRPcpLwQD34K/LJZaOG0Wr1jnRWlJVQjYAZcxRl9LgZ+asTT
         ABUXQ7xypnLYiv/OEi7IMRqWrqpxkJmwVx4Rq7MtHTv1Mf+YIr3mBolbhYBPNiscgN4e
         9IVQeaD1ONimpf+hynmC0pjcgykzUzNPUAA7aXhEf+UhqT/uqbs3xh4AXCvO4fmrIBaW
         JGBVIDELReMm3oW1ymZCPway7Z1F8MNUHrE/0J1H37jrwLCYTlrIQ4fgHI8JpcM+BssW
         DuZAeEL987gE4ZLG2IUl7lahQLqlrc2s+THX/PZCEKqtJblk+gkG71GbfLEr2/isC+mI
         nAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ilrPrGODat9njllzbpa2mFweinR9gf7X7kNZv6BES2U=;
        b=UKmLK0t7SAtrH0qKSbrxcDJre4D9f7/tmqeCYgv9YTcbP66B/aFAPwRjHeK4Rcd64U
         ajpa9nQF/NpG2Wq1g0R6/e45F3og4ChV5EdQjuvaBigaN8KvbOOYHkx1mJGRQ/lFnnYp
         LMwykPXfP9QGzsoi4zVb9wyoyn+dgmf/G6hBKVv7FS9PDLCjs11RdfLlFr3G75vUYnpV
         7TvT1WqEC/HC6EqgYrH1ne0sH2cQHhu8q4OSRIq4jrNmDpuzzAEYiZay7qRgNFxCJ4KC
         zkxAoqyr7JEASS9e6x61QhTFWy81B2zh/7+BTqOGlUKs8NFUBfCfNR51CldVQhXp7/0P
         S7FQ==
X-Gm-Message-State: APjAAAXbyIYhiW0yTw5SEi03luwyT7CG3g8F8p0P6HpJAdLeDhpdmU64
        YHMKXprTOZGjbCidaJfF3qk=
X-Google-Smtp-Source: APXvYqwsSeFcyzJcOhi3tqDSJGPKALtsnkVdQciAcltWERDoXevmjqyh9qgqGOQgtofSUzIwUOJI3g==
X-Received: by 2002:a37:4dc1:: with SMTP id a184mr6027115qkb.62.1576600604362;
        Tue, 17 Dec 2019 08:36:44 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:b136:c627:c416:750? ([2601:284:8202:10b0:b136:c627:c416:750])
        by smtp.googlemail.com with ESMTPSA id o17sm8027120qtq.93.2019.12.17.08.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 08:36:43 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2 2/2] iplink: bond: print 3ad
 actor/partner oper states as strings
To:     Andy Roulin <aroulin@cumulusnetworks.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, stephen@networkplumber.org
References: <1576103595-23138-1-git-send-email-aroulin@cumulusnetworks.com>
 <1576103595-23138-3-git-send-email-aroulin@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <74e45193-2882-cc47-e53b-1373e6a26205@gmail.com>
Date:   Tue, 17 Dec 2019 09:36:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1576103595-23138-3-git-send-email-aroulin@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/19 3:33 PM, Andy Roulin wrote:
> The 802.3ad actor/partner operating states are only printed as
> numbers, e.g,
> 
> ad_actor_oper_port_state 15
> 
> Add an additional output in ip link show that prints a string describing
> the individual 3ad bit meanings in the following way:
> 
> ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>
> 
> JSON output is also supported, the field becomes a json array:
> 
> "ad_actor_oper_port_state_str":
> 	["active","short_timeout","aggregating","in_sync"]
> 
> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
> Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
>  ip/iplink_bond_slave.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 

Andy: Update the uapi file per the comments on that thread and resubmit
this patch with the updated names.
