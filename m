Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F473E3D21
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 01:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhHHXIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 19:08:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52115 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhHHXIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 19:08:54 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210808230833epoutp01f138b3a7f2570fecc53876a40eb75b22~Zd3uel2cW1513315133epoutp01b
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 23:08:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210808230833epoutp01f138b3a7f2570fecc53876a40eb75b22~Zd3uel2cW1513315133epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628464113;
        bh=jvL3UYfe1fnogHMOYPJzMx9xpzgagoS4gyTCYbeMpBw=;
        h=Subject:To:From:Date:In-Reply-To:References:From;
        b=S1ADDSUB0BbuPrqoyvJ5/JSwFGqNadkOLAYnToz4V5Z1lxpst7nYnLi5iqoztEw6i
         rRfOl3eRwhYMz0OgtEz8EHjn63LMv3IoHsy5CVoFsWdqtfIsl9WZvtNBwd1KqCOvQf
         fy2Tsm4Bszm6ABtB5gHs5hCFBVLIauXZgfojclmA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210808230832epcas1p2a51ccbdd1dde25963e707fa23c685015~Zd3txeD6M3036730367epcas1p2S;
        Sun,  8 Aug 2021 23:08:32 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.158]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GjZdT0TB8z4x9QD; Sun,  8 Aug
        2021 23:08:29 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.38.10119.CE360116; Mon,  9 Aug 2021 08:08:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210808230828epcas1p17835a0574e65e9c41d853cfa8d5bf1ce~Zd3pwQrEt0136301363epcas1p1M;
        Sun,  8 Aug 2021 23:08:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210808230828epsmtrp1ce1171943a869376c5c1ef6382c7d1ce~Zd3pvIOLV2793027930epsmtrp1C;
        Sun,  8 Aug 2021 23:08:28 +0000 (GMT)
