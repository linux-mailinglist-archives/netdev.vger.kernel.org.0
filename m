Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47066D0774
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjC3N6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjC3N6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:58:33 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6CF4213
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1680184695; i=frank-w@public-files.de;
        bh=DGqqdU8ytWBHqsgypG2qymjakx1aR/BTD3lbkT1PnBE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=j4+PtC9PNpytFg/Cu0cgVxej6IJ+ay0khy8wkZ8HCB5NeVpqRntdSzMoRlmOURaax
         ZKxYFU7UNXsSv5uv+hF+uoJuMfn8dthL/icIZA3NhgqZIIRyJCOqyUbxK5iy7aBhH8
         YLbjOKe78dNPl5R6TxChf5d03iLBQpk6uDFyoYqJPoGjJmmok5mzAPrB6h1fr7acX3
         f5VrCYlU0hZy/NUSdEEfYy2Zne1nVzZmAQFo6YkXsu4+FBKSgJnERP1F0VyCgr08Rx
         rbSxRUDxzozafd7L9AcJg9KAOB0021cqIVgiFrON8sHT4/vwrAiTyPhwC0rYJr8l/B
         rS3HeqC68YggA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [157.180.227.161] ([157.180.227.161]) by web-mail.gmx.net
 (3c-app-gmx-bap58.server.lan [172.19.172.128]) (via HTTP); Thu, 30 Mar 2023
 15:58:15 +0200
MIME-Version: 1.0
Message-ID: <trinity-283297c1-e5fc-4d90-9f4b-505ebf8c82cb-1680184695162@3c-app-gmx-bap58>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Aw: Re:  Re: Re: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix tx
 throughput regression with direct 1G links
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 30 Mar 2023 15:58:15 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <8bb00052-2e12-9767-27b9-f5a33a93fcc8@nbd.name>
References: <20230324140404.95745-1-nbd@nbd.name>
 <trinity-84b79570-2de7-496a-870e-a9678a55f4a4-1679736481816@3c-app-gmx-bap48>
 <2e7464a7-a020-f270-4bc7-c8ef47188dcd@nbd.name>
 <trinity-30bf2ced-ef19-4ce1-9738-07015a93dede-1679850603745@3c-app-gmx-bap64>
 <4a67ee73-f4ee-2099-1b5b-8d6b74acf429@nbd.name>
 <trinity-6b2ecbe5-7ad8-4740-b691-8b9868fae223-1679852966887@3c-app-gmx-bap64>
 <956879eb-a902-73dd-2574-1e6235571647@nbd.name>
 <trinity-79a1a243-0b80-402f-8c65-4bda591d6aa1-1679938094805@3c-app-gmx-bs30>
 <8bb00052-2e12-9767-27b9-f5a33a93fcc8@nbd.name>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:q7//H2JA6wy09wi+FXr/zgcVxd6Bvn0mUZ6wVPnkcaOtG8/vIkSzlzXgC01ac0RwRYAMb
 wLomCS6+S91YHa1FuS35aQh76azbYDg26o65oTcqm+bKhNKXr/37f3UjW32W/cXhqKXT7IBM3x3H
 FZX2X8WzESXnyrcjiSwQUk00IljuacyGbrvx9FF7CpguEusI53p1adxmJiXgHvV29oc4Z1sc/WOn
 EhbCCVtPxRwmkJiZ7PSRRbGgb+GkYe4DlF5qvUu9aXZc0W3GjCViA25qSr1VQichWBDeFQJsxsDi
 D8=
UI-OutboundReport: notjunk:1;M01:P0:hJIqzHzSxdE=;P7NqyBVf1tn9Msy3GSnzmzMEnkc
 f6lg4sc8sp2QN2nhX/NrhAWR3OKaSZsHXgHCJ2+umMhiEYyCHX03yuywQUWozVko0sBQTPOdl
 zemo5QLVNQaqiz0tjYIwosw3nC8b+n3t3/nBi02wEbtoXr7sF7niUCzAWvz/15ytSIfbK1yQm
 GOx4n1KS63GkvUx7BWy4sjT50F+G4nmacfrwjC/2kz7Hm3TsUgLv5Sa5961trXsqyySDAPX5a
 zgw/UT7U7k6lKop+zgRGrOFa1VZud7iEZldgFssai2SAdeOBMK50n+5AOzberBDyK+4EhsAN7
 m4iiKdBZsoyXahLWtAH5ojb7/rk+S1XZqdScUlWXAISOUjwDKXKaTleE+oZ+5gT7eZh2XNPAM
 I3lgaLE259ZrljflYyH4odIt4ZGmdoaXWIi96+Bfawl8TfToRm+hFSrFUHHAP9Y/n30f1rasE
 VywWxQvmIuF8k96z7emYGjyj5NsTlHAl8TsemtFzjKJBUokiFbZik7+cmVUxt1CHDy47ZkLo/
 ziIT5jyId3+PKk1Swx5kCS1oehYPMupB963TEBqY+8NSmxKME+GWWji/lHucd02UJ9qy8FXGr
 KjLFQmA9a2p2cbbUGY3P5jr1WCbd3ImVeIlc/nSEhN046+hxL1T/1Ycly4AVIFma43ROyy3W9
 ebwl1ze2vEtPKUovd1ZhC93J3NQ3vRYi148FCgqIAUpUILsy34SYvUY/Vx7kvCZQsFKn6sZAF
 PfkUfY00p7ZGM6DuKn9XPt832SawuXzYBiKhtmfkp/uN765cS/eRJ5qGPGuwpx2WKia9JeZuM
 a5y1iV3tZTXcKlBxpagf6tgQFRkAfcXumoJn8lHlMHFnA=
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

