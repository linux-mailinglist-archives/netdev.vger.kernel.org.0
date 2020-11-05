Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C232A7827
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 08:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgKEHmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 02:42:53 -0500
Received: from mout.gmx.net ([212.227.17.21]:46059 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729141AbgKEHmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 02:42:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1604562170;
        bh=LapJPlgixeKlKh32RX9ip+L9RZiboLVCjGqI+5P1+dQ=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=hEb0Hyg9wOv2AYrwzCA50qJmRCbjRHxyDmFes4iTzliTiT3u2gkTLq+ILcywDrmcT
         NeRWsru/51R+/EGx2+9y4xgwQLnP+y09/x6lIG4tXbxZzJjXiWYxGx38X5Lh+DdzPe
         J5j7mCdgDbE8xGydT9gIZs0UkEPd/RpYin+JLS7o=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N0oG5-1kO9Ge17W1-00woGX; Thu, 05
 Nov 2020 08:42:49 +0100
Subject: Re: Very slow realtek 8169 ethernet performance, but only one
 interface, on ThinkPad T14.
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
References: <57f16fe7-2052-72cc-6628-bbb04f146ce0@gmx.com>
 <7ee6a86c-5aca-3931-73cc-2ab72d8dd8a7@gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAU4EEwEIADgCGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCXZw1oQAKCRDC
 PZHzoSX+qCY6CACd+mWu3okGwRKXju6bou+7VkqCaHTdyXwWFTsr+/0ly5nUdDtT3yEVggPJ
 3VP70wjlrxUjNjFb6iIvGYxiPOrop1NGwGYvQktgRhaIhALG6rPoSSAhGNjwGVRw0km0PlIN
 D29BTj/lYEk+jVM1YL0QLgAE1AI3krihg/lp/fQT53wLhR8YZIF8ETXbClQG1vJ0cllPuEEv
 efKxRyiTSjB+PsozSvYWhXsPeJ+KKjFen7ebE5reQTPFzSHctCdPnoR/4jSPlnTlnEvLeqcD
 ZTuKfQe1gWrPeevQzgCtgBF/WjIOeJs41klnYzC3DymuQlmFubss0jShLOW8eSOOWhLRuQEN
 BFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcgaCbPEwhLj
 1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj/IrRUUka
 68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fNGSsRb+pK
 EKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0q1eW4Jrv
 0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEvABEBAAGJ
 ATwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCXZw1rgUJCWpOfwAKCRDCPZHz
 oSX+qFcEB/95cs8cM1OQdE/GgOfCGxwgckMeWyzOR7bkAWW0lDVp2hpgJuxBW/gyfmtBnUai
 fnggx3EE3ev8HTysZU9q0h+TJwwJKGv6sUc8qcTGFDtavnnl+r6xDUY7A6GvXEsSoCEEynby
 72byGeSovfq/4AWGNPBG1L61Exl+gbqfvbECP3ziXnob009+z9I4qXodHSYINfAkZkA523JG
 ap12LndJeLk3gfWNZfXEWyGnuciRGbqESkhIRav8ootsCIops/SqXm0/k+Kcl4gGUO/iD/T5
 oagaDh0QtOd8RWSMwLxwn8uIhpH84Q4X1LadJ5NCgGa6xPP5qqRuiC+9gZqbq4Nj
Message-ID: <c4c063eb-d20b-8bc7-bbd7-b8df70c69a11@gmx.com>
Date:   Thu, 5 Nov 2020 15:42:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <7ee6a86c-5aca-3931-73cc-2ab72d8dd8a7@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ijIbhWMe5LRS7kOXDJMa1nWWTvb4Knu84"
X-Provags-ID: V03:K1:7iXZ5fvYDS74UW9VijPrGPkeCITXl0XwgamP6NKCx7FP0EY4VO9
 FdhTqHLOrAWPOdxALUvlG0Z19dZqamwMg4SvVGqZXKoZ+2N5D3gbROatA92Dail+8M81CMa
 3e3MvKrCFtSJk/573ddSo/m5llV8xyMmzHxbzA0/jQyWlSV8/40kIPOLqEWCRaq37sO7cf9
 yXAlFT43yMfvAlz+sVWRg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SdSvMZmtrAM=:hXQ9NYtMzhjdACRfGVda27
 zhw+XfjkyRymT0nWdiQcbpUHUYPUMIcSAsriYRw0Mn0trf/OPOAzloX6HIlj9BH/2ED8/I2RE
 hgmbInqU8QjK1RCQ+VaK3fl726lStwDB4AMEbZATu2yRMK5tP2tLUQGJlDY+apNSwubuIBbAX
 9hN9pKXfCBkjqEPC8h9V6h3dD5A+0/bKhok0jZ8H677zChMHPXvvURfI+wE6rB/jxNXVx2YcI
 JttGm0l007oRx9ePeTLXAoC10QD9St6dopZKTb98TZcJO40wtJJmGOuJvx6uNW46JoqyybjeZ
 8ITV6+0F6fLRD8966ZKSmWdAL7nCO4YjTAsmTc4UFGy41tRtySG/8QkDaz3xIMJnq2XugI4aM
 hspbkl7oBRsxNsagX2LVfoE9j7DRlayvacaUUF1j8akJTJPV37ONc+2BDmYqaUhGF941Q3rEV
 jJw9dMkemAQ35aoa+OSy4fPs0vdKjB4JnT0Jg+ryu7q4VQ2hBsux06CwLPXZL9T87W4wze4bA
 8t+CDo1YxxkH9VgQLAUppf+wDbE8ZNPy3iafk/bERvgirVMwCo5RqBJSc5FCgYXUaapxszjGu
 cx6cwGApwBlhEWsD/2nc7peHD9AK9afEg0/i7IY1LgAA/0BBBM82ZkKXTNeybMN3jZGF8pvpR
 6hkCsC0Y8W2+k3ohBphZ2x41Hvv0IKuQwzVV0TRN+Z+bb+I21PucOaky3gLhxbSGbVJ/MPZ5J
 m/k9V9xgTvJ8wdF0aEy5Slvu+isCwXNf3jEG2+kKSAXgteyWociM9x0m9zrMDGg9IM62DbXGb
 nRQkGTtn5syifti4bfNQUlvw6J10hf2JBB96kbzrbBU+laqr+jTnZ2t/WuVqUK6vsvbx0o9YX
 Q+XZYXJC62x+rGmpdkIA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ijIbhWMe5LRS7kOXDJMa1nWWTvb4Knu84
Content-Type: multipart/mixed; boundary="ASaQZR5BYvEEQf48JzsMKdsx4uYjktmKT"

--ASaQZR5BYvEEQf48JzsMKdsx4uYjktmKT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2020/11/5 =E4=B8=8B=E5=8D=883:01, Heiner Kallweit wrote:
> On 05.11.2020 03:48, Qu Wenruo wrote:
>> Hi,
>>
>> Not sure if this is a regression or not, but just find out that after =
upgrading to v5.9 kernel, one of my ethernet port on my ThinkPad T14 (ryz=
en version) becomes very slow.
>>
>> Only *2~3* Mbps.
>>
>> The laptop has two ethernet interfaces, one needs a passive adapter, t=
he other one is a standard RJ45.
>>
>> The offending one is the one which needs the adapter (eth0).
>> While the RJ45 one is completely fine.
>>
>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8=
168/8411 PCI Express Gigabit Ethernet Controller (rev 0e)
>> 05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8=
168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
>>
>> The 02:00.0 one is the affected one.
>>
>> The related dmesgs are:
>> [   38.110293] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have=
 ASPM control
>> [   38.126069] libphy: r8169: probed
>> [   38.126250] r8169 0000:02:00.0 eth0: RTL8168ep/8111ep, 00:2b:67:b3:=
d9:20, XID 502, IRQ 105
>> [   38.126252] r8169 0000:02:00.0 eth0: jumbo features [frames: 9194 b=
ytes, tx checksumming: ko]
>> [   38.126294] r8169 0000:05:00.0: can't disable ASPM; OS doesn't have=
 ASPM control
>> [   38.126300] r8169 0000:05:00.0: enabling device (0000 -> 0003)
>> [   38.139355] libphy: r8169: probed
>> [   38.139523] r8169 0000:05:00.0 eth1: RTL8168h/8111h, 00:2b:67:b3:d9=
:1f, XID 541, IRQ 107
>> [   38.139525] r8169 0000:05:00.0 eth1: jumbo features [frames: 9194 b=
ytes, tx checksumming: ko]
>> [   42.120935] Generic FE-GE Realtek PHY r8169-200:00: attached PHY dr=
iver [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=3Dr8169-200:00, irq=3D=
IGNORE)
>> [   42.247646] r8169 0000:02:00.0 eth0: Link is Down
>> [   42.280799] Generic FE-GE Realtek PHY r8169-500:00: attached PHY dr=
iver [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=3Dr8169-500:00, irq=3D=
IGNORE)
>> [   42.477616] r8169 0000:05:00.0 eth1: Link is Down
>> [   76.479569] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow=
 control rx/tx
>> [   91.271894] r8169 0000:02:00.0 eth0: Link is Down
>> [   99.873390] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow=
 control rx/tx
>> [   99.878938] r8169 0000:02:00.0 eth0: Link is Down
>> [  102.579290] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow=
 control rx/tx
>> [  185.086002] r8169 0000:02:00.0 eth0: Link is Down
>> [  392.884584] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow=
 control rx/tx
>> [  392.891208] r8169 0000:02:00.0 eth0: Link is Down
>> [  395.889047] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow=
 control rx/tx
>> [  406.670738] r8169 0000:02:00.0 eth0: Link is Down
>>
>> Really nothing strange, even it negotiates to 1Gbps.
>>
>> But during iperf3, it only goes up to miserable 3Mbps.
>>
>> Is this some known bug or something special related to the passive ada=
pter?
>>
>> Since the adapter is passive, and hasn't experience anything wrong for=
 a long time, I really doubt that.
>>
>> Thanks,
>> Qu
>>
>>
> Thanks for the report. From which kernel version did you upgrade?

Tested back to v5.7, which still shows the miserable performance.

So I guess it could be a faulty adapter?

> Please test
> with the prior kernel version and report behavior (link stability and s=
peed).
> Under 5.9, does ethtool -S eth0 report packet errors?
>=20
Nope, no tx/rx_errors, no missed/aborted/underrun.

Adding that the adapter is completely passive (no chip, just converting
RJ45 pins to the I shaped pins), I'm not sure that the adapter itself
can fail.

THanks,
Qu


--ASaQZR5BYvEEQf48JzsMKdsx4uYjktmKT--

--ijIbhWMe5LRS7kOXDJMa1nWWTvb4Knu84
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAl+jrPYACgkQwj2R86El
/qjN/QgAkezfx3yT8zXEG99GIOGF9JAxRowNz+ZPqJFfxFPvnhPs4Ah3kWfDNTqi
GHnbkT3vvIWKTktvbvJj7NnUPjQbMEFGmWr4C/Pjr4EQCVjJGFDUz3i9rplV1ZGF
7cD2FMYlGM3bnMWxkp5G/wzw9ZKeWQKPpMku1Yb7I4WA6pcFWwpMXw3shpZLwCV9
RZdZtPLlt+XJTz9AKr6I+8YFw8pKHmjI5h1AaH44egEjZzcFBr9GCeqVNZxujykF
xeBAQ/JU0UHPpeUHb6jmZg1NYuLmlJNyHQnI5C7B6VQEfczx/Sp+S/1ySmMiciPh
gRigRSfXaX3kqIlPnX/FbUrCwhWZCw==
=6e0b
-----END PGP SIGNATURE-----

--ijIbhWMe5LRS7kOXDJMa1nWWTvb4Knu84--
