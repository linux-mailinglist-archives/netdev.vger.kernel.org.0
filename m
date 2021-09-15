Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D00B40C1F4
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 10:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhIOIp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 04:45:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40078 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236721AbhIOIpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 04:45:54 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210915084434euoutp026b8ab926ab5caa50f9e74282e1c1a56b~k8mOkyD2c0711307113euoutp022
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 08:44:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210915084434euoutp026b8ab926ab5caa50f9e74282e1c1a56b~k8mOkyD2c0711307113euoutp022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631695474;
        bh=zuHBnPm1j3W/zEJwgQIsxbw9eYDizN0gbD/sfi5hIfo=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=CTVTSMk+wBLeNWvzrtG1we3qG3nmYUQnMBFVALNb9gUGV5XTmwcJ5YUGyDBa0Z2CU
         BgV0vyg1PcJo1/q3idZwrDEwP67egQ2dB+15VtBzACqRNvMbbF9IkmMyN4BfZcZ1j6
         trlYCRQv/K860tfacw+6fAgkYa3SygBFnv/QeG0U=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210915084434eucas1p2dc182421decfc2aac20c4ad9f11aaca7~k8mOATbaq2536225362eucas1p2C;
        Wed, 15 Sep 2021 08:44:34 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 44.52.56448.172B1416; Wed, 15
        Sep 2021 09:44:34 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210915084433eucas1p2c421eb2f9cbf66a77526c063c2d94982~k8mNSDaoh2473924739eucas1p2v;
        Wed, 15 Sep 2021 08:44:33 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210915084433eusmtrp2ed1f2f96ee7d912607bf00dbbf06981a~k8mNRDwaL1513315133eusmtrp2I;
        Wed, 15 Sep 2021 08:44:33 +0000 (GMT)
X-AuditID: cbfec7f5-d3bff7000002dc80-fe-6141b271744d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id DF.51.20981.172B1416; Wed, 15
        Sep 2021 09:44:33 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210915084432eusmtip21aa097f846daa64cffacf8ffda8f9ac8~k8mMQMvO02772527725eusmtip2k;
        Wed, 15 Sep 2021 08:44:32 +0000 (GMT)
