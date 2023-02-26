Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5226A2F62
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 13:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjBZMM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 07:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBZMM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 07:12:28 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EADB47F
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 04:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1677413524; i=frank-w@public-files.de;
        bh=msrOUDb4gb/DHCW8OcEO9EJqNFQKh0I/nti6VFjZJW8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Bo/FdTbb7GKy/gaDZKlYVmC2Rnpsr3Hsnkyrfs73eYRI8NdDG1yjFhrO0Y6L4leRs
         +WapmeLrtaaPqvamXpy9TvKmbotQ/ZrDXfuGW0OEcDYLRbPEygecxvkfakPVFvEDCE
         wvVZeMNzYlWvwZQGeuNI+ShZzga0KmRov3OC0iIyoC6HKxZDvNcuOnhSKF0uj5Aa8q
         Bk+z2IbpvqaNPGofNwrkiyA29jiM4sJDUcyUHSpHzi2759WfW+/i1gptVgHZFyWIOi
         +4lus021pekLVx0fPR1A1VnFqr9VUZ5qeGzD8iewtou+s1YYOlQ1CquvGFDYV32+GA
         H4PZkPPF1bp+g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.74.252] ([80.245.74.252]) by web-mail.gmx.net
 (3c-app-gmx-bs15.server.lan [172.19.170.67]) (via HTTP); Sun, 26 Feb 2023
 13:12:04 +0100
MIME-Version: 1.0
Message-ID: <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Felix Fietkau <nbd@nbd.name>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Aw: Re:  Re: Choose a default DSA CPU port
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 26 Feb 2023 13:12:04 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:50TQ+f/GBhxvRh/Hoy2KFRJ604SmREVgB8Y39DVznTvamTTQ3QTwCloPI/KHZoPPQzg9Y
 3B42brjI0QVYjEDmMNoTwRs59JpzvcFgyNNI2gM1D+FLoV6AGAlv8oD+QFxEwmfCLd9ftXMsnSXC
 pWiGfMQA3OXsrOQ94mZj+HP+M2GQJPEFhNLDBDvT6ORgJgAjetd5X596IXIzA/CQTeRfUsohS1AQ
 aE2AqghObYmFCTsxLhgwjkn2b9QrOqMvQ1kqvZL/eXGIECg4SvbhwIbMnnHJSc3MG7YR23ONvoki
 lU=
UI-OutboundReport: notjunk:1;M01:P0:/G3GC/4q/DI=;xxUfhp+zqWap437kJW8+pSOO7Ia
 Vh46Oj/AtnyI52hMTFeNzC9OUfhmgwkQ/a+j6y5aUpp5BjwAYZAoDCG4zDu/1r15nkRHAA5IK
 gj4V81it+IJBMZzuWmjvPoTgdpzGviH7ZkADduVr/INdRNEEJXYG5R0c/eOsSIXczq7QYQWVO
 BPQ1qzpuvSHwUeX5sIhDMyxWfCuco/rrpIKwzgRkRgk1F1xy7pBaYFgdV01bepVvULaOAPNG7
 mMzt9rc7Rqv6yoK1VxL26b2B7Yk4S7NZe8BGYj09rUdwcyXrzM3UlS7A6zDM4Enktk3uJEHGw
 U99253RJDUnEN1uqYPfeqMlSTpCIDnZ5/yLLIBqmiEp0xfKbeh52+ejSD7NDbKHN+g1sJ9cyc
 QZ+tF+5/mpyClmtihFApxjO4Hi0qhZ0pdx8mdEWQ2K4h/HAAuos7oombVqJ2MPGG8BvVeLzeK
 F2X1jlVs1nDTjhpx5rfo8adh+bGqIvjFoi0MptT5C3qTtijCXcB1UhM2aKC1oVJQtdv05vn6B
 zpDgJL4vEpGvFp8ftfus8qdkT4a6Ojbo6YL55M7ppIVn9BChGc/7eKA8aVWyIketMyQFOyRxb
 wzsdhMX87fB+sXrBhvE5GqNMX4hTuMI1dwzJ3ZBCibvXlTXs4sPZg/eamoyjT0t8DSonZ/GW3
 VkVcpBIXw39QFx06sm9/nTllouFMpKr/WusxYHb7ZZa5PK0gJV1/glyhx5Wj5AGOAxBYXiqBE
 POOJj+IF9/G7O2F4Y8DpOUvazfMCTKX43D0zD3tWLH1kDFPsb3UnRhOzO5O0/e8VgcbptTYDS
 sdTiHHGn22RNDe6XcFa0z8bPRZbLAwFM0Veh37evzyT9k=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
> Gesendet: Samstag, 25=2E Februar 2023 um 20:56 Uhr
> Von: "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arinc=2Eunal@arinc9=2Ecom>

> On 25=2E02=2E2023 19:11, Ar=C4=B1n=C3=A7 =C3=9CNAL wrote:
> > On 25=2E02=2E2023 16:50, Frank Wunderlich wrote:

> >> f63959c7eec3151c30a2ee0d351827b62e742dcb is the first bad commit
> >=20
> > Thanks a lot for finding this=2E I can confirm reverting this fixes th=
e=20
> > low throughput on my Bananapi BPI-R2 as well=2E

> Just tested on an MT7621 Unielec U7621-06 board=2E MT7621 is not affecte=
d=2E

do you have full 1G (940 Mbit/s) on mt7621 device in 6=2E1??

if you look at the commit you see a special handling for mt7621

if (IS_ENABLED(CONFIG_SOC_MT7621)) {
=2E=2E=2E
}else{
//all others go there including mt7623, out (t)rgmii should be here (inter=
nally SPEED_100 afair, but higher clock for trgmii):
               case SPEED_1000:
                       val |=3D MTK_QTX_SCH_MAX_RATE_EN |
                              FIELD_PREP(MTK_QTX_SCH_MAX_RATE_MAN, 10) |
                              FIELD_PREP(MTK_QTX_SCH_MAX_RATE_EXP, 5) |
                              FIELD_PREP(MTK_QTX_SCH_MAX_RATE_WEIGHT, 10);
                       break;
}

but i do not understand the full code as it looks like it changes the full=
 packet-handling ;)

imho reverting is good for test, but dropping the full change is not the r=
ight way=2E=2E=2Ewe should wait for felix here

but back to topic=2E=2E=2Ewe have a patch from vladuimir which allows sett=
ing the preferred cpu-port=2E=2E=2Ehow do we handle mt7531 here correctly (=
which still sets port5 if defined and then break)?

https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/netdev/net-next=2Egit/=
tree/drivers/net/dsa/mt7530=2Ec#n2383

	/* BPDU to CPU port */
	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
			   BIT(cpu_dp->index));
		break; //<<< should we drop this break only to set all "cpu-bits"? what =
happens then (flooding both ports with packets?)
	}

as dsa only handles only 1 cpu-port we want the real cpu-port (preferred |=
 first)=2E is this bit set also if the master is changed with your follow-u=
p patch?

regards Frank
