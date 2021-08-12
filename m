Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6B53EAD1D
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 00:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbhHLWZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 18:25:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33347 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhHLWZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 18:25:51 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210812222523epoutp03b52a69e526c93a926779e5df5d475444~ar3MEhs_B2593625936epoutp03i
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 22:25:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210812222523epoutp03b52a69e526c93a926779e5df5d475444~ar3MEhs_B2593625936epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628807123;
        bh=uGMImXLROuaXIlRM3ziE5kD/gMKtk73S5JDnGjDptSE=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=u/Ihj0/SU2iAsEnLHyacaTjw1E+qf0TRGTo/8q0Qyuu5bNZFHjtG0uhfh2b49KvWH
         vy7n+cW2WK0aKuzFAq4mcUOdWoxE9uMPG9IJJJOsr6aWM6geWosg1EgUchMcZ14xrt
         n1BbyNrKLTVIKq2YFk6MvyQYQzGLsCCgsBtoAWHg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210812222523epcas1p3a2332b70096a521c8e22279f77ec6499~ar3LXhV2q2702527025epcas1p3M;
        Thu, 12 Aug 2021 22:25:23 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.155]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Gm1Tq5phWz4x9Pq; Thu, 12 Aug
        2021 22:25:19 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.9D.45479.FCF95116; Fri, 13 Aug 2021 07:25:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210812222518epcas1p10a9de28c1dbbcadf244c58326776f3ce~ar3HnLVel2953529535epcas1p1C;
        Thu, 12 Aug 2021 22:25:18 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210812222518epsmtrp267773e085daef1d60b6bf840e597e402~ar3HmQE7c0661306613epsmtrp2D;
        Thu, 12 Aug 2021 22:25:18 +0000 (GMT)
