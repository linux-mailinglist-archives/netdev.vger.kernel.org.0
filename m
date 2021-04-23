Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445A736955D
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 17:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243314AbhDWPAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 11:00:50 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:39314 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242966AbhDWPAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 11:00:06 -0400
Received: from [IPv6:2003:e9:d72f:be76:f08b:2b88:fdb6:ca12] (p200300e9d72fbe76f08b2b88fdb6ca12.dip0.t-ipconnect.de [IPv6:2003:e9:d72f:be76:f08b:2b88:fdb6:ca12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 1337CC0415;
        Fri, 23 Apr 2021 16:59:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1619189965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A5hj1CYkQHpWX8gvpmHJaJvsPr9XdPFXJhjmLkETq9c=;
        b=w2J0Jh/4LaATGXD0LquZGrz5PrZvcBKqnGb3/5eqPnI1NsPxaIVrvw1Y7P8pcMTKkpN0gw
        nYq45OkVqDZbDskVWDl3utPWeBa8CfPDZR/Wg4PW8P1JEneREbJ2tKa5ZP5KiI3YRtuq4G
        jPWZmZ3oc7QW4spZ6mgnqKiUsqQ9p91MzmDlNU2maMr6SzBeb5VyAIiLThMm7luMwiv19K
        9P9/jXe+gPB+4NYmXFJnyyayzDwtOyode7Rp25yFf2rvjAEFwA+aOHFg4raVV5GsN18DZR
        YA4ttzFgT05Fsjqi/aYSU0AV0geZWU15oe/9CQ3GsgrhMKsK6+9XWDlU3ez/5A==
Subject: Re: [PATCH 2/2] net: ieee802154: fix null deref in parse key id
To:     Dan Robertson <dan@dlrobertson.com>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <20210423040214.15438-1-dan@dlrobertson.com>
 <20210423040214.15438-3-dan@dlrobertson.com>
 <CAB_54W557gEShnirMUfa1Y0MM0ho=At-sbuW10HbY=HEAX91AQ@mail.gmail.com>
 <YILbFi7LQb40lTkP@dlrobertson.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <559dae4a-ed56-c264-e0d1-4a3ea6f5e439@datenfreihafen.org>
Date:   Fri, 23 Apr 2021 16:59:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YILbFi7LQb40lTkP@dlrobertson.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 23.04.21 16:35, Dan Robertson wrote:
> On Fri, Apr 23, 2021 at 09:28:48AM -0400, Alexander Aring wrote:
>> Hi,
>>
>> On Fri, 23 Apr 2021 at 00:03, Dan Robertson <dan@dlrobertson.com> wrote:
>>>
>>> Fix a logic error that could result in a null deref if the user does not
>>> set the PAN ID but does set the address.
>>
>> That should already be fixed by commit 6f7f657f2440 ("net: ieee802154:
>> nl-mac: fix check on panid").
> 
> Ah right. I didn't look hard enough for an existing patch :) Thanks!
> 
>   - Dan
> 

Dropped from my patchwork queue.

regards
Stefan Schmidt
