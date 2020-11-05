Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5052A7B82
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgKEKU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:20:26 -0500
Received: from mout.gmx.net ([212.227.17.20]:57875 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgKEKU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 05:20:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1604571622;
        bh=J60Hs08ctBMGnu8VYEei//B33PVRybH0LWEN5EqOdZk=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=IIMhubYpsATwnXOOPCXRLtomHQNTW4HJ1eXThoUQRJQewuodC3ohW0uV+5XCq6g/n
         3eQDDCHV5A2+JTVl4Wt6ep9NlZD2rkLpj7SrP9r+TKLTxAxN69vCsWvDO+SZIodQLT
         WS/VO08LcvUwSi0syvYWVbkDvlm3G18TbW6XSlTw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MF3HU-1kYRa94BHE-00FQ85; Thu, 05
 Nov 2020 11:20:22 +0100
Subject: Re: Very slow realtek 8169 ethernet performance, but only one
 interface, on ThinkPad T14.
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
References: <57f16fe7-2052-72cc-6628-bbb04f146ce0@gmx.com>
 <7ee6a86c-5aca-3931-73cc-2ab72d8dd8a7@gmail.com>
 <c4c063eb-d20b-8bc7-bbd7-b8df70c69a11@gmx.com>
 <9f8785d2-76b2-f0ad-7fa1-a8a38d7df3af@gmail.com>
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
Message-ID: <57b01490-7131-b845-81b0-14d64e83d316@gmx.com>
Date:   Thu, 5 Nov 2020 18:20:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <9f8785d2-76b2-f0ad-7fa1-a8a38d7df3af@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="weZFtWHdsGDjdghiI3EptHmQuqGvNuFC5"
X-Provags-ID: V03:K1:lSwYX1KfJseE/jhMUBWNz9yRpl2lpNiyzo6o31gXz5PtrhBwWto
 olj6NTGirJX8YroBMn8iP5pcr/DN25H/ohn4BuhYHOSnc9arossdf0avRbG3JyyrhFlB1mW
 yMzI4vqwB4oYyz8aaTU+UCxsDYcuS29cE40D4Sh+RjhPWSdmO9uvPW54QPNez5WJW4PiqsS
 bryOS5Bjj0qEw7IgIrm/g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:s+sipxVpYfE=:iiSENiUbVCS03RnvrDG5c+
 Pn0TNdaOfCLZmsOa9SQyhdFE0+NpcEDCo4L+y9uYS1RX5vQnZ8PFLHDZnvvDiKb4cvyvDPFvJ
 DIu6HA2f7yfTeTe4dM/IOINjw4cFT0oAN//D2/aPzTcrljeRrJ/tMS+TcvpaymiDe4+SMdqlp
 beH2e5LJieJr5no2zPkWzXLfrU6hX3A7PMNjqibTFE2o5rEtwUrQP/n6LcAsVVZXuf9swvT3r
 08GKz/E32IizUUKBu955n/Ai3XpX3IBnvHpPH148r0GCMVv9jGC6W4BBJD8wy5xsqr8dNzJtr
 LHEsTR9NCzJpzKbJki3ejXrjF4ENfFSZwuKJhwxKygQ+0hKlvmq7JfncZzLRxP93CIgiR6D9s
 DdUdMYev2sHr2c+xTN+5XMTCfX3/QzVvJINmhPCUXed67Y42x7D1y3tgsxNKDZnB0nzb+JIbo
 psX+qKWY+IO1sR7qBfYuP98Pq5hx5BUCorpetVuI61NIpBT8ml88T6PdE+hZ8pmG96MryTWBs
 ihka5kq8aSjEHXXcTUt3m648OO/eAuKYctaVrVXBvbHWzKcJYI2MAum5rn/+8D9WX1QyN/TFu
 eR+ODI3LDBYu7eqFZ88A3HMBfaGoIRN4LOH6QAnmeUZEPynojsJxIkGotBCJK8Co4/hruht/4
 +5hPKHbm6fiXgwudQmBqZQGMsBMVeC524HpkiUSjHU6ZP0cgzDlDrpdhLnoOpZZgXCSzCWWXz
 6zAXzyEQlBTdlmhM2cBapFyapq2e/g8h15ipAa4j1k9j9bWPZ8kGhYU5ZBlTmEnwI6NG8ESj8
 ffzMB4lWayCBg8IbYD+RRpLdyoJcTsa0AGv9WtXQ39pD7Ma4O00DLlhvP+Ol6r6f+aa3vCBGC
 J65UTQDUXbE6QiBBAV0Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--weZFtWHdsGDjdghiI3EptHmQuqGvNuFC5
Content-Type: multipart/mixed; boundary="TEmQDuz14bPA62p4mFqjpnRG5Aqe9SAml"

--TEmQDuz14bPA62p4mFqjpnRG5Aqe9SAml
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2020/11/5 =E4=B8=8B=E5=8D=885:13, Heiner Kallweit wrote:
> On 05.11.2020 08:42, Qu Wenruo wrote:
>>
>>
>> On 2020/11/5 =E4=B8=8B=E5=8D=883:01, Heiner Kallweit wrote:
>>> On 05.11.2020 03:48, Qu Wenruo wrote:
>>>> Hi,
>>>>
>>>> Not sure if this is a regression or not, but just find out that afte=
r upgrading to v5.9 kernel, one of my ethernet port on my ThinkPad T14 (r=
yzen version) becomes very slow.
>>>>
>>>> Only *2~3* Mbps.
>>>>
>>>> The laptop has two ethernet interfaces, one needs a passive adapter,=
 the other one is a standard RJ45.
>>>>
>>>> The offending one is the one which needs the adapter (eth0).
>>>> While the RJ45 one is completely fine.
>>>>
>>>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111=
/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0e)
>>>> 05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111=
/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
>>>>
>>>> The 02:00.0 one is the affected one.
>>>>
>>>> The related dmesgs are:
>>>> [   38.110293] r8169 0000:02:00.0: can't disable ASPM; OS doesn't ha=
ve ASPM control
>>>> [   38.126069] libphy: r8169: probed
>>>> [   38.126250] r8169 0000:02:00.0 eth0: RTL8168ep/8111ep, 00:2b:67:b=
3:d9:20, XID 502, IRQ 105
>>>> [   38.126252] r8169 0000:02:00.0 eth0: jumbo features [frames: 9194=
 bytes, tx checksumming: ko]
