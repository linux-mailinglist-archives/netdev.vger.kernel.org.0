Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7C5360685
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 12:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhDOKG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 06:06:26 -0400
Received: from mout.gmx.net ([212.227.15.15]:57405 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231919AbhDOKGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 06:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1618481132;
        bh=+kUA0a4ZwMlKKIjn9JGeCEsofiYmSw4pSDq5hmtIq2I=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:To:CC:From;
        b=QuPPBRiENJoCcijPjvZcehy4ig2VOX3F66I2kOgs/vJFAbu8+rKBAGMfkS9y51vXB
         Qn5gDOQSDEvgZWUuNQ5EEFtH81pRpUqBh0iC6+KQptIxJ/1CigUqydmPRjMQR9EMfV
         8SSnKuex4gojzwa1SAAqkMBNtVSmJDEWCYsEXDh8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([80.245.79.33]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MQMyZ-1lBLGH0N3x-00MIeU; Thu, 15
 Apr 2021 12:05:32 +0200
Date:   Thu, 15 Apr 2021 12:05:26 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20210415094005.2673-1-dqfext@gmail.com>
References: <20210415094005.2673-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next] net: ethernet: mediatek: fix typo in offload code
To:     linux-mediatek@lists.infradead.org,
        DENG Qingfang <dqfext@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
CC:     Alex Ryabchenko <d3adme4t@gmail.com>
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <86DA3F5B-32B2-446B-B83D-AFDC5EE6BF53@public-files.de>
X-Provags-ID: V03:K1:PlTSyeEjvd5QpR+8/glb3oZRAAoeP/sVZ46rDI8ff51bte7qAzo
 0y2loCGZIEppur0KEOWHSPNx8Y9tDeluhuV/o4OqnexoiTupD728MW1s2fpWZKDBuxOvXfb
 C/vrQFUlaGuEhSHV/Gx7EM64seFRytvCQFMaQu8S9QIUd5pDZ2TZvfgBDdmNf9K6zt1bbxJ
 iuY9NS+J6LMaZX07t2W2A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LO/CZ9QTzDI=:TYoFxZWYwdEgCCGxcK3MPf
 i0vOKpwaIvIrvkV1M0tkhAKn7sKMGNM9MpwEM9N79U05yJ7fh7KDk6ytrZCeoTEkEeu/p9hUz
 zFUP+jIKSB7OkeKUGdF+HJEblIFk4jZknfZtUCtVVyA77U8gL6aVsV0Fd3TsJNCNvTHAbOVFN
 xYh1G+Je+q6EapArZY9YWSKJw+Za2MXSWZYcuqF3QJHwRm5RekNw1lSO5ihVcavLu4NNKW/hz
 fIXKxYK/h4VaPK2ZQ7l4JwrnK70w2MtKTeOUsN1KNRZ8GBqE7Z+hKUJBUD2yzrmiSQZ9ycD5M
 lUc/m7UGN7b4bC+Z0ODNfwdSm4f1ghEB7G0dCUffelaFN9x1mRhnFuuDoziX6hQneCKVt+CoS
 KenOiEcQt8w44+rJ8T9DpGvszeuC8MzOHZSF5/u/WV5XSxh8L0V0xlsAw3dyWa03figFU8Js1
 +8wSayeVS/hGr2KPxksqF/xIQ4GTg7cw7Meu9/LHvVwrMty//jzV+ItunAWrYBcqjztkqraMN
 oSUGTlxlYSdISUd9UZdtHRr+nIfSwtQVWcwvR1bIV0TQfnWEXG9dx+enkG0u9rhwiKztKppb5
 iNyydbFT5EqfR4Yz19WhIzukxwMZnH0aO5xrfXLO//Rz+FmeUER/hghpdGWoDxJQawi/WeJDr
 rszR7gnOwXj0HyQTDPwgQQ8bpEr8FVf6M5suG+EtMx2XXruZkdB1grvFX4f1GmnlF1m0aHfN4
 HmN086lOjt8gZocbSS8mB+pythc2ptrT8ZxuhyzBFubW2Tp0r2d+mgGYa4joZFhhDCu2XMfJ4
 IK+VPsx4dukuWSeI2P8IRUxbmoBETGdiYbKG9G0ZE1rmOtmqY4zFp7HLlkNCa/YJkIa5xYDVl
 r/XB4XLFkBupHKz0JLfMs1CgjsTXjdAhuNGupbi+nekHtj+siSV6pMdmbl+2tFs8/bWeF+blA
 LGZsR0wHfG1hix/WzpiHNuT0Ct59EUEmq6y/hQxorW7Gv3uYFx8Gp/ej6ivoaKqjp7r5ChNCJ
 +Sa4UKwUeYGQ91oCRcqNc4jOJsFR9KobtIqot9f3jNS7ZBwIpDu++c9fbIH+vRjdXcyN+C29D
 pAlOnygQnwO4m6rFW26M+b60irT9wQqUF+LWYIPQ6H8fnQ0M2BDMJAjfxcR88HKfwc4cozygB
 G6yaHjWcfuQR7Lg8CPSnnz4zCwQDsVplG8XQH+gTiuYhGtGsjWyzodKEAF/no2UMobZIYpyzf
 5eB6pZ2/vrYv3/I6K
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 15=2E April 2021 11:40:05 MESZ schrieb DENG Qingfang <dqfext@gmail=2Ecom=
>:
>=2Ekey_offset was assigned to =2Ehead_offset instead=2E Fix the typo=2E
>
>Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading
>support")
>Signed-off-by: DENG Qingfang <dqfext@gmail=2Ecom>

Thanks for posting the fix,but imho commit-message is not good=2E

Issue were traffic problems after a while with increased ping times if flo=
w offload is active=2E

It turns out that key_offset with cookie is needed in rhashtable_params an=
d head_offset was defined twice=2E
regards Frank
