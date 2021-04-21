Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1838B366D8E
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243251AbhDUOFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:05:43 -0400
Received: from mout.gmx.net ([212.227.17.22]:56801 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235887AbhDUOFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 10:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1619013874;
        bh=eo1nK0UD2a7QXD/BCB5NO5zSj3zAXmk7v82G2w6ov4I=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=G+fxJoRkgDWQqoVA/oCFNizQN28RLwvucCkG4u4LUS13DuzyCAR10TCUyD06nCofG
         ktc2+sk1UiidCDYbv0oth/EwiWC8eym5yn/GmOCsMA9NdU0NWWicPpnSZjYjm93O9s
         KF+ZykHc+hPXTY42qP9sVj0rp1RujzEaHoeKMbM4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.77.133] ([80.245.77.133]) by web-mail.gmx.net
 (3c-app-gmx-bs34.server.lan [172.19.170.86]) (via HTTP); Wed, 21 Apr 2021
 16:04:34 +0200
MIME-Version: 1.0
Message-ID: <trinity-47c2d588-093d-4054-a16f-81d76aa667e0-1619013874284@3c-app-gmx-bs34>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Subject: Aw: Re: [PATCH net-next v2 2/2] net: ethernet: mediatek: support
 custom GMAC label
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 21 Apr 2021 16:04:34 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <CALCv0x2SG=0kBRnxfSPxi+FvaBK=QGPHQkHWHvTXOw64KawPUQ@mail.gmail.com>
References: <20210419154659.44096-1-ilya.lipnitskiy@gmail.com>
 <20210419154659.44096-3-ilya.lipnitskiy@gmail.com>
 <20210420195132.GA3686955@robh.at.kernel.org>
 <CALCv0x2SG=0kBRnxfSPxi+FvaBK=QGPHQkHWHvTXOw64KawPUQ@mail.gmail.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:sV5Mlbn73eWH7aiVlwaybpsQCFZyxd8vwbmUGt69EWlA1fnqNSM9XL/OwUTnRLA5pwmJ2
 gQkOKxpSNkq6/G3e221sldSrvVJLEN4B49Qny4npb20S0MhCGfh0wrdacbeBD/nargGhUw2I7I5m
 I99HhDGPZSLFTC/zJEQhrTf4sJ7+6nT2AQu9uZLnD84WejyQBaFQZMMuNpHJdGVRAYllNzG7loj4
 Gf6K304Da2vxOZP1JyzFMtzwfeh81dRZHl+2GW69itbKKoKMzWtgkXQ1d2CHNHQaHTbgHAVGY+rW
 P0=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Z2mfGzqKo3A=:7BgbnqxAImJaah8rUDd72I
 qd9iee+wk72p/Y+dXXy+REOgl5yfZHwf4KOIwbXQ4SOZPHo3dgu7MNwpkGTS0N+4iNTbwggOX
 ctORwLVkjE7QoBlZLU0RBC6JpGFZb0gVOoLpALJwzHV9kfwhyTq0YwdecwIennA5diIsyFl6u
 +eDtmPFQAGVrcusQ2RngtfIftgPhmiZ4aMkfWzV+QfaUx9wjCf4sLpw6+KBAaXSLymW6FLCOt
 u67DE3xm5QTYs3rZfoKBFNM5oAx5FiY1pjUV76MWmsUZFXsPxU6voxOh15CH5t9esDGdb6Cyj
 54qZ+K5QuGVsSpLgUC9xGtbBi/BQjMkM+Zr2b0exGKaeyniIaeTi3vDuuRX1Z/ZgrICmO7w+G
 /lSqUT9dnFfBBfYzxNfNBJTpKHeUCNDtKHqK/QM+KJRvFdCaeV7Wo4HrM4R47Ymp6Em7RiT8r
 k12pTc/fB0ZQnFEVhSPmIAcGBMRbRWqQffoHJTsD6B0nH69C+PcgsqFGNyli89FXqPZuJ1pLr
 DCITTDUsUy1TfhafZOMiw+AqNh7fOQPazWrpSmr0ui8Darhm+dEw6U/lNLBlhqWFLAfOlarvi
 q5Dn1CNvLeRjGKRnq6v4KdWrogCp5dLFQrlpzMORRtkpHyAwTsPj8mBAp42ltz/kfqBp0H/Dt
 6cZr5FZhVMceWm6R+P8m505ySlRkX/MsnPnKRT57l5fa4XxLYdAEQRS1Jy+pfoA69A8j44Byw
 YRi4CtB4eiB/JKOptodiWl5nnYIs6H6DIRGXZgrhZCDFiElEVj572TAKYmMWAGi+q90VkzIm5
 N3YMTjWFekP3kFSV9/ZR372038pW0j+0ijryhNruduR4LIjCXJY2J6OrIFAUzTM68Y7hjCuBq
 ZWyWRmxE0zfwVUlIHTCJBmMaSaZcQiHhPA5qzSfJE+vAatagR1ewYZ2yDZFoO81/25igrac+K
 9DcCk+d7Igg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

for dsa slave-ports there is already a property "label", but not for master/cpu-ports

https://elixir.bootlin.com/linux/v5.12-rc8/source/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts#L163

handled here:

https://elixir.bootlin.com/linux/v5.12-rc8/source/net/dsa/dsa2.c#L1113

@ilya maybe you can rename slave-ports instead of master-port without code change?

i also prefer a more generic way to name interfaces in dts, not only in the mtk-driver, but the udev-approach is a way too, but this needs to be configured on each system manually...a preset by kernel/dts will be nice (at least to distinguish master/cpu- and user-ports).

regards Frank
