Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA6A6B8F24
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCNKB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCNKB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:01:57 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7DF8C58F;
        Tue, 14 Mar 2023 03:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678788102; i=frank-w@public-files.de;
        bh=nWZ0C/Z5vtI09XjgI+kRHhkKyKhHcEAc1TQPLoGhFpk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=iS/r78nySa9yxiZx6MuLGdklvMWytPnOcZHNg5SRnAZThJ5UuvJ7z/vGiylQuL3li
         1eRY0YYxlVWU5Z/sLA29zzwRNLXRio1ZVMHu27f6Cua6jPBX5AfSlQohxWMPf86vcf
         skoQkVeq/XCd2Zxq8Yf9ulJFqaG+MUrMGgFSiRLN6zl10j+j0TtuwtMQoOXCDn1s+1
         LhfDgzXjCZclKjN6/ofzViW7RJ9GsfaV3tX+vGVlsomvxX/fHsmRq2REtUSG2nuQSe
         iBy8banIjg/+0ajRc42MVr3IRo7FAseDwxF6IXDwnFGrIiZjB382g/+lGzBxSJcg3N
         +VJNyu9SQLu4Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.77.27] ([80.245.77.27]) by web-mail.gmx.net
 (3c-app-gmx-bap66.server.lan [172.19.172.66]) (via HTTP); Tue, 14 Mar 2023
 11:01:42 +0100
MIME-Version: 1.0
Message-ID: <trinity-bc4bbf4e-812a-4682-ac8c-5178320467f5-1678788102813@3c-app-gmx-bap66>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Aw: Re: Re: Re: Re: Re: [PATCH net-next v12 08/18] net: ethernet:
 mtk_eth_soc: fix 1000Base-X and 2500Base-X modes
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 14 Mar 2023 11:01:42 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <ZBA6gszARdJY26Mz@shell.armlinux.org.uk>
References: <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
 <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
 <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
 <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
 <ZA4wlQ8P48aDhDly@shell.armlinux.org.uk>
 <ZA8B/kI0fLx4gkQm@shell.armlinux.org.uk>
 <trinity-93681801-f99c-40e2-9fbd-45888b3069aa-1678732740564@3c-app-gmx-bs66>
 <ZA+qTyQ3n6YiURkQ@shell.armlinux.org.uk>
 <trinity-e2c457f1-c897-45f1-907a-8ea3664b7512-1678783872771@3c-app-gmx-bap66>
 <ZBA6gszARdJY26Mz@shell.armlinux.org.uk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:wapH+Fg+zxqJspdputyYroVMnLUEUu0otmaCiOOlCS7FfawOEM2rytVRpJPH2qoKqiPNy
 kyMfeRwfZGNyjYnVvLPvz8Bcr/kAybStj42JpuqUX3Uzv4XJuTnRd0SH/qVxXdtlfK7a+ypZgy/O
 te/66HGI0LvRlbNgdUoRJtCZktwoUJlFAs/3VXBuX92qXvCZ9ZgdY9Wl6UgKvqQARuAzZHI73nEN
 RykJXaj5XdFtTe43Frve8hvVRkxJpj4Zekj58O7RVUkQ+ure0jodPOEr3BKCAnl8Go4PCSREnIXq
 us=