>>>> [   38.126294] r8169 0000:05:00.0: can't disable ASPM; OS doesn't ha=
ve ASPM control
>>>> [   38.126300] r8169 0000:05:00.0: enabling device (0000 -> 0003)
>>>> [   38.139355] libphy: r8169: probed
>>>> [   38.139523] r8169 0000:05:00.0 eth1: RTL8168h/8111h, 00:2b:67:b3:=
d9:1f, XID 541, IRQ 107
>>>> [   38.139525] r8169 0000:05:00.0 eth1: jumbo features [frames: 9194=
 bytes, tx checksumming: ko]
>>>> [   42.120935] Generic FE-GE Realtek PHY r8169-200:00: attached PHY =
driver [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=3Dr8169-200:00, irq=3D=
IGNORE)
>>>> [   42.247646] r8169 0000:02:00.0 eth0: Link is Down
>>>> [   42.280799] Generic FE-GE Realtek PHY r8169-500:00: attached PHY =
driver [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=3Dr8169-500:00, irq=3D=
IGNORE)
>>>> [   42.477616] r8169 0000:05:00.0 eth1: Link is Down
>>>> [   76.479569] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - fl=
ow control rx/tx
>>>> [   91.271894] r8169 0000:02:00.0 eth0: Link is Down
>>>> [   99.873390] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - fl=
ow control rx/tx
>>>> [   99.878938] r8169 0000:02:00.0 eth0: Link is Down
>>>> [  102.579290] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - fl=
ow control rx/tx
>>>> [  185.086002] r8169 0000:02:00.0 eth0: Link is Down
>>>> [  392.884584] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - fl=
ow control rx/tx
>>>> [  392.891208] r8169 0000:02:00.0 eth0: Link is Down
>>>> [  395.889047] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - fl=
ow control rx/tx
>>>> [  406.670738] r8169 0000:02:00.0 eth0: Link is Down
>>>>
>>>> Really nothing strange, even it negotiates to 1Gbps.
>>>>
>>>> But during iperf3, it only goes up to miserable 3Mbps.
>>>>
>>>> Is this some known bug or something special related to the passive a=
dapter?
>>>>
>>>> Since the adapter is passive, and hasn't experience anything wrong f=
or a long time, I really doubt that.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>> Thanks for the report. From which kernel version did you upgrade?
>>
>> Tested back to v5.7, which still shows the miserable performance.
>>
>> So I guess it could be a faulty adapter?
>>
>>> Please test
>>> with the prior kernel version and report behavior (link stability and=
 speed).
>>> Under 5.9, does ethtool -S eth0 report packet errors?
>>>
>> Nope, no tx/rx_errors, no missed/aborted/underrun.
>>
>> Adding that the adapter is completely passive (no chip, just convertin=
g
>> RJ45 pins to the I shaped pins), I'm not sure that the adapter itself
>> can fail.
>>
> Each additional mechanical connection may cause reflections or other si=
gnal
> disturbance. You could try to restrict the speed to 100Mbps via ethtool=
,
> and see what the effective speed is then. 100Mbps uses two wire pairs o=
nly.

OK, you're right, now I can get around 60Mbps.

So definitely something wrong with the adapter.

Will use the RJ45 one and avoid use the ThinkPad proprietary interface.

Thanks,
Qu
>=20
>> THanks,
>> Qu
>>
>=20


--TEmQDuz14bPA62p4mFqjpnRG5Aqe9SAml--

--weZFtWHdsGDjdghiI3EptHmQuqGvNuFC5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAl+j0eMACgkQwj2R86El
/qhtkggAlL8gqogEU0MAgoxn1hAoyxsSq2zBtjZi19Pj94qRnW7QI+DmvbtFueAi
3OeVbzSR03OOlvjGP7ICLA29LFP7hJSoSzqe3E1sayDMHr4QXyIWctqxwT5gisaG
X39WIftMEMCWo+UM03MJ0bXEIjhYl69lZxvXyaclr7cXoofK7qKUOZgBESFt7ljQ
9WhH+5O+G/L3UXfOwYh5w5i/IFlQUWNFnyH7ELqJUGdyz4M6ZX6ajUU8QqlSqOm4
W/IWd1+XK2PMi05IIMfipqfg+OZKbCYDDsXQQfaCvwyREmWb3w3DAcu4VjKTgGub
psVPP2gNiaPoq3pTJQqkb5ARaJpMoQ==
=aZxd
-----END PGP SIGNATURE-----

--weZFtWHdsGDjdghiI3EptHmQuqGvNuFC5--
