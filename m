Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C203DEBB0
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbhHCLZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:25:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11135 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbhHCLZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 07:25:12 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210803112500euoutp01415de35ce9d43a3f86043923a9b45e80~XyDCCAfo11165811658euoutp01t
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 11:25:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210803112500euoutp01415de35ce9d43a3f86043923a9b45e80~XyDCCAfo11165811658euoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627989901;
        bh=zYLaBjBk31n8vHM/YCh1kj3oHM3/iGdm5x5vdPgMHgQ=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=IYhrfoB/C0pY+hpAYnhGR/bHUAPi0jckWMOX2+cBfsQucfVNcOCTqm5DhljU6nJep
         iul1iTqgi+Bayh4592JVC0Be6O9wMIHxrFbZgYIulxe2X2mNR91FfCrLS4NRg+d7Up
         R2mm0L4mRaOeF1PRsqRveORQDcFQAbTen0I8gEjc=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210803112500eucas1p19a81c7d88108a6ff29ad0207afdf4404~XyDBvn3jV0461204612eucas1p1H;
        Tue,  3 Aug 2021 11:25:00 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id B7.08.42068.C8729016; Tue,  3
        Aug 2021 12:25:00 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210803112459eucas1p190c5c610f689438a3a67b46e5d395720~XyDBGWjVN1753717537eucas1p1f;
        Tue,  3 Aug 2021 11:24:59 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210803112459eusmtrp1d862277e6d00d88028499836440a858c~XyDBFsTFP0386203862eusmtrp1A;
        Tue,  3 Aug 2021 11:24:59 +0000 (GMT)
X-AuditID: cbfec7f4-c89ff7000002a454-27-6109278cf7ee
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 1E.85.20981.B8729016; Tue,  3
        Aug 2021 12:24:59 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210803112459eusmtip24e547f14ebd6beba24d158e7254e6b71~XyDApKsD42897528975eusmtip2k;
        Tue,  3 Aug 2021 11:24:59 +0000 (GMT)
Subject: Re: Fwd: Re: [PATCH] net: convert fib_treeref from int to
 refcount_t
