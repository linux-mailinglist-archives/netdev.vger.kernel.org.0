Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33DE474E42
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 14:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388287AbfGYMiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 08:38:05 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60826 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387879AbfGYMiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 08:38:05 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2BFF0A80079;
        Thu, 25 Jul 2019 12:38:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 25 Jul
 2019 05:37:59 -0700
Subject: Re: [PATCH] net: sfc: falcon: convert to i2c_new_dummy_device
To:     David Miller <davem@davemloft.net>,
        <wsa+renesas@sang-engineering.com>
CC:     <linux-i2c@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <mhabets@solarflare.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190722172635.4535-1-wsa+renesas@sang-engineering.com>
 <20190724.154739.72147269285837223.davem@davemloft.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <72968faa-e260-3640-99be-9c63bc79ad5e@solarflare.com>
Date:   Thu, 25 Jul 2019 13:37:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190724.154739.72147269285837223.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24796.003
X-TM-AS-Result: No-7.381600-4.000000-10
X-TMASE-MatchedRID: oTBA/+sdKabmLzc6AOD8DfHkpkyUphL9fEdXo4+42aEkt9BigJAcVgjx
        o7OW856yTtDq+0o8imgSs4PEHE58E9fQ7AU9Ytd4lVHM/F6YkvRDyJQKgOPwxIj5cMaEv6IyTpS
        1paZtgYF1nt+700MBrsT6tzHD1wk5+5Y5nT90ICBky+3bD6o2HKa83Mq89i9dGUs9b7xvtJrFhC
        wp4b+TJfj1IL4P7eCO7phItSi3Xzl9G+Xm35+1yP3HILfxLV/9fS0Ip2eEHnw7lDGytTXSz/oLR
        4+zsDTtjoczmuoPCq32UcM14UFnrdM9fJjZ1or/+LMMQwpJHXjyb2MvkMmHkaPRoAinAl+w
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.381600-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24796.003
X-MDID: 1564058284-ivdeBhWiSCVo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/07/2019 23:47, David Miller wrote:
> From: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Date: Mon, 22 Jul 2019 19:26:35 +0200
>
>> Move from i2c_new_dummy() to i2c_new_dummy_device(). So, we now get an
>> ERRPTR which we use in error handling.
>>
>> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Subject & description are incomplete, you're also changing i2c_new_device()
 to i2c_new_client_device().
Other than that,
Acked-by: Edward Cree <ecree@solarflare.com>

> Solarflare folks, please review/test.
>
> Thank you.
Falcon isn't likely to get tested by us, I think we only have about three
 of them left in the building, two of which are in display cabinets ;-)
We end-of-lifed this hardware a couple of years ago, maybe it should be
 downgraded from 'supported' to 'odd fixes'.  Or even moved to staging,
 like that qlogic driver recently was.
