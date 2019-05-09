Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2F718965
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 14:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbfEIMBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 08:01:16 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36139 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfEIMBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 08:01:16 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190509120114euoutp02752127f8ce9e4bafc0d01319c3772b72~dAgbCUZhc2136921369euoutp02V
        for <netdev@vger.kernel.org>; Thu,  9 May 2019 12:01:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190509120114euoutp02752127f8ce9e4bafc0d01319c3772b72~dAgbCUZhc2136921369euoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557403274;
        bh=qiD6lRtF4wFiAqbHs9VVmyccR0AScqMMNG8nnc7i+Fs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nw8h4OMbLeACI14ysETF3yx789i0PTWMGQpPKfuEGPPz6ZYcq5otmRCEJgWWQSlmC
         bHfVOWEIrNdRJidtJFEcUsZYcyFNVrUWDrIy5+PW9mgd1nXtC54PIS6gz0oI2ROMhq
         ZAA6cfSriReTeP09CyXz0s1KBrps7tqwCBSIkCek=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190509120113eucas1p26b764a8af5501d7e96e132f6b02a42b6~dAgaPtk9N2799027990eucas1p2u;
        Thu,  9 May 2019 12:01:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 1A.D7.04298.98614DC5; Thu,  9
        May 2019 13:01:13 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190509120112eucas1p252b59f7cf1bfa4a67a00accd03766bcf~dAgZloE8C2799127991eucas1p2v;
        Thu,  9 May 2019 12:01:12 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190509120112eusmtrp1f330e69651b69b5a141efd5eef4a46fc~dAgZXhXro1886318863eusmtrp1D;
        Thu,  9 May 2019 12:01:12 +0000 (GMT)
X-AuditID: cbfec7f2-3615e9c0000010ca-18-5cd41689e560
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 03.FB.04140.88614DC5; Thu,  9
        May 2019 13:01:12 +0100 (BST)
