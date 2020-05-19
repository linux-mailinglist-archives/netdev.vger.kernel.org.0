Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2311D99C3
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgESObb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:31:31 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:35948 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgESObb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:31:31 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BFD0960055;
        Tue, 19 May 2020 14:31:30 +0000 (UTC)
Received: from us4-mdac16-4.ut7.mdlocal (unknown [10.7.65.72])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A74E78009B;
        Tue, 19 May 2020 14:31:30 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.40])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7585F280053;
        Tue, 19 May 2020 14:31:29 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D6BB0BC0087;
        Tue, 19 May 2020 14:31:28 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 19 May
 2020 15:31:02 +0100
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump
 mode
To:     Vlad Buslov <vladbu@mellanox.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <dcaratti@redhat.com>, <marcelo.leitner@gmail.com>,
        <kuba@kernel.org>
References: <20200515114014.3135-1-vladbu@mellanox.com>
 <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
 <vbfo8qkb8ip.fsf@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1581796d-2f28-397b-d234-2614b1e64f8a@solarflare.com>
Date:   Tue, 19 May 2020 15:30:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <vbfo8qkb8ip.fsf@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25428.003
X-TM-AS-Result: No-6.646500-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E/mLzc6AOD8DfHkpkyUphL9SeIjeghh/zPCtB5AXGRY23CP
        Z1ohdVsRIWlA6ZCW3oaXeiT2Em65KNce6ujdrJ2nwY28o+cGA5rJ5SXtoJPLyEl/J9Ro+MABE8O
        4wkrUNK7XgPU09aUnZKgmldVr64sMggzbwPvflRvPkJgNw33UmwGZ/+APXW9kFBNfI88/d9rRzj
        70RhS7/HjlNG5fNlWM7rkZhvF7EUgPkUPAqVjHplLduNeqG/eIxlTeSbP0L8eR4iYpgCc6d7p0J
        rjcBDnf585VzGMOFzAQVjqAOZ5cjQtuKBGekqUpbGVEmIfjf3t+LOq4wPSOgcR8+so1gtfr/Nqf
        B+xGwLutZylpMji8RrlcEQyzoh26
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.646500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25428.003
X-MDID: 1589898689-RMe_Jp-r6ETk
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2020 10:04, Vlad Buslov wrote:
> On Mon 18 May 2020 at 18:37, Edward Cree <ecree@solarflare.com> wrote:
>> I.e. if next year it turns out that some
>>  user needs one parameter that's been omitted here, but not the whole dump,
>>  are they going to want to add another mode to the uapi?
> Why not just extend terse dump? I won't break user land unless you are
> removing something from it.
But then all terse dump users pay the performance cost for thatone
 app's extra need.

> - Generic data is covered by current terse dump implementation.
>   Everything else will be act or cls specific
Fair point.
I don't suppose something something BPF mumble solve this? I haven't
 been following the BPF dumping work in detail but it sounds like it
 might be a cheap way to get the 'more performant next step' that
 was mentioned in the subthread with David.  Just a thought.

-ed
