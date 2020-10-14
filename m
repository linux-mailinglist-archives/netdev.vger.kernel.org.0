Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2C428E1DA
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 16:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388832AbgJNOEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 10:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbgJNOEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 10:04:04 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45F022072D;
        Wed, 14 Oct 2020 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602684243;
        bh=heP+SDNFV0lDWgTbjCwam9BghiQiUU/MWiB+oQoekcs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xmTnyTHRF35IJL6H0DAj3zdOZuyRJuwMvSF63rcbq1EXGy/etny5iWdtXUcZCGejr
         uPkvAz8OXPBfzauto7XArjuiEgOEYgRnhdpW/UMJQIbTzrWYJYFdcdCpSKvBVrhfbg
         4z5Hvbhb918Jr7eASeakCR4lOZJF/gUS9gx8IEHk=
Date:   Wed, 14 Oct 2020 10:04:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.8 18/24] net: usb: rtl8150: set random MAC
 address when set_ethernet_addr() fails
Message-ID: <20201014140401.GR2415204@sasha-vm>
References: <20201012190239.3279198-1-sashal@kernel.org>
 <20201012190239.3279198-18-sashal@kernel.org>
 <c93d120c850c5fecadaea845517f0fdbfd9a61c7.camel@perches.com>
 <20201012210105.GA26582@nucleusys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201012210105.GA26582@nucleusys.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 12:01:06AM +0300, Petko Manolov wrote:
>On 20-10-12 12:11:18, Joe Perches wrote:
>> On Mon, 2020-10-12 at 15:02 -0400, Sasha Levin wrote:
>> > From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>> >
>> > [ Upstream commit f45a4248ea4cc13ed50618ff066849f9587226b2 ]
>> >
>> > When get_registers() fails in set_ethernet_addr(),the uninitialized
>> > value of node_id gets copied over as the address.
>> > So, check the return value of get_registers().
>> >
>> > If get_registers() executed successfully (i.e., it returns
>> > sizeof(node_id)), copy over the MAC address using ether_addr_copy()
>> > (instead of using memcpy()).
>> >
>> > Else, if get_registers() failed instead, a randomly generated MAC
>> > address is set as the MAC address instead.
>>
>> This autosel is premature.
>>
>> This patch always sets a random MAC.
>> See the follow on patch: https://lkml.org/lkml/2020/10/11/131
>> To my knowledge, this follow-ob has yet to be applied:
>
>ACK, the follow-on patch has got the correct semantics.

I'll hold off on this patch until the follow-on is merged, thanks!

-- 
Thanks,
Sasha
