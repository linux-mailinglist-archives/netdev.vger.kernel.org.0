Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF86D1F429C
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 19:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbgFIRnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 13:43:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47500 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728472AbgFIRnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 13:43:12 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C5D4B600C6;
        Tue,  9 Jun 2020 17:43:11 +0000 (UTC)
Received: from us4-mdac16-67.ut7.mdlocal (unknown [10.7.64.34])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C33202009B;
        Tue,  9 Jun 2020 17:43:11 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.38])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0020B22005B;
        Tue,  9 Jun 2020 17:43:11 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 74DD380005C;
        Tue,  9 Jun 2020 17:43:10 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Jun 2020
 18:43:02 +0100
Subject: Re: [PATCH v3 1/7] Documentation: dynamic-debug: Add description of
 level bitmask
To:     Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jason Baron <jbaron@akamai.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jim Cromie <jim.cromie@gmail.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-2-stanimir.varbanov@linaro.org>
 <20200609111615.GD780233@kroah.com>
 <ba32bfa93ac2e147c2e0d3a4724815a7bbf41c59.camel@perches.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <727b31a0-543b-3dc5-aa91-0d78dc77df9c@solarflare.com>
Date:   Tue, 9 Jun 2020 18:42:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <ba32bfa93ac2e147c2e0d3a4724815a7bbf41c59.camel@perches.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25470.003
X-TM-AS-Result: No-8.552100-8.000000-10
X-TMASE-MatchedRID: UuaOI1zLN1jsYbGmK/WYxvZvT2zYoYOwC/ExpXrHizxPvOpmjDN2khRf
        A1I3OlqqMsOCsLooWnhTMzwIlbNqigkGWAZ8v6Jzt0cS/uxH87AHgh3sKJBzPznKJvFx9/+yWXj
        F9NKzdCmSmxTZw6MyobzX7h2+UuZkJT6mV4xCSZYJteOxcC2tigoXSOLC5a441y0aXF5eX+hqOm
        kOtBFAiBs1sRoz9CTzVNP1aViTJ07BHFyXUjp8G8zSKGx9g8xhHkWa9nMURC4mKtDuZhlzmAoeR
        RhCZWIBtI3VVXMQt001b89uV6eclF3ESD6IRpXqyhPaAPXFzs3naaW2UTafyKZwleT7xjO5HHuq
        L5OlwoiMMQ2VRcJiy7Lhf59ApN2Zlrk4492pNLWeAiCmPx4NwHJnzNw42kCxxEHRux+uk8h+ICq
        uNi0WJIXcrebLszrlx48ugytnjOhRjFfjgwIAhWWZsP6IwhvxftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.552100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25470.003
X-MDID: 1591724591-lLDe95U7OXgC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/06/2020 17:58, Joe Perches wrote:
> On Tue, 2020-06-09 at 13:16 +0200, Greg Kroah-Hartman wrote:
>> What is wrong with the existing control of dynamic
>> debug messages that you want to add another type of arbitrary grouping
>> to it? 
> There is no existing grouping mechanism.
>
> Many drivers and some subsystems used an internal one
> before dynamic debug.
>
> $ git grep "MODULE_PARM.*\bdebug\b"|wc -l
> 501
>
> This is an attempt to unify those homebrew mechanisms.
In network drivers, this is probablyusing the existing groupings
 defined by netif_level() - see NETIF_MSG_DRV and friends.  Note
 that those groups are orthogonal to the level, i.e. they control
 netif_err() etc. as well, not just debug messages.
Certainly in the case of sfc, and I'd imagine for many other net
 drivers too, the 'debug' modparam is setting the default for
 net_dev->msg_enable, which can be changed after probe with
 ethtool.
It doesn't look like the proposed mechanism subsumes that (we have
 rather more than 5 groups, and it's not clear how you'd connect
 it to the existing msg_enable (which uapi must be maintained); if
 you don't have a way to do this, better exclude drivers/net/ from
 your grep|wc because you won't be unifying those - in my tree
 that's 119 hits.

-ed
