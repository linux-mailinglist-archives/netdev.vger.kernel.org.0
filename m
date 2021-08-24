Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD11E3F58A8
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 09:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhHXHE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 03:04:29 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61611 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhHXHE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 03:04:28 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210824070343euoutp0284c983cd265daea3fad48aab99e075ce~eLB5EcgFn1481914819euoutp02_
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 07:03:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210824070343euoutp0284c983cd265daea3fad48aab99e075ce~eLB5EcgFn1481914819euoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629788623;
        bh=K7UcmSiFeYIOQ4+FF8trOkGP6PZRVAmTewD5ZmA1IiY=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Jktda2QXVQN4FoGQyCjj//PxhEyo/A1Ud7cR8R+t7/x4pa6DJH+Zb/2VW9mWsk5DZ
         K/EchbnT/8Qjhod1D2dAFNUvCVfI5arenxmdEVOh2dup7jsLrljAEtOx+cz7fCAvYC
         Nt0kff8af6BX+c+65iDbutK+mIyfXxbVnYsvKKkA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210824070343eucas1p1b780ef683d1f7bb4b90669590f8f0e65~eLB4xq0Pf2738027380eucas1p18;
        Tue, 24 Aug 2021 07:03:43 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 7D.A6.42068.FC994216; Tue, 24
        Aug 2021 08:03:43 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210824070342eucas1p1c0293540f5c1138aa0c7b7e877ef1da9~eLB4M9k520119901199eucas1p1Q;
        Tue, 24 Aug 2021 07:03:42 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210824070342eusmtrp2f3f6005efdc359dbb440103206c25839~eLB4L90IY0846908469eusmtrp2I;
        Tue, 24 Aug 2021 07:03:42 +0000 (GMT)
X-AuditID: cbfec7f4-c71ff7000002a454-90-612499cfdc75
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 08.A0.20981.EC994216; Tue, 24
        Aug 2021 08:03:42 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210824070342eusmtip1decc011336f231776205c3907c391e6b~eLB3kOT1P1034810348eusmtip1T;
        Tue, 24 Aug 2021 07:03:42 +0000 (GMT)
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for
 "phy-handle" property