UI-OutboundReport: notjunk:1;M01:P0:PayLcYJZHEs=;dG4E1CIyqqGyWe4q93J9DWLHHYy
 2Xoji/en+2pTKvfCap3nd/oQUDLv4W+mBiPI4bE0yLNRJFPZ4V3GdGlCWTTg2g6uLCLb5BjnS
 9bqt+CMZ64VwmyXp9Ppm60s5We42vnFaGEO83ZkJbHiDqW+NKrO4U3EM/6KTfyIMu1prp6lSg
 EYGhAZxvfParsuvy+TVVzgwLiGJRyG5Cdm8Oco8pV0hBrPk4Oxz45mM8T3uyyGKNqEPyXkGP7
 NzE8xxaxTJSr9lr+0e4s4wchaNFXMLYyuoJHHrVAVmvPb921qA9TmiF0ioYhuoAXCOWn5HgwO
 CO8NsYu5oFfdsyiLsGUWIBSkKXp+zFxoJLF9XDZfE26v5vkm8J5MeL5e9QcfQDTJDTWpDKVMf
 DgtYEALbmgWErWBCSLXY9kDocHQleyLGYbUmmnH6cdoORW4O4/9/9n9H9xRlvn8Jahq7nCsAh
 xpQF6eIhWldLVM+lr2LvnQxyewHs84FFLo5JWUQ+0dQd0ZqzZoaLVrlFGisP9+313vVRlpUWF
 VbCMAqY8/65+eHXIjtfBTZ+5KB35c0yixgXrF/RQl8wHwUempqN4g/IEKC8dd2P21zGr7cpuT
 sYQow+Bsfdxw4+XzVDvoY2f5ETxqEaxH1kE2FWGbF1rvusq/iITBIWcMOS9CcAHHweJH09r8o
 zz1atywcQWyEit7E5nRXlb+cuQV/WqoFqD2VZEPeR9h3dERFNmHyhS8rgBX6ZRMnrH9w66E4Y
 PEPi62MGkG+5OrNNCkC2Mbs0iclUCV7IboI7O5SwA89HUHkIzn+Ry376H9Gdy+LFGvXZpNd2o
 HNMy0nBjkZ4s/He7sd9KkBCA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> Gesendet: Dienstag, 14=2E M=C3=A4rz 2023 um 10:12 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>
> On Tue, Mar 14, 2023 at 09:51:12AM +0100, Frank Wunderlich wrote:
> > Hi,
> >=20
> > at least the error-message is gone, and interface gets up when i call =
ethtoo to switch off autoneg=2E
=2E=2E=2E
> > [   34=2E400860] mtk_soc_eth 15100000=2Eethernet eth1: phylink_mac_con=
fig: mode=3Dinband/2500base-x/Unknown/Unknown/none adv=3D00,00000000,000000=
00,0000e400 pause=3D04 link=3D0 an=3D1
>=20
> Looking good - apart from that pesky an=3D1 (which isn't used by the PCS
> driver, and I've been thinking of killing it off anyway=2E) Until such
> time that happens, we really ought to set that correctly, which means
> an extra bit is needed in phylink_sfp_set_config()=2E However, this
> should not affect anything=2E
>=20
> > root@bpi-r3:~#=20
> > root@bpi-r3:~# ethtool -s eth1 autoneg off
> > root@bpi-r3:~# [  131=2E031902] mtk_soc_eth 15100000=2Eethernet eth1: =
Link is Up - 2=2E5Gbps/Full - flow control off
> > [  131=2E040366] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes rea=
dy
> >=20
> > full log here:
> > https://pastebin=2Ecom/yDC7PuM2
> >=20
> > i see that an is still 1=2E=2Emaybe because of the fixed value here?
> >=20
> > https://elixir=2Ebootlin=2Ecom/linux/v6=2E3-rc1/source/drivers/net/phy=
/phylink=2Ec#L3038
>=20
> Not sure what that line has to do with it - this is what the above
> points to:
>=20
>         phylink_sfp_set_config(pl, MLO_AN_INBAND, pl->sfp_support, &conf=
ig);

MLO_AN_INBAND =3D> may cause the an=3D1 and mode=3Dinband if previously (?=
) disabled :)

> Anyway, the important thing is the Autoneg bit in the advertising mask
> is now zero, which is what we want=2E That should set the PCS to disable
> negotiation when in 2500baseX mode, the same as ethtool -s eth1 autoneg
> off=2E
>=20
> So I think the question becomes - what was the state that ethtool was
> reporting before asking ethtool to set autoneg off, and why does that
> make a difference=2E

ok, i do ethtool output before and after on next test=2E

> > and yes, module seems to do rate adaption (it is labeled with 100M/1G/=
2=2E5G), i tried it on a 1G-Port and link came up (with workaround patch fr=
om daniel),
> > traffic "works" but in tx-direction with massive retransmitts (i guess=
 because pause-frames are ignored - pause was 00)=2E
>=20
> We'll see about addressing that later once we've got the module working
> at 2=2E5G=2E However, thanks for the information=2E

of course=2E=2E=2Estep by step, just wanted to tell this behaviour

> The patch below should result in ethtool reporting 2500baseT rather than
> 2500baseX, and that an=3D1 should now be an=3D0=2E Please try it, and du=
mp the
> ethtool eth1 before asking for autoneg to be manually disabled, and also
> report the kernel messages=2E

i see no Patch below ;)

regards Frank
