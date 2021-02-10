Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203E431640C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhBJKj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:39:27 -0500
Received: from mail.thelounge.net ([91.118.73.15]:21841 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhBJKf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:35:59 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4DbGNd6cv9zXMD;
        Wed, 10 Feb 2021 11:34:57 +0100 (CET)
Subject: Re: [PATCH net 1/4] netfilter: xt_recent: Fix attempt to update
 deleted entry
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
References: <20210205001727.2125-1-pablo@netfilter.org>
 <20210205001727.2125-2-pablo@netfilter.org>
 <69957353-7fe0-9faa-4ddd-1ac44d5386a5@thelounge.net>
 <alpine.DEB.2.23.453.2102051448220.10405@blackhole.kfki.hu>
 <a51d867a-3ca9-fd36-528a-353aa6c42f42@thelounge.net>
 <3018f068-62b1-6dae-2dde-39d1a62fbcb2@thelounge.net>
 <alpine.DEB.2.23.453.2102072036220.16338@blackhole.kfki.hu>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <303fdd83-a324-5d0c-b45e-9584ea0c9cd5@thelounge.net>
Date:   Wed, 10 Feb 2021 11:34:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.23.453.2102072036220.16338@blackhole.kfki.hu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 07.02.21 um 20:38 schrieb Jozsef Kadlecsik:
> On Sun, 7 Feb 2021, Reindl Harald wrote:
> 
>>> well, the most important thing is that the firewall-vm stops to
>>> kernel-panic
>>
>> why is that still not part of 5.10.14 given how old that issue is :-(
>>
>> https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.10.14
> 
> Probably we missed the window when patches were accepted for the new
> release. That's all

probably something is broken in the whole process given that 5.10.15 
still don't contain the fix while i am tired of a new "stable release" 
every few days and 5.10.x like every LTS release in the past few years 
has a peak of it

https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.10.15

