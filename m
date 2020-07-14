Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4944021EB15
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 10:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgGNINm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 04:13:42 -0400
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:33747
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725816AbgGNINl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 04:13:41 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2020 04:13:41 EDT
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 373D420D83;
        Tue, 14 Jul 2020 08:07:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 14 Jul 2020 10:07:10 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux X25 <linux-x25@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wan/x25_asy: Fix to make it work
Organization: TDT AG
In-Reply-To: <CAJht_EOqgWh0dShG258C3uoYdQga+EUae34tvL9HhqpztAv1PQ@mail.gmail.com>
References: <20200708043754.46554-1-xie.he.0141@gmail.com>
 <20200708.101321.1049330296069021543.davem@davemloft.net>
 <CAJht_EOqgWh0dShG258C3uoYdQga+EUae34tvL9HhqpztAv1PQ@mail.gmail.com>
Message-ID: <490146353e9225245d8165b6edade1a9@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-08 21:04, Xie He wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, Jul 8, 2020 at 10:13 AM -0700
>> Something's not right, because I find it hard to believe this has been
>> so fundamentally broken for such a long period of time.
>> 
>> Maybe the drivers all handle things differently, and whilst your 
>> change
>> might fix some drivers, it will break others.
>> 
>> I'm not applying this until this situation is better understood.
> 
> Yes, it was hard for me to believe, too.
> 
> At first when I tried this driver, it was silently not able to 
> establish
> LAPB connections, I found that it was because it was ignoring
> 2-byte frames. I changed it to make 2-byte frames pass. Then I
> encountered kernel panic. I don't know how to solve it, so I looked
> at the way "lapbether" does things and changed this driver according
> to the "lapbether" driver. And it worked.
> 
> The "lapbether" driver and this driver both use the "lapb" module to
> implement the LAPB protocol, so they should implement LAPB-related
> code in the same way.
> 
> This patch only changes this driver and does not affect other drivers.
> 
> I don't know how I can better explain this situation. Please tell me
> anything I can do to help. Thanks!

It really seems very strange that this driver seems to contain such
fundamental errors. I have never used it.

But the explanations and fixes look plausible to me.
