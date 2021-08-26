Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AFB3F8D91
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 20:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243092AbhHZSHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 14:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhHZSHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 14:07:37 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84732C061757;
        Thu, 26 Aug 2021 11:06:49 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id o10so8621972lfr.11;
        Thu, 26 Aug 2021 11:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ScO346pAaxul9WVEbiLaOsiKhWakUZ+nhWVfJ1DCI24=;
        b=XvQTn0RCSdBucl74gZc5NIWSgMt+ya5Y6FBKQKQicfgyrvijxGyyKYcM3crPwW6uSb
         wGsUpsltdZqlo24EjWjh92+MCoCjnwmr8jZzfKhqZL4Nj0qXNJKw1h6p57gHb47rovhC
         kQmbYEqiWUaGWxDi7xHIBe1gP7nJ2GaZXTMZJxpwgYVMbznfmjP1IwOH+UoaHJLN9KN9
         Uo0XD7xHHVuism0MZ6WnECc4I9u1a4GGs/6I2cjU5mmZDrcrISAlh0Pjxd+SaIrJp2LO
         4bMRsfv1L5sypW+douupWuciin3YY5c13CihOWSey1kigHi+yU0JXlX4SleTB6a/AUKa
         QMMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ScO346pAaxul9WVEbiLaOsiKhWakUZ+nhWVfJ1DCI24=;
        b=gok9peLAjVT0LAe1NvG03p6NQAUGfIcN24OMhsWTUd7ubnR6T5XVco4IgQCaP+j/Ut
         g1M6OM8v5mNArYuY6FeQBOuZDSaxu/Xu1p9Ghge+ngc04DlXNi62J6skkrr+/yF/j+I1
         nHZ+5kMXo7p4uuhXoYS5E/M8at8JUJY2XqoPm5yMviklxDE/7H2k+V4T7+D88c0Nbv4V
         9oHDIW/ziYHByrPwFig252JWLTEvzT0DVBc1jKtuzXFq7I6cWoLwnyYwpiREz1AAlFcR
         z6efneBRBwzf5NWIkzy5LrUUoOTwvwemMlpxzGolDYOa9Ja2kLN2ZPzScoyxU4ocAE1f
         LzpA==
X-Gm-Message-State: AOAM533bK8Yj3jgqMdDHUaLi25LVgD11RoSAez0napbMK+G54TokxxK8
        XxJPQQXLPyt/ane2N7HB7DI=
X-Google-Smtp-Source: ABdhPJzrRyuupHliXQVfToAprh0i/qN5FUSqUH2uf3LQdV5cSz50DnlyXkEnT+XxB/xmdUQCISl6vQ==
X-Received: by 2002:a05:6512:4011:: with SMTP id br17mr3718982lfb.463.1630001207853;
        Thu, 26 Aug 2021 11:06:47 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.83.98])
        by smtp.gmail.com with ESMTPSA id d24sm417728ljj.8.2021.08.26.11.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 11:06:47 -0700 (PDT)
Subject: Re: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
 <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
 <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <9b0d5bab-e9a2-d9f6-69f7-049bfb072eba@omp.ru>
 <OS0PR01MB5922F8114A505A33F7A47EB586C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <93dab08c-4b0b-091d-bd47-6e55bce96f8a@gmail.com>
