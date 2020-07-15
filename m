Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F291722121A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgGOQSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgGOQSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:18:45 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9374C061755;
        Wed, 15 Jul 2020 09:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Zdi+5mPzXsgsVrBdccSR0v7sN/rPNAvRapROglaxpbE=; b=RZE25lU0TR/4wgr0Ox/rYL15qx
        UVcfUm3JnqqReLtb2cAwd9R8nvIyzxUnq9plnYNsILQHuRYqv7M7zIT6igpPnEDAbrcjULF0Gu66e
        BrK+W+aJhvZBif00RlbyjtxMm5vYEGE06Y2ocpJu8fq9QWpWP6vzv0mJtRUHqn5qe6q8Te2p4QHO8
        uHH8fCUXa4FDxUHJVLt7HKJndy/5W9+//CpGRCzc7kSyFXRqzYIO189vPtNwESZDKDvXwnIoL0Ayi
        jE3gfZJieZVoezSmm4t3qXbeCBSzMvs5uDG414plSnWy0WW/6sbmPDN1TiR2dv4vEuAYRuzp26vCB
        LgA7J3iA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvk7H-0001xM-IK; Wed, 15 Jul 2020 16:18:43 +0000
Subject: Re: [PATCH 01/13 net-next] net: nl80211.h: drop duplicate words in
 comments
To:     Joe Perches <joe@perches.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        johannes@sipsolutions.net
References: <20200715025914.28091-1-rdunlap@infradead.org>
 <20200715084811.01ba7ffd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6653f2f65ec4a9cc1024b69ffe97d5dc4c7ff33a.camel@perches.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <359af6cb-a242-c003-83e1-cca6dd75336f@infradead.org>
Date:   Wed, 15 Jul 2020 09:18:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <6653f2f65ec4a9cc1024b69ffe97d5dc4c7ff33a.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 9:12 AM, Joe Perches wrote:
> On Wed, 2020-07-15 at 08:48 -0700, Jakub Kicinski wrote:
>> On Tue, 14 Jul 2020 19:59:02 -0700 Randy Dunlap wrote:
>>> Drop doubled words in several comments.
>>>
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: netdev@vger.kernel.org
>>
>> Hi Randy, the WiFi stuff goes through Johannes's mac80211 tree.
>>
>> Would you mind splitting those 5 patches out to a separate series and
>> sending to him?
> 
> Do I understand you to want separate patches
> for separate sections of individual files?
> 
> I think that's a bit much...

I plan to move wireless.h, regulatory.h, nl80211.h,
mac80211.h, and cfg80211.h patches to a wireless patch series.

wimax can stay in net?? (I hope.)


-- 
~Randy