To:     yajun.deng@linux.dev
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <fe4fcc5c-5ede-cd0f-cb02-3a1568f16879@samsung.com>
Date:   Tue, 3 Aug 2021 13:24:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7177b79774f6be76431ff4af9fa164f8@linux.dev>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42LZduznOd0edc5EgwXL5S3mnG9hsbiwrY/V
        4vKuOWwWxxaIWXzfs57JgdVjy8qbTB6bVnWyeSxsmMrs8XmTXABLFJdNSmpOZllqkb5dAlfG
        66ZJ7AX72Svmrl7N3sC4hK2LkZNDQsBEYuPtk8xdjFwcQgIrGCV+7DsIlhAS+MIocfF6CUTi
        M6PElF0r2GE6dq2ezQ6RWM4ocXTHZSjnI6PE7YsrWECqhAX8Jf5v72bsYuTgEBGQkLi2Kxwk
        zCyQILFt6nJGEJtNwFCi620X2DZeATuJtr9LwVpZBFQkmuZNA6sRFUiWuHP6PVSNoMTJmU/A
        ajgFLCXm/tvHCDFTXmL72znMELa4xK0n85kgDj3CIbFmaSKE7SLxcFsLVFxY4tXxLVDPyEic
        ntzDAnK/hEAzo8TDc2vZIZweRonLTTMYIaqsJe6c+8UG8gyzgKbE+l36EGFHif9fZ7KDhCUE
        +CRuvBWEuIFPYtK26cwQYV6JjjYhiGo1iVnH18GtPXjhEvMERqVZSD6bheSbWUi+mYWwdwEj
        yypG8dTS4tz01GKjvNRyveLE3OLSvHS95PzcTYzABHP63/EvOxiXv/qod4iRiYPxEKMEB7OS
        CG/oDY5EId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxJW9bECwmkJ5akZqemFqQWwWSZODilGpjY
        CqXz6jktvUs8d+acNzmo8/Atn8sd5kUMT41ZLdetuRjWu2uh8iupQ3WiQcFXPt1kC5Au8j52
        omVz8df/7wJZPTXef0iuCN7H/19ddYbWS4N2wXJXkUumkZrdckb5zfWfjt6KvCK3s4J7Vsv0
        xL3T17GGeG6oV7nSpcnU8/Gks4zZnsMPztjaKqsFFlTw7mxZNqf6z2Guwv8zttTviz7quPpP
        TV6eNZvZHgWXiW4HtZyc/2g7XM2p0Jy3uPGvn3Lu0qDvm4szbz8VOLHg0ofM53t1VTxCv+5X
        zE/fzX81x+bLz0Sppds0Ddn07zIsOs0R2GvYkO/kucF26QvzGzzf/ml9u83YubGg+8T6G0os
        xRmJhlrMRcWJAB12TZ2fAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t/xe7rd6pyJBnMeGVnMOd/CYnFhWx+r
        xeVdc9gsji0Qs/i+Zz2TA6vHlpU3mTw2repk81jYMJXZ4/MmuQCWKD2bovzSklSFjPziElul
        aEMLIz1DSws9IxNLPUNj81grI1MlfTublNSczLLUIn27BL2M102T2Av2s1fMXb2avYFxCVsX
        IyeHhICJxK7Vs9m7GLk4hASWMkrc+7qOHSIhI3FyWgMrhC0s8edaFxtE0XtGia+HbrCAJIQF
        fCWe794B1MDBISIgIXFtVzhImFkgQWLrie1Q9TOZJG59nswEkmATMJToetsFtplXwE6i7e9S
        sDksAioSTfOmMYLYogLJEn1fJjBC1AhKnJz5BKyGU8BSYu6/fYwQC8wk5m1+yAxhy0tsfzsH
        yhaXuPVkPtMERqFZSNpnIWmZhaRlFpKWBYwsqxhFUkuLc9Nzi430ihNzi0vz0vWS83M3MQKj
        atuxn1t2MK589VHvECMTB+MhRgkOZiUR3tAbHIlCvCmJlVWpRfnxRaU5qcWHGE2B/pnILCWa
        nA+M67ySeEMzA1NDEzNLA1NLM2MlcV6TI2vihQTSE0tSs1NTC1KLYPqYODilGphSg5YfnaHZ
        uPXSxUMLO1T2uT2wf5Vn8fJfaeR+f/2etVFfIu71u5paG7Gq7G15U864/p519X5t6VU5T6xk
        1nG85s2Kb/2YWzxHSli4e/LpFW7bVIrXaOWUM88/b58d3PwqjSV50b7QmPNvDysH7a1/Wr1x
        90ZFvWJf8TAe9ZKw68v5ufPVlnzjitJeXHjLp0btIe//XcG33QMuTtRazL1ahc2w6PtGv+Au
        r4CTTxb+fPmYuVv/k5DQd2PbJd7Z7D9efmt8fWpzZcqcEGftrnt7frVs//3PLirHejnHzKrV
        5axHD7j3n3l3fulG/8+/nJ9dmuOSkSezcKXd429XhaazlDJ8vj9dp4L1wZ/fSq+UWIozEg21
        mIuKEwHs4kdMMwMAAA==
X-CMS-MailID: 20210803112459eucas1p190c5c610f689438a3a67b46e5d395720
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210803111811eucas1p298c36220457c42252d13df0a03a1c446
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210803111811eucas1p298c36220457c42252d13df0a03a1c446
References: <2033809a-1a07-1f5d-7732-f10f6e094f3d@gmail.com>
        <20210729071350.28919-1-yajun.deng@linux.dev>
        <20210802133727.bml3be3tpjgld45j@skbuf>
        <CGME20210803111811eucas1p298c36220457c42252d13df0a03a1c446@eucas1p2.samsung.com>
        <7177b79774f6be76431ff4af9fa164f8@linux.dev>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.08.2021 13:17, yajun.deng@linux.dev wrote:

> This patch from David Ahern was applied in the newest net-next.
>
> -------- Forwarded message -------
> From: "David Ahern" <dsahern@gmail.com>
> To: "Ioana Ciornei" <ciorneiioana@gmail.com>, "Yajun Deng" <yajun.deng@linux.dev>
> CC: davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
> netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-decnet-user@lists.sourceforge.net
> Sent: August 2, 2021 10:36 PM
> Subject: Re: [PATCH] net: convert fib_treeref from int to refcount_t
> On 8/2/21 7:37 AM, Ioana Ciornei wrote:
>
>> Unfortunately, with this patch applied I get into the following WARNINGs
>> when booting over NFS:
> Can you test the attached?

Yes, it fixes the issue on my test systems. Feel free to add:

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

