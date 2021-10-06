Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3814240FB
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbhJFPOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:14:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238124AbhJFPOP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 11:14:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBADF60E94;
        Wed,  6 Oct 2021 15:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633533142;
        bh=Sn6xAQq4cN/hOpF85QY+PACDZDzO2M6VmNGmM+0OmEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jWG5kdHEOgYeuqPo2BYKsVo+OpJ4s+JsQkD1phUUbjY134b1/KFtJymIqgSp5NMMU
         WaUw1Nqo0aSfhYhmxUrebcRi2sbuGOvTqWDoPA0AFJmyaZrb/aQ5DoovV8E2hY+jWF
         SE7GhR1e7fNIhUtg5RZS+Ive/oOwGYhJS5fvpCgpy/bYEZ9aOFC6U2oocu1BcTP3BZ
         kHezkOddYqOknCMjA/1Y51f1Zrp1CJBv51s52E5mU0bgIQWBTRh7C05EENfb2PGsu4
         Zx2+TkcfK05ExJGvO3CFLXp6lnUqK8nkz7Pe9oA9PW+MIRjWwZWscUD4f+Z8YpBSw0
         sHdjPRv5W6OdA==
Date:   Wed, 6 Oct 2021 11:12:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yanfei Xu <yanfei.xu@windriver.com>,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 28/40] net: mdiobus: Fix memory leak in
 __mdiobus_register
Message-ID: <YV281dk7FLrJKBab@sashalap>
References: <20211005135020.214291-1-sashal@kernel.org>
 <20211005135020.214291-28-sashal@kernel.org>
 <YVxa7w8JWOMPOQsp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YVxa7w8JWOMPOQsp@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 04:02:23PM +0200, Andrew Lunn wrote:
>On Tue, Oct 05, 2021 at 09:50:07AM -0400, Sasha Levin wrote:
>> From: Yanfei Xu <yanfei.xu@windriver.com>
>>
>> [ Upstream commit ab609f25d19858513919369ff3d9a63c02cd9e2e ]
>>
>> Once device_register() failed, we should call put_device() to
>> decrement reference count for cleanup. Or it will cause memory
>> leak.
>
>Hi Sasha
>
>https://lkml.org/lkml/2021/10/4/1427
>
>Please don't backport for any stable kernel.

Dropped, thanks!

-- 
Thanks,
Sasha
