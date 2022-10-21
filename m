Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBD5607F4B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiJUTxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiJUTxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:53:10 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C16F245E89;
        Fri, 21 Oct 2022 12:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666381956;
        bh=fpDJO6xw87XOPgLQXGhHqc6UPyXxqjCz+Pv2+8G7LNQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DOfM/aOA5rhFQoa2yNpJUnGeasmqcLztJOut0Fai5IcTVopHetUf7KcMIy076R1Y6
         8+ADyrrehWGuynokU6hS6tlvPJT7ot2a2ZvaW5nWZX/ov0svg4ObEqiCNM5QfcFRdT
         skhxioRmVcA9M5HmzghCLA88FlDfIgZVFaf8yQMg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.146.132] ([217.61.146.132]) by web-mail.gmx.net
 (3c-app-gmx-bap55.server.lan [172.19.172.125]) (via HTTP); Fri, 21 Oct 2022
 21:52:36 +0200
MIME-Version: 1.0
Message-ID: <trinity-b567c57e-b87f-4fe8-acf7-5c9020f85aed-1666381956560@3c-app-gmx-bap55>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 21 Oct 2022 21:52:36 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <Y1LlnMdm8pGVXC6d@shell.armlinux.org.uk>
References: <20221020144431.126124-1-linux@fw-web.de>
 <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk>
 <02A54E45-2084-440A-A643-772C0CC9F988@public-files.de>
 <Y1JhEWU5Ac6kd2ne@shell.armlinux.org.uk>
 <trinity-e60759de-3f0f-4b1e-bc0f-b33c4f8ac201-1666374467573@3c-app-gmx-bap55>
 <Y1LlnMdm8pGVXC6d@shell.armlinux.org.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:wIZ9ALfKQQdEv1eLRnuW6Hp9CdJw3iUykNQveb68jTlztIraIMRnSIAwfe6cuGHeL02Po
 vVCfMom87gN/ejCrLhe4kXWEtIAoUvwDiRFz52rndCn6cU+b5TwagQOEtNw74bsgSRrMKylWWTga
 rGfXI+UVmhUd5aVpZfMV/8XgaBlQICusjw813IIN3xNAG7cSeeTrL6Ed4id+WkPFIk3gqfpMOoMp
 skGf4fiFbEinwJmLxf4PV4vutzA70VYL3PRniwLbVxxx1emVHtvCSbBlHsLCo56+0Q2dsRDEBr+t
 Zk=
X-UI-Out-Filterresults: notjunk:1;V03:K0:Us0JAQ0Y064=:Y0TUtzahCCqmLnSzAnA6Cx
 JSHeF7pDmK8GUNIr17tGOdBat4121KTQzfUdy3bT7ptTaXMdMeboNzn07Ly3AnqaxyDV25Oue
 rk235VfTyACyccowX6cQJ3ktDW0Tc+yklmAzRBbruZDl0k/RyQe/MWL17NAbSnE1P7mS2ZNGJ
 E59g0JkNZRWXQ7PL0sz4BaLvRuYZoVOg/OO1KPAbMglVuKNBL4O2hqwQW2yZCDMgL2CbwuFsi
 0+G938j1SKjgDat8hyGsIZMCt+I9L0rBH5ZSwa6x75bEXnp98M4MC/E79uuI1VjUE4oCEsYaO
 j2vrWkM/MF4GkfqODtcnc/51sOeNfv6O+Z4VFwK+lFDNrmeMNh7m3AGDZx9loAmJjhDLsutZK
 55UzWoVLg1m8/Nr1YtH7inGuYeSt4nnMedZqtwPFgfwQC0Wo27YZSQzcwsztM5pLk/axvc1/u
 esp7ovIMFIePWsgzPUQ+cnIyYkPxgG3hZGy8smnomghe/IKteS015XVpJWJFcBBWZa8aTTP5l
 amOi/YxIOSVaO9eCAeOfkCxfwUz7Wh6at9CCSINNv04Pe0dDwWcK9WEhWsVRIFPFkprL1Lt1e
 9QAD6Z6rdl3pOp4VsW9MDKoBgfB+Im9NZB7LQkMZFhG+JlyvofaEYiVXc0NNYQHqOxCxxcJof
 s+Iucj0/JYGLZw6t+3VSrW+SIVgOIQaTOgbJIZkIu/6ALoxP6hnWp3G9GcTIiz2+7APVIV1T5
 h9+DQH2LYXH7q8JHDkTv2ALB2xxOQuXc1nDx2l1RMwIrfoJ46xiWjbZon9Rj3sqKWR3W9/sd3
 lmrWtex1QCupLdmaR1BiWq9HZ8WLNMBSXrqaeNPcIYR6Cua5GjWR9607QJQGZvmLqiuFSPoa2
 8pfQcgdQYzCmrHF1d8NkX647IGtixbn53er82dTqW3oQnDeIHJCLP3FtW1WwHlTTM6lUWqt8K
 HgvWCSFSdBy+wUPmFb7Ze6kMOZV+bUBweU4H+eHKBJHQQANx5ftsDpMHki5aR3RZQDXKzR8gY
 43Y6zj8msyMIt3S3SHYCKd8G5pRA5NLrGmapXLqBITCx2XelidyDxbFX8Y9PX3VU5Vf9tyb7V
 EWEL1PWbiPZwSW8rhJA70qH8XWKBZ/06mjIr/0yQyQ44w34EENJaMGkdn6AB5zkeZoIBAGTfV
 sGAe0C4wyDkSYoU1CBT2/HkPFJSlgZnUT3sDejt60gD43b7Aum1ac1inVF6sqYPSkIyj+ovMT
 C3fLMVOghbatiR9tiXH3OYmDJ744AJ13q/kBrr4Cnqb6g2+M5dwCIrEFkqDbHUBPLrmaq/4zr
 Igoqp2+ou/cQ2XXQT60EcYbVErNVfQ==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Freitag, 21. Oktober 2022 um 20:31 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux.org.uk>

