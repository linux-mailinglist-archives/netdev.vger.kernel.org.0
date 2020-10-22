Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DAD2958E1
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505847AbgJVHQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:16:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41379 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505822AbgJVHQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 03:16:17 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201022071559euoutp01bbb2df2cc5eae6f96188717993b02f81~APzP4kp1P2193521935euoutp01U
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:15:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201022071559euoutp01bbb2df2cc5eae6f96188717993b02f81~APzP4kp1P2193521935euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603350959;
        bh=IsiwbCNVHp4hQUbN8T60nlFVyvfjwqsAD5hMA9e7xvE=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=B2MCDDGIpBLq2z8eh/+pyhwY470lMDwLS7cT2OnVbcJ4NDoNRjhB3vrui1i2xBYap
         uuH4bn05VCaODZv3kvyabvyL8C3q4MG5MV18BYUG9KY8/lk9xEev/BY4VrPwM5x8+N
         tIVyUCTa44L5WspuSGDfDNRHMy5y4+RyN3b46yTE=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201022071551eucas1p1f7e4b9d92075722100e61201b49e1fed~APzIHmFet1113211132eucas1p1r;
        Thu, 22 Oct 2020 07:15:51 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id A8.A4.05997.7A1319F5; Thu, 22
        Oct 2020 08:15:51 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201022071551eucas1p142dca6ac4cf010110f8f2684f8b96c78~APzHtgJsR0168601686eucas1p1q;
        Thu, 22 Oct 2020 07:15:51 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201022071550eusmtrp20e218991ef4b2e28813275e4decef0ff~APzHslbPn2580825808eusmtrp2V;
        Thu, 22 Oct 2020 07:15:50 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-2d-5f9131a7e62a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 98.F6.06017.6A1319F5; Thu, 22
        Oct 2020 08:15:50 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201022071550eusmtip2ad8d94470ca9e7d3ec5291905255c710~APzG6UQAv2718927189eusmtip2d;
        Thu, 22 Oct 2020 07:15:50 +0000 (GMT)
