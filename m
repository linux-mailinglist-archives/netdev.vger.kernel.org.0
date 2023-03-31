Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DCA6D20C0
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjCaMrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjCaMrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:47:10 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC7D20638
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 05:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1680266792; i=frank-w@public-files.de;
        bh=sSQIBU/bd2zswxflHAWghguXAVKiF6qeZSypPn6UPnw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=NqQt9bmfY4/V8yBHKtHTdbEyPFGnQeLjSHTKyCYzz6rAy6R4zJdWpZZcBd1moNwuU
         O4/j30j5N+qyXleowE95comdSoLHUaQGd5Gu0TzyZMIkRvsRbyGF2ESB9ujEgffsxn
         YolL+7wfk0vA3WK1WFiBcqK51rCd41G/WgnIMZeFYOXRhzVWn/zKJT+ebdrLspRqGk
         Rwi36Je8VeXr5Wi3Gp4aB2rdFmKorUAnfuIBrZW2rejHnc1UR19S1YapwFbOejoJ0j
         hZrHEgC6Gp4H52L+8dZS1RPbYSRNCsDddlz3jxfpXgmMbh9npEyTOSnVkAauBvusyj
         njMh3oAXZ4nQQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.79.69] ([80.245.79.69]) by web-mail.gmx.net
 (3c-app-gmx-bap64.server.lan [172.19.172.134]) (via HTTP); Fri, 31 Mar 2023
 14:46:32 +0200
MIME-Version: 1.0
Message-ID: <trinity-41b05a18-568d-44eb-9d8d-c39b7afc9ea3-1680266792272@3c-app-gmx-bap64>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Aw: Re:  Re: Re: Re: Re: [PATCH net] net: ethernet: mtk_eth_soc:
 fix tx throughput regression with direct 1G links
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 31 Mar 2023 14:46:32 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <2e778829-d2a9-3606-3769-e50ab23836dc@nbd.name>
References: <20230324140404.95745-1-nbd@nbd.name>
 <trinity-84b79570-2de7-496a-870e-a9678a55f4a4-1679736481816@3c-app-gmx-bap48>
 <2e7464a7-a020-f270-4bc7-c8ef47188dcd@nbd.name>
 <trinity-30bf2ced-ef19-4ce1-9738-07015a93dede-1679850603745@3c-app-gmx-bap64>
 <4a67ee73-f4ee-2099-1b5b-8d6b74acf429@nbd.name>
 <trinity-6b2ecbe5-7ad8-4740-b691-8b9868fae223-1679852966887@3c-app-gmx-bap64>
 <956879eb-a902-73dd-2574-1e6235571647@nbd.name>
 <trinity-79a1a243-0b80-402f-8c65-4bda591d6aa1-1679938094805@3c-app-gmx-bs30>
 <8bb00052-2e12-9767-27b9-f5a33a93fcc8@nbd.name>
 <trinity-283297c1-e5fc-4d90-9f4b-505ebf8c82cb-1680184695162@3c-app-gmx-bap58>
 <2e778829-d2a9-3606-3769-e50ab23836dc@nbd.name>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:aNXA8LjzEwnlMFfybmdqmksoo/cHXsjKkw02GF1gDkZmqv4GWf/zzEC8Y9DcssaF9toMD
 T/0XPjcJrBheImNQd6f+3GrHnRNUQIKPgZoeBp5nxw+Y4vEEzcf3LzxEgstKXy6+6YF2IwjACiRC
 8unLMC5QZW0m7cGbGD7+PxVjUqKOTUyNsYaYqfQ32ycPV6DelPGOn6R7X2EqKCoToZp9YtOmnANG
 wwi8NzG/VFfFTqyyxCmdC1TVe/efDQehQNsr+hi0FCjnjkrsiA9tGtyCGux49K+wCH7tV8e4f4KI
 M8=
