Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73D01E26AE
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbgEZQRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:17:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41204 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728279AbgEZQRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:17:14 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7E2C5200FE;
        Tue, 26 May 2020 16:17:13 +0000 (UTC)
Received: from us4-mdac16-65.at1.mdlocal (unknown [10.110.50.184])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7911E8009B;
        Tue, 26 May 2020 16:17:13 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.106])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EAB4040058;
        Tue, 26 May 2020 16:17:12 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 99780B4007E;
        Tue, 26 May 2020 16:17:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 26 May
 2020 17:17:06 +0100
Subject: Re: [PATCH net-next 0/3] net/sched: act_ct: Add support for
 specifying tuple offload policy
To:     Paul Blakey <paulb@mellanox.com>, Jiri Pirko <jiri@resnulli.us>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
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
 <d5be2555-faf3-7ca0-0c23-f2bf92873621@solarflare.com>
 <73cf369e-80bc-b7d2-b3f5-106633c3c617@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <9fb20da4-ac4d-54b4-8365-effaee1add3c@solarflare.com>
Date:   Tue, 26 May 2020 17:17:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <73cf369e-80bc-b7d2-b3f5-106633c3c617@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25442.003
X-TM-AS-Result: No-8.050200-8.000000-10
X-TMASE-MatchedRID: xcONGPdDH5rmLzc6AOD8DfHkpkyUphL9sKzLQnnS/xwUE18jzz932paT
        uLyNbZXgrW702S6GBasna5sZ1mBmvL7B68mjCRLBoxjrap5AGQtBSY6kx+M18deM7+ynemuGGCV
        vCiARVvPll5HXtk7Wj0WyyHKLktK9ZMWKXMYF1HGiVU7u7I4INS9Xl/s/QdUMYAwzRYoPhqxzfv
        mhvQjM3asX2h7dktoaxBu+r0f/xo9E/Sp0PD3Gx4mdvL31hbmuZAGtCJE23YgZSz1vvG+0mgrV1
        iu1XB5tB1aphc+FW80QXv5QIP0BCsTrvy/DX1MPnMQdNQ64xfcBDya2JbH/+rZVMaEd3DdN2zMl
        MhmuHAh91umf6Vbd4JzAuW1U1Efi9XUyefCCihAqsMfMfrOZRTVfUuzvrtymSg8ufp5n3T7HGPf
        3UmVWP+Od/LibTZRK3BTxUdcaKkK/WXZS/HqJ2gtuKBGekqUpIG4YlbCDECsYpN+2ZkfdFzJ6UA
        /CaBtWHTRWNH77H71ZNbsPeW96vjKaFvIdc38e4eZLp8bTU/Q=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.050200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25442.003
X-MDID: 1590509833-3zhWh2upBlBo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/05/2020 10:25, Paul Blakey wrote:
> On 5/18/2020 9:02 PM, Edward Cree wrote:
>> Well, really it's related as much to flower ct_state as to act_ct: the
>>  policy numbers control when a conntrack rule (from the zone) gets
>>  offloaded into drivers, thus determining whether a packet (which has
>>  been through an act_ct to make it +trk) is ±est.
> It doesn't affect when a connection will become established (+est),
> just the offloading of such connections.
Yes; what I meant was that the packet wouldn't match a +trk+estrule in
 hardware if the connection hadn't been offloaded (it would instead go
 to software, where it would match).
So the policy is in a sense controlling ct_state offload, as much as it
 is act_ct offload.

> I'm not sure how well it will sit with the flow table having a device while
> the filter has a tc block which can have multiple devices.
>
> And then we have the single IPS_OFFLOAD_BIT so a flow can't currently be
> shared between different flow tables that will be created for different devices.
> We will need to do a an atomic lookup/insert to each table.
I see; it does get a bit complicated.  I agree that the 'policy per
 device' use case is too speculative to justify all that work.

But I think I can still make my dream happen with the global policy,
 just by putting the "we used this CT zone in an action, we need to
 offload it" smarts into TC rather than all the drivers.  Which I
 suppose is orthogonal to the TC CT policy uAPI question; but I still
 prefer the 'explicit CT object' approach.  To do those smarts, TC
 would need a CT object internally anyway, so we may as well expose
 it and get a clean policy API into the bargain.

> What you are suggesting will require new userspace and kernel (builtin)
> tc netlink API to manage conntrack zones/nf flow tables policies.
Either way there's new API.  Yours may be a smaller change (just adding
 new attributes hung off the act_ct), but you still need to update
 userspace to take advantage of it, else you get the default policy.
And `tc ct add zone 1 policy_timeout 120` (global policy) can be done
 backwards-compatibly, too, as I described in my message before last.

(Policy-per-device would be much more of a pain new-uAPI-wise; again,
 I agree to drop that idea.)

-ed
