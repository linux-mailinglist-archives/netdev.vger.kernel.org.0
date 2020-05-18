Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2105B1D8499
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 20:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387599AbgERSMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 14:12:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:40470 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732631AbgERSDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 14:03:17 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 408D06011E;
        Mon, 18 May 2020 18:03:16 +0000 (UTC)
Received: from us4-mdac16-27.ut7.mdlocal (unknown [10.7.66.59])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3D5E4800A3;
        Mon, 18 May 2020 18:03:16 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.36])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9C91B28006D;
        Mon, 18 May 2020 18:03:15 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4AF2BB40071;
        Mon, 18 May 2020 18:03:13 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 18 May
 2020 19:02:54 +0100
Subject: Re: [PATCH net-next 0/3] net/sched: act_ct: Add support for
 specifying tuple offload policy
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "Oz Shlomo" <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
 <3d780eae-3d53-77bb-c3b9-775bf50477bf@solarflare.com>
 <20200514144938.GD2676@nanopsycho>
 <9f68872f-fe3f-e86a-4c74-8b33cd9ee433@solarflare.com>
 <f7236849-420d-558f-8e66-2501e221ca1b@mellanox.com>
 <64db5b99-2c67-750c-e5bd-79c7e426aaa2@solarflare.com>
 <20200518172542.GE2193@nanopsycho>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <d5be2555-faf3-7ca0-0c23-f2bf92873621@solarflare.com>
Date:   Mon, 18 May 2020 19:02:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200518172542.GE2193@nanopsycho>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25426.003
X-TM-AS-Result: No-8.779100-8.000000-10
X-TMASE-MatchedRID: Jm7Yxmmj9OnmLzc6AOD8DfHkpkyUphL9TLZB6U/YaPpiRkyBrHIiymYV
        eS0LJeRGOOIn5zbTcyzSey6M+8j1yl5XsfiaoQFVoxjrap5AGQv2hUAowGKip2KuDy0kKGx09yF
        Is9Jg08kbt2DuXNOb3latCKdBmErhoqn18XUssBXVNj9wuvGJUCFceJVsZ+5jabJxhiIFjJkBSr
        A72lIhPXz5FqjLfl+Y2lYDQthBn6m/yjNcwjTwjPChiQolft/yL1eX+z9B1QyPiMW+3Yzkgj7Fn
        CrEJ7NN0+YqjDkWLxmbRn5szxtcYONg7rwk6R23NDrSVZCgbSv5qGeseGYAlEdmDSBYfnJRjVNs
        paGN/MHSe7fNpJWzjake5xdln/JmPXdZx1sZHpC84C/3iwAgxEloPruIq9jTAwAObkR2opYESlQ
        F95uWdkd/bWHoAHqS2fOkLykeRy9qEf6Xr7r2WIeMWfCwoMwMqyb8uklAH9WCm0ktRXpIXbnxKz
        FEGfLiHXM6uLE8K2vMDeiFaS4qhfcP4R8hkkRzngIgpj8eDcByZ8zcONpAscRB0bsfrpPIx1FPl
        NAAmcCiM5ey8XbXD0rFr5v7hqyOPGuHv6hAxJmFhMbaxTsCDp6oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.779100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25426.003
X-MDID: 1589824996-sAszKG1Bq-Up
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2020 18:25, Jiri Pirko wrote:
> Is it worth to have an object just for this particular purpose? In the
> past I was trying to push a tc block object that could be added/removed
> and being used to insert filters w/o being attached to any qdisc. This
> was frowned upon and refused because the existence of block does not
> have any meaning w/o being attached.
A tc action doesn't have any meaning either until it is attached to a
 filter.  Is the consensus that the 'tc action' API/command set was a
 mistake, or am I misunderstanding the objection?

> What you suggest with zone sounds quite similar. More to that, it is
> related only to act_ct. Is it a good idea to have a common object in TC
> which is actually used as internal part of act_ct only?
Well, really it's related as much to flower ct_stateas to act_ct: the
 policy numbers control when a conntrack rule (from the zone) gets
 offloaded into drivers, thus determining whether a packet (which has
 been through an act_ct to make it +trk) is ±est.
It's because it has a scope broader than a single ct action that I'm
 resistant to hanging it off act_ct in this way.

Also it still somewhat bothers me that this policy isn't scoped to the
 device; I realise that the current implementation of a single flow
 table shared by all offloading devices is what forces that, but it
 just doesn't seem semantically right that the policy on when to
 offload a connection is global across devices with potentially
 differing capabilities (e.g. size of their conntrack tables) that
 might want different policies.
(And a 'tc ct add dev eth0 zone 1 policy_blah...' would conveniently
 give a hook point for callback (1) from my offtopic ramble, that the
 driver could use to register for connections in the zone and start
 offloading them to hardware, rather than doing it the first time it
 sees that zone show up in an act_ct it's offloading.  You don't
 really want to do the same in the non-device-qualified case because
 that could use up HW table space for connections in a zone you're
 not offloading any rules for.)

Basically I'm just dreaming of a world where TC does a lot more with
 explicit objects that it creates and then references, rather than
 drivers having to implicitly create HW objects for things the first
 time a rule tries to reference them.
"Is it worth" all these extra objects?  Really that depends on how
 much simpler the drivers can become as a result; this is the control
 path, so programmer time is worth more than machine time, and space
 in the programmer's head is worth more than machine RAM ;-)

-ed
