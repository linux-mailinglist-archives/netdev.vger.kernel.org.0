Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5901A1CB5EA
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgEHR0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:26:46 -0400
Received: from mout.gmx.net ([212.227.17.22]:33597 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgEHR0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 13:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1588958790;
        bh=hyiprsuz9UXAT1dCFSVeWCkFnS5rgGuHF6WUa6L+qyE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=XdCQG2JywkVdQPiYKoFmsQR9sa2vd+DpceT8ZVFK16oDjljRPrEsyujLz6rvA2Zun
         68wK9mqP3edtvn5OnwL+8UO30tX6F5p4Idc5RSB+Qe6sp7NvjUAfT1vdoG2djne0K4
         l6lyemfnbbDy3hO10NYqEyE7y6yW6YHLOLwq0YZY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.164] ([37.4.249.184]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M7b6b-1jTWP52VNV-0085h9; Fri, 08
 May 2020 19:26:30 +0200
Subject: Re: [PATCH net v2] net: bcmgenet: Clear ID_MODE_DIS in
 EXT_RGMII_OOB_CTRL when not needed
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200225131159.26602-1-nsaenzjulienne@suse.de>
 <cf07fae3-bd8f-a645-0007-a317832c51c1@samsung.com>
 <CGME20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865@eucas1p2.samsung.com>
 <a3df217d-f35c-9d74-4069-d47dee89173e@samsung.com>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <e8526ec5-9a42-4b0a-b517-f9beaea5e8cd@gmx.net>
Date:   Fri, 8 May 2020 19:26:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a3df217d-f35c-9d74-4069-d47dee89173e@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:QdtA8F0kYyNoHEZrdRjOVAssihw7PGofdsobrZm2T8ZvrBcvUfZ
 8sMD5G2Kof/nPqxiMCRkCmEV6Kc8NWuNaTRHZUzHM3ES/d8nohVpUacaaTlYCpDJqA3PRng
 FQmHgjiDvavlbk4/LpoaJh+59S56fY85ZqgM1wTE+tVljgNy8dA4tdrJKUwxH0SayF4jQzN
 1sh3ucYpH+pJzExcsLTzQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:P/q6NKSUbV0=:A4YzS7pK6RtZjlZ38JGiFB
 V/PDfUf541AB8SN+Hn6Hm+El35YDbx9Nh6fV6a9tOYPAGx61GBpXc92PJFTidFrlX7aJWd1sO
 8emKlgDokWoPzFflN6a95wRwR+0J+cKpXz6cx/Muk4M7lThJzlGIr458+elLeWuC6YqJgxsGv
 DVth3XE58ox4ALCbBPykLMLezSBAv9fYhOQjxpVAO2YlqaSjH8Z9SrV6uCXbAAhzAbuoJ2wIN
 qeJq0dfZl1tR0IK4rjfgdEWwxv72wgKqfQcDCWoq0gqfE0J4Dm+9STg5f16bs1kPxe//98wLM
 ++Br6FR72jdvFYFhcPeQsYmk4aOBzCIJOMuLS9kIZhX2ea2eUkIOiFASg2C7tN+TYTCD/Du/d
 TQ2dKyYa2eezGgeSVhaEj1zXeyUEOA4HvNIPhl/Msc0kTNB4Fm3Wg9fGPpivCJ7eRFbTXPpG+
 J+4xYeULgHKpRjwgryb6Z1gouGXIQRfLXLj3CR6xLhfjT2wy1aK6J+zlIOwX2s8LSxKRyEW6q
 Ty//WdvwtKV3Skj7/r0ip1R6RxqKiEWtZ3xJDM9Q+7l4iJ4GAQGR88Una1k2b4z+0MxRdQQYs
 pfJOxAlyDu7+hcHqi7sw+8B/Wz0NHE2U1AfJF3OoHtC+YmM/Wh572cvwMh4elBuDasYBIpqlE
 NO/6dKrnz1Ia3T74oeiFVH7MrSnlXYMHlcB8yGOA3z7uV72RmuWDeok95IWxFLI0HxTSdFhcW
 IQ2EIa9PFambksUDWb7mKO7jQr9X7LGMOZMbOSUVhp0fQ/0g3N6Z8uGWfXWOTvIyagHRaDSgD
 50b63P+glTXfC+rVt7A/Vzkytvp/vaiX0W/Kcf63B4kz6b0wC/g1xMzwlApZrixqJAi6hWE5Y
 T8klZUa6fbbrEBWpo9bCTMu2qyXmb9S1MuOnkvzBexGxnSCckbMt91vx1eSHFPCWeWth3k0mn
 1mPxm1bTVT0aogD0eaCean3JngUBFXpTN4McZ53XNbpRsj6sJxeb17hjDdZ1Y/ICvHpW01y18
 Y9d88ayPmKj6fRGXX+HOpS/6BGkqK65zFlx1oWEqWSl6xdI7H2AGehi2oAVtlINBYpRE3cjJJ
 bgHkEG1jiEPS21kvqHqG1XIYIMoQO9aLkuHvcyYjIkcMzo0deeBJmh73Px8yrHy5S2pHpTooi
 uBdQ0xxtFFsZwQpuZKLEBvRC/9G4Al/ooN8K7h5ru0ajPGHaIbV41WCa9TCtCV3ZCt0BHkCYB
 EiFIDhlxOp+DnrkbP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

Am 07.05.20 um 12:03 schrieb Marek Szyprowski:
> Hi
>
> On 07.05.2020 11:46, Marek Szyprowski wrote:
>> On 25.02.2020 14:11, Nicolas Saenz Julienne wrote:
>>> Outdated Raspberry Pi 4 firmware might configure the external PHY as
>>> rgmii although the kernel currently sets it as rgmii-rxid. This makes
>>> connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
>>> explicitly clear that bit whenever we don't need it.
>>>
>>> Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")
>>> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
>> I've finally bisected the network issue I have on my RPi4 used for
>> testing mainline builds. The bisect pointed to this patch. Once it got
>> applied in v5.7-rc1, the networking is broken on my RPi4 in ARM32bit
>> mode and kernel compiled from bcm2835_defconfig. I'm using u-boot to
>> tftp zImage/dtb/initrd there. After reverting this patch network is
>> working fine again. The strange thing is that networking works fine if
>> kernel is compiled from multi_v7_defconfig but I don't see any obvious
>> difference there.
>>
>> I'm not sure if u-boot is responsible for this break, but kernel
>> definitely should be able to properly reset the hardware to the valid
>> state.
>>
>> I can provide more information, just let me know what is needed. Here
>> is the log, I hope it helps:
>>
>> [=C2=A0=C2=A0 11.881784] bcmgenet fd580000.ethernet eth0: Link is Up -
>> 1Gbps/Full - flow control off
>> [=C2=A0=C2=A0 11.889935] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link beco=
mes ready
>>
>> root@target:~# ping host
>> PING host (192.168.100.1) 56(84) bytes of data.
>> From 192.168.100.53 icmp_seq=3D1 Destination Host Unreachable
>> ...
> Okay, I've played a bit more with this and found that enabling
> CONFIG_BROADCOM_PHY fixes this network issue. I wonder if Genet driver
> should simply select CONFIG_BROADCOM_PHY the same way as it selects
> CONFIG_BCM7XXX_PHY.

thanks for finding this issue. So it seems arm64/defconfig is also affecte=
d.

I don't have a strong opinion how to solve this.

Best regards
Stefan

>
> Best regards
