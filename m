Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA071D7D0A
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgERPiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:38:09 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60592 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgERPiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:38:09 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AFE8A200FE;
        Mon, 18 May 2020 15:38:08 +0000 (UTC)
Received: from us4-mdac16-54.at1.mdlocal (unknown [10.110.50.14])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AE508800A4;
        Mon, 18 May 2020 15:38:08 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.106])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 40E044006F;
        Mon, 18 May 2020 15:38:08 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E6D38B40082;
        Mon, 18 May 2020 15:38:07 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 18 May
 2020 16:38:02 +0100
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump
 mode
To:     Vlad Buslov <vladbu@mellanox.com>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <dcaratti@redhat.com>, <marcelo.leitner@gmail.com>,
        <kuba@kernel.org>
References: <20200515114014.3135-1-vladbu@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
Date:   Mon, 18 May 2020 16:37:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200515114014.3135-1-vladbu@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25426.003
X-TM-AS-Result: No-5.621500-8.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTrmLzc6AOD8DfHkpkyUphL9R8lmSfB6K5IOUs4CTUgKy3v6
        cG7t9uXqIv4TIHHMcmIDyKSw4EF1FziULkq/3BRulAhSvvpqeTCYTIcrNzjYvFAoBBK61Bhcit/
        /Acuj+KgdsIE/Zo8flAf4uaoYK0nQQu/XDiW47J43xCYZDydSGg73P4/aDCIFERgtK1vKtV2w0F
        FGdeCd9r4xBnZH9Ovq2Via0E1bchtj3cEXcFAPHm6HurDH4PpPDmTV5r5yWnpKDy5+nmfdPpgM2
        5fIhnOfEZ65ChiuPzxftuJwrFEhTRMQLQ/0+9hG3QfwsVk0UbuGrPnef/I+enyKOFVW9o0DJMgm
        r34iVYY/qGC9nYwmyrGmrXJZXuKzC8XKjsVbJjU=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.621500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25426.003
X-MDID: 1589816288-em3IXvjIA8ua
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/05/2020 12:40, Vlad Buslov wrote:
> In order to
> significantly improve filter dump rate this patch sets implement new
> mode of TC filter dump operation named "terse dump" mode. In this mode
> only parameters necessary to identify the filter (handle, action cookie,
> etc.) and data that can change during filter lifecycle (filter flags,
> action stats, etc.) are preserved in dump output while everything else
> is omitted.
I realise I'm a bit late, but isn't this the kind of policy that shouldn't
 be hard-coded in the kernel?  I.e. if next year it turns out that some
 user needs one parameter that's been omitted here, but not the whole dump,
 are they going to want to add another mode to the uapi?
Should this not instead have been done as a set of flags to specify which
 pieces of information the caller wanted in the dump, rather than a mode
 flag selecting a pre-defined set?

-ed