Subject: Re: [PATCH v3 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
To:     =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     =?UTF-8?Q?Bart=c5=82omiej_=c5=bbolnierkiewicz?= 
        <b.zolnierkie@samsung.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <633bbf18-1aec-4b2a-7967-898cde1930aa@samsung.com>
Date:   Thu, 22 Oct 2020 09:15:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <20201021214910.20001-4-l.stelmach@samsung.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRju2zln5ziaHDfLFwuDRUlBK7Pgi9LKFNYN/BFFQtnSg13cjE27
        gWiaYcNbhjmnpGilLXK21toErYYpZW3qSrK0Ea4kw5QU7Wq5nSz/Pbf3e58XPoaQDFGhzFF1
        OqdRK1NlQhFpbf/mWlUfcSlxzbdOKXYNOAh8R2+icJXrPImr25wUrh3VU7h3pJ/CxYOfCOxy
        NdG4y1pE4T5HA8LmwV4Ku5urhFjvahVgR1kLwu01C3FeSxu9hVW4e7sJheVmn0BhNwzQCrPx
        olBx91qWwm4bFyiKLEakGDeHxTMJok3JXOrRk5xmdfQh0ZG3jTbBiU/s6bwbD8lsdC9QhwIY
        YNdBX6Gb1CERI2EbELz4XSjgyQSCNqflLxlH0GP3UrMj1u5qIW/UI/heMf2XjCIYHisX+lJS
        di80V7QQPiOYrSRBP3TdbxBsPBRcniR9WMhGgG5E59fFbDR8flNL+zDJLoPpCw3Ihxewh6HH
        k0PzmSB4UuH1zwawm+DW08c0/+YSyL1XSfA4BF57q/29gc1jID//moDvHQuTrVcJHkthuMNC
        83gx/LbPDuQieOe8TfOkAIE7R4/41Ebod36fqcrMrFgBpubVvLwVnhXW+WVgA+HVSBBfIhBK
        reUEL4sh/4KETy8HQ0fjv7WPunqIEiQzzDnNMOccw5xzDP/31iDSiEK4DK0qhdOuVXOn5Fql
        SpuhTpEnpanMaOb7dU53TNhQ88/DDsQySDZfPLarJFFCKU9qz6gcCBhCFiyOed55UCJOVp45
        y2nSEjUZqZzWgRYxpCxEHFn78YCETVGmc8c57gSnmXUFTEBoNprX/b6obJdtfaN5RUWcp3Ed
        Nu7ecefc9SGpJkdm/DCauD8pt5TI2Fz+w92/8b7pSlv9toGpl7+y3iepPeejyvo83dWH5FOG
        rxuOhfRmfqhzP5VHPtrcZPXQSyen9kwkmIRx5dunY3d/MRWH1yxK2+n0KsNLYp8PR0kz22PC
        Hkztk8tI7RFlxEpCo1X+AX+YRzJ6AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t/xe7rLDCfGG5z+ZWlx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbQ4tkDMonXvEXYHAY/L1y4ye2xZeZPJY+esu+wem1Z1snlsXlLvsXPHZyaP
        vi2rGD0+b5IL4IjSsynKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcks
        Sy3St0vQy7i3bgdTwWuBitZlB1gaGLfydTFyckgImEhsuzifrYuRi0NIYCmjxJtrn1ggEjIS
        J6c1sELYwhJ/rnVBFb1llFj+9zYjSEJYIEzi74r9zCAJEYG5LBJtV36ygSSYBfwkOle+ZoLo
        OMgosWTxfbAEm4ChRNfbLjCbV8BO4t3tRewgNouAqsS/thVgU0UFkiT2n7jJAlEjKHFy5hMw
        m1PARmL1qaPsEAvMJOZtfsgMYctLNG+dDWWLS9x6Mp9pAqPQLCTts5C0zELSMgtJywJGllWM
        IqmlxbnpucVGesWJucWleel6yfm5mxiB0b7t2M8tOxi73gUfYhTgYFTi4f3gMyFeiDWxrLgy
        9xCjBAezkgiv09nTcUK8KYmVValF+fFFpTmpxYcYTYGem8gsJZqcD0xEeSXxhqaG5haWhubG
        5sZmFkrivB0CB2OEBNITS1KzU1MLUotg+pg4OKUaGLurGXQshZW0xDjEeXcvqN/39aoPO/O+
        6avZ5ra1xr0pXpPLLLsormuhfoX38cDEFyYnGOT7Hi+9zWJ48Myl6K4vzi18K+pWynnYBPDu
        2L7ugWL+kgOP50xKWaNh/2+/v+H0fDHeSRuPPZGccM7ovEbf6oXP4jrV/Rlmf4uVnZHTHb9u
        0RWxRiWW4oxEQy3mouJEAL34yv4MAwAA
X-CMS-MailID: 20201022071551eucas1p142dca6ac4cf010110f8f2684f8b96c78
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201021214933eucas1p2fd4e5ccc172f3e22fe0d7009d8b2742d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201021214933eucas1p2fd4e5ccc172f3e22fe0d7009d8b2742d
References: <20201021214910.20001-1-l.stelmach@samsung.com>
        <CGME20201021214933eucas1p2fd4e5ccc172f3e22fe0d7009d8b2742d@eucas1p2.samsung.com>
        <20201021214910.20001-4-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21.10.2020 23:49, Łukasz Stelmach wrote:
> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
> supports SPI connection.
>
> The driver has been ported from the vendor kernel for ARTIK5[2]
> boards. Several changes were made to adapt it to the current kernel
> which include:
>
> + updated DT configuration,
> + clock configuration moved to DT,
> + new timer, ethtool and gpio APIs,
> + dev_* instead of pr_* and custom printk() wrappers,
> + removed awkward vendor power managemtn.
>
> [1] https://www.asix.com.tw/products.php?op=pItemdetail&PItemID=104;65;86&PLine=65
> [2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.10-artik/
>
> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
> chips are not compatible. Hence, two separate drivers are required.
>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>

coś zaszalałeś, jak dobry koreański kod - push bez kompilacji ;)

drivers/net/ethernet/asix/ax88796c_main.c:758:13: error: static 
declaration of ‘ax88796c_set_csums’ follows non-static declaration
  static void ax88796c_set_csums(struct ax88796c_device *ax_local)
              ^
In file included from drivers/net/ethernet/asix/ax88796c_main.c:12:0:
drivers/net/ethernet/asix/ax88796c_ioctl.h:24:6: note: previous 
declaration of ‘ax88796c_set_csums’ was here
  void ax88796c_set_csums(struct ax88796c_device *ax_local);
       ^
scripts/Makefile.build:283: recipe for target 
'drivers/net/ethernet/asix/ax88796c_main.o' failed
make[4]: *** [drivers/net/ethernet/asix/ax88796c_main.o] Error 1
scripts/Makefile.build:500: recipe for target 
'drivers/net/ethernet/asix' failed
make[3]: *** [drivers/net/ethernet/asix] Error 2
scripts/Makefile.build:500: recipe for target 'drivers/net/ethernet' failed
make[2]: *** [drivers/net/ethernet] Error 2
scripts/Makefile.build:500: recipe for target 'drivers/net' failed
make[1]: *** [drivers/net] Error 2

 > ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

