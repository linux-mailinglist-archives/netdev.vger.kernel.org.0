Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B778FE17C0
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404336AbfJWKW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:22:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40440 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404309AbfJWKW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:22:57 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20191023102256euoutp016a506d847664e8c88f01dc0ad005d664~QP5RZge4c2854128541euoutp01Y
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 10:22:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20191023102256euoutp016a506d847664e8c88f01dc0ad005d664~QP5RZge4c2854128541euoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571826176;
        bh=nEwa9AqtRqOH/1tI4JgppDN9b7uF1/aatluiGEi2DL0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=VHUyWi+Yjq2BvzAjJV/MXcgErwgYJcp0f8+96OOyM8MamO7rUPvpl/6A9gz772hBv
         Tbe0ahuTMBZtdAg7HpE3mnV+RlSHbclqnVMJlCBBrzvgI5sZFJ8XNMll9w0yQISqWH
         7pzkdSsvWsPsjAKpBAjndCganjqj40klXOS6tC4Y=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20191023102256eucas1p1b11e67c24607954bfd20d97bf5fd4ce4~QP5RNxyUd2978529785eucas1p1s;
        Wed, 23 Oct 2019 10:22:56 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 1A.16.04309.00A20BD5; Wed, 23
        Oct 2019 11:22:56 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20191023102255eucas1p187669b0a3672fd293e4d6acc05efaaad~QP5Q1Zg-w2978529785eucas1p1r;
        Wed, 23 Oct 2019 10:22:55 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191023102255eusmtrp2ef5c3895cb7599b506b6b694d4cc720e~QP5Qz1ZQq2298822988eusmtrp2_;
        Wed, 23 Oct 2019 10:22:55 +0000 (GMT)
X-AuditID: cbfec7f4-afbff700000010d5-cc-5db02a00fc2a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id DF.F6.04117.FF920BD5; Wed, 23
        Oct 2019 11:22:55 +0100 (BST)
