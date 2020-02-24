Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCE216AA7D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBXPug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:50:36 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43122 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727972AbgBXPug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:50:36 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5D663940065;
        Mon, 24 Feb 2020 15:50:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 24 Feb
 2020 15:50:23 +0000
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW stats
 type
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <xiyou.wangcong@gmail.com>,
        <pablo@netfilter.org>, <mlxsw@mellanox.com>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e08c0342-ff79-c249-f59d-1f5ab00b6db1@solarflare.com>
Date:   Mon, 24 Feb 2020 15:50:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25250.003
X-TM-AS-Result: No-1.439000-8.000000-10
X-TMASE-MatchedRID: 5+1rHnqhWUTmLzc6AOD8DfHkpkyUphL94lzqEpaPQLWZt08TfNy6OF71
        kxpD3kyBinL+T0EoeSAt4xyEud4fJR3noULxg9buIwk7p1qp3JZ/9Mg6o+wMi/ITG2uG4/lQo8W
        MkQWv6iUDpAZ2/B/BlgJTU9F/2jaz3QfwsVk0UbuZ/dgf3Hl0lfozOWH1sPY9HFl6SMKZdMmq/X
        emM29Vbc3WNrZq6Vx4RxXJ+SDt/AakCxZBBLFXCsFGkKJWfGE5ZB2F/HSXW9hSmWLFCFyFuKKAQ
        fLsnhLrKWSt4DmvbhpicKLmK2TeKmsPn5C6nWpTiTSgm8kJVKRDDKa3G4nrLQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.439000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25250.003
X-MDID: 1582559435-hbl5TyzobRUZ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/02/2020 15:45, Jamal Hadi Salim wrote:
> Going backwards and looking at your example in this stanza:
> ---
>   in_hw in_hw_count 2
>   hw_stats immediate
>         action order 1: gact action drop
>          random type none pass val 0
>          index 1 ref 1 bind 1 installed 14 sec used 7 sec
>         Action statistics:
> ----
>
> Guessing from "in_hw in_hw_count 2" - 2 is a hw stats table index?
AIUI in_hw_count is a reference count of hardware devices that have
 offloaded the rule.  Nothing to do with stats "counters".

-ed
