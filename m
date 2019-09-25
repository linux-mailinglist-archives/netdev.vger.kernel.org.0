Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4070BDFEE
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 16:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436481AbfIYOWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 10:22:13 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:41077 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfIYOWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 10:22:13 -0400
Received: by mail-io1-f41.google.com with SMTP id r26so14239825ioh.8
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 07:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s3Kls2jKt2wmh3rSKX/J2YMdQ339jxbZrxGRHXqgy9s=;
        b=orSHDFsYun/KXS1pFbFnHF+ZdMr4TYlsD1JTkQyumG9F5z5T/iJhIYUY/PwbVGPIHd
         w1xApOQo74ZbxSqaW6vCOH5Srp4OnP3JjiFgu1mtyTRqlqZZNeHw+2zctqmDrWHfKl4a
         FNXCYx31PFJ6qrGIuYakQclupaCsVcin1i56wUdd1PM8gtjslTFu3VO6b2qau1SbRT5X
         Zc0l5cj7/qKurh5qADFTDyMkIDzVH0AXF/mF/+3rJHMeWri86fWE7OAjaQq4IzRl2/Kc
         M7qVgE+cFybqr1rNjYAF8EGhtiqY6ac6kIICBWCo20p3xpWforj6G5b/6gbPSPhWqfA4
         QjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s3Kls2jKt2wmh3rSKX/J2YMdQ339jxbZrxGRHXqgy9s=;
        b=X0YNil3sYyee3bXQxzKeUIQczh9tT7BZ/T8KPkyK9tbGinCkrFZ1JFWnXxttKac1jH
         +SMCYKYCWHWvkvB1QL+5nxrrAMx5uIkk7huE0An1+i0Wl4iQGfn9HC4l2Ul9zcbpLHnH
         2SL734Npl1SKH5vp5UdGTkVWdgS4NeVZaUevP2Se/G2Gff51bbkfUOg+NzBOvKDdWnYg
         gcE/0bLfzU6mGdrVdPmrQssClbBefC8Dwm433iMf/KSKXDEjTvf0jkEKaMgcIocYd8Wt
         2FlCQmUaQ6S4amTnuuWZXJZqoJLT4W/aHi0W8K86R3OTRKovY1ZD1NHWFkB/VDh2LCKM
         ATlA==
X-Gm-Message-State: APjAAAVOFwVg5EB2f1QwG9wmzdjVHjZo1tDogrokp3XEHjnXskjEDDG/
        MfooBtERiwo4/gdNF/RUY/ekXl/s
X-Google-Smtp-Source: APXvYqy9XrYYrcfufGKBoeqLSIBtp63tVA/7FVzuP+3dG92Z1OD0Gl9HWJYTEeKAXjJN8tMQQ+LQNQ==
X-Received: by 2002:a6b:8d06:: with SMTP id p6mr1537093iod.219.1569421332295;
        Wed, 25 Sep 2019 07:22:12 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:2042:8656:d3fc:5efd])
        by smtp.googlemail.com with ESMTPSA id m67sm8117614iof.21.2019.09.25.07.22.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 07:22:11 -0700 (PDT)
Subject: Re: Fw: [Bug 204903] New: unable to create vrf interface when
 ipv6.disable=1
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <20190919104628.05d9f5ff@xps13>
 <a15f9952-e5ed-8358-e28d-6325bf4d5801@gmail.com>
 <20190925060109.GG22507@unicorn.suse.cz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <05ab2080-bf2f-c853-db2c-b7b43995e961@gmail.com>
Date:   Wed, 25 Sep 2019 08:22:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190925060109.GG22507@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/19 12:01 AM, Michal Kubecek wrote:
> Not sure if it's the only problem but vrf_fib_rule() checks
> ipv6_mod_enabled() for AF_INET6 but not for RTNL_FAMILY_IP6MR.

yes, that's the problem. sending a patch soon.