> On Fri, Oct 21, 2022 at 07:47:47PM +0200, Frank Wunderlich wrote:
> > > Gesendet: Freitag, 21. Oktober 2022 um 11:06 Uhr
> > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>

> > > Looking at SGMSYS_PCS_CONTROL_1, this is actually the standard BMCR =
in
> > > the low 16 bits, and BMSR in the upper 16 bits, so:
> > >
> > > At address 4, I'd expect the PHYSID.
> > > At address 8, I'd expect the advertisement register in the low 16 bi=
ts
> > > and the link partner advertisement in the upper 16 bits.
> > >
> > > Can you try an experiment, and in mtk_sgmii_init() try accessing the
> > > regmap at address 0, 4, and 8 and print their contents please?
> >
> > is this what you want to see?

> > [    1.083359] dev: 0 offset:0 0x840140
> > [    1.083376] dev: 0 offset:4 0x4d544950
> > [    1.086955] dev: 0 offset:8 0x1
> > [    1.090697] dev: 1 offset:0 0x81140
> > [    1.093866] dev: 1 offset:4 0x4d544950
> > [    1.097342] dev: 1 offset:8 0x1
>
> Thanks. Decoding these...
>
> dev 0:
>  BMCR: fixed, full duplex, 1000Mbps, !autoneg
>  BMSR: link up
>  Phy ID: 0x4d54 0x4950
>  Advertise: 0x0001 (which would correspond with the MAC side of SGMII)
>  Link partner: 0x0000 (no advertisement received, but we're not using
>     negotiation.)
>
> dev 1:
>  BMCR: autoneg (full duplex, 1000Mbps - both would be ignored)
>  BMSR: able to do autoneg, no link
>  Phy ID: 0x4d54 0x4950
>  Advertise: 0x0001 (same as above)
>  Link partner: 0x0000 (no advertisement received due to no link)
>
> Okay, what would now be interesting is to see how dev 1 behaves when
> it has link with a 1000base-X link partner that is advertising
> properly. If this changes to 0x01e0 or similar (in the high 16-bits
> of offset 8) then we definitely know that this is an IEEE PHY register
> set laid out in memory, and we can program the advertisement and read
> the link partner's abilities.

added register-read on the the new get_state function too

on bootup it is now a bit different

[    1.086283] dev: 0 offset:0 0x40140 #was previously 0x840140
[    1.086301] dev: 0 offset:4 0x4d544950
[    1.089795] dev: 0 offset:8 0x1
[    1.093584] dev: 1 offset:0 0x81140
[    1.096716] dev: 1 offset:4 0x4d544950
[    1.100191] dev: 1 offset:8 0x1

root@bpi-r3:~# ip link set eth1 up
[  172.037519] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/=
1000base-x link mode
root@bpi-r3:~#
[  172.102949] offset:0 0x40140 #still same value
[  172.102964] offset:4 0x4d544950
[  172.105842] offset:8 0x1
[  172.108992] mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/Unkn=
own - flow control off
[  172.120058] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

so no change on link up

maybe ethtool-output is interesting

root@bpi-r3:~# ethtool -m eth1
        Identifier                                : 0x03 (SFP)
        Extended identifier                       : 0x04 (GBIC/SFP defined=
 by 2-wire interface ID)
        Connector                                 : 0x07 (LC)
        Transceiver codes                         : 0x00 0x00 0x00 0x01 0x=
