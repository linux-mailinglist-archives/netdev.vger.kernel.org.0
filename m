Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C9D40F4A1
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 11:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245571AbhIQJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 05:20:27 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41293 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240434AbhIQJTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 05:19:47 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210917091813euoutp02769c21bf12b7d3609ec08fd080a09177~lkWLExUXF2535625356euoutp02W
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:18:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210917091813euoutp02769c21bf12b7d3609ec08fd080a09177~lkWLExUXF2535625356euoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631870293;
        bh=wbJpxbdk8fXuJctEc7nFHrSEd5I3TEELjlGpqlHc7SQ=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Y5OYt7j38iemuwoD6+lLaZX5gKHS8uoRyfvFC/RpHJT143JmKSE0IotWi93DmAGBY
         voIpmazn/bZvm9npJeRUw/LSRH3dGCxix53G/lf7S1HXPC0XRQQnOZN/WP82ttlG/J
         nU0/LmZLJIL2J7BON3LsddnwZvrapMRzkF5HiIrk=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210917091812eucas1p1bd832a1e8cb9b010b7262cda2ace4d3e~lkWKlW1hq3207932079eucas1p10;
        Fri, 17 Sep 2021 09:18:12 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 64.1A.42068.45D54416; Fri, 17
        Sep 2021 10:18:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210917091812eucas1p1fc2a7421f2e2efdc6539b9ecd03f400a~lkWKC7zFF1938619386eucas1p1k;
        Fri, 17 Sep 2021 09:18:12 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210917091812eusmtrp178c4c11c9b378437106a3469419f88ee~lkWKB9HRQ0330903309eusmtrp1g;
        Fri, 17 Sep 2021 09:18:12 +0000 (GMT)
X-AuditID: cbfec7f4-c71ff7000002a454-36-61445d54dd36
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 9F.1C.31287.45D54416; Fri, 17
        Sep 2021 10:18:12 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210917091811eusmtip175e9535d5e53e9d570c2f88e66db3f08~lkWI4SLld0090500905eusmtip1x;
        Fri, 17 Sep 2021 09:18:10 +0000 (GMT)