something ist still strange=2E=2E=2Ei get a rcu stall again with this patch=
=2E=2E=2Ereverted it and my r2 boots again=2E

[   29=2E772755] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[   29=2E778689] rcu:     2-=2E=2E=2E0: (1 GPs behind) idle=3D547c/1/0x400=
00000 softirq=3D251/258 fqs=3D427
[   29=2E786697] rcu:     (detected by 1, t=3D2104 jiffies, g=3D-875, q=3D=
29 ncpus=3D4)
[   29=2E793308] Sending NMI from CPU 1 to CPUs 2:
[   34=2E492968] vusb: disabling
[   34=2E495828] vmc: disabling
[   34=2E498587] vmch: disabling
[   34=2E501433] vgp1: disabling
[   34=2E504426] vcamaf: disabling
[   39=2E797579] rcu: rcu_sched kthread timer wakeup didn't happen for 994=
 jiffies! g-875 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[   39=2E808619] rcu:     Possible timer handling issue on cpu=3D1 timer-s=
oftirq=3D493
[   39=2E815487] rcu: rcu_sched kthread starved for 995 jiffies! g-875 f0x=
0 RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D1
[   39=2E825571] rcu:     Unless rcu_sched kthread gets sufficient CPU tim=
e, OOM is now expected behavior=2E
[   39=2E834520] rcu: RCU grace-period kthread stack dump:
[   39=2E839564] task:rcu_sched       state:I stack:0     pid:14    ppid:2=
      flags:0x00000000
[   39=2E847928]  __schedule from schedule+0x54/0xe8
[   39=2E852472]  schedule from schedule_timeout+0x94/0x158
[   39=2E857619]  schedule_timeout from rcu_gp_fqs_loop+0x12c/0x50c
[   39=2E863467]  rcu_gp_fqs_loop from rcu_gp_kthread+0x194/0x21c
[   39=2E869135]  rcu_gp_kthread from kthread+0xc8/0xcc
[   39=2E873931]  kthread from ret_from_fork+0x14/0x2c
[   39=2E878639] Exception stack(0xf0859fb0 to 0xf0859ff8)
[   39=2E883690] 9fa0:                                     00000000 000000=
00 00000000 00000000
[   39=2E891864] 9fc0: 00000000 00000000 00000000 00000000 00000000 000000=
00 00000000 00000000
[   39=2E900037] 9fe0: 00000000 00000000 00000000 00000000 00000013 000000=
00
[   39=2E906645] rcu: Stack dump where RCU GP kthread last ran:
[   39=2E912125] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6=2E3=2E0-rc1-b=
pi-r2-rc-net #2
[   39=2E919518] Hardware name: Mediatek Cortex-A7 (Device Tree)
[   39=2E925082] PC is at default_idle_call+0x1c/0xb0
[   39=2E929698] LR is at ct_kernel_enter=2Econstprop=2E0+0x48/0x11c
[   39=2E935267] pc : [<c0d105ec>]    lr : [<c0d0ffa4>]    psr: 600e0013
[   39=2E941527] sp : f0861fb0  ip : c15721e0  fp : 00000000
[   39=2E946746] r10: 00000000  r9 : 410fc073  r8 : 8000406a
[   39=2E951964] r7 : c1404f74  r6 : c19e0900  r5 : c15727e0  r4 : c19e090=
0
[   39=2E958486] r3 : 00000000  r2 : 2da0a000  r1 : 00000001  r0 : 00008cf=
c
[   39=2E965007] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segm=
ent none
[   39=2E972138] Control: 10c5387d  Table: 84f4806a  DAC: 00000051
[   39=2E977878]  default_idle_call from cpuidle_idle_call+0x24/0x68
[   39=2E983805]  cpuidle_idle_call from do_idle+0x9c/0xd0
[   39=2E988863]  do_idle from cpu_startup_entry+0x20/0x24
[   39=2E993921]  cpu_startup_entry from secondary_start_kernel+0x118/0x13=
8
[   40=2E000457]  secondary_start_kernel from 0x801017a0

