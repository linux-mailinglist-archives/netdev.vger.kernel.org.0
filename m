Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849CA1AADBC
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415553AbgDOQS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:18:56 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59492 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2410362AbgDOQSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 12:18:52 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A9C90600DC;
        Wed, 15 Apr 2020 16:18:50 +0000 (UTC)
Received: from us4-mdac16-6.ut7.mdlocal (unknown [10.7.65.74])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A563A2009B;
        Wed, 15 Apr 2020 16:18:50 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.42])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1853C220068;
        Wed, 15 Apr 2020 16:18:50 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9A017A4008C;
        Wed, 15 Apr 2020 16:18:49 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 15 Apr
 2020 17:18:42 +0100
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
To:     Sasha Levin <sashal@kernel.org>
CC:     Or Gerlitz <gerlitz.or@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Linux Netdev List" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
References: <20200411231413.26911-1-sashal@kernel.org>
 <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
Date:   Wed, 15 Apr 2020 17:18:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200414205755.GF1068@sasha-vm>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25356.003
X-TM-AS-Result: No-0.162400-8.000000-10
X-TMASE-MatchedRID: xcONGPdDH5rx4D8KxdMay56vBgoAbaC269aS+7/zbj+qvcIF1TcLYIB1
        DC4vClW5aiz3Dq8BYk4U9E0FLUe/uTthmaU+uhdCRXdiukZQCgG/yN2q8U674hBEGklbuMi4ylA
        YwPIY79Pf+V9vge8ELJfR5wEm5PRXT8T8t9BFA68BnSWdyp4eoToSfZud5+Gg4zCcMWWKsiZf1a
        VK9zaoNTn5tACRiVgACBHnexUEYKbob/hVdrvnXuIfK/Jd5eHmAQ8mtiWx//od0WOKRkwsh9N+V
        O8UR4MhfI34OzI/0AxYiZFrF8ZSst6khhVmPGCFDcJe2cgs17z/j4ZByyZz4mlzEo7bHFvOilvA
        b18i4hNT/9dAnCjwEpFIUP7msLqCFvp4+NM7kPmiVU7u7I4INZ8z6yZBmpaQT7zqZowzdpKBWVe
        fSkg0pcEsN0vJyKBrX7bicKxRIU3yABN92SNtPN0H8LFZNFG7GOa/xe+6dpEMI8Fusw1LKe20T2
        3bS9MpyZD6i6vaeuKAtx3xCfZ+N3pGY1A9HF8YLTvkH7PgMHjcVG008kZv+C26w+M0jpt8a6y+p
        kMFH4fwHX5+Q8jjw1wuriZ3P6dErIJZJbQfMXRqaM5LmpUkwz8UunPw/LQonqg/VrSZEiM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.162400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25356.003
X-MDID: 1586967530-s6amwzQHFOd0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Firstly, let me apologise: my previous email was too harsh and too
 assertiveabout things that were really more uncertain and unclear.

On 14/04/2020 21:57, Sasha Levin wrote:
> I've pointed out that almost 50% of commits tagged for stable do not
> have a fixes tag, and yet they are fixes. You really deduce things based
> on coin flip probability?
Yes, but far less than 50% of commits *not* tagged for stable have a fixes
 tag.  It's not about hard-and-fast Aristotelian "deductions", like "this
 doesn't have Fixes:, therefore it is not a stable candidate", it's about
 probabilistic "induction".

> "it does increase the amount of countervailing evidence needed to
> conclude a commit is a fix" - Please explain this argument given the
> above.
Are you familiar with Bayesian statistics?  If not, I'd suggest reading
 something like http://yudkowsky.net/rational/bayes/ which explains it.
There's a big difference between a coin flip and a _correlated_ coin flip.

> This is great, but the kernel is more than just net/. Note that I also
> do not look at net/ itself, but rather drivers/net/ as those end up with
> a bunch of missed fixes.
drivers/net/ goes through the same DaveM net/net-next trees, with the
 same rules.
>> To be honest, that this needs to be explained to you does not inspire
>> confidence in the quality of your autoselection process...
>
> Nothing like a personal attack or two to try and make a point?
It wasn't meant as a personal attack, more as an "it's worrying that this
 is not known to the people doing the stable selection".  But I did agonise
 over whether to say that and now wish I hadn't; sorry.  (I'm not exactly
 my best self right now, what with all the lockdown cabin fever.)

-ed