X-AuditID: b6c32a38-965ff70000002787-db-611063eccdc2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C8.2C.08394.BE360116; Mon,  9 Aug 2021 08:08:27 +0900 (KST)
Received: from [10.113.113.235] (unknown [10.113.113.235]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210808230827epsmtip2e25de7e5d2324b984c47152384feffcf~Zd3pYtg1B1773317733epsmtip2D;
        Sun,  8 Aug 2021 23:08:27 +0000 (GMT)
Subject: Re: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book
 Flex2 Alpha
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
From:   Jaehoon Chung <jh80.chung@samsung.com>
Message-ID: <8c55c7c9-a5ae-3b0e-8a0f-8954a8da7e7b@samsung.com>
Date:   Mon, 9 Aug 2021 08:09:13 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
        Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAFxkdApGUeGdg4=rH=iC2SK58FO6yzbFiq3uSFMFTyZsDQ5j5w@mail.gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJsWRmVeSWpSXmKPExsWy7bCmvu6bZIFEgwOdlhZzzrewWLRuu8tq
        8ej1NmaLB5vvMlk8WjGL3eLCtj5Wi0UrF7JZXN41h83izYo77BaHty5gspjTco7Z4tgCMYv5
        2x4xWhy6s5DZgc/jcl8vk8eWlTeZPBbvecnksWlVJ5vH9B0OHn1bVjF6fN4kF8AelW2TkZqY
        klqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SxkkJZYk4pUCgg
        sbhYSd/Opii/tCRVISO/uMRWKbUgJafAskCvODG3uDQvXS85P9fK0MDAyBSoMCE7Y9efxWwF
        39kqDt2dz9LAuIW1i5GTQ0LARKL73A2WLkYuDiGBHYwS+3deZAZJCAl8YpR4f1QNIvGNUeLu
        0nNMXYwcYB0LJ7tBxPcySjQd6WWCcN4zSvy7P5MJpFtYIFzi0vsrLCC2iMAhFomFb7NBbDYB
        HYnt346D1fAK2EkcWnQOrIZFQEXi2vV+dhBbVCBS4vzuBSwQNYISJ2c+AbM5BQIljuz4BNbL
        LCAucevJfChbXmL72znMEO8c4JB4czkBwnaR2HL9FDuELSzx6vgWKFtK4mV/G5RdLbGr+Qwz
        yAMSAh2MEre2NTFBJIwl9i+dDPYxs4CmxPpd+hBhRYmdv+cyQuzlk3j3tYcVEii8Eh1tQhAl
        KhKXXr9kgll198l/aEh7SMyZtxka0rcZJZZ29LNOYFSYheTNWUhem4XktVkIVyxgZFnFKJZa
        UJybnlpsWGCCHNmbGMGJWctiB+Pctx/0DjEycTAeYpTgYFYS4V0/gy9RiDclsbIqtSg/vqg0
        J7X4EKMpMOAnMkuJJucDc0NeSbyhqZGxsbGFiaGZqaGhkjjvt9ivCUIC6YklqdmpqQWpRTB9
        TBycUg1MhRvMpvt3Lnn4dmHbEfew8rUTCvxqvnvOvPHe9r6PDeeLjJarwgH7+sRzT4isC81l
        2li+NefYAYkVk3ZFP7zz5Y37HueboY3fk358Zc7pCM9KEP0YqnqFy10h6tz75U3B/U2zP02a
        Iul9at7znGbdyb3r1p5Zu6s+vdCy+Kb89t/+/lfXTlS6d2ODpOS5354Hr79a8fFvRN6Ktled
        s6S+tXfryAYtTlPhnyP+dJJOt4sxp/RToxusnI+ebLij4la6W0xp44KnIpxW866pBK3171qq
        M1v/48f8qxuYLp8S9V2/chqD7YMc9V3Hqje6b5O6EX39RS6D1RvmnVtz+9cvn/Pw9KLXWz6t
        UuIJ1dG69k+JpTgj0VCLuag4EQAKG+FmVQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvO7rZIFEgyN3jSzmnG9hsWjddpfV
        4tHrbcwWDzbfZbJ4tGIWu8WFbX2sFotWLmSzuLxrDpvFmxV32C0Ob13AZDGn5RyzxbEFYhbz
        tz1itDh0ZyGzA5/H5b5eJo8tK28yeSze85LJY9OqTjaP6TscPPq2rGL0+LxJLoA9issmJTUn
        syy1SN8ugStj15/FbAXf2SoO3Z3P0sC4hbWLkYNDQsBEYuFkty5GLg4hgd2MEp9f7GLrYuQE
        iktJfH46lQ2iRlji8OFiiJq3jBI3Ph5lBqkRFgiXuPT+CgtIQkTgEIvEy19PwBJCArcZJSa3
        eoDYbAI6Etu/HWcCsXkF7CQOLTrHAmKzCKhIXLvezw5iiwpESnxe8IoVokZQ4uTMJ2A1nAKB
        Ekd2fALrZRZQl/gz7xIzhC0ucevJfKi4vMT2t3OYJzAKzkLSPgtJyywkLbOQtCxgZFnFKJla
        UJybnltsWGCYl1quV5yYW1yal66XnJ+7iREcc1qaOxi3r/qgd4iRiYPxEKMEB7OSCO/6GXyJ
        QrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTCt+e6y3dLv
        ModTL/e6y42HuLg4jXlsdh/ocjC6VRr79WVymDFbboBPEVPt7O9Kh/Tzlrwzz319mPfIiUNb
        CkK6L545GdqRKmqm4eNU6VGuovp6nqzgSsajMT3L/+m9s0tct+9XkJXv33rJjz7Zu1ImnZf5
        X22/vWRhIrvXQq843nYRqaIvG208mNo9WE/Zl32J2rZ76XLnPuWWcu69hZl1e/eul+zeMmfp
        vW61D9b1q4v+sc1IWNS37OJKoXMtGx8sW/vz2QH9H5Fqk3idVLcxmK5SvXbEk50n9tf7guRH
        zFVlW6x4Va7zLi3Ibamo+fjk+m4zTq4mjRnpF+9r741f8u22Y9nt0GXMsVudo5VYijMSDbWY
        i4oTAQFCeSIoAwAA
X-CMS-MailID: 20210808230828epcas1p17835a0574e65e9c41d853cfa8d5bf1ce
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 7/10/21 2:32 AM, Justin Forbes wrote:
> On Fri, Jul 2, 2021 at 5:32 PM Justin M. Forbes
> <jforbes@fedoraproject.org> wrote:
>>
>> The Samsung Galaxy Book Flex2 Alpha uses an ax201 with the ID a0f0/6074.
>> This works fine with the existing driver once it knows to claim it.
>> Simple patch to add the device.
>>
>> Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>


Before sending patch, I have found same patch to solve the Wifi problem.
Is there any progress about this patch? 

I hope that this patch will be applied.

Reviewed-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung


>> ---
> 
> Just an update from the user with this hardware that I built a test kernel for:
> "Still going strong w/ AX201, speed OK, on par w/ speeds on windows,
> no crashes, no weird messages about the driver."
> 
> Justin
> 