UI-OutboundReport: notjunk:1;M01:P0:YjFcfmRx2Y4=;S8gVIhp5yk8/uAz/1fOjNXMVhsZ
 GFX60Y1dtHYf7zp6iRfubVmHtAmUiG9APSvknEq/M9Ti6L3qzU6nInQCbYA78aDtmG1Vu/OI6
 67w8noLFfl5Y8lJeKhUtM4rUtdbM7vmfHsFjFJrszAhtVlATaG5Esup1X9hNEWIwKMTBDDjkn
 rv1XMCFsZMqV76W/W4MMWqq6USfcs/vIFOO16R3aYPjlO53ho/ibghLjD/HS99ES5bw4sIMgK
 Wmj97k0X/Ol5EktH2RV8IErKjK2OmS7Gwe/SI30/X4AF7MAG/jCHkZZSzesf7Lx957q0xSqK0
 9YJqMagA2efOUUJPj/mB0m7Juse0zZ8nNgP/litpcsSUWVx061TAI31y7h3ddn/lcIjaraAjd
 0blFo7a1D7TG5HKJMngkq3M9QIMZP3p9ePMmqoSwehem75N+2HbcRQ35KsPvc36pXqMN44/ea
 nHeTf/FbDA9NijPOQHYOjY5Zvegf2AdlXOxRuVNMJHTjqGPgnljFB0t0BqHLqUdkjGcY0Ftzt
 nUJYlUEMHt6bRzKSIZ40nK4KSZWdGfTyZa+Pa0JONiLMoEXKPsMIwLrQCMkcj2nQbtKrV9710
 mLGdNNLVyTrrrhmtbayc3uYyUBQuBNq8LuqDdKfH09iLPCULBtj72SLUMnkm3E4YuYaG66LH3
 C4vOR3Mq7CEG0SXimGq2gsP6lSkiObrdIkE9Vjibbjg09ZEHLYVMXzyM4fKxT/DQ2PGbqPj75
 iZORTK1x1hNYz+TShdVAh9tjF6H17rAOv5XvyPxsr6NhPpnZyeAcmBeg5w5gWw5SNVXh7Rvb4
 ZCYa7AnMvN9WqRiT9Q4jKJBQpfYzN09yDAMpFfw9iPQe8=
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



regards Frank


> Gesendet: Donnerstag, 30=2E M=C3=A4rz 2023 um 19:06 Uhr
> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> An: "Frank Wunderlich" <frank-w@public-files=2Ede>
> Cc: netdev@vger=2Ekernel=2Eorg, "Daniel Golle" <daniel@makrotopia=2Eorg>
> Betreff: Re: Aw: Re: Re: Re: Re: [PATCH net] net: ethernet: mtk_eth_soc:=
 fix tx throughput regression with direct 1G links
>
> On 30=2E03=2E23 15:58, Frank Wunderlich wrote:
> > something ist still strange=2E=2E=2Ei get a rcu stall again with this =
patch=2E=2E=2Ereverted it and my r2 boots again=2E
> >=20
> > [   29=2E772755] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> > [   29=2E778689] rcu:     2-=2E=2E=2E0: (1 GPs behind) idle=3D547c/1/0=
x40000000 softirq=3D251/258 fqs=3D427
> > [   29=2E786697] rcu:     (detected by 1, t=3D2104 jiffies, g=3D-875, =
q=3D29 ncpus=3D4)
> > [   29=2E793308] Sending NMI from CPU 1 to CPUs 2:
> >=20
> > maybe i need additional patch or did anything else wrong?
> >=20
> > still working on 6=2E3-rc1
> > https://github=2Ecom/frank-w/BPI-Router-Linux/commits/6=2E3-rc-net
> Can you try applying this patch to a stable kernel instead? These hangs=
=20
> don't make any sense to me, especially the one triggered by an earlier=
=20
> patch that should definitely have been a no-op because of the wrong=20
> config symbol=2E
> It really looks to me like you have an issue in that kernel triggered by=
=20
> spurious code changes=2E

Hi,

have applied it on top of 6=2E2=2E0 which has the "implement multi-queue s=
upport for per-port queues" in, and indeed it fixes the problem on mt7623=
=2E

thx for the fix, you can send it with my tested-tag

Tested-By: Frank Wunderlich <frank-w@public-files=2Ede>

regards Frank