00 0x00 0x00 0x00 0x00
        Transceiver type                          : Ethernet: 1000BASE-SX
        Encoding                                  : 0x01 (8B/10B)
        BR, Nominal                               : 1300MBd
        Rate identifier                           : 0x00 (unspecified)
        Length (SMF,km)                           : 0km
        Length (SMF)                              : 0m
        Length (50um)                             : 550m
        Length (62.5um)                           : 270m
        Length (Copper)                           : 0m
        Length (OM3)                              : 0m
        Laser wavelength                          : 850nm
        Vendor name                               : OEM
        Vendor OUI                                : 00:90:65
        Vendor PN                                 : GLC-SX-MMD     _
        Vendor rev                                : _e
        Option values                             : 0x00 0x1a
        Option                                    : RX_LOS implemented
        Option                                    : TX_FAULT implemented
        Option                                    : TX_DISABLE implemented
        BR margin, max                            : 0%
        BR margin, min                            : 0%
        Vendor SN                                 : CSCGE1M14134
        Date code                                 : 220120
        Optical diagnostics support               : Yes
        Laser bias current                        : 3.634 mA
        Laser output power                        : 0.3181 mW / -4.97 dBm
        Receiver signal average optical power     : 0.3444 mW / -4.63 dBm
        Module temperature                        : 35.32 degrees C / 95.5=
8 degrees F
        Module voltage                            : 3.3101 V
        Alarm/warning flags implemented           : Yes
        Laser bias current high alarm             : Off
        Laser bias current low alarm              : Off
        Laser bias current high warning           : Off
        Laser bias current low warning            : Off
        Laser output power high alarm             : Off
        Laser output power low alarm              : Off
        Laser output power high warning           : Off
        Laser output power low warning            : Off
        Module temperature high alarm             : Off
        Module temperature low alarm              : Off
        Module temperature high warning           : Off
        Module temperature low warning            : Off
        Module voltage high alarm                 : Off
        Module voltage low alarm                  : Off
        Module voltage high warning               : Off
        Module voltage low warning                : Off
        Laser rx power high alarm                 : Off
        Laser rx power low alarm                  : Off
        Laser rx power high warning               : Off
        Laser rx power low warning                : Off
        Laser bias current high alarm threshold   : 100.000 mA
        Laser bias current low alarm threshold    : 0.000 mA
        Laser bias current high warning threshold : 90.000 mA
        Laser bias current low warning threshold  : 0.100 mA
        Laser output power high alarm threshold   : 1.2589 mW / 1.00 dBm
        Laser output power low alarm threshold    : 0.0501 mW / -13.00 dBm
        Laser output power high warning threshold : 0.7943 mW / -1.00 dBm
        Laser output power low warning threshold  : 0.0631 mW / -12.00 dBm
        Module temperature high alarm threshold   : 90.00 degrees C / 194.=
00 degrees F
        Module temperature low alarm threshold    : -45.00 degrees C / -49=
.00 degrees F
        Module temperature high warning threshold : 85.00 degrees C / 185.=
00 degrees F
        Module temperature low warning threshold  : -40.00 degrees C / -40=
.00 degrees F
        Module voltage high alarm threshold       : 3.8000 V
        Module voltage low alarm threshold        : 2.7000 V
        Module voltage high warning threshold     : 3.7000 V
        Module voltage low warning threshold      : 2.8000 V
        Laser rx power high alarm threshold       : 0.7943 mW / -1.00 dBm
        Laser rx power low alarm threshold        : 0.0079 mW / -21.02 dBm
        Laser rx power high warning threshold     : 0.5012 mW / -3.00 dBm
        Laser rx power low warning threshold      : 0.0126 mW / -19.00 dBm
root@bpi-r3:~# ethtool eth1
[  295.755349] offset:0 0x40140
[  295.755368] offset:4 0x4d544950
Settings for eth[  295.758247] offset:8 0x1
1:
        Supported p[  295.761551] offset:0 0x40140
[  295.765446] offset:4 0x4d544950

        Supported link modes:   1000baseX/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseX/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Unknown! (255)
        Auto-negotiation: on
        Port: FIBRE
        PHYAD: 0
        Transceiver: internal
        Current message level: 0x000000ff (255)
                               drv probe link timer ifdown ifup rx_err tx_=
err
        Link detected: yes


> At that point, we should try programming the low 16-bits of offset 8
> to see whether that advertisement makes it to the far end of the link.

have only my switch on the other side where i imho cannot read out these a=
dvertising. and programming to which values at which point (in the get-sta=
te callback to be done on link-up)?

> It would be well worth trying to work this out, because it will then
> vastly improve the knowledge of this hardware, and improve the
> driver no end.
>
> Is this something you could investigate please?

regards Frank