Subject: Re: [PATCH v2 0/6] fw_devlink improvements
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <9353510e-d6ac-bd73-4e3d-d92d66ef2120@samsung.com>
Date:   Fri, 17 Sep 2021 11:18:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAGETcx_C8N8r4nQiUU1eGdkE3E1b=wxUTFEtKhSfobqrdDrTQw@mail.gmail.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0wTZxjHfe+u12ul+lKYvMH9SklHRhDrXLJb2NyIzJxzRljQKIniKQcY
        oJIeBXFsceqYqziYorhbFdQtlSpCCiu0iEpZSpys1BVQSQkhdv7MxbF2Nd1wzvbixn/f53k/
        z/d5vslL4eq7smRqh76SM+jZMg2pJOzuiGdJ3uZsVjc6m06PTLpw2jyyn6DvTPRj9L4zHSR9
        +tFxGT389xK6tyeR9tq/ltGOaZGkLZcaAO1zmknadbQf0O7WRXRn12OMPhE6itNf9P8kp02u
        J+T78Yy9zy5jfOPXcaa77RbGOIRJOdNqMzI261ck4x+/SDKuwQOAuXzivJxx9AYxJmh7OWd+
        vvKdQq5sRxVnWLpiq7LkYOd+vOLL+buGZ7V7QJgyAQWF4Juo7p5bbgJKSg3PAtRichNSEQKo
        qWcAj1JqGATooG/L8wnn5EVMgiwANZ6akEnFDEDiiEhEqQS4HIXbvyGjOhGmIdv47ZgtDgcJ
        FLb2xSASLkMm0RSDVHAFGqubwqKagFp0PTQtj+oX4HZ07MleXGLi0dVvA89mKUoBc5G5no22
        cfgK6hHNuKST0ESgJXYdgh4Fihx7GuMRzEYm52IpQQJ6MNQtl/SL6NqRekLi9wE07WmXS0U9
        QL69x4FEZSK/5y8yaoTD11GHc6nkmYVuDtdIcgG6KcZLJyxAh+3NuNRWoQN1asnjNSQMXfhv
        64D3V7wRaIQ5uYQ5YYQ5YYT/17YCwgqSOCNfXszxb+i56gyeLeeN+uKM7TvLbeDZX7z2z1Co
        F1gezGS4AEYBF0AUrklUeWuzWLWqkK3ZzRl2FhiMZRzvAospQpOk2tZ9vkANi9lKrpTjKjjD
        81eMUiTvwdb6PsxoW5NZs8sz+Cr2vVinayw51bL7zLmU1esMJ5dbutpwYlVDwapa0NlW/l04
        p7rLvzI/2a1zzmzAJqs7NjxWNLM8l7oV6e4dvj8976HgHSvyuq/GnV1zKHPLPLH3xoD2I557
        a1NF6OGfzC0hEvjdPvD5L6WtikXJT02pvh/8wm9FYwkfdLJp93NHqxx9eW+nhquw9tLMqVm9
        9l238g67stKW8t5nV6qFrpojHxP5mrjETSnWuHxwe/0jixYL/LFN9emNUf2hCz/n5iycMTua
        NzPBu8om99pIkFntv+KvnXopYP3RWF+YvlDMPmndyEQ2FnnTK0ebprKgriHvEw3Bl7DL0nAD
        z/4LWy2ClfoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t/xu7ohsS6JBsvesFucv3uI2WLO+RYW
        i2e39jJZNC9ez2ax6P0MVoszv3UtdmwXsbiwrY/VYufDt2wWy/f1M1pc3jWHzeLQ1L2MFscW
        iFls2PydyWLul6nMFq17j7BbdB36y+Yg6LFt9zZWj8vXLjJ7bFl5k8lj56y77B4LNpV6bFrV
        yeZx59oeNo9DhzsYPfbPXcPusXPHZyaPz5vkArij9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSM
        TCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DK6N7QwF7RzV5z5o9rA+I2ji5GTQ0LARGLX3T1M
        ILaQwFJGieZn0RBxGYmT0xpYIWxhiT/Xuti6GLmAat4zSnz49QosISxgLPFt7UQ2EFtEQEti
        07XHLCBFzAJHWSQ2317PAtHRxSRx+kUDM0gVm4ChRNfbLrAOXgE7iatt98FWswioSlz88pAd
        xBYVSJZ4+/o7E0SNoMTJmU+ABnFwcAoESszpSQQJMwuYSczb/JAZwpaX2P52DpQtLnHryXym
        CYxCs5B0z0LSMgtJyywkLQsYWVYxiqSWFuem5xYb6hUn5haX5qXrJefnbmIEpoJtx35u3sE4
        79VHvUOMTByMhxglOJiVRHgv1DgmCvGmJFZWpRblxxeV5qQWH2I0BXpnIrOUaHI+MBnllcQb
        mhmYGpqYWRqYWpoZK4nzbp27Jl5IID2xJDU7NbUgtQimj4mDU6qBScNjocSUftfWStu9PGL3
        FIQU7sxV4t3CJlWWf/cXS3TH5yK5ypu1qjoWut7W/3SWfpfxZc1+x3Z02ZHEZJ2VK3Ne2Ptl
        LNd1mHzshd55Ea8jTh67t5fsXXN079ajVcsa/D125rBfS/2QI79jncDsuJlp++9dbmHMPOX3
        P/Oz5ZVkzRR1K7OL7yRungo4VefS0XPn7tNTITYTb7dqsP27/JJnO+9Z2x8rRSyklrHeD+jn
        V5JSq5vBe7lg1zTecuHv68zde3bmZ7+WOZGe8fhZlO2Xy7ZNOy5vizxe/WXvnT9sq605NYq/
        aEsYxx1NOKfxIm2P2Q/Tgv8qZ9Llt01Oe+J6ZLGSS3xUhZbak+8RSizFGYmGWsxFxYkAIy0i
        /Y4DAAA=
X-CMS-MailID: 20210917091812eucas1p1fc2a7421f2e2efdc6539b9ecd03f400a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210915081147eucas1p130ee8d5f1910ea3be265d37e4236a606
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210915081147eucas1p130ee8d5f1910ea3be265d37e4236a606
References: <CGME20210915081147eucas1p130ee8d5f1910ea3be265d37e4236a606@eucas1p1.samsung.com>
        <20210915081139.480263-1-saravanak@google.com>
        <9c437d41-05b2-8e22-a537-d9aa7865f01b@samsung.com>
        <CAGETcx_C8N8r4nQiUU1eGdkE3E1b=wxUTFEtKhSfobqrdDrTQw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 15.09.2021 18:44, Saravana Kannan wrote:
> On Wed, Sep 15, 2021 at 1:44 AM Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> On 15.09.2021 10:11, Saravana Kannan wrote:
>>> Patches ready for picking up:
>>> Patch 1 fixes a bug in fw_devlink.
>>> Patch 2-4 are meant to make debugging easier
>>> Patch 5 and 6 fix fw_devlink issues with PHYs and networking
>> Is this patchset supposed to fix the PHY related issues I've experienced
>> or does it also require the Andrew's patch for 'mdio-parent-bus'? If the
>> first, then applying only this patchset on top of today's linux-next
>> doesn't fix the ethernet issue on my Amlogic SoC based test boards.
> Marek,
>
> The issue you hit was actually a general issue with fw_devlink and
> that's fixed by Patch 1. But I also needed to revert the phy-handle
> patch for other reasons (see commit text) and that fixes the issue you
> were hitting without needing the 'mdio-parent-bus' patch.
> https://lore.kernel.org/lkml/20210915081933.485112-1-saravanak@google.com/
>
> When I eventually bring back phy-handle support, I'll need the
> 'mdio-parent-bus' to not break your use case.
>
> Hope that clarifies things.

Okay, I missed the fact that you have sent the revert of the phy-handle 
patch. Now I see it in the linux-next, so everything is fine.

Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

