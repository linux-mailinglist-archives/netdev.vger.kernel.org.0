Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47F32A7617
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 04:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388619AbgKEDdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 22:33:24 -0500
Received: from linux.microsoft.com ([13.77.154.182]:47172 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387643AbgKEDdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 22:33:24 -0500
Received: from [192.168.0.114] (unknown [49.207.198.216])
        by linux.microsoft.com (Postfix) with ESMTPSA id E10CF20B4905;
        Wed,  4 Nov 2020 19:33:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E10CF20B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1604547204;
        bh=Oe/MfzqV2v9zkGZtZkogWbchmVLqgIEFJ/RW772EC/c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Nu6XJ2VormhUSq9kLwFfSbjzHyC68StGlGoTNgXV+mwIaCsOe5JAOdRQgx3i/5hQ2
         GgPMRq4avNV/vXNXYCGRoml/CspyCPj033Yz6s3SMvg4XtehZgIKysuxvq6NFFJlri
         UA8dXYoP3hB+GLehJy4OQovzioUu3lSZFZlHbub0=
Subject: Re: [PATCH v2 0/3] wireless: convert tasklets to use new
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Allen Pais <allen.lkml@gmail.com>, ryder.lee@mediatek.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi83@gmail.com,
        kuba@kernel.org, davem@davemloft.net, nbd@nbd.name
References: <20201007103309.363737-1-allen.lkml@gmail.com>
 <c3d71677-a428-f215-2ba8-4dd277a69fb6@linux.microsoft.com>
 <87blgdqdpb.fsf@codeaurora.org>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <9e9219d9-fab7-404b-0f40-f5721f781a1d@linux.microsoft.com>
Date:   Thu, 5 Nov 2020 09:03:10 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87blgdqdpb.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>>
>>> This series converts the remaining drivers to use new
>>> tasklet_setup() API.
>>>
>>> The patches are based on wireless-drivers-next (c2568c8c9e63)
>>
>>   Is this series queue? I haven't seen any email. This is the last
>> series as part of the tasklet conversion effort.
> 
> They are queued in linux-wireless patchwork, see the link below. I have
> lots of patches pending but hopefully I'll tackle most of them soon.
> 

Thank you very much.

