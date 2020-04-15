Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD5C1A9AFC
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 12:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896487AbgDOKkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 06:40:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47055 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408836AbgDOKkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 06:40:13 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200415104011euoutp0177c8908b82e466030d7edd935fb90a09~F_BTETOBZ1423914239euoutp01g
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 10:40:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200415104011euoutp0177c8908b82e466030d7edd935fb90a09~F_BTETOBZ1423914239euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586947211;
        bh=ilbWDGWbaRmexJKmcC9EJmUzad9wnDBQcm71APgXbnk=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=qdwRsKTSNMK1fAZXMy5zYYLm50MlaZ/u/e/tTTHag0EDTTg02uhHDLQWhwt/AIi1v
         pukbWAo6DDMEg4veEhwcyZuiZvTV2WwAA8oql3nGwWVmSyal8zmuobqReRSJl9a1Qn
         DEIdcR7gnv/HZbkUFZb5xbssMTxpYEX7q1XoNS70=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200415104011eucas1p237a10ec69b125ca05daa8bfa24607cd2~F_BSiSR-B0638006380eucas1p2G;
        Wed, 15 Apr 2020 10:40:11 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id F4.66.60679.B84E69E5; Wed, 15
        Apr 2020 11:40:11 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200415104010eucas1p101278e53e34a2e56dfc7c82b533a9122~F_BSNbnvX2212922129eucas1p1F;
        Wed, 15 Apr 2020 10:40:10 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200415104010eusmtrp284c0e1fa3491e3a5d7df659fc36fcdcc~F_BSMVzis0073600736eusmtrp2y;
        Wed, 15 Apr 2020 10:40:10 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-7b-5e96e48b1b50
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 79.23.07950.A84E69E5; Wed, 15
        Apr 2020 11:40:10 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200415104009eusmtip14f72f942ba7857a4c5f586d41e0a2cc9~F_BRLVgds1086210862eusmtip1I;
        Wed, 15 Apr 2020 10:40:09 +0000 (GMT)
Subject: Re: [RFC 0/8] Stop monitoring disabled devices
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <dc999149-d168-0b86-0559-7660e0fdec77@samsung.com>
Date:   Wed, 15 Apr 2020 12:40:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <aeec2ce8-8fb9-9353-f3dd-36a476ceeb3b@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTZxjG8507uOrnAeWNSkYaNREzYcPoF3UGMpeczET3z9QQL3RyhmS0
        mh7A6R+bGwpY5wUnt0o2EFNajIAFkXKpE6ZlkRXES7yA0lFdcRadqBMjKIcjkf+ePM/7+97n
        TT6BFt3cLCHVlC6bTYY0PRfK1F8a7vzogL9gc2z2BZ442kcZ8r93mCK2/rsMOVr0hia/DkWS
        ks69DLGUxRLf9bUke6iIIb7fPyO3fmyiSEkgk9R6f2ZJZb6LIS5fkCMV7sOIOPtvsMTyykGT
        oYN/IHKpdCbp6tpITjUHaNJxuZslft8hjoycczIkUBdBWvZdoUmtM5+OnyM19J5EUp3jFiXZ
        n8ZILmsvL9Xao6Xy5gFKclbu56SeG82cNOj1jvknf5D+e+TnpQeFbZR05EmQk84MNlDS4ZFY
        6eXVR+yXYYmhK5LltNRM2RyzMil0m7to7o6L+LuSe4XsHtSgs6AQAfBicJy30RYUKojYjqDJ
        /oRSAxE/Q/CyI00LhhD09bfTE0TZtcZ3RAWCY/sHOI0IIrAHNqk6DC+F4522cT8cx8FwfZBX
        ARq/4OH++X8YNeDwMsjLqUSq1uGVUPzT87FXBYHB86A2a5pqz8Ab4GlfG6uNTIc/i/3jaAhO
        gH+7u3hV0zgCbvt/ozT9IWSdPT5eDvCBELhZUExprVfBtb1NrKbD4KGnjtf0HHjjUmEVqEIw
        kht4R59DUPHLKKdNLYce7ytObUfjBVDdGKPZCXCxo4pXbcBT4WZwulZiKhytL6Q1Wwe52aI2
        PR9qbDXcxFqLy0EfQXrrpNOsk86xTjrH+n5vKWIqUYScoRhTZOUTk7xzkWIwKhmmlEVbtxud
        aOxXXx71PGtAja+/bkVYQPoPdFHV+ZtF1pCp7DK2IhBofbiu2jhm6ZINu3bL5u1bzBlpstKK
        ZguMPkIXd2Jgk4hTDOnyt7K8QzZPpJQQMmsP2j1i7Lggjya618d9PqUndfX1aVH+Y1VW0ZP1
        ouyLb5JbHnYnPfZFpeftG2aXD65jok8Hvkoqt4t1kUX9oscUl/N6yhXm70/L18U0r6ox3NMV
        5PN385Z1KbY1iUu2bpgbn+PpQ21rZvz1+GB7fGxp+Iry503u7/2R7Z47BQsTelvoXD2jbDN8
        HE2bFcNbHona49EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRiH+XbOzqa1Ok3NDzWLUQlF07mtfYtaVhQnsuyCUdlt6EEtt9k5
        U7KC1MzqkJmVtyWmdNNVRNNslkmpqVEsL2UoWYojFS9YFqZ4aUsD/3v4vb+HlxdeISZu5HsJ
        o/VGmtFrYySEK/5usq59FWfPOhzwqN4fFddP4mjENspD97q+4uhazhSG8ocXobwPKTjiCgNQ
        56cQlDqcg6POV5tQa9ILHsrriUcltst8ZM4sx1F55wCB7lemA2TpauEjbqwYQ8NpNQDVFixE
        DQ0H0YOKHgy9f9fER/bOKwSaeGbBUU+pJ3p5vhFDJZZMLMiHsrbfAVRpcSuPKvrpT5Wb2gVU
        SdEK6nZFL4+ymC8R1JeWCoIatNkc+Z2z1I9+u4D6nl3No64ODRDUk0Erj0qfCKD+NPfzd7od
        kK5lDHFGekmUgTWuk4TJUKBUpkbSQIVaKpOrDq0JVEr8NWsj6JjoeJrx1xyVRlXmLI19Q57M
        +5bNTwRWEQdchJBUwMKPzzEOuArF5F0Aa7L6CQ4IHQMfWPc4frrjBsdbOGK60wdg9+AU3zlw
        I1Xw5od7hJPdSTkcLRsQOEsY+UcAr3T9mjHuA2h5MPLPIMg1MOOCGThZRGpgbvJvzLkNJ5fB
        knPznbEHuQ9WW00zlQXwba4dd7ILuQH2NTUInIyRfnA8vwmbZk/YZr/Fm+bF8NzTm9hVIDbN
        0k2zFNMsxTRLKQC4GbjTcawuUscGSlmtjo3TR0rDDToLcLxTWe1oqRVwg3uqACkEkrmi+oeZ
        h8V8bTyboKsCUIhJ3EWPdY5IFKFNOEUzhiNMXAzNVgGl47YMzMsj3OB4Tr3xiEwpUyG1TCVX
        yVcjiafoIvn6oJiM1Brp4zQdSzP/PZ7QxSsRZFwOHWhL0+d694d4DgWEZjHbolZiY/vXf05I
        3Rqs2cs2zHu4N/V6h+8ThZpI37JjpGNzgbpXHs5tjvY+U6dU7G/bjd9W+DG+Sbn4dltdiPvz
        7aLTOcneldY5J7RcypaMG081x8K8d3klhprVk2kbK1OS8aEg340jG5rnLu+epwyW4GyUVrYC
        Y1jtX4N//AhkAwAA
