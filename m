Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042482834A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbfEWQWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:22:01 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53942 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730752AbfEWQWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:22:01 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 35EE38005C;
        Thu, 23 May 2019 16:21:58 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 23 May
 2019 09:21:51 -0700
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
 <20190522152001.436bed61@cakuba.netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <267b6dc6-b621-3278-58cf-562452d9450f@solarflare.com>
Date:   Thu, 23 May 2019 17:21:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190522152001.436bed61@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24632.005
X-TM-AS-Result: No-6.364400-4.000000-10
X-TMASE-MatchedRID: eVEkOcJu0F7mLzc6AOD8DfHkpkyUphL9MVx/3ZYby79IYGsjR+Gjso0G
        9GYox3FwRb34t8z9QDEBEU4E817kldpsFVyqUNwXA9lly13c/gH2X2nyY2WSCaRea8wUAdQ6Qo9
        AVz98w380lP87HDyGK7NGgtaeTxvb4OhwfKpL0fCOnKW5y3Y2vVsP0tBwe3qDMtnJCTb1F/gMmM
        T/PJy+pPf9gIfFCvAAtPdh757doSp12bezThnCIBlJKXOepS1tqUdpDBnLMO1i0lpUl7/Asa6+U
        xOBi85NE2+BZU8pCt7tHfyc98gI23neW/L/sknPxTsb2k0Y+TVPG9xFU38g5i/h9VOvT6AgMMfG
        evmkG3AIaclBEWRkGj48erx7ecjev1l2Uvx6idqJhnKtQtAvVsRB0bsfrpPIx1FPlNAAmcDcLr6
        abctwd4KvFRhWT3h172FvkeluTGHzlxDxfAewrp6oP1a0mRIj
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.364400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24632.005
X-MDID: 1558628520-PYh8aSU28VYQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/05/2019 23:20, Jakub Kicinski wrote:
> On Wed, 22 May 2019 22:37:16 +0100, Edward Cree wrote:
>> * removed RFC tags
> Why?  There is still no upstream user for this
Well, patch #2 updates drivers to the changed API, which is kinda an
 "upstream user" if you squint... admittedly patch #1 is a bit dubious
 in that regard; I was kinda hoping someone on one of the existing
 drivers would either drop in a patch or at least point me at the info
 needed to write one for their HW, but no luck :-(
My defence re patch #1 is that I'm not really adding a 'new feature'
 to the kernel, just restoring something that used to be there.  It's
 a grey area and I'm waiting for the maintainer(s) to say yea or nay
 (Jiri noped v1 but that had a much bigger unused interface (the
 TC_CLSFLOWER_STATS_BYINDEX callback) so I'm still hoping).
> (my previous objections of this being only partially correct aside).
I didn't realise you still had outstanding objections, sorry.
Regarding RTM_GETACTION dumping, it should be possible to add an offload
 callback based on this, which would just pass the action cookie to the
 driver.  Then the driver just has to look the cookie up in its stats
 tables to find the counter.  That would deal with the 'stale stats'
 issue.
But right now, that really _would_ be an API without a user; still, I
 might be able to do that as an RFC patch to prove it's possible, would
 that help this series to go in as-is?

-Ed