Subject: Re: [PATCH v2 0/6] fw_devlink improvements
To:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <9c437d41-05b2-8e22-a537-d9aa7865f01b@samsung.com>
Date:   Wed, 15 Sep 2021 10:44:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210915081139.480263-1-saravanak@google.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsWy7djP87pFmxwTDbqaGS3O3z3EbDHnfAuL
        xbNbe5ksmhevZ7NY9H4Gq8WZ37oWO7aLWFzY1sdqsfPhWzaL5fv6GS0u75rDZnFo6l5Gi2ML
        xCw2bP7OZDH3y1Rmi9a9R9gtug79ZXMQ9Ni2exurx+VrF5k9tqy8yeSxc9Zddo8Fm0o9Nq3q
        ZPO4c20Pm8ehwx2MHvvnrmH32LnjM5PH501yAdxRXDYpqTmZZalF+nYJXBkzO5YwF0zjrzje
        PYGtgXECTxcjJ4eEgInEgVsLGbsYuTiEBFYwSpzY8w7K+cIosa2lkRXC+cwocfRaB0sXIwdY
        y9S5LBDx5YwSf7a9YYNwPjJKPLx5gA1krrCAscS3tRPBEiICj5gkJv3ezQ7iMAt0M0n8v7OY
        GaSKTcBQouttF1gHr4CdxITe1cwgK1gEVCWmXasCCYsKJEtM+9vEDFEiKHFy5hMWEJtTwFri
        ZD+EzSwgL7H97RxmCFtc4taT+UwguyQELnFKvLpyhAXiUxeJ1qYmRghbWOLV8S3sELaMxP+d
        MA3NQC+cW8sO4fQwSlxumgHVYS1x59wvNpDrmAU0Jdbv0oeEhaPEjTOVECafxI23ghA38ElM
        2jadGSLMK9HRJgQxQ01i1vF1cFsPXrjEPIFRaRaSz2Yh+WYWkm9mIaxdwMiyilE8tbQ4Nz21
        2DgvtVyvODG3uDQvXS85P3cTIzA5nv53/OsOxhWvPuodYmTiYDzEKMHBrCTCe6HGMVGINyWx
        siq1KD++qDQntfgQozQHi5I4766ta+KFBNITS1KzU1MLUotgskwcnFINTGE6K46cdzDmnM25
        yyLGb0FRm3yKHJeE0cI6qxBHl9jZoTJnE1RLO8r0pjY2friTVFPz7oNE+weLhQ/D4+JfcN/l
        igs3rjQpq9qY+XnqnSdBIS7pbqtP33Ar295+4/rrT+0NH1j3Vp77e150Q5j9pI99RRN0fi5a
        U7Pq603vrLNlqa9+Ml2sDTR6J9DfOWXdBXWxexsqC/ud/Xu3/K+OOzGRi8NzqpGSHfNidy+r
        vSeCDHudPvgDAztl9oXKY7GpDLy5Ge8dmh+XxD/KDqi8nZRwUOan3mnTb401IY9XmOfE213u
        /q0V/syoslmlPe7mjZ/X5BssVZPMDyxbMbFGdVV45PyTB6Zwn1p7qkKJpTgj0VCLuag4EQC1
        pAg//QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t/xe7qFmxwTDSY/F7A4f/cQs8Wc8y0s
        Fs9u7WWyaF68ns1i0fsZrBZnfuta7NguYnFhWx+rxc6Hb9kslu/rZ7S4vGsOm8WhqXsZLY4t
        ELPYsPk7k8XcL1OZLVr3HmG36Dr0l81B0GPb7m2sHpevXWT22LLyJpPHzll32T0WbCr12LSq
        k83jzrU9bB6HDncweuyfu4bdY+eOz0wenzfJBXBH6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZ
        mVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GXM7FjCXDCNv+J49wS2BsYJPF2MHBwSAiYSU+ey
        dDFycQgJLGWUOP3/O3MXIydQXEbi5LQGVghbWOLPtS42iKL3jBIPJnaAFQkLGEt8WzsRLCEi
        8IhJYsbNvewgDrNAL5PEsvk7mSBa+hglvh5ZwATSwiZgKNH1FmQWJwevgJ3EhN7VzCB3sAio
        Sky7VgUSFhVIlnj7+jsTRImgxMmZT1hAbE4Ba4mT/RA2s4CZxLzND5khbHmJ7W/nQNniEree
        zGeawCg0C0n7LCQts5C0zELSsoCRZRWjSGppcW56brGRXnFibnFpXrpecn7uJkZgOth27OeW
        HYwrX33UO8TIxMF4iFGCg1lJhPdCjWOiEG9KYmVValF+fFFpTmrxIUZToHcmMkuJJucDE1Je
        SbyhmYGpoYmZpYGppZmxkjivyZE18UIC6YklqdmpqQWpRTB9TBycUg1Mkx7Yqs3q6+dfbKiv
        GHqujXn3eYs7J37Evj6Xuf+09+p+17wZOssjjTqSZXZ4xp7qr1ukGNghMvf6t326f5nkH+e3
        F71ZtVX/bT1HztMg8cOpzCU+r54v1jmfbRzeb8Cvniu44m+Rssj3oPVtMdfy3t/67TBTbO1a
        0cnvfM4IJy59mPyUfyMT2w7r69uNrjCd+18t3fW4b82k499ibgqWOi4Tv5F2MvzoYZ9tly7M
        qJ1nXetY9v91J2fMF6m5cyr2Jtdtl+kVWXCpx1wn5P715qDIA1cfXTk+P3naxvk1DwxPSwi8
        czyup6p1e9HBfWf3qXyczHly4pq8xJ5VRQ0irtWdHuJRT1re5HAqnb9wRomlOCPRUIu5qDgR
        AOvVKwaQAwAA
X-CMS-MailID: 20210915084433eucas1p2c421eb2f9cbf66a77526c063c2d94982
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210915081147eucas1p130ee8d5f1910ea3be265d37e4236a606
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210915081147eucas1p130ee8d5f1910ea3be265d37e4236a606
References: <CGME20210915081147eucas1p130ee8d5f1910ea3be265d37e4236a606@eucas1p1.samsung.com>
        <20210915081139.480263-1-saravanak@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On 15.09.2021 10:11, Saravana Kannan wrote:
> Patches ready for picking up:
> Patch 1 fixes a bug in fw_devlink.
> Patch 2-4 are meant to make debugging easier
> Patch 5 and 6 fix fw_devlink issues with PHYs and networking

Is this patchset supposed to fix the PHY related issues I've experienced 
or does it also require the Andrew's patch for 'mdio-parent-bus'? If the 
first, then applying only this patchset on top of today's linux-next 
doesn't fix the ethernet issue on my Amlogic SoC based test boards.

> Andrew,
>
> I think Patch 5 and 6 should be picked up be Greg too. Let me know if
> you disagree.
>
> -Saravana
>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vladimir Oltean <olteanv@gmail.com>
>
> v1->v2:
> - Added a few Reviewed-by and Tested-by tags
> - Addressed Geert's comments in patches 3 and 5
> - Dropped the fw_devlink.debug patch
> - Added 2 more patches to the series to address other fw_devlink issues
>
> Thanks,
> Saravana
>
> Saravana Kannan (6):
>    driver core: fw_devlink: Improve handling of cyclic dependencies
>    driver core: Set deferred probe reason when deferred by driver core
>    driver core: Create __fwnode_link_del() helper function
>    driver core: Add debug logs when fwnode links are added/deleted
>    driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
>    net: mdiobus: Set FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD for mdiobus parents
>
>   drivers/base/core.c        | 90 ++++++++++++++++++++++++++------------
>   drivers/net/phy/mdio_bus.c |  4 ++
>   include/linux/fwnode.h     | 11 +++--
>   3 files changed, 75 insertions(+), 30 deletions(-)
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