X-CMS-MailID: 20200415104010eucas1p101278e53e34a2e56dfc7c82b533a9122
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200415104010eucas1p101278e53e34a2e56dfc7c82b533a9122
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200415104010eucas1p101278e53e34a2e56dfc7c82b533a9122
References: <20200407174926.23971-1-andrzej.p@collabora.com>
        <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
        <aeec2ce8-8fb9-9353-f3dd-36a476ceeb3b@collabora.com>
        <CGME20200415104010eucas1p101278e53e34a2e56dfc7c82b533a9122@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/9/20 1:10 PM, Andrzej Pietrasiewicz wrote:
> Hi Daniel,
> 
> W dniu 09.04.2020 o 12:29, Daniel Lezcano pisze:
>> On 07/04/2020 19:49, Andrzej Pietrasiewicz wrote:
>>> The current kernel behavior is to keep polling the thermal zone devices
>>> regardless of their current mode. This is not desired, as all such "disabled"
>>> devices are meant to be handled by userspace,> so polling them makes no sense.
>>
>> Thanks for proposing these changes.
>>
>> I've been (quickly) through the series and the description below. I have
>> the feeling the series makes more complex while the current code which
>> would deserve a cleanup.
>>
>> Why not first:
>>
>>   - Add a 'mode' field in the thermal zone device
>>   - Kill all set/get_mode callbacks in the drivers which are duplicated code.
>>   - Add a function:
>>
>>   enum thermal_device_mode thermal_zone_get_mode( *tz)
>>   {
>>     ...
>>     if (tz->ops->get_mode)
>>         return tz->ops->get_mode();
>>
>>     return tz->mode;
>>   }
>>
>>
>>   int thermal_zone_set_mode(..*tz, enum thermal_device_mode mode)
>>   {
>>     ...
>>     if (tz->ops->set_mode)
>>         return tz->ops->set_mode(tz, mode);
>>
>>     tz->mode = mode;
>>
>>     return 0;
>>   }
>>
>>   static inline thermal_zone_enable(... *tz)
>>   {
>>     thermal_zone_set_mode(tz, THERMAL_DEVICE_ENABLED);
>>   }
>>
>>   static inline thermal_zone_disable(... *tz) {
>>     thermal_zone_set_mode(tz, THERMAL_DEVICE_DISABLED);
>>   }
>>
>> And then when the code is consolidated, use the mode to enable/disable
>> the polling and continue killing the duplicated code in of-thermal.c and
>> anywhere else.
>>
>>
> 
> Thanks for feedback.
> 
> Anyone else?

Yes. :)

Please take a look at the following patchset (which I'm reviving currently):

	https://lkml.org/lkml/2018/10/17/926

It overlaps partially with your work so we need to coordinate our efforts.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
