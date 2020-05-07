Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123C91C8A3F
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 14:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgEGMPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 08:15:52 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:45612 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbgEGMPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 08:15:52 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8DA95600C1;
        Thu,  7 May 2020 12:15:51 +0000 (UTC)
Received: from us4-mdac16-48.ut7.mdlocal (unknown [10.7.66.15])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8CA518009B;
        Thu,  7 May 2020 12:15:51 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.197])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0D079280050;
        Thu,  7 May 2020 12:15:48 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 81D4AA40063;
        Thu,  7 May 2020 12:15:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 7 May 2020
 13:15:41 +0100
Subject: Re: [PATCH net,v4] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>, <kuba@kernel.org>
References: <20200506183450.4125-1-pablo@netfilter.org>
 <828ef810-9768-5b5c-7847-0edeb666af9b@solarflare.com>
 <20200507114400.GA2179@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <dbe545f3-b041-ffe4-a908-f7e29afa322d@solarflare.com>
Date:   Thu, 7 May 2020 13:15:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200507114400.GA2179@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25404.003
X-TM-AS-Result: No-3.248000-8.000000-10
X-TMASE-MatchedRID: oTBA/+sdKaa8rRvefcjeTR4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYHzW
        dSUbujfyiK4AoRG6tnCbymr8/mqLG0BfEFcIy7hycI7vRACwF0L5awEvkHdlMSBQRBOQhaJiT6Y
        y0anPBpbQmQgkxwKCie74hCpKBA1e33y2DTfklpBtFkauyh5b+MtEPnVvPlFk1R/ptYWR8C4pQP
        60tO0L4QGHuSswFJxukXSJzFJzhLxCUInNiru3wJ4CIKY/Hg3AnCGS1WQEGtDGr09tQ7Cw/1BIV
        svVu9ABWBd6ltyXuvuCAFz5q9+UxhhkEtEZPu3D9SJ8jSHFJScyRwp2j1O6EWOSjM7Z9tRA57Dp
        dQ4myEV+crsQOY4ObTywjVKEq7yyQjkYVKz3GsTwHX5+Q8jjw1wuriZ3P6dErIJZJbQfMXRqaM5
        LmpUkwzunJXJz8X1QftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.248000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25404.003
X-MDID: 1588853748-aCa3zDxaJ2Z2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2020 12:44, Pablo Neira Ayuso wrote:
> Could you point to what driver might have any problem with this update?
Drivers *can* implement the API in this patch.  It's just that the
 alternative API Jakub proposed would make for simpler driver code.
I.e. I'm not saying it's bad, just that it could be made better.
That's why I didn't hard-NACK it at any point.
I guess I should send the change I'm suggesting as a patch, rather
 than asking it of you — I'll try to get that done today.
(Although I'm not sure if it's really 'net' material or if I should
 wait for David to merge net into net-next and make the patch
 against the latter — wdyt?)

-ed
