Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D78C23CE9
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 18:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389042AbfETQLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 12:11:06 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:52744 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387513AbfETQLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 12:11:06 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DDF6B7800B5;
        Mon, 20 May 2019 16:11:04 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 20 May
 2019 09:10:44 -0700
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
 <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
 <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
 <3db2e5bf-4142-de4b-7085-f86a592e2e09@mojatatu.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <17cf3488-6f17-cb59-42a3-6b73f7a0091e@solarflare.com>
Date:   Mon, 20 May 2019 17:10:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3db2e5bf-4142-de4b-7085-f86a592e2e09@mojatatu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24624.005
X-TM-AS-Result: No-14.360900-4.000000-10
X-TMASE-MatchedRID: WMT2WRIkHPPmLzc6AOD8DfHkpkyUphL9NV9S7O+u3Ka2ZO4LLn5VShAa
        tES/U7wV9376qnd+Dz7k0pQKEYGk1EKPluOEKT3/Iwk7p1qp3JahmhSedX3bwmmJ+7V5rRczT5j
        NhKqBMgabcLuvF7mKkMKztThuQn/GXHYbXzCVxL43X0+M8lqGUrK2BPB+RqJ9ommsqZ2nyk8MmM
        T/PJy+pOg2MNGKY1m996I4JfaNu8kM5WJq5oHS2Yrkmrf0Igi/4sNkJLS+x0QrVk6u1Q5ye+DGR
        KQQH0piGNopF9Up6vyMA/tn63EgdjC8Z6yBHvVBJDcimQIrvHhqzXAAkex/IuhIuiTtbcXXLN7Y
        /j9rSN/7cwVpwiGNaySeeEG0FurMBy0s9WEbFp5yFiJvyj8nUI19AQoYrNi9QTf+q86OAUsjJxw
        pT9SCm26lKwpaJzZceHmJYxnmx2hccQ8eam5EfYMbH85DUZXy3QfwsVk0UbvdirxFVpmK9Ti9gl
        VqlHsn4TXbx8uRI5191PrW4g6U1DFEXBryO0v86FWB09b9RE0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--14.360900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24624.005
X-MDID: 1558368665-rntPvnwvqkLQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2019 16:38, Jamal Hadi Salim wrote:
> That is fine then if i could do:
>
> tc actions add action drop index 104
> then
> followed by for example the two filters you show below..
That seems to work.

> Is your hardware not using explicit indices into a stats table?
No; we ask the HW to allocate a counter and it returns us a counter ID (which
 bears no relation to the action index).  So I have an rhashtable keyed on
 the cookie (or on the action-type & action_index, when using the other
 version of my patches) which stores the HW counter ID; and the entry in that
 hashtable is what I attach to the driver's action struct.

> Beauty.  Assuming the stats are being synced to the kernel?
> Test 1:
> What does "tc -s actions ls action drop index 104" show?
It produces no output, but
    `tc -s actions get action drop index 104`
or
    `tc -s actions list action gact index 104`
shows the same stats as `tc -s filter show ...` did for that action.
> Test 2:
> Delete one of the filters above then dump actions again as above.
Ok, that's weird: after I delete one, the other (in `tc -s filter show ...`)
 no longer shows the shared action.

# tc filter del dev $vfrep parent ffff: pref 49151
# tc -stats filter show dev $vfrep parent ffff:
filter protocol arp pref 49152 flower chain 0
filter protocol arp pref 49152 flower chain 0 handle 0x1
  eth_type arp
  skip_sw
  in_hw in_hw_count 1
        action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
         index 1 ref 1 bind 1 installed 180 sec used 180 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

        action order 2: mirred (Egress Mirror to device $pf) pipe
        index 101 ref 1 bind 1 installed 180 sec used 169 sec
        Action statistics:
        Sent 256 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 256 bytes 4 pkt
        backlog 0b 0p requeues 0

        action order 3: vlan  pop pipe
         index 2 ref 1 bind 1 installed 180 sec used 180 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

#

Yet `tc -s actions get` still shows it...

# tc -s actions get action drop index 104
total acts 0

        action order 1: gact action drop
         random type none pass val 0
         index 104 ref 2 bind 1 installed 812 sec used 797 sec
        Action statistics:
        Sent 534 bytes 7 pkt (dropped 7, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 534 bytes 7 pkt
        backlog 0b 0p requeues 0
# tc filter show dev $vfrep parent ffff:
filter protocol arp pref 49152 flower chain 0
filter protocol arp pref 49152 flower chain 0 handle 0x1
  eth_type arp
  skip_sw
  in_hw in_hw_count 1
        action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
         index 1 ref 1 bind 1

        action order 3: vlan  pop pipe
         index 2 ref 1 bind 1

# tc -s actions get action mirred index 101
total acts 0

        action order 1: mirred (Egress Mirror to device $pf) pipe
        index 101 ref 1 bind 1 installed 796 sec used 785 sec
        Action statistics:
        Sent 256 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 256 bytes 4 pkt
        backlog 0b 0p requeues 0
#

Curiouser and curiouser... it seems that after I delete one of the rules,
 TC starts to get very confused and actions start disappearing from rule
 dumps.  Yet those actions still exist according to `tc actions list`.
I don't *think* my changes can have caused this, but I'll try a test on a
 vanilla kernel just to make sure the same thing happens there.

-Ed
