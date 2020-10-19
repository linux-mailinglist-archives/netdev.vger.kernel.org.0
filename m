Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1419292ADF
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgJSPvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbgJSPvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 11:51:31 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0328C22283;
        Mon, 19 Oct 2020 15:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603122690;
        bh=8B7YwTxm/lobGEcA2BNanE+yqf0j0qg+SYaqGvJ6nCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pRrRy0BALNrJMfcFLuTM3bEHLINC3lZklijOH8/rMZF0RtLaXC3Kh1Bi7LL2AgYbM
         aP1JA49mvcccAEoSJUMRHfq3WS7oLiz9yZ+gsQ+XZHf5uktyzrA+xMD5IOV5LuQr4y
         ZIOD8IFx3/kx/SJPb9dmXJLUJG3nkgbrhx1eyf0s=
Date:   Mon, 19 Oct 2020 11:51:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.9 035/111] ipv6/icmp: l3mdev: Perform icmp
 error route lookup on source device routing table (v2)
Message-ID: <20201019155128.GD4060117@sasha-vm>
References: <20201018191807.4052726-1-sashal@kernel.org>
 <20201018191807.4052726-35-sashal@kernel.org>
 <20201018124004.5f8c50a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <842ae8c4-44ef-2005-18d5-80e00c140107@gmail.com>
 <1388027317.27186.1603113573797.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1388027317.27186.1603113573797.JavaMail.zimbra@efficios.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 09:19:33AM -0400, Mathieu Desnoyers wrote:
>----- On Oct 18, 2020, at 9:40 PM, David Ahern dsahern@gmail.com wrote:
>
>> On 10/18/20 1:40 PM, Jakub Kicinski wrote:
>>> This one got applied a few days ago, and the urgency is low so it may be
>>> worth letting it see at least one -rc release ;)
>>
>> agreed
>
>Likewise, I agree there is no need to hurry. Letting those patches live through
>a few -rc releases before picking them into stable is a wise course of action.

That's fair, and I've moved this patch into a different queue to make it
go out later.

-- 
Thanks,
Sasha