To:     Saravana Kannan <saravanak@google.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <427ce8cd-977b-03ae-2020-f5ddc7439390@samsung.com>
Date:   Tue, 24 Aug 2021 09:03:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAGETcx_xJCqOWtwZ9Ee2+0sPGNLM5=F=djtbdYENkAYZa0ynqQ@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsWy7djP87rnZ6okGsx4IGBx/u4hZov5R86x
        Wsx885/NYsd2EYsFs7ktLu+aw2ZxqC/a4tgCMYvWvUfYLboO/WVz4PLYtnsbq8f7G63sHjtn
        3WX3WLCp1GPTqk42j81L6j127vjM5PF5k1wARxSXTUpqTmZZapG+XQJXxrG/B9kLpktVfL01
        k7mBcYJYFyMnh4SAiURr63PGLkYuDiGBFYwSp689Y4dwvjBK/N06lRnC+cwo8ejlAUaYlnPP
        b0JVLWeUePv6LCuE85FRYvX0LewgVcICkRJn9+1lA7FFBLQkNl17zAJSxCywkkni9vpHLCAJ
        NgFDia63XWBFvAJ2Eh2nIWwWAVWJtbvvgA0SFUiWmPhkEitEjaDEyZlPgHo5ODgFAiW+XTQE
        CTMLyEs0b53NDGGLS9x6Mp8JZJeEwH8OiQ0vtrBBnO0i0XywiwXCFpZ4dRziUAkBGYn/O2Ea
        mhklHp5byw7h9DBKXG6aAfW0tcSdc7/YQDYzC2hKrN+lDxF2lPjd/pgVJCwhwCdx460gxBF8
        EpO2TWeGCPNKdLQJQVSrScw6vg5u7cELl5gnMCrNQvLZLCTvzELyziyEvQsYWVYxiqeWFuem
        pxYb5aWW6xUn5haX5qXrJefnbmIEpq3T/45/2cG4/NVHvUOMTByMhxglOJiVRHj/MiknCvGm
        JFZWpRblxxeV5qQWH2KU5mBREudN2rImXkggPbEkNTs1tSC1CCbLxMEp1cAUtDVLV4xb9M2y
        VRPtpBt5GhfMr+r4wr9v/UxVhidnT/vMqLG2XHGBSSdH8FTBtdmLsl+uCFI1Maw07HptppHd
        7TLDTe+mXlXVvN2X5s9ZdWm6iBTn1jau4+4/c47s0Og4OUtk3t50fbb9uufZ8oXUjp42mLlg
        4rfSi8npJetCLhhOT3pZ8bM4f3rj8/LlW+74l/e+yNT7+T3J/UnljzAhg9uSsrznT2gwii6L
        uuS68KBUdbb7iUvxEy6Xx/e5f7603041b9H7DTO2qW64Nfk+v8ab6XPnLwjaW/PnZj6/sOsX
        AW6R/fVNCi8lwrMr5TRqVqe1TL9zUWGSJ+veEtWIN5uOv3/bcug+j3GBzKLLSizFGYmGWsxF
        xYkAnR9FucoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t/xu7rnZqokGjy8qGpx/u4hZov5R86x
        Wsx885/NYsd2EYsFs7ktLu+aw2ZxqC/a4tgCMYvWvUfYLboO/WVz4PLYtnsbq8f7G63sHjtn
        3WX3WLCp1GPTqk42j81L6j127vjM5PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJ
        pZ6hsXmslZGpkr6dTUpqTmZZapG+XYJexrG/B9kLpktVfL01k7mBcYJYFyMnh4SAicS55zfZ
        uxi5OIQEljJKPLn9lBkiISNxcloDK4QtLPHnWhcbRNF7RonHv+cwgSSEBSIlvj87yQhiiwho
        SWy69pgFxGYWWMkksfJROURDN5PElBlNYAk2AUOJrrcgkzg5eAXsJDpOQ9gsAqoSa3ffYQex
        RQWSJT6cXsoKUSMocXLmE6BeDg5OgUCJbxcNIeabSczb/JAZwpaXaN46G8oWl7j1ZD7TBEah
        WUi6ZyFpmYWkZRaSlgWMLKsYRVJLi3PTc4uN9IoTc4tL89L1kvNzNzECo3TbsZ9bdjCufPVR
        7xAjEwfjIUYJDmYlEd6/TMqJQrwpiZVVqUX58UWlOanFhxhNgd6ZyCwlmpwPTBN5JfGGZgam
        hiZmlgamlmbGSuK8JkfWxAsJpCeWpGanphakFsH0MXFwSjUwqeiW1H8/re2+Q0l/q9TMeu5F
        Xu8WuZWwHN01N9KqOvoa62OdkNV76zRF19yaZcrFYLnrfV3ckajQE41JMq7//+oEPxDMe7az
        fn5F9U+/dkfWi/JODIpzVCZsdGzfKnVlb2D9F6ONywpmPQ05vUXx9ek2Eb1ejzuzlBfuvb3N
        akXY16fznwea7wy6NPngeQ4fodbs/u+OdpdVHp7eO2myy/ZS09pVWqkP6/vyS9Y9+xgtG3Oi
        X+RrwjGuiPgLmUE/nvw4sl42vmrztuQY1gP7i7xEFIOvKr6q5tl9xGDBqcefZ5zm644rExZy
        vOi3WqV7gyfLl6K386Pi8m7Hf/BZLXLrm9iW8B9h+1Z67z32VImlOCPRUIu5qDgRAGox1BNb
        AwAA
