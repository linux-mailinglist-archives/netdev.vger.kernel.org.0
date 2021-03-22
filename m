Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83F7345390
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhCWAEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:04:09 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:42522 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhCWADd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:03:33 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2021 20:03:33 EDT
Received: from [192.168.254.6] (unknown [50.34.172.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 8796B13C2B0;
        Mon, 22 Mar 2021 16:58:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 8796B13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1616457487;
        bh=F2kPVH+YIfx7glKDCME0BM3ell9Hw27xQXR6vGdxgdY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fOOBW2PSG4xEkmwBzm4IzgVLucWvw5nQhuliy60WR4uzgwp46Ej5sJenIgPKdJFoI
         nqcjvzVwnFr167lW3hlRvHMC8K9unVjPKCHFngHMF7b2SRcJptMBn+knKl6evs/5cb
         /z8wCxp6sjXfWdZ9a62yd8DMR3C1yPt8lmJItto0=
Subject: Re: [RFC 2/7] ath10k: Add support to process rx packet in thread
To:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dianders@chromium.org, evgreen@chromium.org
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <1595351666-28193-3-git-send-email-pillair@codeaurora.org>
 <13573549c277b34d4c87c471ff1a7060@codeaurora.org>
 <d79ae05e-e75a-de2f-f2e3-bc73637e1501@nbd.name>
 <04d7301d5ad7555a0377c7df530ad8522fc00f77.camel@sipsolutions.net>
 <1f2726ff-8ba9-5278-0ec6-b80be475ea98@nbd.name>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <06a4f84b-a0d4-3f90-40bb-f02f365460ec@candelatech.com>
Date:   Mon, 22 Mar 2021 16:57:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1f2726ff-8ba9-5278-0ec6-b80be475ea98@nbd.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/20 6:00 AM, Felix Fietkau wrote:
> On 2020-07-22 14:55, Johannes Berg wrote:
>> On Wed, 2020-07-22 at 14:27 +0200, Felix Fietkau wrote:
>>
>>> I'm considering testing a different approach (with mt76 initially):
>>> - Add a mac80211 rx function that puts processed skbs into a list
>>> instead of handing them to the network stack directly.
>>
>> Would this be *after* all the mac80211 processing, i.e. in place of the
>> rx-up-to-stack?
> Yes, it would run all the rx handlers normally and then put the
> resulting skbs into a list instead of calling netif_receive_skb or
> napi_gro_frags.

Whatever came of this?  I realized I'm running Felix's patch since his mt76
driver needs it.  Any chance it will go upstream?

Thanks,
Ben

> 
> - Felix
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
