Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD7E178493
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 22:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732347AbgCCVHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 16:07:05 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:41110 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732336AbgCCVHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 16:07:05 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D011468006B;
        Tue,  3 Mar 2020 21:07:01 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 3 Mar 2020
 21:06:52 +0000
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <mlxsw@mellanox.com>,
        <netfilter-devel@vger.kernel.org>
References: <20200228172505.14386-2-jiri@resnulli.us>
 <20200229192947.oaclokcpn4fjbhzr@salvia> <20200301084443.GQ26061@nanopsycho>
 <20200302132016.trhysqfkojgx2snt@salvia>
 <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
 <20200302192437.wtge3ze775thigzp@salvia>
 <20200302121852.50a4fccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200302214659.v4zm2whrv4qjz3pe@salvia>
 <20200302144928.0aca19a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9478af72-189f-740e-5a6d-608670e5b734@solarflare.com>
 <20200303202739.6nwq3ru2vf62j2ek@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <0452cffa-1054-418f-0a5d-8e15afd87969@solarflare.com>
Date:   Tue, 3 Mar 2020 21:06:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200303202739.6nwq3ru2vf62j2ek@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25266.003
X-TM-AS-Result: No-3.380100-8.000000-10
X-TMASE-MatchedRID: eVEkOcJu0F4bF9xF7zzuNfZvT2zYoYOwC/ExpXrHizw/hcT28SJs8oEQ
        k1c2BTxcoZjv0XwCLb2myB5m8hwFFbSi69HcXkHAelGHXZKLL2s5OMMyyCn/wdfzBtkSvJ4x7TP
        +aufk0FiRKSoqryx7WDF8zadsvor+N2+T837spRTgzeXQR5e9DYx4V49TS24wWgyC8H9R1eGc/2
        wcFt9opNUCyTFXDJXQr6YqKNQbbRklVaqTQ2WNXElbX5/aWn0XlhpPdwv1Z0ojRiu1AuxJTGmMO
        g4NfcwtY9Y+hIZD5d35IJ21EQeYAwxCbiBA+b+8xVtvemNbkycIKj6WwO7KdWMunwKby/AXxytw
        wT/CqKfGBd91xcMekWivLll7h+Hdv1l2Uvx6idpqHXONfTwSQsRB0bsfrpPInxMyeYT53RlHDNC
        UBJ8bZuiwu/KrBDqd/zowpUXlRkb6jbNOQkcjF4VbhOvKPf0BYLV+5x8B8URHvVXSXSSIKIC162
        r/MuKkVchOMekwJ2fUNewp4E2/TgSpmVYGQlZ3sxk1kV1Ja8cbbCVMcs1jUlZca9RSYo/b
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.380100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25266.003
X-MDID: 1583269623-PR-oWbbEMFN3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/03/2020 20:27, Pablo Neira Ayuso wrote:
> On Tue, Mar 03, 2020 at 06:55:54PM +0000, Edward Cree wrote:
>> On 02/03/2020 22:49, Jakub Kicinski wrote:
>>> On Mon, 2 Mar 2020 22:46:59 +0100 Pablo Neira Ayuso wrote:
>>>> On Mon, Mar 02, 2020 at 12:18:52PM -0800, Jakub Kicinski wrote:
>>>>> On Mon, 2 Mar 2020 20:24:37 +0100 Pablo Neira Ayuso wrote:  
>>>>>> It looks to me that you want to restrict the API to tc for no good
>>>>>> _technical_ reason.  
>> The technical reason is that having two ways to do things where one would
>>  suffice means more code to be written, tested, debugged.  So if you want
>>  to add this you need to convince us that the existing way (a) doesn't
>>  meet your needs and (b) can't be extended to cover them.
> One single unified way to express the hardware offload for _every_
> supported frontend is the way to go. The flow_offload API provides a
> framework to model all hardware offloads for each existing front-end.
>
> I understand your motivation might be a specific front-end of your
> choice, that's fair enough.
I think we've misunderstood each other (90% my fault).

When you wrote "restrict the API to tc" I read that as "restrict growth of
 the API for flow offloading" (which I *do* want); I've now re-parsed and
 believe you meant it as "limit the API so that only tc may use it" (which
 is not my desire at all).

Thus, when I spoke of "two ways to do things" I meant that _within_ the
 (unified) flow_offload API there should be a single approach to stats
 (the counters attached to actions), to which levels above and below it
 impedance-match as necessary (e.g. by merging netfilter count actions
 onto the following action as Jakub described), rather than bundling
 two interfaces (tc-style counters and separate counter actions) into
 one API (which would mean that drivers would all need to write code to
 handle both kinds, at no gain of expressiveness).
I was *not* referring to tc and netfilter as the "two different ways", but
 I can see why you read it that way.

I hope that makes sense now.
-ed
