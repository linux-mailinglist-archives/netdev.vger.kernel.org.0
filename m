Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C7D28172
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731094AbfEWPmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:42:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42972 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730790AbfEWPmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 11:42:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id 33so371540pgv.9
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 08:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YHQm2PLrhy1oeoxk2ZBf8g8iUVCf6tkrVLdMu3kGKSY=;
        b=tTezPXVJqcXSK5uwx4Fd7devZoGeeIrLQMwCFCeuymltzTzPIYok5phBmEb6rD4JKq
         CRcMjRvlnr7B/+PdK7yHTz2udWUjZy6CIfmfCalmsgBlDryetP4U6ibgW2E6bgGN2lPB
         W8VxcoX5mROeJV8w6ynU2Jwq5x90mpYbSV/Lxk5SIF7zaQ7Rp3GfdSxhOGQtarDLss+x
         PnkCfDfv4mTIrYSrvkUv5vDw187Br6GBXYbek8W7X0dvFgkIeE0c/jkHr2Lj1ECV5o7u
         a8YVrMEFs94dsFvmJNFn6ACO7EqnFBlW1vYiUGhUgPA9F9DXGvDTkBp5tEXd2oZJrKJd
         hE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YHQm2PLrhy1oeoxk2ZBf8g8iUVCf6tkrVLdMu3kGKSY=;
        b=JfYPQ5ZR5jmmpxx5rAY0VJfB6TzrlwJlkywx+e2JYcFJylPCJLtAKp/mu0gQPUcR+l
         l2mD2OgveP9b48z2ivAh0q5YctvasH6qgKkhOByuckJQf1c4D78xWnxMo2OybdIfARuZ
         pcFeeRNs80NQf1eqnUp4pE5kqlos3nB5XW7orXtCx9q3vMuO5pzNV+AUFGbkK7avrvTx
         s282F2hqavFzM6SxrfbstqhrpgBzaerFtqmvAIc9lfN5A1HIfIMytNWrzLNEJh5Slxm6
         ZQp44W2bQHNfD0WxLopkagpOsKQbwuyyi4ovFbZDyTEkORxZXwtGxQ2HIPx6lMkaidyD
         03ZQ==
X-Gm-Message-State: APjAAAVmSJNC4V2rZqAc3jcsiAPAQyTH66lo6IApzaVD+5gLk9PXSf83
        ZnBs8OXCpjKuQZSbHnYM27lCaOkv
X-Google-Smtp-Source: APXvYqy7fQBlrbgKhBgRhGY3TS6q4s/8xvXKOM6JiKdcEKj+7j/9x86BHp6Q1vgssp5VEUTON40+oA==
X-Received: by 2002:a62:5306:: with SMTP id h6mr4364479pfb.29.1558626122365;
        Thu, 23 May 2019 08:42:02 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:6c53:cc13:22bf:e3cd? ([2601:282:800:fd80:6c53:cc13:22bf:e3cd])
        by smtp.googlemail.com with ESMTPSA id r9sm50219400pfc.173.2019.05.23.08.42.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:42:01 -0700 (PDT)
Subject: Re: [PATCH net-next] selftests: pmtu: Simplify cleanup and namespace
 names
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20190522191106.15789-1-dsahern@kernel.org>
 <20190523095817.45ca9cae@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8b642166-e0f9-cfb7-8e19-5a46f58549b6@gmail.com>
Date:   Thu, 23 May 2019 09:41:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190523095817.45ca9cae@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/19 1:58 AM, Stefano Brivio wrote:
> Hi David,
> 
> On Wed, 22 May 2019 12:11:06 -0700
> David Ahern <dsahern@kernel.org> wrote:
> 
>> From: David Ahern <dsahern@gmail.com>
>>
>> The point of the pause-on-fail argument is to leave the setup as is after
>> a test fails to allow a user to debug why it failed. Move the cleanup
>> after posting the result to the user to make it so.
>>
>> Random names for the namespaces are not user friendly when trying to
>> debug a failure. Make them simpler and more direct for the tests. Run
>> cleanup at the beginning to ensure they are cleaned up if they already
>> exist.
> 
> The reasons for picking per-instance unique names were:
> 
> - one can run multiple instances of the script in parallel. I
>   couldn't trigger any bug this way *so far*, though
> 
> - cleanup might fail because of e.g. device reference count leaks (this
>   happened quite frequently in the past), which are anyway visible in
>   kernel logs. Unique names avoid the need to reboot
> 
> Sure, it's a trade-off with usability, and I also see the value of
> having fixed names, so I'm fine with this too. I just wanted to make
> sure you considered these points.
> 
> By the way, the comment to nsname() (that I would keep, it's still
> somewhat convenient) is now inconsistent.
> 

I have been using the namespace override for a while now. I did consider
impacts to the above, but my thinking is this: exceptions are per FIB
entry (per fib6_nh with my latest patch set, but point still holds), FIB
entries are per FIB table, FIB tables are per network namespace. Running
multiple pmtu.sh sessions in parallel can not trigger an interdependent
bug because of that separation. The cleanup within a namespace teardown
(reference count leaks) should not be affected.

Now that we have good set of functional tests, we do need more complex
tests but those will still be contained within the namespace separation.
If you look at my current patch set on the list I add an icmp_redirect
test script. It actually does redirect, verify, mtu on top of redirect,
verify and then resets and inverts the order - going after an exception
entry with an update for both use cases.

For the pmtu script, perhaps the next step is something as simple as
configuring the setup and routing once and then run all of the
individual tests (or multiple of them) to generate multiple exceptions
within a single FIB table and then tests to generate multiple exceptions
with different addresses per entry.
