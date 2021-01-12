Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5382F2B28
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390484AbhALJUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:20:38 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:36672 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732377AbhALJUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:20:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1610443066;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:From:
        Subject:Sender;
        bh=1mjQlQ48bblead7QmUHUNYxJvOehWMjF68FlUPNTbm8=;
        b=ci8ZLVpR/wlykiwRwY9GCrwrzZFxVLhxnpz9+clJ1CnxCUIwASmO35BufDKe9K1PKU
        kP0JjdBUGQBuKlEEDcAVY+S+wkJFxr9OEhdzvOPYbufsKfdC5wsHHciSxPv6Il8dkown
        m7lGrM8BLr1y4yu22E2bmff95UmUYaredb/P9g93OExt2twKBfId8SkoOiShIboDmVsp
        6aX4N3DC/7NagdIaT5J63BJiq5i5ZLg1Zk4zxULIOWUcMie9bSs2nqbL188gdKI/R1Yt
        1V/H2ZBKkXhkopEJVBxoJEB/QzMuMo4RKQSG2whIpyUg1INJCHPod9MHEG2zXkh/H7Gw
        ZlBQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR9J8xty10="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.12.1 SBL|AUTH)
        with ESMTPSA id k075acx0C9HfKUx
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 12 Jan 2021 10:17:41 +0100 (CET)
Subject: Re: [PATCH] can: isotp: fix isotp_getname() leak
To:     Marc Kleine-Budde <mkl@pengutronix.de>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com
References: <20210112090457.11262-1-socketcan@hartkopp.net>
 <6c2550bd-0e58-c300-c830-94d38b6ab7c9@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <cc5729d2-1301-6ca6-3847-f7bda9028583@hartkopp.net>
Date:   Tue, 12 Jan 2021 10:17:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6c2550bd-0e58-c300-c830-94d38b6ab7c9@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12.01.21 10:12, Marc Kleine-Budde wrote:
> On 1/12/21 10:04 AM, Oliver Hartkopp wrote:
>> Initialize the sockaddr_can structure to prevent a data leak to user space.
>>
>> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
>> Reported-by: syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Can you add a Fixes: tag?

Yes, of course.

Sent out a v2 with Fixes: tag.

Best regards,
Oliver
