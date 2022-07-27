Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE94F5834D6
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 23:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbiG0V2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 17:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiG0V2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 17:28:13 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76695C9E1;
        Wed, 27 Jul 2022 14:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1658957243;
        bh=8WOt+MYJ3RGaGTSXP0En/MlzifF8rqzSSeHA0bFuetk=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=DjRfw7fds+VkeaO2dOWU3xPCs3MpDFt7ZxgTassG2qCHwsipN7zmPw+wmOWmRv6vM
         MK+mUT8HADAVcm3gGdeGmGqygrlOceqtjMkiviPSeZJWjjYX9i8U2GXaPNX3/2wCq+
         oQbXjVS6WXP/skDdnBpMuflFu/cCl0XdBnpP0eAE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [127.0.0.1] ([80.187.106.185]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M4axq-1oISir0mHe-001eeL; Wed, 27
 Jul 2022 23:27:23 +0200
Date:   Wed, 27 Jul 2022 23:26:21 +0200
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?ISO-8859-1?Q?Ren=E9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_Aw=3A_=5BRFC_PATCH_net-next=5D_dt-bindings=3A_net=3A_?= =?US-ASCII?Q?dsa=3A_mediatek=2Cmt7530=3A_completely_rework_binding?=
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <f8ccb632-4bca-486b-a8a4-65b6b90de751@arinc9.com>
References: <20220726122406.31043-1-arinc.unal@arinc9.com> <trinity-96b64414-7b29-4886-b309-48fc9f108959-1658953872981@3c-app-gmx-bs42> <f8ccb632-4bca-486b-a8a4-65b6b90de751@arinc9.com>
Message-ID: <0426AFB2-55B6-48E6-998F-8DA09D0BDC29@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:M7TIcaKGplOm/U/51BEaDo9eQd6CP5ebaIhOTpjSvBoqjZn1Laa
 hoyLDsYoLH0uFojZMwEapLh+7Osyu7N1VjOx61ECfn6j/g8wMyOQiImlf4c1M6j3qw6Agpx
 PXMn/65C6WAjx0GlxDQp8CERVPouu37r4dBuGBBtGZlJJBcDs7Ef8tXxtk78rEnZ7J3clvq
 tdokMFGLJwxv5WSoqXqHg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1JyOrsDr/ZQ=:yeW1+6p3Q2s1CRpLbyBJCf
 rbetOwGIj+xndrmaoJToSLcglGQKgUuGaAyczAWlIJ3n8/72JtzZSSHwEapDg54JQM8HS8DbR
 nUB0bqfaCR0J7S+PuNGZwTyEn29dVL/Djk2W6QeG5PzCKwi3fBdKDPUYq6CFNE3IiaEBcQ9Dy
 +GYiXcWzU33B0jOY436RbYX6wbLcVTTvSvHoYVmCE5UP68ElJTJzRe8u+1mLJLd/+B7g1nSFz
 Zj8Pr7kdq3/0Ri6HYsVzR3IjF1wikUL0g4vfxzRdCAnkRA15CHaIv0iz5WIisjg/noddcnsia
 ZuHNtjAlFS4bTF2FtThB37JQ2NinJBTY9pwKLvLEopjixYhVKgdVSEb6Qig7eSrP0yFP8FY3i
 7zoOJEZ+eTvWJtup5A4QoMRSo4FbEcPuwaG38QJ2DKfkn8WymUy8jjwKzVaxOC6rw0bh78wWA
 5CvUn8a2WixSn+5OPqP3R8TiNDse9Oarn/5scJBWhaceb43JmNaZD6yZMjtUzLTibJp6UBPJo
 rvRFZnLOQ+FRVutm0OMTmuPwrOzLckyMbQTyAhx1zJs1M1fYvBX52Dp/j5aggAE+Um9eqE75x
 pFm2uKTlGIYVUhcKNr6ylqbthCQP78c4efPipggdUYBQZ/oA2pWPw9OKnwlo6rju5OUIcSOcR
 /RwqhKAisAkLNw6UZGi2UMZW8v/Bs1EQ/kQ1ez4cNUtiBbkGRI9QPrx+16ma11REA+/GC9/Lq
 0tQEr8fRpl8x2YIPB7HeX4dplHup0EWCokhidXGfL4aiYhalhiPdAyzD+S1aK2Ly1V8BGWxBo
 RmvvfoMG9bVZZFEp0j3MynIcwEALQH1tbw5/X6PZPRlHcJ2TpIu31TQcDOe7sn4SM/9PW31SO
 S2qMdwCJfbhOWgucRwFO85cJPTwdh2KNW0xPOM8120S6VncuMNmiB2Yb6gJiFJREQOGBmKJ+S
 KOGmy/YgLFVEKOSW2bR6cdQPZ49xNG1dLsJ2saH1nHRIWmI5C4mzYIxm1jLQ0eIwRbDkxufev
 +nhvMVAuXtYypve/9N3kd1s6b4+jzHHKdWP6DFZCUxFzDRKWubgP2MAkC4nFKI0PR8VcGn4cR
 d0yd4ueDIJffwXMw35Ze0hs/VL4s5wFw+LCgYBSY8Z/5aDlxw3RAMZpNQ==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 27=2E Juli 2022 22:59:16 MESZ schrieb "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arinc=
=2Eunal@arinc9=2Ecom>:
>On 27=2E07=2E2022 23:31, Frank Wunderlich wrote:
>>=20

>I've seen this under mt7530_setup():
>The bit for MHWTRAP_P6_DIS is cleared to enable port 6 with the comment "=
Enable Port 6 only; P5 as GMAC5 which currently is not supported"=2E
>
>https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/netdev/net-next=2Egit=
/tree/drivers/net/dsa/mt7530=2Ec#n2189

Later in same function it looks comment is obsolete=2E

https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/netdev/net-next=2Egit/=
tree/drivers/net/dsa/mt7530=2Ec#n2234

 I know that rene added p5 support while phylink conversion,but not sure i=
t was complete=2E

regards Frank
