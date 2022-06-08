Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C92543AAD
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 19:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiFHRjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 13:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiFHRjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 13:39:39 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAA031DC6;
        Wed,  8 Jun 2022 10:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654709911;
        bh=SR1VTuMOXDTjsNlYicSw844o8AeTNjX000JV8bAUIic=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=L4P+F8gecA14ZeUYBilj1mn805fMy+4IuO5W8qlxvEmZVnea+1VpSkzBR3ZoIc+KK
         pTFseQic+GP2azKNjmb9LlWvRHItqIufW1cAHKCvblQpLjHElsk+/UuObfSDqMyMie
         TktnoD92HpwjJKlFp1l3D+vaqB2F6uIwkcdiK9t8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.76.43] ([80.245.76.43]) by web-mail.gmx.net
 (3c-app-gmx-bap09.server.lan [172.19.172.79]) (via HTTP); Wed, 8 Jun 2022
 19:38:30 +0200
MIME-Version: 1.0
Message-ID: <trinity-c7b8fdfa-11b4-4e5c-90d6-6dd96da1e2d2-1654709910860@3c-app-gmx-bap09>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     linux-mediatek@lists.infradead.org
Cc:     linux-rockchip@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Frank Wunderlich <linux@fw-web.de>
Subject: Aw: [PATCH v3 0/6] Support mt7531 on BPI-R2 Pro
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 8 Jun 2022 19:38:30 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20220507170440.64005-1-linux@fw-web.de>
References: <20220507170440.64005-1-linux@fw-web.de>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:b5vLgY6x8wk0IfFlmacN0mlyvljNM3lzBAp6gZ3YYSyGfOwKIWWsICLx3aTIAj3wYk/H5
 KVQ8p8tAQrEv3DQDo7PQzbkzWkokqRFf5VURxU6LUhBvPkAKZ9FZw3ZaXGypApq2yw2Ceb05qSGM
 XRJy/ooHfrCvcRmLD9Ke0/z1BvxnrEIlnadqGaoJ1UULJfp1IYpnx6rhukiqQ9/97t7RF/EBk44L
 sFcuSdyJtzl3S2x3tomYxVO9hsvM/5ek/0SO3qkAI58RWVUfRNVJl44Bu1VF36NtG8GHcyq7WKwL
 vI=
X-UI-Out-Filterresults: notjunk:1;V03:K0:Tsy9Ri02RQw=:VA5cKMITPNkPq9WTs/tyI5
 IjrtX4u3TO8GPfPqH+1pF6qOd/RzV5bHzcfPzolKqrEJegNSwOR9dRj11z4LI38lhFvcnmGR0
 XB8FVZM2QG8b3Q8t4QhZnkjw6viiWfwYAxQ98ij+WD4+LgI3nw6PI4brmkiOWww4oEO0inDGG
 9YloHncR2sFyBA5eBBGlLHzk6MzUjs/0m8ylNlLehz6Er50By1lF7JMVO4bAF0+upZfPzf7zX
 kJxoCLq3xjhdP21hWx7QWTVCKQOObDnxm7dHAUlXvxzHurGAmEhMdpeB3I59kImogpVtEqCyJ
 AYHEv1jo6He+6AI1JgA0Xm3k9bn4UTeSuINvJDLZ2QXNHXRtJzWNQFbS6AG3y82lZKFRNXast
 FTjc1TifJ8RpkrrkLVTvRginX7LjqJBJdsv2sLun6kZjRCf6ZFmNw4MTCmwdEIoyW4soi74nH
 PAzPg0Sfi/DgFp6WpztZpmLTIiZUD7ISQTNOM+tPfYMxR8lBwle894MCVvcge7kOfrokpcKyf
 zS5h3DyIvETKIvLWdE44K027QtM+lvqdGIz3l/VHAR8DIWPm2DTNJAm4AZr7Pxr5FS/JJTcAe
 gi8SSBK0BZjlNzJ7JKhe3F31W8RHOqLYKMRCd3hV7ccjCy+8adYSwSkmMn+RiyyTpAmgYOlCz
 8KfkD6OOFkcVrUeoyoNIPyCD5rFo1DJQf2BcOTB/bQumkAhPlHa+V6dyvOcipGdjZ2kMX8uty
 y2zow8tcV+TjBJDzaggVBQm1ein3QpSVMiDHkQSWJ7S3aay+x6lWp4lYTnz7JPTIy+lmJv/Jl
 YwcpfGn
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

just a gentle ping, is anything missing/wrong?

regards Frank