Received: from amdc2143 (unknown [106.120.51.59]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20190509120111eusmtip23fda3d7ae222be3f7c54dbdd80beb0c1~dAgYqpa281332313323eusmtip2C;
        Thu,  9 May 2019 12:01:11 +0000 (GMT)
Message-ID: <0510351d1fbd17f11018b7c934fb3a525c265936.camel@samsung.com>
Subject: Re: [PATCH v2] netfilter: xt_owner: Add supplementary groups option
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>
Date:   Thu, 09 May 2019 14:01:10 +0200
In-Reply-To: <ffbaeda9-1e0c-f526-15aa-e865fcb4ec95@gmail.com>
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsWy7djPc7qdYldiDE6/ZrX4u7Od2WLO+RYW
        i33vz7JZbOtdzWjx/7WOxeW+acwWl3fNYbM4tkDMYsK6UywW099cZXbg8jjdtJHFY8vKm0we
        O2fdZfd4+/sEk8eh7wtYPT5vkgtgi+KySUnNySxLLdK3S+DKOPHnPUvBNI6K3ueLWRsYl7N1
        MXJySAiYSHy7tJi5i5GLQ0hgBaPE58nX2UESQgJfGCWO9vNCJD4zSvzYuZkRpmPt9zesEInl
        QIn9jYwQzjNGid4Nj5hBqngFPCReP9oMVMXBISzgI7HlpQVImE3AQOL7hb1g60QEDjJJdG26
        DbaOWUBdYunsZhYQm0VAVeLM9j4mEJtTwFbiav8UsLiogK7EjQ3P2CDmC0qcnPmEBaJXXqJ5
        62ywoRICh9gljm85wwayWELARWLfojSIq4UlXh3fwg5hy0icntzDAlFSLXHyTAVEawejxMYX
        s6G+tJb4PGkLM0gNs4CmxPpd+hDljhKTP0lBmHwSN94KQhzAJzFp23RmiDCvREebEMQMVYnX
        e2DmSUt8/LMXar+HxOEbW5gmMCrOQvLKLCSvzEJYu4CReRWjeGppcW56arFhXmq5XnFibnFp
        Xrpecn7uJkZgIjr97/inHYxfLyUdYhTgYFTi4bXgvxIjxJpYVlyZe4hRgoNZSYT3+sRLMUK8
        KYmVValF+fFFpTmpxYcYpTlYlMR5qxkeRAsJpCeWpGanphakFsFkmTg4pRoY4yaseteYrHpL
        a+6/AIee/wmtyueS4ksnTo6+kLM+peHCqrDs7s+qRVH8P84s+Bj4e9Pa1Y//ndupGzfrgZ7o
        80f78o4Vlt+vtLO5tXGxT8G3Hw1ZB0KenflqNuVdYBPXyh7xGV+uq9U8rFq/1uui0IZdjfL3
        vCXfb5KfeLVk/kkpScmjy68JP1ZiKc5INNRiLipOBADj8V2QQAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t/xe7odYldiDLrOsVj83dnObDHnfAuL
        xb73Z9kstvWuZrT4/1rH4nLfNGaLy7vmsFkcWyBmMWHdKRaL6W+uMjtweZxu2sjisWXlTSaP
        nbPusnu8/X2CyePQ9wWsHp83yQWwRenZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8da
        GZkq6dvZpKTmZJalFunbJehlnPjznqVgGkdF7/PFrA2My9m6GDk5JARMJNZ+f8PaxcjFISSw
        lFHiV/t2RoiEtMTxAwtZIWxhiT/Xutggip4wSsx7+podJMEr4CHx+tFmoCIODmEBH4ktLy1A
        wmwCBhLfL+xlBqkXETjIJDHx7XNmkASzgLrE0tnNLCA2i4CqxJntfUwgNqeArcTV/iksEAsW
        s0isPvKNBaJBU6J1+2+wZaICuhI3Njxjg1gsKHFy5hOoGnmJ5q2zmScwCs5C0jILSdksJGUL
        GJlXMYqklhbnpucWG+kVJ+YWl+al6yXn525iBMbatmM/t+xg7HoXfIhRgINRiYfXgv9KjBBr
        YllxZe4hRgkOZiUR3usTL8UI8aYkVlalFuXHF5XmpBYfYjQF+mgis5Rocj4wDeSVxBuaGppb
        WBqaG5sbm1koifN2CByMERJITyxJzU5NLUgtgulj4uCUamA8eomFd5khI0+CeibL2i/36lZp
        cp21XF1wMMnmwXWRPdFX/ulwRc6UK6kxXqBzxqXRv1mn3HzmtTdfP+36GWl380pl1P2M3T4h
        Mrt+LJ725cDiz3Ne1m5NmXqy2+ZCnIHntLhbvuzPlyxu2CPJHc+jsmFX/f+L1a6SEYlzrs5s
        DjiZ397xTvOEEktxRqKhFnNRcSIAg2lTWMsCAAA=
X-CMS-MailID: 20190509120112eucas1p252b59f7cf1bfa4a67a00accd03766bcf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190508141219eucas1p1e5a899714747b497499976113ea9681f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190508141219eucas1p1e5a899714747b497499976113ea9681f
References: <CGME20190508141219eucas1p1e5a899714747b497499976113ea9681f@eucas1p1.samsung.com>
        <20190508141211.4191-1-l.pawelczyk@samsung.com>
        <98f71c64-3887-b715-effb-894224a71ef9@gmail.com>
        <cdba4a3b7f31ae8ece81be270233032fe774bd86.camel@samsung.com>
        <6a6e9754-4f2b-3433-6df0-bbb9d9915582@gmail.com>
        <cf34c829002177e89806e9f7260559aefb3c2ac7.camel@samsung.com>
        <afc200a8-438f-5d73-2236-6d9e4979bb59@gmail.com>
        <cd06d09489cd723b3cc48e42f7cccc21737bfd9e.camel@samsung.com>
        <ffbaeda9-1e0c-f526-15aa-e865fcb4ec95@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-05-09 at 04:57 -0700, Eric Dumazet wrote:
> sk_socket keeps reference to f_cred. f_cred keeps reference to
> > group_info. As long as f_cred is alive and it doesn't seem to be
> > the
> > issue in the owner_mt() function, group_info should be alive as
> > well as
> > far as I can see. Its refcount will go down only when f_cred is
> > freed
> > (put_cred_rcu()).
> > 
> > If there is something I'm missing please correct me.
> 
> The problem is that you can´t clearly explain why the code is safe :/
> 
> Why would get_group_info() be needed then ?

Originally I though it wouldn't, that's why I did not include it in the
patch. Your question made me doubt that for a second. I also got
confused a little because the group_info code looked completely
different a while back, it got reworked and simplified.

> 
> You need to explain this in the changelog, so that future bug hunters
> do not have
> to guess.

Ok, I will.

-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