Received: from [106.120.51.15] (unknown [106.120.51.15]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191023102255eusmtip2ff13bacd2d020226fbc223ddcac3718f~QP5QVAn151093910939eusmtip2O;
        Wed, 23 Oct 2019 10:22:55 +0000 (GMT)
Subject: Re: [PATCH net-next] r8152: support request_firmware for RTL8153
To:     Hayes Wang <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "pmalani@chromium.org" <pmalani@chromium.org>,
        "grundler@chromium.org" <grundler@chromium.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <c20abd08-5f22-2cc8-15fa-956d06b5b8af@samsung.com>
Date:   Wed, 23 Oct 2019 12:22:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
        Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18ED3FA@RTITMBSVM03.realtek.com.tw>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01SeUiTYRz23bfj22jyOo/9UNEadCh4pX98dIhB0IqCEBLLJKd+eG1TNrWs
        f9RIzAMq8ppaongkqGOVVzlSy5Wlm1tIpHiggYrDwpFKorl9s/zveX7X8zwvL0mItBxvMk2Z
        TauUMrmEK2B3j2wZg1wCtfGh5jEOtfJ+k0VVDpYhymjU8ihLfx2XqjbqWVRjywOCGmnwomzl
        Gg5VYarlRfGltfkTbKmu/SFXumB9yZOu6/yusm8IziTT8rRcWhUSmSBINRdZOFnzXndGd+e5
        +eiLqATxScARYLaVskuQgBThNgRtrQOIITYEb35tOMk6gpqdD7z9lYG2PoJptCIY1vY4iRVB
        8dgcYZ9yxxdhe6mBa8ceOA7GW3ocpwi8wIIfvfWOBheHQYm1xIGFOBJ0P/uRHbPxUWitHXMc
        8sTxMLNpIJgZN/hUs7jnliT5OBpm62LsZQL7Q4+1jmCwGL4vPmfZtQDreVD8fIfF2D4PT5sK
        nRHcYcXwyol9Ybdvf+E+gvnxDh5DyhBYCqsRM3Uahg0THLsygQOgqz+EKZ+DptV5hyHArvDN
        6saYcIUn3VUEUxZCcZHzsY+BxtD5T3bQZCYeIYnmQDLNgTiaA3E0/3UbELsdiekctSKFVp9U
        0reD1TKFOkeZEpyUqdChvX/0ecdg60X924lDCJNIckgYtdYZL+LIctV5iiEEJCHxEE6HdsSL
        hMmyvLu0KvOWKkdOq4eQD8mWiIX3XObiRDhFlk1n0HQWrdrvski+dz5K2PhYIdaduhbeIGrk
        898dX864GZOePin1+6P0idAHdMY2d1c1CbdHX/jbBh6rWl+Pf52xaBOLn3UdMZmwZ3TBpbdb
        15fM0XF5PvU1nc38qezyyaypbL2srzq30nS2qDQkcE0wOx27fKHMp+Dy753VSnnQiXB/3+Ur
        SUK/w41ZqxK2OlUWFkio1LK/99usfUMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t/xe7r/NTfEGkxeqmnx6sgPJotpB3sY
        Lc6f38BucXnXHDaLGef3MVksWtbKbHFsgZjFl95ZrBZTL8xmd+D0mN1wkcVj06pONo/Hbzez
        e3zeJBfAEqVnU5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9nk5Kak1mWWqRv
        l6CXcantMmvBQ7GKU/8fsjUwnhHqYuTkkBAwkdi7YidzFyMXh5DAUkaJ9f0HWCASMhInpzWw
        QtjCEn+udbFBFL1mlGj+8IMdJCEs4Cnx58UCNhBbRCBaovPQX1aQImaB50wSiz+/YIXo6GOS
        eHZ0EyNIFZuAoUTX2y6wDl4BO4lNH3aBxVkEVCWWzz4LdAcHh6hArMSmvWYQJYISJ2c+YQEJ
        cwoESdyfEwYSZhYwk5i3+SEzhC0vsf3tHChbXOLWk/lMExiFZiHpnoWkZRaSlllIWhYwsqxi
        FEktLc5Nzy020itOzC0uzUvXS87P3cQIjL5tx35u2cHY9S74EKMAB6MSD6/D+3WxQqyJZcWV
        uYcYJTiYlUR47xisjRXiTUmsrEotyo8vKs1JLT7EaAr02kRmKdHkfGBiyCuJNzQ1NLewNDQ3
        Njc2s1AS5+0QOBgjJJCeWJKanZpakFoE08fEwSnVwMjwMMB9hdfDHtu/2pXanY7sEzqnxQis
        ctVMPhm1Tizuk4/1xKxDLwMn7fn8Zhufn/GWayfMFY89m2ZzxL1aK1vu9O3/V8zXSvCE8ph5
        zcyceVUmcO/c8rzpro7GIjWRH+fkcFze91S8ZUNqkeP8R8+jSxWX8fzhKmhX/vtnrev31PQ1
        9TNOGCqxFGckGmoxFxUnAgAbpVEa1AIAAA==
X-CMS-MailID: 20191023102255eucas1p187669b0a3672fd293e4d6acc05efaaad
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20191023091648eucas1p12dcc4e9041169e3c7ae43f4ea525dd7f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20191023091648eucas1p12dcc4e9041169e3c7ae43f4ea525dd7f
References: <1394712342-15778-329-Taiwan-albertk@realtek.com>
        <CGME20191023091648eucas1p12dcc4e9041169e3c7ae43f4ea525dd7f@eucas1p1.samsung.com>
        <44261242-ff44-0067-bbb9-2241e400ad53@samsung.com>
        <0835B3720019904CB8F7AA43166CEEB2F18ED3FA@RTITMBSVM03.realtek.com.tw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hayes,

On 23.10.2019 11:48, Hayes Wang wrote:
> Marek Szyprowski [mailto:m.szyprowski@samsung.com]
>> Sent: Wednesday, October 23, 2019 5:17 PM
>> Subject: Re: [PATCH net-next] r8152: support request_firmware for RTL8153
>>
>> Hi Hayes,
>>
>> On 16.10.2019 05:02, Hayes Wang wrote:
>>> This patch supports loading additional firmware file through
>>> request_firmware().
>>>
>>> A firmware file may include a header followed by several blocks
>>> which have different types of firmware. Currently, the supported
>>> types are RTL_FW_END, RTL_FW_PLA, and RTL_FW_USB.
>>>
>>> The firmware is used to fix some compatible or hardware issues. For
>>> example, the device couldn't be found after rebooting several times.
>>>
>>> The supported chips are
>>> 	RTL_VER_04 (rtl8153a-2.fw)
>>> 	RTL_VER_05 (rtl8153a-3.fw)
>>> 	RTL_VER_06 (rtl8153a-4.fw)
>>> 	RTL_VER_09 (rtl8153b-2.fw)
>>>
>>> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
>>> Reviewed-by: Prashant Malani <pmalani@chromium.org>
>> This patch (which landed in linux-next last days) causes a following
>> kernel oops on the ARM 32bit Exynos5422 SoC based Odroid XU4 board:
> Please try the following patch.

Yes, this fixes the issue. I've applied those changes manually on top of 
Linux next-20191022, due to some differences in the context. When you 
prepare a final patch, feel free to add:

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 9370f2d05a2a ("r8152: support request_firmware for RTL8153")
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>


> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index d3c30ccc8577..283b35a76cf0 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -4000,8 +4000,8 @@ static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
>   static void rtl8152_apply_firmware(struct r8152 *tp)
>   {
>   	struct rtl_fw *rtl_fw = &tp->rtl_fw;
> -	const struct firmware *fw = rtl_fw->fw;
> -	struct fw_header *fw_hdr = (struct fw_header *)fw->data;
> +	const struct firmware *fw;
> +	struct fw_header *fw_hdr;
>   	struct fw_phy_patch_key *key;
>   	u16 key_addr = 0;
>   	int i;
> @@ -4009,6 +4009,9 @@ static void rtl8152_apply_firmware(struct r8152 *tp)
>   	if (IS_ERR_OR_NULL(rtl_fw->fw))
>   		return;
>   
> +	fw = rtl_fw->fw;
> +	fw_hdr = (struct fw_header *)fw->data;
> +
>   	if (rtl_fw->pre_fw)
>   		rtl_fw->pre_fw(tp);
>
>>> +static void rtl8152_apply_firmware(struct r8152 *tp)
>>> +{
>>> +	struct rtl_fw *rtl_fw = &tp->rtl_fw;
>>> +	const struct firmware *fw = rtl_fw->fw;
>>> +	struct fw_header *fw_hdr = (struct fw_header *)fw->data;
>>> +	int i;
>>> +
>>> +	if (IS_ERR_OR_NULL(rtl_fw->fw))
>>> +		return;
>>> +
>>> +	if (rtl_fw->pre_fw)
>>> +		rtl_fw->pre_fw(tp);
>>> +
>>>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

