Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A2F142DBE
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 15:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgATOjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 09:39:25 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:44060 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbgATOjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 09:39:24 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 25F7280067;
        Mon, 20 Jan 2020 14:39:23 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 20 Jan
 2020 14:39:17 +0000
Subject: Re: [PATCH net] net: Fix packet reordering caused by GRO and
 listified RX cooperation
To:     Alexander Lobakin <alobakin@dlink.ru>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        "Tariq Toukan" <tariqt@mellanox.com>
References: <20200117150913.29302-1-maximmi@mellanox.com>
 <7939223efeb4ed9523a802702874be9b8f37f231.camel@mellanox.com>
 <da13831f11d0141728a96954685fdf40@dlink.ru>
 <5b0519b8640f9f270a9570720986eee7@dlink.ru>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1b91ee24-1ec0-3aef-9ab7-d58673dc98ae@solarflare.com>
Date:   Mon, 20 Jan 2020 14:39:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <5b0519b8640f9f270a9570720986eee7@dlink.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25178.003
X-TM-AS-Result: No-2.964500-8.000000-10
X-TMASE-MatchedRID: +c13yJDs9034ECMHJTM/ufZvT2zYoYOwC/ExpXrHizynRvssirgAKxAF
        IK5TH5/7RKNWDt5BRjJVjdEnKZ0vVhKovmG69iNrfid4LSHtIAMmKH/Kj46+VYSouYJQSRHXngI
        gpj8eDcC063Wh9WVqgmWCfbzydb0giCFykZQ+I/rkwjHXXC/4I8prJP8FBOIasvOLFGvwMZt7Ox
        p499KrIIrqecQqT64dwO6C0Hf3nYSsi79TBRrn6YVyAlz5A0zC7xsmi8libwVi6nHReNJA8sM4V
        WYqoYnhs+fe0WifpQo=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.964500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25178.003
X-MDID: 1579531164-UCF0B_BjRKXM
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2020 09:44, Alexander Lobakin wrote:
> Still need Edward's review. 
Sorry for delay, didn't have time to catch up with the net-next firehose
 on Friday.

With this change:
> IV. Patch + gro_normal_list() is placed after napi_gro_flush()
 and the corrected Fixes tag, I agree that the solution is correct, and
 expect to ack v2 when it's posted.

-Ed
