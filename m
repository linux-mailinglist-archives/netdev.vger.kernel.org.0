Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B2A132051
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 08:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgAGHTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 02:19:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19715 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgAGHTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 02:19:46 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200107071942epoutp04310413c39cad552f05caf69fb085aa92~nia-MYKSO0303003030epoutp04B
        for <netdev@vger.kernel.org>; Tue,  7 Jan 2020 07:19:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200107071942epoutp04310413c39cad552f05caf69fb085aa92~nia-MYKSO0303003030epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1578381582;
        bh=RtHBBp39OA/t7F5pUSrmvE58Xz4xcndYYyN4RSw8QTI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=aZVg8M9KIVJF+ezqQojge7zhRXQ0LOIvSLDXh3x/dVaaGLqzYwOD1HYyPCk4W8Nhi
         J3BwzJ7dcW+56p6pQICkdXhtnpJAPMAMyCxVONPY7TZsHpbQAbERQAmxId+gCBYowF
         Z2jQ6ZwQTLt1k43Bl46FvHbtYX71Je4jpnS/zYwY=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200107071941epcas5p12510686870381ac565da007cc10091f0~nia_gHgvH2658626586epcas5p1U;
        Tue,  7 Jan 2020 07:19:41 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        26.B1.20197.D01341E5; Tue,  7 Jan 2020 16:19:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200107071941epcas5p1018fc89889dbcc1fa2abfcdaed6f4e5b~nia92732L1745517455epcas5p1P;
        Tue,  7 Jan 2020 07:19:41 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200107071941epsmtrp19e20e87e3082f1aba42ac9725f5a6329~nia91piny0674606746epsmtrp1a;
        Tue,  7 Jan 2020 07:19:41 +0000 (GMT)
