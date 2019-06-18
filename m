Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 018EE4A59F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbfFRPlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:41:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42707 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729349AbfFRPlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:41:46 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so30817622ior.9
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 08:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MZxsyTjg1k59xNuVyc67xhe+ytLlXEZ0W0mBpEpHGUw=;
        b=lMb8+kR/nNrVsQy+4KdNJBRARw1f3JfQ5r0FU8OyA2K3nTZylh4GlL/4NJohD6Os0X
         5r20HSF5ItlbgBzUKV9wCnEqf0YysD0PspXF9rIR190F6JPumpxy3ghlfMhbooxwogh6
         FP4bpJ3X7Lh1MbcSwWrqaCCL7yhDHa9J28mtYUesHwdJ/j/y4eCTTRx8vNVClIHo4Lcd
         +OGCo2C4aIKy1OcSKnV+gfp1uxvAf1uw4+aQTOA2aUSZpGJ52SpmSM9wJ/7fj4yqnGpx
         4e0nwGqUmtLXhe8BxYURDdfilX3CrqAirl827dkGpZEH1dGduIuj5Tsy9bisqlkxIzmv
         NCrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MZxsyTjg1k59xNuVyc67xhe+ytLlXEZ0W0mBpEpHGUw=;
        b=SF9MsQGFfoJzVtvLFrcb8hC9hbu/nG1PkwQ2torgHDlx6vNLnv2gpDAxDBjwZtHvua
         rJslbTDp0I3+6EKQviwbX3/hcYaCgIRfhRu5gknx2rjas4lmuCrnaIiaOe2Gm+5baWSy
         e/IbDz+CiDjxpr4bUAp69TFKmbRxm5unktOTwHO/omVrMllzR3JBTD5nI2yJ6ndu205X
         pLNplJbiU2cJ+xhcrBbZWwTy2YMP7W0L5KmY4tBy6eGeathldhQ3eyOuJTdyL623rVVl
         ATnFY0WUsA6FAofYURizEV1d1LhlkI9htsB1jalbN5JyZ7BpQmszT+jhI28jfy+85lDN
         t+Pw==
X-Gm-Message-State: APjAAAWfL2bu8abxIEUmBBojVcsrEkRXjSAxPzjxocgkzQTaxcj1nA5x
        amTCvImos68F+FKzkc6lY6w=
X-Google-Smtp-Source: APXvYqzR8EDZnJS52Tihq1taEs+icxXKcWOuwS7KjK7XEgYkARPKjQb+19HYbG3ULdqtvs4E9uN0Jg==
X-Received: by 2002:a6b:f00c:: with SMTP id w12mr5281709ioc.280.1560872506124;
        Tue, 18 Jun 2019 08:41:46 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:fd97:2a7b:2975:7041? ([2601:282:800:fd80:fd97:2a7b:2975:7041])
        by smtp.googlemail.com with ESMTPSA id b14sm17787755iod.33.2019.06.18.08.41.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 08:41:45 -0700 (PDT)
Subject: Re: [iproute2 net-next PATCH] ip: add a new parameter -Numeric
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
References: <20190612092115.30043-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8f9263b0-0a90-2746-0b4d-05669868c221@gmail.com>
Date:   Tue, 18 Jun 2019 09:41:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190612092115.30043-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/19 3:21 AM, Hangbin Liu wrote:
> Add a new parameter '-Numeric' to show the number of protocol, scope,
> dsfield, etc directly instead of converting it to human readable name.
> Do the same on tc and ss.
> 
> This patch is based on David Ahern's previous patch.
> 
> Suggested-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/utils.h  |  1 +
>  ip/ip.c          |  6 +++++-
>  ip/rtm_map.c     |  6 ++++++
>  lib/inet_proto.c |  2 +-
>  lib/ll_proto.c   |  2 +-
>  lib/ll_types.c   |  3 ++-
>  lib/rt_names.c   | 18 ++++++++++--------
>  man/man8/ip.8    |  6 ++++++
>  man/man8/tc.8    |  6 ++++++
>  misc/ss.c        | 15 ++++++---------
>  tc/tc.c          |  5 ++++-
>  11 files changed, 48 insertions(+), 22 deletions(-)
> 

applied to iproute2-next.Thanks

