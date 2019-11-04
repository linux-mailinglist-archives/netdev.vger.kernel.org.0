Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A320EE5A2
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 18:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfKDRNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 12:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfKDRNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 12:13:47 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD3122080F;
        Mon,  4 Nov 2019 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572887627;
        bh=WZNAQxEx/8ncYLq8yBvU9TqOCozNK1btDUNO+7bTgvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uEs23NJqt6a+gr0ynnpSD5TMAdK8IYRxj+ee2KGOz52TH3IYHCzHVDgK3a+yBfPDV
         FWMjiRwkN6qNQavQVpiYpe2IskHiBvGStwlXbaAV/qE+ETtWJ/US3wE9xtxz03aAMV
         m7gNp+CIBCXApq8j2jjtd5K21rewN6ENsvWQri5s=
Date:   Mon, 4 Nov 2019 12:13:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: stable-rc 4.14 : net/ipv6/addrconf.c:6593:22: error:
 'blackhole_netdev' undeclared
Message-ID: <20191104171345.GG4787@sasha-vm>
References: <CA+G9fYsnRVisD=ZvuoM2FViRkXDcm_n0hZ1cceUSM=XtqJRHgQ@mail.gmail.com>
 <20191104133258.GA2130866@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191104133258.GA2130866@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 02:32:58PM +0100, Greg Kroah-Hartman wrote:
>On Mon, Nov 04, 2019 at 06:44:39PM +0530, Naresh Kamboju wrote:
>> stable-rc 4.14 for architectures arm64, arm, x86_64 and i386 builds
>> failed due to below error,
>>
>> net/ipv6/addrconf.c: In function 'addrconf_init':
>> net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared
>> (first use in this function); did you mean 'alloc_netdev'?
>>   bdev = ipv6_add_dev(blackhole_netdev);
>>                       ^~~~~~~~~~~~~~~~
>>                       alloc_netdev
>> net/ipv6/addrconf.c:6593:22: note: each undeclared identifier is
>> reported only once for each function it appears in
>> net/ipv6/addrconf.c: In function 'addrconf_cleanup':
>> net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared
>> (first use in this function); did you mean 'alloc_netdev'?
>>   addrconf_ifdown(blackhole_netdev, 2);
>>                   ^~~~~~~~~~~~~~~~
>>                   alloc_netdev
>>
>> Build link,
>> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.14/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/632/consoleText
>>
>
>Ick, my fault, will go fix this, sorry about that.

I've dropped this patch from 5.3 too, it was reverted upstream.

-- 
Thanks,
Sasha
