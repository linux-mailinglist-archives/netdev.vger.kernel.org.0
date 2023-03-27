Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105C66CABD6
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjC0R2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjC0R2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:28:19 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFB1A4
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1679938094; i=frank-w@public-files.de;
        bh=dgsSaoTCDVqAOaD/aUsPkrY8Ic1ce9KA9wmnTbdDwGY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=J1ulP4/U0Leqsowbj/grWZDPUvHJbjbXa3dLsSVpckoxGIXSTtBpAaPRCE/BOIehy
         MP+IKeDND+ryPXuET/vFgUAu8HaGjQygy2frMLGHucu0YSUPnLlEuIX725Z4uMeWzS
         yRzQzObt4DyoZdFaZWxHz+rFeBADK4J2iBlURtjhXr0mtWFuQYbL105wfFZ2EGLH0h
         fbSow30R9URXyu72v1XXIvDp9zoFaJSkqE5JMGqo/CMbI5O2cIGSar/b3TiHfDGvtj
         bpfNn+W/0kik/IaGhqyP5P5cSFisobSOgmE2e63eANDsuRbU+VEVIr2HZepSLy7Bex
         MJzMZJqS1AF+g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.145.97] ([217.61.145.97]) by web-mail.gmx.net
 (3c-app-gmx-bs30.server.lan [172.19.170.82]) (via HTTP); Mon, 27 Mar 2023
 19:28:14 +0200
MIME-Version: 1.0
Message-ID: <trinity-79a1a243-0b80-402f-8c65-4bda591d6aa1-1679938094805@3c-app-gmx-bs30>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Aw: Re:  Re: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix tx
 throughput regression with direct 1G links
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 27 Mar 2023 19:28:14 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <956879eb-a902-73dd-2574-1e6235571647@nbd.name>
References: <20230324140404.95745-1-nbd@nbd.name>
 <trinity-84b79570-2de7-496a-870e-a9678a55f4a4-1679736481816@3c-app-gmx-bap48>
 <2e7464a7-a020-f270-4bc7-c8ef47188dcd@nbd.name>
 <trinity-30bf2ced-ef19-4ce1-9738-07015a93dede-1679850603745@3c-app-gmx-bap64>
 <4a67ee73-f4ee-2099-1b5b-8d6b74acf429@nbd.name>
 <trinity-6b2ecbe5-7ad8-4740-b691-8b9868fae223-1679852966887@3c-app-gmx-bap64>
 <956879eb-a902-73dd-2574-1e6235571647@nbd.name>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:j8ni4FCgv/uwYIwtbC7WoWxpznHi/Ck/lkj9MVFMP6oIDqBw8LDPauGuITUFkPG54xn8x
 e1DanQak30JvBezkmOAwV7VAiCuQ7QPYr8uJV1TZYS28n6TRQNQpFEWxnyeyzuEcWc3Ig2qpSEc4
 sTgw3R1Hy/Frp2kSb1mw7RGNYn5MZYpAUUdc+X9AzZCzniL5rDkn/deV7yQ8yVCskw3KW+8IUMfG
 CQgU2kFnS2arSzXxx2QD8Vxe0IBDIqQJyHMfh1rowl9qoGzLPKRJAjOA4IpGEOH3ZGqiQYxrUYXU
 pk=
