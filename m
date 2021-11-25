Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B8C45DA31
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 13:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354877AbhKYMk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 07:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353292AbhKYMi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 07:38:57 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EB0C061574;
        Thu, 25 Nov 2021 04:34:34 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id l190so5118046pge.7;
        Thu, 25 Nov 2021 04:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0eAV0QCSYY59EfhYYGwBRd+u8b18m2Ztdaw86lrALGo=;
        b=LbIS6sfQbR7fqoUkZOLPzKEM4vW/6AVOeUj6EtJCuvOGCkevZx04B0ZK5wHKeN5+EO
         jNQ2xJsCyzfwE6iYGIeypC9+6edPYMpDvF1ty1u13S8lgV1HAmPRLWt62UTJyEMr2TPt
         dRwMyHNQwkT6FiEADnEd3k2q13CS7l4MLg+17ZaoargK+4QB8DBvtBHR2j3th/INXGrC
         zhuiWiRkFb6NgeaKCrHfleTOk4LEQuI1jFO4gdU5K3J38H3BM3xZVlQw2AuaDtL9dbjY
         8bqWDCG0AkUDXu2UMsee5uKh1XwQuHZgFlXA5qgBofn7aNe4oHiglbVAzW5mqJSSxT69
         Xq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0eAV0QCSYY59EfhYYGwBRd+u8b18m2Ztdaw86lrALGo=;
        b=WspoN9kmzOntqEPUsKkmQa5ImrytQYLVqR3FZIdhEcPCFfst6Ce1gLU+6IguZ9YT45
         GqtuECXzNFCR0YtGYQ7lvEReelGZMzLFdVMsXG4aEHHeDwtST+AjPW+eSz4nJeQnjH3i
         Xl2IEwqciPS43CMzThcmh0oza+Z/IYa68Wk70ycV3fHjYG20xlr8cy/WkmO/Ukkhm/7a
         jgLkdxEQMfiMd42rsREpQcizL54GqvOX1Qf9TISj6lhUdqw7iC4pZXhKgU1h7vozbaYM
         GunnPi6D5y7EtOCMmjKOsjotkXGrHgW0/PTjdmfTUe1FauIrPVkjyRppDhP4TD7Au3Nd
         tNPQ==
X-Gm-Message-State: AOAM530V9LqzRipSFxWssXCNs53txkLVALf6Uhjk4hJX0ezM3B6gvCXf
        iwcuQI1BbAHoM4GZDhlRwTxs1ZISHH0=
X-Google-Smtp-Source: ABdhPJwJjoRLjGJFIoyzqBMwPXueRu0hLtMHlkWRVw7D9yc9QIuLxqm8pMij0y6F3VMyns6g1SUmQQ==
X-Received: by 2002:a05:6a00:8c6:b0:4a2:d762:8b42 with SMTP id s6-20020a056a0008c600b004a2d7628b42mr13732350pfu.28.1637843674170;
        Thu, 25 Nov 2021 04:34:34 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h13sm2373135pgg.16.2021.11.25.04.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 04:34:33 -0800 (PST)
Date:   Thu, 25 Nov 2021 20:34:28 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH wireguard] wireguard: selftests: refactor the test
 structure
Message-ID: <YZ+C1MWdWQvd66ic@Laptop-X1>
References: <20211116081359.975655-1-liuhangbin@gmail.com>
 <CAHmME9pNFe7grqhW7=YQgRq10g4K5bqVuJrq0HonEVNbQSRuYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pNFe7grqhW7=YQgRq10g4K5bqVuJrq0HonEVNbQSRuYg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 03:35:40PM +0100, Jason A. Donenfeld wrote:
> Hi Hangbin,
> 
> I don't know how interested in this I am. Splitting things into two
> files means more confusing maintenance, and categorizing sections
> strictly into functions means there's more overhead when adding tests
> (e.g. "where do they fit?"), because the categories you've chosen are
> fairly broad, rather than being functions for each specific test. I'd
> be more amenable to something _entirely_ granular, because that'd be
> consistent, or what we have now, which is just linear. Full
> granularity, though, has its own downsides, of increased clutter.
> Alternatively, if you'd like to add some comments around the different
> areas to better document what's happening, perhaps that'd accomplish
> the same thing as this patch.
> 

Hi Jason,

May be my timezone is not very fit for yours. So I will copy my IRC replies
in the mail to moving on our kselftest topic.

The reason I did this patch is because I want to make the test more clear
and able to run each test case separately. My though is to make the
wireguard test looks like tools/testing/selftests/net/fib_tests.sh.(Of course
this could be discussed).

Because the linear structure makes reader hard to find out what test it does.
The function name in my current patch is also a little broad to look, which
could to be updated. After updating, I'd like to make the test has 2 parts,
functional tests and regression test. Functional tests for big part of function
tests and regression test for small specific issues.

BTW, one downside about current linear structure I think is that when someone
want to add a new test, he need to read through the whole test to know that
kind of topology at last. But with function structure, when we want to add a
new test. We can just do like:
1. set up basic topology
2. configure to specific topo for testing, or just skip the first step and
   configure to specific topo directly.
3. Do test
4. Clean up environment or reset to basic topology

I think this would make adding new test case easier. What do you think?

Thanks
Hangbin