X-CMS-MailID: 20210824070342eucas1p1c0293540f5c1138aa0c7b7e877ef1da9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210823120849eucas1p11d3919886444358472be3edd1c662755
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210823120849eucas1p11d3919886444358472be3edd1c662755
References: <CGME20210823120849eucas1p11d3919886444358472be3edd1c662755@eucas1p1.samsung.com>
        <20210818021717.3268255-1-saravanak@google.com>
        <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
        <CAGETcx_xJCqOWtwZ9Ee2+0sPGNLM5=F=djtbdYENkAYZa0ynqQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 23.08.2021 20:22, Saravana Kannan wrote:
> On Mon, Aug 23, 2021 at 5:08 AM Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> On 18.08.2021 04:17, Saravana Kannan wrote:
>>> Allows tracking dependencies between Ethernet PHYs and their consumers.
>>>
>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>> Cc: netdev@vger.kernel.org
>>> Signed-off-by: Saravana Kannan <saravanak@google.com>
>> This patch landed recently in linux-next as commit cf4b94c8530d ("of:
>> property: fw_devlink: Add support for "phy-handle" property"). It breaks
>> ethernet operation on my Amlogic-based ARM64 boards: Odroid C4
>> (arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts) and N2
>> (meson-g12b-odroid-n2.dts) as well as Khadas VIM3/VIM3l
>> (meson-g12b-a311d-khadas-vim3.dts and meson-sm1-khadas-vim3l.dts).
>>
>> In case of OdroidC4 I see the following entries in the
>> /sys/kernel/debug/devices_deferred:
>>
>> ff64c000.mdio-multiplexer
>> ff3f0000.ethernet
>>
>> Let me know if there is anything I can check to help debugging this issue.
> I'm fairly certain you are hitting this issue because the PHY device
> doesn't have a compatible property. And so the device link dependency
> is propagated up to the mdio bus. But busses as suppliers aren't good
> because busses never "probe".
>
> PHY seems to be one of those cases where it's okay to have the
> compatible property but also okay to not have it. You can confirm my
> theory by checking for the list of suppliers under
> ff64c000.mdio-multiplexer. You'd see mdio@0 (ext_mdio) and if you look
> at the "status" file under the folder it should be "dormant". If you
> add a compatible property that fits the formats a PHY node can have,
> that should also fix your issue (not the solution though).

Where should I look for the mentioned device links 'status' file?

# find /sys -name ff64c000.mdio-multiplexer
/sys/devices/platform/soc/ff600000.bus/ff64c000.mdio-multiplexer
/sys/bus/platform/devices/ff64c000.mdio-multiplexer

# ls -l /sys/devices/platform/soc/ff600000.bus/ff64c000.mdio-multiplexer
total 0
lrwxrwxrwx 1 root root    0 Jan  1 00:04 
consumer:platform:ff3f0000.ethernet -> 
../../../../virtual/devlink/platform:ff64c000.mdio-multiplexer--platform:ff3f0000.ethernet
-rw-r--r-- 1 root root 4096 Jan  1 00:04 driver_override
-r--r--r-- 1 root root 4096 Jan  1 00:04 modalias
lrwxrwxrwx 1 root root    0 Jan  1 00:04 of_node -> 
../../../../../firmware/devicetree/base/soc/bus@ff600000/mdio-multiplexer@4c000
drwxr-xr-x 2 root root    0 Jan  1 00:02 power
lrwxrwxrwx 1 root root    0 Jan  1 00:04 subsystem -> 
../../../../../bus/platform
lrwxrwxrwx 1 root root    0 Jan  1 00:04 
supplier:platform:ff63c000.system-controller:clock-controller -> 
../../../../virtual/devlink/platform:ff63c000.system-controller:clock-controller--platform:ff64c000.mdio-multiplexer
-rw-r--r-- 1 root root 4096 Jan  1 00:04 uevent
-r--r--r-- 1 root root 4096 Jan  1 00:04 waiting_for_supplier

# cat 
/sys/devices/platform/soc/ff600000.bus/ff64c000.mdio-multiplexer/waiting_for_supplier
0

I'm also not sure what compatible string should I add there.

> I'll send out a fix this week (once you confirm my analysis). Thanks
> for reporting it.

Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