X-AuditID: b6c32a4a-769ff70000014ee5-e6-5e14310d9b92
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.0B.06569.C01341E5; Tue,  7 Jan 2020 16:19:40 +0900 (KST)
Received: from sriramdash03 (unknown [107.111.85.29]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200107071937epsmtip2e23034f6e8d0d72bfcf34456a3b13809~nia6wOa913273432734epsmtip2Q;
        Tue,  7 Jan 2020 07:19:37 +0000 (GMT)
From:   "Sriram Dash" <sriram.dash@samsung.com>
To:     "'Florian Fainelli'" <f.fainelli@gmail.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'kernelci.org bot'" <bot@kernelci.org>,
        <tomeu.vizoso@collabora.com>, <khilman@baylibre.com>,
        <mgalka@collabora.com>, <guillaume.tucker@collabora.com>,
        <broonie@kernel.org>, "'Jayati Sahu'" <jayati.sahu@samsung.com>,
        "'Padmanabhan Rajanbabu'" <p.rajanbabu@samsung.com>,
        <enric.balletbo@collabora.com>, <narmstrong@baylibre.com>,
        "'Heiko Stuebner'" <heiko@sntech.de>
Cc:     "'Jose Abreu'" <Jose.Abreu@synopsys.com>,
        "'Alexandre Torgue'" <alexandre.torgue@st.com>,
        <rcsekar@samsung.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "'Maxime Coquelin'" <mcoquelin.stm32@gmail.com>,
        <pankaj.dubey@samsung.com>,
        "'Giuseppe Cavallaro'" <peppe.cavallaro@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <54a292b8-3cac-0caf-08c7-841c469fb68f@gmail.com>
Subject: RE: broonie-regmap/for-next bisection: boot on
 ox820-cloudengines-pogoplug-series-3
Date:   Tue, 7 Jan 2020 12:49:36 +0530
Message-ID: <012001d5c52a$d3be2590$7b3a70b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-in
Thread-Index: AQHVkLQqlgs7zItKQK6JQygQi6mu7gG5ib8fAmHNbWsB+6DuOQJmiUKZAkmHUKmniOUmUA==
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjmO5ftTDr1dVz5ZhdsXbXSjIIvKouKOF1+BEGFiTXyZKJT2UxL
        oiRKa+ryQheH2TKREkWcMy0zbd2NVUxbjsiyZhe1DLPISoztGPnved7veZ73feDjaKFEEcjF
        JaZI+kRtgkbhx1y7Ezx/ER+ujl7c6AwlNZ7HiDjdLSw50+VRkOKnxxlS+dKOyK8vd5Wkb+Ay
        TUbe9rLkbmsZRTr/fGXJUJaNItZ3Lpa03ShWEKPLw5KS4SqWZHaeUxK7aRe5b5lM7tVsI6V1
        g0oy0luHiPlZA0tMVU7FmgCxv+OEUmx4VYZE21U3JV43v1KK1opTCvHmp3FibdlR0WSrQGK9
        q4QWb98KF7t/NtGirfkbEr9ZZ2zlI/1WxkgJcamSPixij99+14lfVHJbFjo4WFfGZKCBeCNS
        cYCXQuuTU4wR+XECbkRw3vORkskAgkefu1mvSsA/EAzeUhkR53P0ORWypglB59UXSCY9CBxd
        b2mvQYEXgaPjmE+lxh00OC3DtJfQOJuGL2fP0t4oFV4FlYUpXoM/joau/guMFzN4Nrit3jNU
        HI+XQ+HNC0jGE+FRkcenofECKL/US8sdgmCou5yV5wFwbyjHN1fj7dDvyPBdB/gMBw5bLZIr
        rIeh5iOy1x96HtiUMg6ET6czR3E8tJk+jOanwPmeS4yMV0NLezHjjaFxMFTfCJPXjofc3x5K
        TufhZKYgq+dAz8va0cSp0FL1mJKxCM2O71QemmkeU8w8pph5TBnz/2UWxFSgKVKyQRcrGZYl
        L0mU0kINWp3hQGJs6N4knRX5fm3IpgZU/mSLHWEOacbxedP8owVWm2o4pLMj4GiNmg9ZqI4W
        +BjtoXRJn7RbfyBBMtjRVI7RBPAF7PMoAcdqU6R4SUqW9P9eKU4VmIGK1l9cymeHFKzY6DY9
        YA+GMUHty+uzdv54E7OhSb1qSoTFMiFNSI8r2JRra01I22esqu9bF3zY9H362tIofKU6blbU
        3EnXk34OVM/LnThhuCigdG9TXcTI/Q3WdBUObdQ9pNsv79juzq9Me+12uXChsKTBHvk1P7Vg
        Wt/m8e/e5+doGMN+bXgIrTdo/wITKEYTsQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sb0hTYRTGeXd3t+twcdtGvjlIW31aqa00XmlaH4ouESSZQSnaytvU3By7
        aplgTqxMRIxh4jBRG8O/kEtLy8yW2rLU+QdxyKTWJGOmqYEtUmuOYt9+53nOec75cAhMoMOD
        iXR1Nq1VKzIlHB776RtJSFigTJR8YFknR+2u9wCN2/twVPnJxUE1o8Vs1DpjAejXYj8XLaw8
        wtCm042j/iEjC83+/o4jz90OFjJ/nsLRxPMaDiqdcuGodr0NR3dmq7jIUp6IBut2oIH2eNTQ
        +YOLNt2dABlsXTgqbxvnHAuilqZvc6kuhxFQHU12FtVtcHApc/M9DtXzNZB6YrxFlXc0A+rZ
        VC1Gve6VUXM/X2JUx6tVQK2ad8XxL/LkqXRmei6tjYi9xEsbXUrQ6IvBDYfLxCoEZcpSQBCQ
        jIQL45xSwCME5AsAG7vMuE8XQ48jrBQE/EUhbNr4wvX1zAPYsvKY7TU4ZBgcni7aGhaRTgw+
        6DaxvAVG3sfgmm0D83YJSCsLfjSd9qYGkDGwVZ/tlYVkEhyatHG9zCb3Qrt5nuVlPhkN9T0P
        gY+3w3fVrq1lGLkPztnn/rOp3o35rguFnjkT7tOD4ICnbEsXkefh0nAhqABCg1+UwS/K4Bdl
        8BuvA+xmsJPWMCqlipFpDqrp6+GMQsXkqJXhV7JUZrD1GFJpF7BaUyyAJIAkkI+ChckCXJHL
        5KksABKYRMSX7hclC/ipirybtDYrRZuTSTMWICbYkiB+SNbgBQGpVGTT12haQ2v/uSwiILgQ
        HBpOI+TRcTrnLDjSuJ51RnxqbEx5NKOv/eqEfiTphNO8UM+TtA3oti2dRCG6opLybPfuiZlz
        nrczGfFxxwfXJmOKXVGLBeKgyGpDVb4R9loT1bc/JDi/TWfarBHhI6sFuVTDYoBVHpp/eU9F
        peNw1EjZWdtykdjeoo7VG0skbCZNIZNiWkbxByB6p14UAwAA
X-CMS-MailID: 20200107071941epcas5p1018fc89889dbcc1fa2abfcdaed6f4e5b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191225075056epcas4p2ab51fc6ff1642705a61f906189bb29f0
References: <CGME20191225075056epcas4p2ab51fc6ff1642705a61f906189bb29f0@epcas4p2.samsung.com>
        <5e0314da.1c69fb81.a7d63.29c1@mx.google.com>
        <03ca01d5c23a$09921d00$1cb65700$@samsung.com>
        <1c3531f8-7ae2-209d-b6ed-1c89bd9f2bb6@gmail.com>
        <011801d5c51a$bd2e5710$378b0530$@samsung.com>
        <54a292b8-3cac-0caf-08c7-841c469fb68f@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Florian Fainelli <f.fainelli=40gmail.com>
> Sent: 07 January 2020 11:21
> Subject: Re: broonie-regmap/for-next bisection: boot on ox820-cloudengine=
s-
> pogoplug-series-3
>=20
>=20
>=20
> On 1/6/2020 9:24 PM, Sriram Dash wrote:
> >> From: Florian Fainelli <f.fainelli=40gmail.com>
> >> Subject: Re: broonie-regmap/for-next bisection: boot on
> >> ox820-cloudengines-
> >> pogoplug-series-3
> >>
> >> On 1/3/20 5:30 AM, Sriram Dash wrote:
> >>>> From: kernelci.org bot <bot=40kernelci.org>
> >>>> Subject: broonie-regmap/for-next bisection: boot on
> >>>> ox820-cloudengines-
> >>>> pogoplug-series-3
> >>>>
> >>>> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> >>>> * This automated bisection report was sent to you on the basis  *
> >>>> * that you may be involved with the breaking commit it has      *
> >>>> * found.  No manual investigation has been done to verify it,   *
> >>>> * and the root cause of the problem may be somewhere else.      *
> >>>> *                                                               *
> >>>> * If you do send a fix, please include this trailer:            *
> >>>> *   Reported-by: =22kernelci.org bot=22 <bot=40kernelci.org>        =
  *
> >>>> *                                                               *
> >>>> * Hope this helps=21                                              *
> >>>> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> >>>>
> >>>> broonie-regmap/for-next bisection: boot on
> >>>> ox820-cloudengines-pogoplug-
> >>>> series-3
> >>>>
> >>>> Summary:
> >>>>   Start:      46cf053efec6 Linux 5.5-rc3
> >>>>   Details:    https://protect2.fireeye.com/url?k=3D36fb52ed-6b2b5a21=
-
> >> 36fad9a2-
> >>>> 000babff3793-
> >>>> f64e7c227e0a8b34&u=3Dhttps://protect2.fireeye.com/url?k=3D2379492a-7=
ee2
> >>>> b5
> >>>> 49-2378c265-0cc47a31cdbc-
> >> 914c67c9400b5bae&u=3Dhttps://protect2.fireeye.com/url?k=3D340b13ed-
> 699712
> >> 8d-340a98a2-0cc47a31307c-
> 743b42a2202bdce9&u=3Dhttps://kernelci.org/boot
> >>>> /id/5e02ce65451524462f9731
> >>>> 4f
> >>>>   Plain log:
> >>>> https://protect2.fireeye.com/url?k=3D58f5fc3b-0525f4f7-58f47774-
> >>>> 000babff3793-f96a18481add0d7f&u=3Dhttps://protect2.fireeye.com/url?k=
=3D
> >>>> 3c
> >>>> 793260-61e2ce03-3c78b92f-0cc47a31cdbc-
> >> c77f49890593c376&u=3Dhttps://stor
> >>>> age.kernelci.org//broonie-
> >>>> regmap/for-next/v5.5-rc3/arm/oxnas_v6_defconfig/gcc-8/lab-
> >>>> baylibre/boot-ox820-cloudengines-pogoplug-series-3.txt
> >>>>   HTML log:   https://protect2.fireeye.com/url?k=3Deaed2629-b73d2ee5=
-
> >>>> eaecad66-000babff3793-
> >>>> 84ba1e41025b4f73&u=3Dhttps://protect2.fireeye.com/url?k=3D8e80051e-d=
31b
> >>>> f9
> >>>> 7d-8e818e51-0cc47a31cdbc-
> dd2d5f3d7e3c3cd2&u=3Dhttps://protect2.fireeye.com/url?k=3Db2fc89d0-ef6088=
b0-
> b2fd029f-0cc47a31307c-30e2364c4b1f1a98&u=3Dhttps://storage.kernelci/.
> >>>> org//broonie-regmap/for-
> >>>> next/v5.5-rc3/arm/oxnas_v6_defconfig/gcc-8/lab-baylibre/boot-ox820-
> >>>> cloudengines-pogoplug-series-3.html
> >>>>   Result:     d3e014ec7d5e net: stmmac: platform: Fix MDIO init for
> platforms
> >>>> without PHY
> >>>>
> >>>> Checks:
> >>>>   revert:     PASS
> >>>>   verify:     PASS
> >>>>
> >>>> Parameters:
> >>>>   Tree:       broonie-regmap
> >>>>   URL:
> >>>> https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git
> >>>>   Branch:     for-next
> >>>>   Target:     ox820-cloudengines-pogoplug-series-3
> >>>>   CPU arch:   arm
> >>>>   Lab:        lab-baylibre
> >>>>   Compiler:   gcc-8
> >>>>   Config:     oxnas_v6_defconfig
> >>>>   Test suite: boot
> >>>>
> >>>> Breaking commit found:
> >>>>
> >>>> -------------------------------------------------------------------
> >>>> --
> >>>> ---------- commit d3e014ec7d5ebe9644b5486bc530b91e62bbf624
> >>>> Author: Padmanabhan Rajanbabu <p.rajanbabu=40samsung.com>
> >>>> Date:   Thu Dec 19 15:47:01 2019 +0530
> >>>>
> >>>>     net: stmmac: platform: Fix MDIO init for platforms without PHY
> >>>>
> >>>>     The current implementation of =22stmmac_dt_phy=22 function initi=
alizes
> >>>>     the MDIO platform bus data, even in the absence of PHY. This fix
> >>>>     will skip MDIO initialization if there is no PHY present.
> >>>>
> >>>>     Fixes: 7437127 (=22net: stmmac: Convert to phylink and remove ph=
ylib
> logic=22)
> >>>>     Acked-by: Jayati Sahu <jayati.sahu=40samsung.com>
> >>>>     Signed-off-by: Sriram Dash <sriram.dash=40samsung.com>
> >>>>     Signed-off-by: Padmanabhan Rajanbabu <p.rajanbabu=40samsung.com>
> >>>>     Signed-off-by: David S. Miller <davem=40davemloft.net>
> >>>>
> >>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> >>>> b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> >>>> index bedaff0c13bd..cc8d7e7bf9ac 100644
> >>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> >>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> >>>> =40=40 -320,7 +320,7 =40=40 static int stmmac_mtl_setup(struct
> >>>> platform_device *pdev,  static int stmmac_dt_phy(struct
> >> plat_stmmacenet_data *plat,
> >>>>  			 struct device_node *np, struct device *dev)  =7B
> >>>> -	bool mdio =3D true;
> >>>> +	bool mdio =3D false;
> >>>>  	static const struct of_device_id need_mdio_ids=5B=5D =3D =7B
> >>>>  		=7B .compatible =3D =22snps,dwc-qos-ethernet-4.10=22 =7D,
> >>>>  		=7B=7D,
> >>>> -------------------------------------------------------------------
> >>>> --
> >>>> ----------
> >>>>
> >>>>
> >>>> Git bisection log:
> >>>>
> >>>> -------------------------------------------------------------------
> >>>> --
> >>>> ----------
> >>>> git bisect start
> >>>> =23 good: =5Be42617b825f8073569da76dc4510bfa019b1c35a=5D Linux 5.5-r=
c1
> >>>> git bisect good e42617b825f8073569da76dc4510bfa019b1c35a
> >>>> =23 bad: =5B46cf053efec6a3a5f343fead837777efe8252a46=5D Linux 5.5-rc=
3 git
> >>>> bisect bad 46cf053efec6a3a5f343fead837777efe8252a46
> >>>> =23 good: =5B2187f215ebaac73ddbd814696d7c7fa34f0c3de0=5D Merge tag
> >>>> 'for-5.5- rc2-tag' of
> >>>> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
> >>>> git bisect good 2187f215ebaac73ddbd814696d7c7fa34f0c3de0
> >>>> =23 good: =5B0dd1e3773ae8afc4bfdce782bdeffc10f9cae6ec=5D pipe: fix e=
mpty
> >>>> pipe check in pipe_write() git bisect good
> >>>> 0dd1e3773ae8afc4bfdce782bdeffc10f9cae6ec
> >>>> =23 good: =5B040cda8a15210f19da7e29232c897ca6ca6cc950=5D Merge tag
> >>>> 'wireless- drivers-2019-12-17' of
> >>>> git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-driver
> >>>> s git bisect good 040cda8a15210f19da7e29232c897ca6ca6cc950
> >>>> =23 bad: =5B4bfeadfc0712bbc8a6556eef6d47cbae1099dea3=5D Merge branch
> >>>> 'sfc- fix-bugs-introduced-by-XDP-patches'
> >>>> git bisect bad 4bfeadfc0712bbc8a6556eef6d47cbae1099dea3
> >>>> =23 good: =5B0fd260056ef84ede8f444c66a3820811691fe884=5D Merge
> >>>> git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
> >>>> git bisect good 0fd260056ef84ede8f444c66a3820811691fe884
> >>>> =23 good: =5B90b3b339364c76baa2436445401ea9ade040c216=5D net: hisili=
con:
> >>>> Fix a BUG trigered by wrong bytes_compl git bisect good
> >>>> 90b3b339364c76baa2436445401ea9ade040c216
> >>>> =23 bad: =5B4c8dc00503db24deaf0b89dddfa84b7cba7cd4ce=5D qede: Disabl=
e
> >>>> hardware gro when xdp prog is installed git bisect bad
> >>>> 4c8dc00503db24deaf0b89dddfa84b7cba7cd4ce
> >>>> =23 bad: =5B28a3b8408f70b646e78880a7eb0a97c22ace98d1=5D net/smc:
> >>>> unregister ib devices in reboot_event git bisect bad
> >>>> 28a3b8408f70b646e78880a7eb0a97c22ace98d1
> >>>> =23 bad: =5Bd3e014ec7d5ebe9644b5486bc530b91e62bbf624=5D net: stmmac:
> >>>> platform: Fix MDIO init for platforms without PHY git bisect bad
> >>>> d3e014ec7d5ebe9644b5486bc530b91e62bbf624
> >>>> =23 good: =5Baf1c0e4e00f3cc76cb136ebf2e2c04e8b6446285=5D llc2: Fix r=
eturn
> >>>> statement of llc_stat_ev_rx_null_dsap_xid_c (and _test_c) git
> >>>> bisect good
> >>>> af1c0e4e00f3cc76cb136ebf2e2c04e8b6446285
> >>>> =23 first bad commit: =5Bd3e014ec7d5ebe9644b5486bc530b91e62bbf624=5D=
 net:
> >>>> stmmac: platform: Fix MDIO init for platforms without PHY
> >>>> -------------------------------------------------------------------
> >>>> --
> >>>> ----------
> >>>
> >>>
> >>> The mdio bus will be allocated in case of a phy transceiver is on
> >>> board, but if fixed-link is configured, it will be NULL and
> >>> of_mdiobus_register will not take effect.
> >>
> >> There appears to be another possible flaw in the code here:
> >>
> >>                 for_each_child_of_node(np, plat->mdio_node) =7B
> >>                         if (of_device_is_compatible(plat->mdio_node,
> >>                                                     =22snps,dwmac-mdio=
=22))
> >>                                 break;
> >>                 =7D
> >>
> >> the loop should use for_each_available_child_of_node() such that if a
> >> platform has a Device Tree definition where the MDIO bus node was
> >> provided but it was not disabled by default (a mistake, it should be
> >> disabled by default), and a =22fixed- link=22 property ended up being
> >> used at the board level, we should not end-up with an invalid
> >> plat->mdio_node reference. Then the code could possibly eliminate the
> >> use of 'mdio' as a boolean and rely exclusively on plat->mdio_node. Wh=
at do
> you think?
> >>
> >
> > Hello Florian,
> >
> > Thanks for the review. We definitely see a problem here. For the platfo=
rms
> which have the snps,dwmac-mdio and they have made it disabled, it will fa=
il.
> > Also, We can completely remove the mdio variable from the function
> stmmac_dt_phy as what we essentially do is to check the plat->mdio_node.
> >
> > Something like this will help:
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > index 1f230bd..15c342e 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > =40=40 -320,7 +320,6 =40=40 static int stmmac_mtl_setup(struct platform=
_device
> > *pdev,  static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
> >                          struct device_node *np, struct device *dev)
> > =7B
> > -       bool mdio =3D false;
> >         static const struct of_device_id need_mdio_ids=5B=5D =3D =7B
> >                 =7B .compatible =3D =22snps,dwc-qos-ethernet-4.10=22 =
=7D,
> >                 =7B=7D,
> > =40=40 -334,18 +333,13 =40=40 static int stmmac_dt_phy(struct
> plat_stmmacenet_data *plat,
> >                  * the MDIO
> >                  */
> >                 for_each_child_of_node(np, plat->mdio_node) =7B
> > -                       if (of_device_is_compatible(plat->mdio_node,
> > +                       if
> > + (for_each_available_child_of_node(plat->mdio_node,
> >                                                     =22snps,dwmac-mdio=
=22))
> >                                 break;
> >                 =7D
> >         =7D
> >
> >         if (plat->mdio_node) =7B
> > -               dev_dbg(dev, =22Found MDIO subnode=5Cn=22);
> > -               mdio =3D true;
> > -       =7D
> > -
> > -       if (mdio) =7B
> >                 plat->mdio_bus_data =3D
> >                         devm_kzalloc(dev, sizeof(struct stmmac_mdio_bus=
_data),
> >                                      GFP_KERNEL);
> >
> >
> > Are you preparing a patch to address this, or we shall take it up?
>=20
> I do not think your patch is going to fix the problem that Heiko reported=
 because
> it would try to scan the MDIO bus node which is non-existent. Also not su=
re what
> the return value of for_each_* is supposed to be given it is a loop const=
ruct.
>

This diff will not solve Heiko's problem. This diff is addressing a differe=
nt issue.
What it intends to do is :
1. as we decide the value mdio valriable on the basis of plat->mdio_node
And then use it to decide the mdio_bus_data allocation, we can remove the
mdio variable altogether from the picture.
2. This was addressing another problem you figured. If some platforms
which have the property snps,dwmac-mdio present in dt, but it is disabled,
this diff will correct the behaviour.

Minor correction in the diff=20
for_each_child_of_node -> for_each_available_child_of_node

> >
> >> And an alternative to your fix would be to scan even further the MDIO
> >> bus node for available child nodes, if there are none, do not perform
> >> the MDIO initialization at all since we have no MDIO devices beneath.
> >>
> >>
> >>> The commit d3e014ec7d5e fixes the code for fixed-link configuration.
> >>> However, some platforms like oxnas820 which have phy transceivers
> >>> (rgmii), fail. This is because the platforms expect the allocation
> >>> of mdio_bus_data during stmmac_dt_phy.
> >>>
> >>> Proper solution to this is adding the mdio node in the device tree
> >>> of the platform which can be fetched by stmmac_dt_phy.
> >>
> >> That sounds reasonable, but we should also not break existing
> >> platforms with existing Device Trees out there, as much as possible.
> >
> > I understand your point. Changing DT should be the last thing we should=
 do.
> > But, the code is broken for some platforms. Without the patch, the plat=
forms
> with fixed-link will not work.
> > For example, stih418-b2199.dts, will fail without the commit d3e014ec7d=
5e.
> Humm then we should change the code to explicitly look for a fixed-link n=
ode
> with the use of of_phy_is_fixed_link() (which would work on the old style=
 fixed-
> link that stih418-b2199.dts uses) instead of relying on some implicit or =
explicit
> MDIO bus registration behavior.
>=20

This can be a possible solution. But rather that a proper fix, IMO, this lo=
oks more
like a hotfix for the platforms that do not include the snps,dwmac-mdio / m=
dio in
the device tree.=20
This is not targeting the actual issue here. By bypassing the issue, we may=
 give rise to
bigger problems in future, and it will be difficult to maintain the code.

> The good thing is that I use arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts
> on a nearly daily basis so I can test if that works/does not work with a =
fixed-link
> plus a mdio bus node.
>

This is good indeed. :)
=20
> > With the patch, platforms with mdio and not declaring the dt parameters=
 will
> fail.
> > For that , we have some proposal:
> > For the newer platforms , Make it mandatory to have the mdio or
> snps,dwmac-mdio property.
> > There is no point of checking the device tree for mdio or snps,dwmac-md=
io
> property and populating the plat->mdio_node, if the platforms are not hav=
ing
> them in the device tree and expect mdio bus memory allocation.
>=20
> Yet that is what broke exactly here, the platforms that Heiko reported th=
e
> breakage on, albeit doing something arguably fragile, are not making use =
of a
> phy-handle property nor a MDIO node to indicate where and how to connect =
to
> a PHY, ended up broken. They use implicit bus scanning going on by
> of_mdiobus_register().
>=20
> >
> > For the existing platforms, which do not have the mdio or snps,dwmac-md=
io
> property and still have the phy, if they can, they must modify the dt and=
 include
> the mdio or snps,dwmac-mdio property in their dts.
>=20
> This should be done, but I doubt it is going to be because those Device T=
ree files
> are ABI and may be baked into firmware/boot loaders.
>=20
> > For those platforms, which cannot modify the dt due to some reason or o=
ther,
> the platform should have a quirk in the platform glue layers, and use it =
in the
> stmmac_platform driver  stmmac_dt_phy  function to enable the mdio.
> >
>=20
> Again, I do not think this is practical to do at all, not would it scale =
particularly
> well, given that the same compatible string for Rockchip gmac has been us=
ed
> with both the correct way and the incorrect way of specifying the connect=
ion to
> the PHY device node.

I know it=E2=80=99s=20a=20pain.=20It=20will=20be=20difficult=20to=20maintai=
n=20for=20the=208=20broken=20platforms=20which=20was=0D=0Alisted=20in=20htt=
ps://lkml.org/lkml/2020/1/7/22.=0D=0ABut=20eventually,=20we=20will=20make=
=20the=20code=20better.=0D=0A=0D=0AI=20went=20through=20the=20Rockchip=20co=
de=20and=20I=20found=0D=0Arockchip,px30-gmac=20is=20used=20for=20the=20brok=
en=20platform.=20In=20the=20dwmac-rk.c=20=20glue=20file,=20=0D=0Ait=20also=
=20has=20the=20platform=20data,=20where=20rk_gmac_ops=20can=20hold=20the=20=
fix=20for=20the=20mdio,=20=0D=0Aand=20can=20update=20a=20new=20private=20da=
ta=20member=20of=20stmmac_platform=20driver,=20which=20can=0D=0Ahold=20the=
=20data=20passed=20from=20glue=20layer=20of=20the=20broken=20platforms.=20T=
his=20in=20turn=20can=20leverage=0D=0Aand=20make=20amends=20to=20the=20mdio=
=20bool=20variable=20for=20the=20stmmac_platform=0D=0Astmmac_dt_phy=20funct=
ion.=0D=0A=0D=0ASimilar=20modification=20can=20be=20done=20for=20other=20br=
oken=20platforms.=0D=0A=0D=0A>=20--=0D=0A>=20Florian=0D=0A=0D=0A
