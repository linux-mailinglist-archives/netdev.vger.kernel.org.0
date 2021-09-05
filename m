Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E71400FB8
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 14:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237988AbhIEMzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 08:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231370AbhIEMzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 08:55:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 734C960F45;
        Sun,  5 Sep 2021 12:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630846443;
        bh=ruSh1z2qEZxoZPV6/YxEJiqcX9nKjn3W941R1BHEJP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rlE3czGFQd04BjSleaGyCPPROfHKgJEj2HwFaH9vtcyKEmouQCDGDDZ/oDhPMOWjA
         YJBKvl0gPrgimxvKs6a5lBDGZ6OVJRl/IGFz8pCTTC5Xh843NORP4xpM4HJtH7Qqdx
         gOBGe4MzU9AxjSoK3/GjotEH3cDJ1wp6JSgantNDDp66jS/SEsLNI0T56kAPCLZ1IM
         p4UlVy9mnSaS1outL7eJkQ3jIEfYcAvU9gKYGffbAGKmizX1PIgsWw8oKFOHfzhhus
         6s1BwmYqgGlwWgxWKIWroMBtD4NUPE0WqWRndOTFkBAz4L6r4W+dMVb8GhPx5T0qAJ
         RDQjFGMJsAtmQ==
Date:   Sun, 5 Sep 2021 08:54:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 13/14] net: fix NULL pointer reference in
 cipso_v4_doi_free
Message-ID: <YTS96ql9DzxpYpnl@sashalap>
References: <20210830115942.1017300-1-sashal@kernel.org>
 <20210830115942.1017300-13-sashal@kernel.org>
 <CAD-N9QUXXjEMtdDniuqcNSAtaOhKtHE=hLMchtCJgbvxQXdABQ@mail.gmail.com>
 <CAHC9VhTjFMw111-fyZsFaCSnN3b-TuQjqXcc1zVu2QTTekTohw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhTjFMw111-fyZsFaCSnN3b-TuQjqXcc1zVu2QTTekTohw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 10:20:22AM -0400, Paul Moore wrote:
>On Mon, Aug 30, 2021 at 8:42 AM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>>
>> On Mon, Aug 30, 2021 at 8:01 PM Sasha Levin <sashal@kernel.org> wrote:
>> >
>> > From: 王贇 <yun.wang@linux.alibaba.com>
>> >
>> > [ Upstream commit 733c99ee8be9a1410287cdbb943887365e83b2d6 ]
>> >
>>
>> Hi Sasha,
>>
>> Michael Wang has sent a v2 patch [1] for this bug and it is merged
>> into netdev/net-next.git. However, the v1 patch is already in the
>> upstream tree.
>>
>> How do you guys handle such a issue?
>>
>> [1] https://lkml.org/lkml/2021/8/30/229
>
>Ugh.  Michael can you please work with netdev to fix this in the
>upstream, and hopefully -stable, kernels?  My guess is you will need
>to rebase your v2 patch on top of the v1 patch (basically what exists
>in upstream) and send that back out.

I'm just going to drop this one for now (it never made it in). If there
is a follow-up you do want us to queue please let us know :)

-- 
Thanks,
Sasha