maybe i need additional patch or did anything else wrong?

still working on 6=2E3-rc1
https://github=2Ecom/frank-w/BPI-Router-Linux/commits/6=2E3-rc-net

regards Frank


> Gesendet: Mittwoch, 29=2E M=C3=A4rz 2023 um 14:04 Uhr
> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> An: "Frank Wunderlich" <frank-w@public-files=2Ede>
> Cc: netdev@vger=2Ekernel=2Eorg, "Daniel Golle" <daniel@makrotopia=2Eorg>
> Betreff: Re: Aw: Re: Re: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix=
 tx throughput regression with direct 1G links
>
> On 27=2E03=2E23 19:28, Frank Wunderlich wrote:
> >=20
> >> Gesendet: Sonntag, 26=2E M=C3=A4rz 2023 um 22:09 Uhr
> >> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> >> On 26=2E03=2E23 19:49, Frank Wunderlich wrote:
> >> >> Gesendet: Sonntag, 26=2E M=C3=A4rz 2023 um 19:27 Uhr
> >> >> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> >=20
> >> >> On 26=2E03=2E23 19:10, Frank Wunderlich wrote:
> >> >> >> Gesendet: Sonntag, 26=2E M=C3=A4rz 2023 um 17:56 Uhr
> >> >> >> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> >=20
> >> >> >> On 25=2E03=2E23 10:28, Frank Wunderlich wrote:
> >> >> >> >> Gesendet: Freitag, 24=2E M=C3=A4rz 2023 um 15:04 Uhr
> >> >> >> >> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> >=20
> >> >> >> > thx for the fix, as daniel already checked it on mt7986/bpi-r=
3 i tested bpi-r2/mt7623
> >> >> >> >=20
> >> >> >> > but unfortunately it does not fix issue on bpi-r2 where the g=
mac0/mt7530 part is affected=2E
> >> >> >> >=20
> >> >> >> > maybe it needs a special handling like you do for mt7621? may=
be it is because the trgmii mode used on this path?
> >> >> >> Could you please test if making it use the MT7621 codepath brin=
gs back=20
> >> >> >> performance? I don't have any MT7623 hardware for testing right=
 now=2E
> >=20
> >> > used the CONFIG_MACH_MT7623 (which is set in my config) boots up fi=
ne, but did not fix the 622Mbit-tx-issue
> >> >=20
> >> > and i'm not sure i have tested it before=2E=2E=2Eall ports of mt753=
1 are affected, not only wan (i remembered you asked for this)
> >> Does the MAC that's connected to the switch use flow control? Can you=
=20
> >> test if changing that makes a difference?
> >=20
> > it does use flow control/pause on mac and switch-port, disabled it, bu=
t it does not change anything (still ~620Mbit on tx)
>=20
> I finally found a MT7623 device in my stash, so I could run some
> experiments with it=2E For some reason I could only reproduce your tx
> throughput values after switching off TRGMII=2E With TRGMII enabled, I g=
ot
> around 864 Mbit/s, which is of course still lower than what I get with
> shaping disabled=2E
> I also experimented with bumping the shaping rate to higher values, but
> got no changes in throughput at all=2E
> Based on that, I'm beginning to think that the shaper simply can't
> handle rates close to the MAC rate and runs into a fundamental limit
> somehow=2E
> Now that I think about it, I do remember that shaping to 2=2E5 Gbps on
> MT7622 also reduced link throughput=2E
>=20
> I think we should simply use this patch to deal with it=2E Do you agree?
>=20
> - Felix
>=20
> ---
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec
> @@ -753,6 +753,7 @@ static void mtk_mac_link_up(struct phylink_config *c=
onfig,
>   		 MAC_MCR_FORCE_RX_FC);
>  =20
>   	/* Configure speed */
> +	mac->speed =3D speed;
>   	switch (speed) {
>   	case SPEED_2500:
>   	case SPEED_1000:
> @@ -3235,6 +3236,9 @@ static int mtk_device_event(struct notifier_block =
*n, unsigned long event, void
>   	if (dp->index >=3D MTK_QDMA_NUM_QUEUES)
>   		return NOTIFY_DONE;
>  =20
> +	if (mac->speed > 0 && mac->speed <=3D s=2Ebase=2Espeed)
> +		s=2Ebase=2Espeed =3D 0;
> +
>   	mtk_set_queue_speed(eth, dp->index + 3, s=2Ebase=2Espeed);
>  =20
>   	return NOTIFY_DONE;
>=20
>=20
>=20
>
