Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF3621504E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgGEXJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbgGEXJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 19:09:40 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F4DC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 16:09:40 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id b4so33267025qkn.11
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 16:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RduFAaZw4oTkL/AqqpFj5OVNGIHvXnPfdnomz+lCFL0=;
        b=pfQKfX6S030aTZTHOiGVtlfskNat7WhalFoUI7eh+K5Z0hxfF9+GndJxDedMzvPGHC
         IFx0B22n8sI3NzNrVM1fVH4pbDmiNEuHWXV4aRkL7Cd9d0VApLfKdW1+V4JKfyYFjYwr
         EVf03LgKLRd5BTBBkecg6diikrZcj6jdG7bBP0ZWWX8QZhNjzgOP6cL/G/uKo9OdmanU
         1/lwS/gcT0n3QTiqeWipC/gX3KXzNR1IMgC5jsqSrthvvX7Qqt5mstWKZagCDlb44Ixh
         Y5wOQK3YBeE6I0e5wqtSmXx+eRQy6Sz+mSk3uiyjg2IdmuzVbyOl7gBF+wEsKZUo/kyC
         TBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RduFAaZw4oTkL/AqqpFj5OVNGIHvXnPfdnomz+lCFL0=;
        b=mT10Gr3TD7a2GaBu1UIcSotYwnMsz0tcYxxkgrfE7mxAuqH1fqvYpDjSafDwnUxBTb
         VCurgXnJYG1+aRmgm7WXd/5uWuBU3In3oxRKIr8dwLlp4Dh0xEcXxa1yMTX0CoZJqDbX
         W3wk4a8/HwZm4IFugSO4pjb3Qzm4faOKbP3Bp0mFHygS74Qy+l6mIdUQyLm2qZRV95Sr
         gSGUpfaoAXqNftKo0JMwd8y8igtRO4mW8T9KecByac7wTONQ3M+l96rg72xvoXYef598
         PLI9Llb/NBmGtKwgPramVE5FbZ65ykqThUlaIYNs+y4a81gJJBSDbHmtzaXGItN7RWDD
         3i4A==
X-Gm-Message-State: AOAM5324YuqXAWLWeFo0hPcgvZ1JBtHGNlwNLWQBENKjJCuCMne8mEon
        iu9zCAGU7PVV/15zmcvSJQh38InJ
X-Google-Smtp-Source: ABdhPJw2Qgl0ciUuWLrWDDe3IhINZlLM6b8j5ZvWBKY7jC4Hz0mBJQ2KrvvNd/JGNamaipw42/WaFw==
X-Received: by 2002:a05:620a:946:: with SMTP id w6mr43971924qkw.75.1593990579606;
        Sun, 05 Jul 2020 16:09:39 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f517:b957:b896:7107? ([2601:282:803:7700:f517:b957:b896:7107])
        by smtp.googlemail.com with ESMTPSA id p63sm17799806qkc.80.2020.07.05.16.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 16:09:39 -0700 (PDT)
Subject: Re: Crash/hang in 5.4.47 with nexthop objects
To:     Brian Rak <brak@choopa.com>, netdev@vger.kernel.org
References: <d46e6ccb-6b00-7c18-21aa-2c36416ab1ea@choopa.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b3c0ed6a-6a35-c18e-6321-1c56f126e13a@gmail.com>
Date:   Sun, 5 Jul 2020 17:09:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d46e6ccb-6b00-7c18-21aa-2c36416ab1ea@choopa.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ sorry for the delay; was on PTO for a couple weeks ]

On 6/24/20 10:32 AM, Brian Rak wrote:
> Hi,
> 
> We're hitting an issue where the kernel with either hang indefinitely or
> immediately crash when IPv6 nexthops are used along with the `rpfilter`
> ip6tables module.  The following commands trigger this issue 100% of the
> time for us:
> 
> ip -6 route del default; ip -6 route del default; # repeat as necessary
> to remove all existing default routes
> ip6tables -t mangle -I PREROUTING 1 -m rpfilter --invert -j DROP
> ip nexthop add id 999 via 2001:19f0:1000:8080::1 dev eno1
> ip -6 route add default nhid 999

Thanks for the steps to reproduce; very helpful.

I think I found the problem; do you build your kernels to test a patch?

