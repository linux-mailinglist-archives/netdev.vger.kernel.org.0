Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4986CDA4B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjC2NRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjC2NRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:17:30 -0400
Received: from out28-225.mail.aliyun.com (out28-225.mail.aliyun.com [115.124.28.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D4F4203
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 06:17:12 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1270735|-1;BR=01201311R951S32rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.022501-0.000559395-0.97694;FP=0|0|0|0|0|0|0|0;HT=ay29a033018047194;MF=aiden.leong@aibsd.com;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.S20t8.-_1680095826;
Received: from eq59.localnet(mailfrom:aiden.leong@aibsd.com fp:SMTPD_---.S20t8.-_1680095826)
          by smtp.aliyun-inc.com;
          Wed, 29 Mar 2023 21:17:07 +0800
From:   Aiden Leong <aiden.leong@aibsd.com>
To:     edumazet@google.com
Reply-To: 20230328235021.1048163-1-edumazet@google.com
Cc:     davem@davemloft.net, eric.dumazet@gmail.com,
        kernelxing@tencent.com, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
Date:   Wed, 29 Mar 2023 21:17:06 +0800
Message-ID: <16988771.uLZWGnKmhe@eq59>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6631629.e9J7NaK4W3";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart6631629.e9J7NaK4W3
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Aiden Leong <aiden.leong@aibsd.com>
To: edumazet@google.com
Reply-To: 20230328235021.1048163-1-edumazet@google.com
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
Date: Wed, 29 Mar 2023 21:17:06 +0800
Message-ID: <16988771.uLZWGnKmhe@eq59>
MIME-Version: 1.0

Hi Eric,

I hope my email is not too off-topic but I have some confusion on how 
maintainers and should react to other people's work.

In short, you are stealing Jason's idea&&work by rewriting your implementation 
which not that ethical. Since your patch is based on his work, but you only 
sign-off it by your name, it's possible to raise lawsuit between Tencent and 
Linux community or Google.

I'm here to provoke a conflict because we know your name in this area and I'd 
to show my respect to you but I do have this kind of confusion in my mind and 
wish you could explain about it.

There's another story you or Tom Herbert may be interested in: I was working 
on Foo Over UDP and have implemented the missing features in the previous 
company I worked for. The proposal to contribute to the upstream community was 
rejected later by our boss for unhappy events very similar to this one.

Aiden Leong

> Jason Xing attempted to optimize napi_schedule_rps() by avoiding
> unneeded NET_RX_SOFTIRQ raises: [1], [2]
> 
> This is quite complex to implement properly. I chose to implement
> the idea, and added a similar optimization in ____napi_schedule()
> 
> Overall, in an intensive RPC workload, with 32 TX/RX queues with RFS
> I was able to observe a ~10% reduction of NET_RX_SOFTIRQ
> invocations.
> 
> While this had no impact on throughput or cpu costs on this synthetic
> benchmark, we know that firing NET_RX_SOFTIRQ from softirq handler
> can force __do_softirq() to wakeup ksoftirqd when need_resched() is true.
> This can have a latency impact on stressed hosts.
> 
> [1] https://lore.kernel.org/lkml/20230325152417.5403-1-> 
kerneljasonxing@gmail.com/
> [2] https://lore.kernel.org/netdev/20230328142112.12493-1-kerneljasonxing@gmail.com/
> 
> 
> Eric Dumazet (4):
>   net: napi_schedule_rps() cleanup
>   net: add softnet_data.in_net_rx_action
>   net: optimize napi_schedule_rps()
>   net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ
> 
>  include/linux/netdevice.h |  1 +
>  net/core/dev.c            | 46 ++++++++++++++++++++++++++++++---------
>  2 files changed, 37 insertions(+), 10 deletions(-)

--nextPart6631629.e9J7NaK4W3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEENSNFoSpoTSrmxF9vGvlck5mKYvIFAmQkOlIACgkQGvlck5mK
YvJwSAf/VsnlU7HdMJWNjJf2rN1tjQ/FejluAcz0qUcfIE+kpytVPREamHPTKwXz
2AhjmPqpvaT7NxEcjh0SHyu8Ba/18uC3EaZF2p0xTJym39Gn/rULUgO6BBhnI+n8
EnmSW3PHh7QyMnDA9vkbNv4P2ifMdVYRcBDOzi5EpdNUG6gsfeasuIdQUSX18VgK
yQFy6qFWA8ZlraH1rQPszV3k3fI0VZh+psPokb8YjXB4EuPnx5N2v56GUfM5iYtI
7yMSIMiUHwMak1zqAbtkMdIli2BkiNQvR1h85paVBJ42P8sHptey/ewuHBrbuU85
pIHxHacVMPuUIWrBH0sLNUgTrPGsag==
=9OU8
-----END PGP SIGNATURE-----

--nextPart6631629.e9J7NaK4W3--



