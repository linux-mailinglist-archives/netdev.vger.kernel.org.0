Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B5B2B1588
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 06:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgKMF2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 00:28:24 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:57759 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgKMF2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 00:28:24 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kdRdB-0005rm-Ey; Fri, 13 Nov 2020 06:28:17 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kdRdA-0009tC-B2; Fri, 13 Nov 2020 06:28:16 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id B2E1024004B;
        Fri, 13 Nov 2020 06:28:15 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 1034E240049;
        Fri, 13 Nov 2020 06:28:15 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 8FDE521DF6;
        Fri, 13 Nov 2020 06:28:14 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 13 Nov 2020 06:28:14 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     John 'Warthog9' Hawley <warthog9@kernel.org>
Cc:     Xie He <xie.he.0141@gmail.com>, postmaster@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Subject: Re: linux-x25 mail list not working
Organization: TDT AG
In-Reply-To: <ed5b91db-fea9-99ff-59b7-fa0ffb810291@kernel.org>
References: <CAJht_EMXvAEtKfivV2K-mC=0=G1n2_yQAZduSt7rxRV+bFUUMQ@mail.gmail.com>
 <ed5b91db-fea9-99ff-59b7-fa0ffb810291@kernel.org>
Message-ID: <f3b2c6ea4185226ad4058ed8a70ffb52@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1605245297-000037DC-DEEE07EB/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-13 03:17, John 'Warthog9' Hawley wrote:
> Give it a try now, there was a little wonkiness with the alias setup
> for it, and I have no historical context for a 'why', but I adjusted a
> couple of things and I was able to subscribe myself.
> 
> - John 'Warthog9' Hawley

Thanks a lot John! Now it seems to work again.

- Martin

> 
> On 11/12/2020 10:27 AM, Xie He wrote:
>> Hi Linux maintainers,
>> 
>> The linux-x25 mail list doesn't seem to be working. We sent a lot of
>> emails to linux-x25 but Martin Schiller as a subscriber hasn't
>> received a single email from the mail list.
>> 
>> Looking at the mail list archive at:
>>      https://www.spinics.net/lists/linux-x25/
>> I see the last email in the archive was in 2009. It's likely that this
>> mail list has stopped working since 2009.
>> 
>> Can you please help fix this mail list. Thanks!
>> 
>> Xie He
>> 
