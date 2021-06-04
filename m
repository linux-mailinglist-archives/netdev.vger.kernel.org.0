Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1651039AF16
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 02:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhFDAgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 20:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDAgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 20:36:01 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89411C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 17:34:16 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Fx3fr5fzwz9s1l;
        Fri,  4 Jun 2021 10:34:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1622766853;
        bh=DlYD7/ikT8YNbVnd2jRpmnUISzjs7MCffewKt+dV8Zk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=MTBAZvCihWnDtnLJ4HtIxdEG+CsBNWqSCDh/aKFo7J0FQp3ZvmnIfHmaTW0SH6dH6
         TGrEG3/TTlNCiXMXrv6D0sCmHdmIvrPJfUfTgz9D9FkATH8vzrovgkESaE58lSH3IN
         dzxbq9TLirzG8TbrbZCrAQS8QCXgUrCaw6PxYQwkZEiI+QikDUZ9grqCA9pOwcMb+d
         2aKKsgO608zGTeIdGEFzbrZJXz4QwaREAr7pf4wCncmFchOzU6SBzQhvV4nUpWmzds
         xRK3CRgxmaVj2wmh0TMu/S8nkcHXNik6PCFsv0/4WjoYMPalRswmWl/0T8lVxrBToa
         7rAvfzwAd8UCA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] DMA fixes for PS3 device drivers
In-Reply-To: <850d4850-d45a-e22f-d4bb-18bd68a35031@infradead.org>
References: <cover.1622577339.git.geoff@infradead.org>
 <875yyvh5iy.fsf@mpe.ellerman.id.au>
 <850d4850-d45a-e22f-d4bb-18bd68a35031@infradead.org>
Date:   Fri, 04 Jun 2021 10:34:10 +1000
Message-ID: <8735tyh3i5.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geoff Levand <geoff@infradead.org> writes:
> Hi Michael,
>
> On 6/2/21 10:38 PM, Michael Ellerman wrote:
>> Geoff Levand <geoff@infradead.org> writes:
>>> Hi,
>>>
>>> This is a set of patches that fix various DMA related problems in the PS3
>>> device drivers, and add better error checking and improved message logging.
>>>
>>> The gelic network driver had a number of problems and most of the changes are
>>> in it's sources.
>>>
>>> Please consider.
>> 
>> Who are you thinking would merge this?
>> 
>> It's sort of splattered all over the place, but is mostly networking by
>> lines changed.
>> 
>> Maybe patches 3-5 should go via networking and I take 1-2?
>
> As suggested, I split the V1 series into two separate series, one for
> powerpc, and one for network.  

Thanks.

> I thought it made more sense for patch 3, 'powerpc/ps3: Add dma_mask
> to ps3_dma_region' to go with the powerpc series, so put it into that
> series.

Oh I thought patches 4 and 5 had a dependency on it, but if not yeah
makes sense for patch 3 to go via the powerpc tree.

cheers