UI-OutboundReport: notjunk:1;M01:P0:q/+EUb73+lQ=;9sRnYz90zngCsHoqUmTLlo3CVro
 QWlKttlZyt3jn5O9T9izxXRLWjqRCSuDQ82nBlaMEI5rQ3e2Bi208bEhq4gaS245BqZz62XnH
 ZiR6UQmTv4rivlOmNmn+hv6IRyw8j2Zp0RglKEPNCBYQSVsla8QbFJU9N2gj38JVmyaA6zGI4
 hJnG+0oe15VUNtnDkFGf+yAk7HdzSuHzI2ENRhH4iGqTi3pHtMGA6GN+6NUtEVLhpsTJl7P92
 fJKtnWHXhuR0zJ2At+gSTQ8ydNKYm5z5KUEVUetJ2ijIa8qmRL1RpBwAfN7UtUq4zk+BrcR1K
 p7kMLqn1uuiuSiayM0Uytx0ekSlNC4fbSjicTFoGx85nUYvTRaB1RBjFdPCJ4EgKciJQ8/yXV
 9o2RLKx1PPyOa6CvQrYHAFKCITyOcuStk+6seJR28UHJCULROwHlXatljjMyiPrTwMlSvbpUO
 GVCdavzWK9x2XPHvUfzE4ptXmbTbb0Kyzi497As5KfUGfWBY24o/ChDRLKU6Hx2Jp0KwPOljM
 Il+WwfisyRiv3vm8pcXA3tfTYvMuTgSITDMwiKHfDokU0R5U8psxwV/zG+4oVXTNYybZ6FpWQ
 luYFxz43NC/QUbVR9YZI8QVdMlrQ3H6loPjSJWkB2Y8q1jabMb0LUySDq+Ylr2v7KEgvYXmMo
 SE7dkAH+bwmTGy49k4TmyQjo4LKux/W1MPsIpJJpEBX4a7UCXLCyPB+UTu8n7tiI0UUuvS1y+
 obOFScdRYpl+MJZQOKPwBN99zANGO7yCUWr98ovl124uagyz91rr+KkN6dlzqWDBxxqg+hl7r
 kDVuFnGwkGq2YBfLiLe6vesfbXkMgAhdQHlA7wPrq6ekM=
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Gesendet: Sonntag, 26=2E M=C3=A4rz 2023 um 22:09 Uhr
> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> On 26=2E03=2E23 19:49, Frank Wunderlich wrote:
> >> Gesendet: Sonntag, 26=2E M=C3=A4rz 2023 um 19:27 Uhr
> >> Von: "Felix Fietkau" <nbd@nbd=2Ename>

> >> On 26=2E03=2E23 19:10, Frank Wunderlich wrote:
> >> >> Gesendet: Sonntag, 26=2E M=C3=A4rz 2023 um 17:56 Uhr
> >> >> Von: "Felix Fietkau" <nbd@nbd=2Ename>

> >> >> On 25=2E03=2E23 10:28, Frank Wunderlich wrote:
> >> >> >> Gesendet: Freitag, 24=2E M=C3=A4rz 2023 um 15:04 Uhr
> >> >> >> Von: "Felix Fietkau" <nbd@nbd=2Ename>

> >> >> > thx for the fix, as daniel already checked it on mt7986/bpi-r3 i=
 tested bpi-r2/mt7623
> >> >> >=20
> >> >> > but unfortunately it does not fix issue on bpi-r2 where the gmac=
0/mt7530 part is affected=2E
> >> >> >=20
> >> >> > maybe it needs a special handling like you do for mt7621? maybe =
it is because the trgmii mode used on this path?
> >> >> Could you please test if making it use the MT7621 codepath brings =
back=20
> >> >> performance? I don't have any MT7623 hardware for testing right no=
w=2E

> > used the CONFIG_MACH_MT7623 (which is set in my config) boots up fine,=
 but did not fix the 622Mbit-tx-issue
> >=20
> > and i'm not sure i have tested it before=2E=2E=2Eall ports of mt7531 a=
re affected, not only wan (i remembered you asked for this)
> Does the MAC that's connected to the switch use flow control? Can you=20
> test if changing that makes a difference?

it does use flow control/pause on mac and switch-port, disabled it, but it=
 does not change anything (still ~620Mbit on tx)

+++ b/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2=2Edts
@@ -182,7 +182,7 @@ gmac0: mac@0 {
                fixed-link {
                        speed =3D <1000>;
                        full-duplex;
-                       pause;
+                       //pause;
                };
        };
=20
@@ -235,7 +235,7 @@ port@6 {
                                        fixed-link {
                                                speed =3D <1000>;
                                                full-duplex;
-                                               pause;
+                                               //pause;
                                        };
                                };
                        };

regards Frank
