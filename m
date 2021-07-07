Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE9D3BE68B
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 12:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhGGKsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 06:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231474AbhGGKsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 06:48:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1EEC61C73;
        Wed,  7 Jul 2021 10:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625654774;
        bh=KdVRnitHyB86oNcQyTTnLF0QMsDGQxcMy5DFv3SFvEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRsfd4KoSV4+ZIUPZ0L9MjLFhVp4g+h5d1l1gYlFRpFxq/+KxUd5SirljP0G0VwaE
         lknTnGqmBea5Dqtg90lUyR2rH9C7jZV54OGjqQoeOQzhqrF8g6EOzau7xd4Pajepha
         e2pbnjO0cMDltDnP6+gBm79WSUZTndzZGZsYHZ3RSYWqKr4qbTB9khmZlJDGwGiWiJ
         92rrzKrBwh15kVtOXz0AqzGjTyzD8Jzn9qvH3294jqZ4RUEo6vftcS0Uk85j9KjjgF
         HHXMUpUAFvlQNzCgmpZo1P6MIGoOwUlxu3Bmlr1RxHZNq2FgR5pnA/CrIKnpRGNAkY
         tc6pjQ1qLbQzg==
Date:   Wed, 7 Jul 2021 06:46:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 152/189] iwlwifi: mvm: support LONG_GROUP
 for WOWLAN_GET_STATUSES version
Message-ID: <YOWF9WOUegrto00D@sashalap>
References: <20210706111409.2058071-1-sashal@kernel.org>
 <20210706111409.2058071-152-sashal@kernel.org>
 <d1ee65748d6ee788c1f882b2f73dddaf7eb191e6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d1ee65748d6ee788c1f882b2f73dddaf7eb191e6.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 04:09:10PM +0200, Johannes Berg wrote:
>On Tue, 2021-07-06 at 07:13 -0400, Sasha Levin wrote:
>> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>
>> [ Upstream commit d65ab7c0e0b92056754185d3f6925d7318730e94 ]
>>
>> It's been a while that the firmware uses LONG_GROUP by default
>> and not LEGACY_GROUP.
>> Until now the firmware wrongly advertise the WOWLAN_GET_STATUS
>> command's version with LEGACY_GROUP, but it is now being fixed.
>
>"Being fixed" here is the key - this will affect only firmware versions
>that the older drivers in stable won't load. No need to backport this.

I'll drop it, thanks!

-- 
Thanks,
Sasha