X-AuditID: b6c32a35-cbfff7000001b1a7-35-61159fcf2317
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.35.08394.ECF95116; Fri, 13 Aug 2021 07:25:18 +0900 (KST)
Received: from [10.113.113.235] (unknown [10.113.113.235]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210812222518epsmtip28690c13cb8259cce15c7e3ff63daf580~ar3HSooDE2229922299epsmtip2h;
        Thu, 12 Aug 2021 22:25:18 +0000 (GMT)
Subject: Re: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book
 Flex2 Alpha
From:   Jaehoon Chung <jh80.chung@samsung.com>
To:     Justin Forbes <jmforbes@linuxtx.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        ybaruch <yaara.baruch@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        yj99.shin@samsung.com
Message-ID: <94edb3c4-43a6-1031-8431-2befb0eca2bf@samsung.com>
Date:   Fri, 13 Aug 2021 07:26:06 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
        Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8c55c7c9-a5ae-3b0e-8a0f-8954a8da7e7b@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmru75+aKJBlNeaFjMOd/CYtG67S6r
        xaPX25gtHmy+y2TxaMUsdosL2/pYLRatXMhmcXnXHDaLNyvusFsc3rqAyWJOyzlmi2MLxCzm
        b3vEaHHozkJmBz6Py329TB5bVt5k8li85yWTx6ZVnWwe03c4ePRtWcXo8XmTXAB7VLZNRmpi
        SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDFSgpliTmlQKGA
        xOJiJX07m6L80pJUhYz84hJbpdSClJwCywK94sTc4tK8dL3k/FwrQwMDI1OgwoTsjDftVxkL
        TnBU7Og8zNTAeJqti5GDQ0LARGJHX1QXIxeHkMAORon27mWMEM4nRoltRx+wQTjfGCXuL93F
        2sXICdax4usTdojEXkaJO+cnsEI47xklLrw7yA5SJSwQLnHp/RUWEJtNQEdi+7fjTCC2iMAh
        FomFb7NBbF4BO4lNU+cygtgsAqoS8xbMYQOxRQUiJc7vXsACUSMocXLmEzCbU8Be4tz2C8wg
        NrOAuMStJ/OZIGx5ie1v5zCDHCEhcIBDYtORWcwQp7pIrL97jQ3CFpZ4dXwLO4QtJfH53V6o
        eLXEruYzUM0djBK3tjUxQSSMJfYvncwECiVmAU2J9bv0IcKKEjt/QxzNLMAn8e5rDyskIHkl
        OtqEIEpUJC69fskEs+ruk//QkPOQmDNvMwsksCYwSbS9OMU4gVFhFpI/ZyH5bRaS32YhXLGA
        kWUVo1hqQXFuemqxYYEhcnRvYgQnZy3THYwT337QO8TIxMF4iFGCg1lJhHennFCiEG9KYmVV
        alF+fFFpTmrxIUZTYMhPZJYSTc4H5oe8knhDUyNjY2MLE0MzU0NDJXHeb7FfE4QE0hNLUrNT
        UwtSi2D6mDg4pRqYdLVfMXfsOCTyV3VyzdEj+ryi7/tWFssE+Oz9emX6Z8e/paFxj9NqvW6t
        Lv3M/0NEMiP6X4nojUbfWe4T3v3b8Ksw6WfabvfdGjPrDXmaMt6989+8fBlD0IMNv6b+nv18
        26ywojtn6/7Y/12aFH336ILn/jOUiyJOveuYwx8UsDZFwrXZ8dP6lRWqxclHq88fkxZuPrOv
        lOOX5jbN7oot1o9zPLT2J/z+N72pu3GPbnZl+hS320duPZu08k+X56VnUb9bl8U4f7ayj5n1
        wCm3p0bp972I9Zqmc/8Xstjsv/31wMGGRSdK1tcvM3Ar3P2wZgtPkKXobTYrZbPqnY4Tgq4m
        sb1g3Mlx3PK615HwR0osxRmJhlrMRcWJAAsRFRpXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvO65+aKJBrO6jSzmnG9hsWjddpfV
        4tHrbcwWDzbfZbJ4tGIWu8WFbX2sFotWLmSzuLxrDpvFmxV32C0Ob13AZDGn5RyzxbEFYhbz
        tz1itDh0ZyGzA5/H5b5eJo8tK28yeSze85LJY9OqTjaP6TscPPq2rGL0+LxJLoA9issmJTUn
        syy1SN8ugSvjTftVxoITHBU7Og8zNTCeZuti5OSQEDCRWPH1CTuILSSwm1HiZpsIRFxK4vPT
        qUA1HEC2sMThw8UQJW8ZJa58qgexhQXCJS69v8ICYrMJ6Ehs/3acqYuRi0NE4BCLxMtfT5hB
        HCGBCUwSb3Y+Ywap4hWwk9g0dS4jiM0ioCoxb8EcsCNEBSIlPi94xQpRIyhxcuYTsKmcAvYS
        57ZfAOtlFlCX+DPvEpQtLnHryXwmCFteYvvbOcwTGAVnIWmfhaRlFpKWWUhaFjCyrGKUTC0o
        zk3PLTYsMMxLLdcrTswtLs1L10vOz93ECI45Lc0djNtXfdA7xMjEwXiIUYKDWUmEd6ecUKIQ
        b0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTC7xPotK87hL
        b2Qszev7kC8z2WJPooJOjpBklNGxZS95FumZ5+4L4wkL+vmpWCqu8uYm/+55FovfleyIz5E1
        jCjgdk5zncAXP+1sSZL76SlmWZaPH+7sDeooXD4/Qml77kQrZTO9B7MnXsqwCmd/VeruP8di
        UsnVzTslmLMevXNjn17dZl/Ct63e8PYLt/U9y1gkNtT/VAqN1f+66JPLnducd29l+Nh4Ld2o
        tm2G8qGrzUtMFjB/Y+j0XV721cNqmXnYs/0lGqG1zacb+Nd7Vmx92yvbtPuh8cSioCeLShm6
        D3166Ryte7Zoit+uJ0vPV4oylp6eIv+oeu2nPd810lbIGx1aVr970okPBgVJSizFGYmGWsxF
        xYkAQYCyfCgDAAA=
X-CMS-MailID: 20210812222518epcas1p10a9de28c1dbbcadf244c58326776f3ce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709173244epcas1p3ea6488202595e182d45f59fcba695e0a
References: <20210702223155.1981510-1-jforbes@fedoraproject.org>
        <CGME20210709173244epcas1p3ea6488202595e182d45f59fcba695e0a@epcas1p3.samsung.com>
        <CAFxkdApGUeGdg4=rH=iC2SK58FO6yzbFiq3uSFMFTyZsDQ5j5w@mail.gmail.com>
        <8c55c7c9-a5ae-3b0e-8a0f-8954a8da7e7b@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 8/9/21 8:09 AM, Jaehoon Chung wrote:
> Hi
> 
> On 7/10/21 2:32 AM, Justin Forbes wrote:
>> On Fri, Jul 2, 2021 at 5:32 PM Justin M. Forbes
>> <jforbes@fedoraproject.org> wrote:
>>>
>>> The Samsung Galaxy Book Flex2 Alpha uses an ax201 with the ID a0f0/6074.
>>> This works fine with the existing driver once it knows to claim it.
>>> Simple patch to add the device.
>>>
>>> Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>

If this patch is merged, can this patch be also applied on stable tree?

Best Regards,
Jaehoon Chung

> 
> 
> Before sending patch, I have found same patch to solve the Wifi problem.
> Is there any progress about this patch? 
> 
> I hope that this patch will be applied.
> 
> Reviewed-by: Jaehoon Chung <jh80.chung@samsung.com>
> 
> Best Regards,
> Jaehoon Chung
> 
> 
>>> ---
>>
>> Just an update from the user with this hardware that I built a test kernel for:
>> "Still going strong w/ AX201, speed OK, on par w/ speeds on windows,
>> no crashes, no weird messages about the driver."
>>
>> Justin
>>
> 
> 

