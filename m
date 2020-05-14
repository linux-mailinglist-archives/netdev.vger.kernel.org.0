Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B331D2E9C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 13:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgENLpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 07:45:01 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:51658 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726067AbgENLpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 07:45:00 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9AFC82007C;
        Thu, 14 May 2020 11:44:59 +0000 (UTC)
Received: from us4-mdac16-45.at1.mdlocal (unknown [10.110.48.16])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9A8726009B;
        Thu, 14 May 2020 11:44:59 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 30D43220054;
        Thu, 14 May 2020 11:44:59 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BF9CF40067;
        Thu, 14 May 2020 11:44:58 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 14 May
 2020 12:44:52 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: Re: [PATCH 0/8 net] the indirect flow_block offload, revisited
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <paulb@mellanox.com>, <ozsh@mellanox.com>, <vladbu@mellanox.com>,
        <jiri@resnulli.us>, <kuba@kernel.org>, <saeedm@mellanox.com>,
        <michael.chan@broadcom.com>
References: <20200513164140.7956-1-pablo@netfilter.org>
Message-ID: <8f1a3b9a-6a60-f1b3-0fc1-f2361864c822@solarflare.com>
Date:   Thu, 14 May 2020 12:44:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200513164140.7956-1-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25418.003
X-TM-AS-Result: No-7.609100-8.000000-10
X-TMASE-MatchedRID: UuaOI1zLN1gbF9xF7zzuNfZvT2zYoYOwt3aeg7g/usBvNs77F4nIWlui
        xS8mDjZOIwuO97ZnkxkPkyd+0GAin/xcXzlUQt0oN+75FOVyJeBXjjsM2/Dfxn9nRLJB1yYQHFJ
        yCMrdNkmNMJ4daKiP9N+aqtQHbaUIUgG7ejycorBOGH/Yn5DKxYZyPbBh/hxWSStniYWNNsPOG5
        8MBtvONrQszBevfBjDsPcjKUYPuwiy9Uh/U28aLy16nmC2/zSqcQTGOtT45qZjLp8Cm8vwF0fny
        52zS9mSU0oMo6UOt+TdL2i2eEkxZWhV4uU8NZ6Bfid4LSHtIANF/jSlPtma/kvEK4FMJdoqMzCe
        U/KrLcqMe8PZFqu1Ziio+Vn+4AqmSSOWVJeuO1CDGx/OQ1GV8rHlqZYrZqdI+gtHj7OwNO0X9rp
        BZuBDbVL+b36eWMniaC2KxQ5GtTZacZsJhA5v1ftj8WFIn+jiKgUstyLLYywEHXewwQRM2UpJq2
        lBkSmVSJLHdRakaCcRp7GxVS4iH3zm6hivSaZZop2lf3StGhISt1bcvKF7ZKbNmFZyaXzY
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.609100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25418.003
X-MDID: 1589456699-CglBGJiTdArH
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2020 17:41, Pablo Neira Ayuso wrote:
> Hi,
>
> This patchset fixes the indirect flow_block support for the tc CT action
> offload. Please, note that this batch is probably slightly large for the
> net tree, however, I could not find a simple incremental fix.
>
> = The problem
>
> The nf_flow_table_indr_block_cb() function provides the tunnel netdevice
> and the indirect flow_block driver callback. From this tunnel netdevice,
> it is not possible to obtain the tc CT flow_block. Note that tc qdisc
> and netfilter backtrack from the tunnel netdevice to the tc block /
> netfilter chain to reach the flow_block object. This allows them to
> clean up the hardware offload rules if the tunnel device is removed.
>
> <snip>
>
> = About this patchset
>
> This patchset aims to address the existing TC CT problem while
> simplifying the indirect flow_block infrastructure. Saving 300 LoC in
> the flow_offload core and the drivers.
This might be a dumb question, but: what is the actual bug being fixed,
 that makes this patch series needed on net rather than net-next?
From your description it sounds like a good and useful cleanup/refactor,
 but nonetheless still a clean-up, appropriate for net-next.

-ed
