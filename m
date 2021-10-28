Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916B043DDA2
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhJ1JWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbhJ1JWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 05:22:19 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A77C061745
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 02:19:52 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id v10so3610889pjr.3
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 02:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vTh3Tsj61CsJgDrJuPiulrlSk2PvJX/t6q74BaXK/Eo=;
        b=MouF0NSa7YiJ1+BydmuQaGvxlReN9Fv9L5/wCci4UbgnLixQM1eUupWOrAH+xaeKvG
         fAmvX/X4vaZPzbVMEIkY5EsbEhax/ZkwZJRsxukNrH/AjS6KfD2EzBrQnQ54mgE98nzI
         vfHBpZs5asuKjoL/4gRNNCsxGGHDt8lrkc7qwn/ROszAJKYcX+605RncnyBZLjtHxbzu
         tnw4zO5PtLrVsrPmqV8+4Xc8K8byIBI09R3sSu7H4ua8BFT6Vdpte5lVWWdaRxiNrA9/
         92ZHpobwNzT/qpIcXysK32N8bkR03iu4aaGYUkYi0ChmHsT2fEMwMEcD6T7KxqqFCjCz
         6Nag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vTh3Tsj61CsJgDrJuPiulrlSk2PvJX/t6q74BaXK/Eo=;
        b=asNXTXUsXWpNhOPh0WmCPjOtyXEB5SAbicOD/Z7iCV/InNXaNbewu8isGp2QOdrn0N
         eWV3xWbr1mZ88jdtFGOdbAQUumPjcWgidVKonVrCsLgzAQvf+ZnQCgmrrTz7cVny+omH
         /1dsTZlq2mWco7vvpxhfImW2QaA2TV26NzEwyds2ymLDhKo3ZpkxSG0wV5U2FJIJfRZa
         eMIQS+B//Y4mvAselgPeTP++8sFPkGLKtVGyGsTrA/GcotFMu+oKsQfxOcNhyq9EIYdN
         fTUF/l478vfh6PflcPPQUuhEZQNdgPSLfkb9WGuEHByX/2EglMlrBpH9A2Iz50SVM6X7
         NISw==
X-Gm-Message-State: AOAM532MaEdnleKfWTsAKGSy9zvm4Y+nDo+Y7aZD7CEMbw+7uxVKXZdN
        PE9DryntCwW4OjFIddkstJbPosi0PP0=
X-Google-Smtp-Source: ABdhPJxwivsYdwza4Q9wNa/m7kXMV5omA1OSjzTdV3XojhhCzPq3iE5HhN4J/54HAwZfCzF7P6X7Jg==
X-Received: by 2002:a17:90b:3b85:: with SMTP id pc5mr3259272pjb.74.1635412792057;
        Thu, 28 Oct 2021 02:19:52 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m16sm2941117pfk.187.2021.10.28.02.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 02:19:51 -0700 (PDT)
Date:   Thu, 28 Oct 2021 17:19:46 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Li RongQing <lirongqing@baidu.com>,
        Kevin Cernekee <cernekee@chromium.org>,
        Taehee Yoo <ap420073@gmail.com>
Subject: Re: [IGMP discuss] Should we let the membership report contains 1 or
 multi-group records?
Message-ID: <YXprMlpiyziQ8r/g@Laptop-X1>
References: <YXEoekVoLZK7ttUd@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXEoekVoLZK7ttUd@Laptop-X1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello All,

Any comments?

Thanks
Hangbin

On Thu, Oct 21, 2021 at 04:44:42PM +0800, Hangbin Liu wrote:
> Hi IGMP experts,
> 
> One of our customers reported that when replying to a general query, the
> membership report contains multi group records. But they think each
> report should only contain 1 group record, based on
> 
> RFC 3376, 5.2. Action on Reception of a Query:
> 
>    1. If the expired timer is the interface timer (i.e., it is a pending
>       response to a General Query), then one Current-State Record is
>       sent for each multicast address for which the specified interface
>       has reception state, as described in section 3.2.  The Current-
>       State Record carries the multicast address and its associated
>       filter mode (MODE_IS_INCLUDE or MODE_IS_EXCLUDE) and source list.
>       Multiple Current-State Records are packed into individual Report
>       messages, to the extent possible.
> 
>       This naive algorithm may result in bursts of packets when a system
>       is a member of a large number of groups.  Instead of using a
>       single interface timer, implementations are recommended to spread
>       transmission of such Report messages over the interval (0, [Max
>       Resp Time]).  Note that any such implementation MUST avoid the
>       "ack-implosion" problem, i.e., MUST NOT send a Report immediately
>       on reception of a General Query.
> 
> So they think each group state record should be sent separately.
> I pointed that in the RFC, it also said
> 
> A.2  Host Suppression
> 
> ...
> 
>    4. In IGMPv3, a single membership report now bundles multiple
>       multicast group records to decrease the number of packets sent.
>       In comparison, the previous versions of IGMP required that each
>       multicast group be reported in a separate message.
> 
> So this looks like two conflicting goals.
> 
> After talking, what customer concerned about is that if there are a thousand groups,
> each has like 50 source addresses. The final reports will be a burst of
> 40 messages, with each has 25 source addresses. The router needs to handle these
> records in a few microseconds, which will take a very high resource for router
> to process.
> 
> If each report only has 1 group record. The 1000 reports could be sent
> separately in max response time, say 10s, with each report in 10ms. This will
> make router much easier to handle the groups' records.
> 
> So what do you think? Do you think if there is a need to implement a way/option
> to make group records send separately? Do anyone know if it's a press to let
> router handle a thousand groups with each having 25 sources address in a few
> microseconds?
> 
> Thanks
> Hangbin