Date:   Thu, 26 Aug 2021 21:06:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922F8114A505A33F7A47EB586C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/21 1:52 PM, Biju Das wrote:
[...]
>>>>>>> There are some H/W differences for the gPTP feature between R-Car
>>>>>>> Gen3, R-Car Gen2, and RZ/G2L as below.
>>>>>>>
>>>>>>> 1) On R-Car Gen3, gPTP support is active in config mode.
>>>>>>> 2) On R-Car Gen2, gPTP support is not active in config mode.
>>>>>>> 3) RZ/G2L does not support the gPTP feature.
>>>>>>>
>>>>>>> Add a ptp_cfg_active hw feature bit to struct ravb_hw_info for
>>>>>>> supporting gPTP active in config mode for R-Car Gen3.
>>>>>>
>>>>>>      Wait, we've just done this ion the previous patch!
>>>>>>
>>>>>>> This patch also removes enum ravb_chip_id, chip_id from both
>>>>>>> struct ravb_hw_info and struct ravb_private, as it is unused.
>>>>>>>
>>>>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>>>>> Reviewed-by: Lad Prabhakar
>>>>>>> <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>>>>>> ---
>>>>>>>    drivers/net/ethernet/renesas/ravb.h      |  8 +-------
>>>>>>>    drivers/net/ethernet/renesas/ravb_main.c | 12 +++++-------
>>>>>>>    2 files changed, 6 insertions(+), 14 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>>>>>> b/drivers/net/ethernet/renesas/ravb.h
>>>>>>> index 9ecf1a8c3ca8..209e030935aa 100644
>>>>>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>>>>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>>>>>> @@ -979,17 +979,11 @@ struct ravb_ptp {
>>>>>>>    	struct ravb_ptp_perout perout[N_PER_OUT];  };
>>>>>>>
>>>>>>> -enum ravb_chip_id {
>>>>>>> -	RCAR_GEN2,
>>>>>>> -	RCAR_GEN3,
>>>>>>> -};
>>>>>>> -
>>>>>>>    struct ravb_hw_info {
>>>>>>>    	const char (*gstrings_stats)[ETH_GSTRING_LEN];
>>>>>>>    	size_t gstrings_size;
>>>>>>>    	netdev_features_t net_hw_features;
>>>>>>>    	netdev_features_t net_features;
>>>>>>> -	enum ravb_chip_id chip_id;
>>>>>>>    	int stats_len;
>>>>>>>    	size_t max_rx_len;
>>>>>>
>>>>>>      I would put the above in a spearte patch...
>>>>
>>>>      Separate. :-)
>>>>
>>>>>>>    	unsigned aligned_tx: 1;
>>>>>>> @@ -999,6 +993,7 @@ struct ravb_hw_info {
>>>>>>>    	unsigned tx_counters:1;		/* E-MAC has TX counters */
>>>>>>>    	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has
>>>> multiple
>>>>>> irqs */
>>>>>>>    	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support
>>>> gPTP
>>>>>> active in config mode */
>>>>>>> +	unsigned ptp_cfg_active:1;	/* AVB-DMAC has gPTP support
>> active in
>>>>>> config mode */
>>>>>>
>>>>>>      Huh?
>>>>>>
>>>>>>>    };
>>>>>>>
>>>>>>>    struct ravb_private {
>>>>>> [...]
>>>>>>> @@ -2216,7 +2213,7 @@ static int ravb_probe(struct platform_device
>>>>>> *pdev)
>>>>>>>    	INIT_LIST_HEAD(&priv->ts_skb_list);
>>>>>>>
>>>>>>>    	/* Initialise PTP Clock driver */
>>>>>>> -	if (info->chip_id != RCAR_GEN2)
>>>>>>> +	if (info->ptp_cfg_active)
>>>>>>>    		ravb_ptp_init(ndev, pdev);
>>>>>>
>>>>>>      What's that? Didn't you touch this lie in patch #3?
>>>>>>
>>>>>>      This seems lie a NAK bait... :-(
>>>>>
>>>>> Please refer the original patch[1] which introduced gPTP support
>>>>> active
>>>> in config mode.
>>>>> I am sure this will clear all your doubts.
>>>>
>>>>      It hasn't. Why do we need 2 bit fields (1 "positive" and 1
>>>> "negative") for the same feature is beyond me.
>>>
>>> The reason is mentioned in commit description, Do you agree 1, 2 and 3
>> mutually exclusive?
>>>
>>> 1) On R-Car Gen3, gPTP support is active in config mode.
>>> 2) On R-Car Gen2, gPTP support is not active in config mode.
>>> 3) RZ/G2L does not support the gPTP feature.
>>
>>     No, (1) includes (2).
> 
> patch[1] is for supporting gPTP support active in config mode.

   Yes.

> Do you agree GAC register(gPTP active in Config) bit in AVB-DMAC mode register(CCC) present only in R-Car Gen3?

   Yes.
   But you feature naming is totally misguiding, nevertheless...

> [1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/net/ethernet/renesas/ravb_main.c?h=next-20210825&id=f5d7837f96e53a8c9b6c49e1bc95cf0ae88b99e8
> 
> Regards,
> Biju

[...]

MBR, Sergey
