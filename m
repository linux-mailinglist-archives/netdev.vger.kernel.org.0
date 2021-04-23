Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A8F3695BC
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 17:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242874AbhDWPLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 11:11:36 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:39976 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhDWPLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 11:11:35 -0400
Received: from [IPv6:2003:e9:d72f:be76:f08b:2b88:fdb6:ca12] (p200300e9d72fbe76f08b2b88fdb6ca12.dip0.t-ipconnect.de [IPv6:2003:e9:d72f:be76:f08b:2b88:fdb6:ca12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 84EA0C0415;
        Fri, 23 Apr 2021 17:10:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1619190656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S070Ld9KTNP9Xn/umxdObbbmHMdP10amp3GIXAglQPY=;
        b=escJAnycWIB6D+onsvioWPlxgDL6D/PcZ81gBgHd161eL70NPBnQvi11G7NZ3nmvYLONPu
        xs+6+pdasmQbh2NtBLrG96VbSFf50H1oC2QwHiFgDPDYxJtGFkP78tYt6O6GNjV6jKC308
        GEjK2GeN5PS7YNtM+I1bAz5XcgOB3y55iQASXxmKJMj036pcHcYvMJg+cuRn3rpGRZpQYJ
        sl0qtxUrzfKq0z8LiUBR1l6wT20ZIo8lpJX17zkm/x7Q4PL8a7qNp5n+RcObeqE1ZDshHw
        34pMSBQaXNhcdaElxQNqhAYuO4KFqmgO3VHj6oUpMPx9Pi5w0yxi/h43FjCigg==
Subject: Re: [PATCH 1/2] net: ieee802154: fix null deref in parse dev addr
To:     Alexander Aring <alex.aring@gmail.com>,
        Dan Robertson <dan@dlrobertson.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <20210423040214.15438-1-dan@dlrobertson.com>
 <20210423040214.15438-2-dan@dlrobertson.com>
 <CAB_54W4T_ZpK2GGvSwwXF0rzXg8eZLWNS6wru0sHq2kL1x4E1A@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <9d7af572-bf93-447d-e239-ba1015096aab@datenfreihafen.org>
Date:   Fri, 23 Apr 2021 17:10:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAB_54W4T_ZpK2GGvSwwXF0rzXg8eZLWNS6wru0sHq2kL1x4E1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 23.04.21 15:25, Alexander Aring wrote:
> Hi,
> 
> On Fri, 23 Apr 2021 at 00:02, Dan Robertson <dan@dlrobertson.com> wrote:
>>
>> Fix a logic error that could result in a null deref if the user sets
>> the mode incorrectly for the given addr type.
>>
>> Signed-off-by: Dan Robertson <dan@dlrobertson.com>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>
> 
> Thanks.
> 
> - Alex
> 


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
