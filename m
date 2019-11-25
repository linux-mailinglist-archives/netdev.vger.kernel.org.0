Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DE3108B42
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 10:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKYJ7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 04:59:32 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:48064 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727215AbfKYJ7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 04:59:32 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 01F32300069;
        Mon, 25 Nov 2019 09:59:30 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 25 Nov
 2019 09:59:25 +0000
Subject: Re: [PATCH net-next] sfc: fix build without CONFIG_RFS_ACCEL
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        <davem@davemloft.net>
CC:     <dahern@digitalocean.com>, <netdev@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>
References: <964dd1b3-b26a-e5ee-7ac2-b4643206cb5f@solarflare.com>
 <20191123174542.5650-1-jakub.kicinski@netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <6945d93e-89bc-0cb3-bfd0-65fca9905ec7@solarflare.com>
Date:   Mon, 25 Nov 2019 09:59:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191123174542.5650-1-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25064.003
X-TM-AS-Result: No-3.947500-8.000000-10
X-TMASE-MatchedRID: 7ySqCuYCpfjmLzc6AOD8DfHkpkyUphL9CqIE7aqEIgYy/xh6GqNHVU90
        OIlVmkoPjjj7xmhW6vgaiEdwliVk/JGlJ5QKyUiCboe6sMfg+k/VbBJAvE6+VRzF5oA48R2iQ/C
        ANf7/lHV9LQinZ4QefL6qvLNjDYTwIq95DjCZh0zLOq+UXtqwWAtuKBGekqUpOlxBO2IcOBbXb3
        sKYNULH3n7gVbItTfslSqJEwf2BnnBGB2FgLbEyOjC57kXwdTyh8xkx6AsMh4ZTSkqdqz5FucIl
        +0VmRmLNglg0VTTR7tgO21BQaodlQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.947500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25064.003
X-MDID: 1574675971-WhHviUZLciRQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2019 17:45, Jakub Kicinski wrote:
> The rfs members of struct efx_channel are under CONFIG_RFS_ACCEL.
> Ethtool stats which access those need to be as well.
>
> Reported-by: kbuild test robot <lkp@intel.com>
> Fixes: ca70bd423f10 ("sfc: add statistics for ARFS")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Thanks for catching this, mea culpa for not testing that case.
-Ed
