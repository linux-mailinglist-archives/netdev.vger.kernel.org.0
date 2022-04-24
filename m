Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAD450D606
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 01:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbiDXXaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 19:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiDXXaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 19:30:11 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1806A049
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 16:27:09 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u7so7872674plg.13
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 16:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AM/y/eoJpDY9L8yHXYF6ID+UHTBp283Dk8nd7KwbBes=;
        b=k2t8UVjP3hHHeebR6ZAwuApihINzr02FmHb1MHV+bOtJri0G5MIPvwbDBYE7EOeUbF
         U/fpbVI5v1a+VjzJzU/mp3UAPhThkM7LGAmmGHPEQMRKR3q5o2RcfNTmP4gdr8mA7VrX
         NKWXv8qaUO7M4fvz00JTsKXNPBvAhESSK1CRqllS9WOc0KyEcFSOeu0JTMeRVteKD92v
         cvq/Mr4e7DkqmfBbq7NmxNDWJP2gzo8T+oyljKURa9gQDD0pM6+hLEh8/wHPqja7W5aA
         BNcUsddNtvGL/KuBcBi2TzLgzgxQlmbcq1Uj4B5IUqGuN4hsrfRLfGtLDgDrNSdw+0Lf
         I/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AM/y/eoJpDY9L8yHXYF6ID+UHTBp283Dk8nd7KwbBes=;
        b=aWI7WHQzFBktv10NCACF0enIjAAkUlcCymVd6il7CZL4e/cTzutS2mvCwbaqEBQBXV
         IziofhipgOK1dL2lcELwKRx6dwVfsNX/83IkpIsF+FoOsaEn2+c4yS8dIbIoLQFUffF5
         /+0rNU/bdZj83eqAkr5YWhTAw/w16UXiGdUfmbv+J1AR1/rtmTDR4UqAFeCEWM0UYrKr
         3ctxcyHKVvUO0ALdiG1zZAOIAWEEpiCQDlTgN3sjaj5F0CNQbxWYAw0bspzrvtLxRpWr
         uncnDMZ+EEJxS2yS95khM2rQLYjIq4AEtUbyEMNGlmIpxJ2jFQOf/YFTqf2mERQWj7pH
         Bq0Q==
X-Gm-Message-State: AOAM532UA3Wv5Tz6hiVaKI9oYj8pPzOg5TJYyWkPypmpR3VmIdTfaqRu
        dDqdjy75I830Ki3PbiJjYGA=
X-Google-Smtp-Source: ABdhPJz7GNfFLcrDD6aveFcqr13TbjJdwyfrLFT7nW34TsNW0220Cyj6QqS2qKqnXxziJA/DhurE+Q==
X-Received: by 2002:a17:902:7789:b0:156:8b5c:606f with SMTP id o9-20020a170902778900b001568b5c606fmr14732076pll.100.1650842828840;
        Sun, 24 Apr 2022 16:27:08 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q9-20020a638c49000000b00398677b6f25sm8103925pgn.70.2022.04.24.16.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 16:27:08 -0700 (PDT)
Message-ID: <91d60847-4721-971d-7e86-22e1dd3c694e@gmail.com>
Date:   Sun, 24 Apr 2022 16:27:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220424022356.587949-2-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/2022 7:23 PM, Jonathan Lemon wrote:
> This adds PTP support for BCM54210E Broadcom PHYs, in particular,
> the BCM54213PE, as used in the Rasperry PI CM4.  It has only been
> tested on that hardware.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---

[snip]

Mostly checking register names/offsets/usage because I am not familiar 
enough with how PTP is supposed to work.

> +#define MODE_SEL_SHIFT_PORT		0
> +#define MODE_SEL_SHIFT_CPU		8
> +
> +#define rx_mode(sel, evt, act) \
> +	(((MODE_RX_##act) << (MODE_EVT_SHIFT_##evt)) << (MODE_SEL_SHIFT_##sel))
> +
> +#define tx_mode(sel, evt, act) \
> +	(((MODE_TX_##act) << (MODE_EVT_SHIFT_##evt)) << (MODE_SEL_SHIFT_##sel))

I would capitalize these two macros to make it clear that they are 
exactly that, macros.

> +
> +/* needs global TS capture first */
> +#define TX_TS_CAPTURE		0x0821
> +#define  TX_TS_CAP_EN			BIT(0)
> +#define RX_TS_CAPTURE		0x0822
> +#define  RX_TS_CAP_EN			BIT(0)
> +
> +#define TIME_CODE_0		0x0854

Maybe add a macro here as well:

#define TIME_CODE(x)		(TIME_CODE0 + (x))

> +#define TIME_CODE_1		0x0855
> +#define TIME_CODE_2		0x0856
> +#define TIME_CODE_3		0x0857
> +#define TIME_CODE_4		0x0858
> +
> +#define DPLL_SELECT		0x085b
> +#define  DPLL_HB_MODE2			BIT(6)

Seems like you have better documentation than I do :)

> +#define SHADOW_CTRL		0x085c

Unused

> +#define SHADOW_LOAD		0x085d
> +#define  TIME_CODE_LOAD			BIT(10)
> +#define  SYNC_OUT_LOAD			BIT(9)
> +#define  NCO_TIME_LOAD			BIT(7)

NCO Divider load is bit 8 and Local time Load bit is 7, can you check 
which one you need?

> +#define  FREQ_LOAD			BIT(6)
> +#define INTR_MASK		0x085e
> +#define INTR_STATUS		0x085f
> +#define  INTC_FSYNC			BIT(0)
> +#define  INTC_SOP			BIT(1)
> +
> +#define FREQ_REG_LSB		0x0873
> +#define FREQ_REG_MSB		0x0874

Those two hold the NCO frequency, can you rename accordingly?

> +
> +#define NCO_TIME_0		0x0875
> +#define NCO_TIME_1		0x0876
> +#define NCO_TIME_2_CTRL		0x0877
> +#define  FREQ_MDIO_SEL			BIT(14)
> +
> +#define SYNC_OUT_0		0x0878
> +#define SYNC_OUT_1		0x0879
> +#define SYNC_OUT_2		0x087a

Likewise a macro could be useful here.

> +
> +#define TS_READ_CTRL		0x0885
> +#define  TS_READ_START			BIT(0)
> +#define  TS_READ_END			BIT(1)
> +
> +#define TIMECODE_CTRL		0x08c3
> +#define  TX_TIMECODE_SEL		GENMASK(7, 0)
> +#define  RX_TIMECODE_SEL		GENMASK(15, 8)

This one looks out of order compared to the other registers

> +
> +#define TS_REG_0		0x0889 > +#define TS_REG_1		0x088a
> +#define TS_REG_2		0x088b
> +#define TS_REG_3		0x08c4
> +#define TS_INFO_0		0x088c
> +#define TS_INFO_1		0x088d
> +
> +#define HB_REG_0		0x0886
> +#define HB_REG_1		0x0887
> +#define HB_REG_2		0x0888
> +#define HB_REG_3		0x08ec > +#define HB_REG_4		0x08ed


> +#define HB_STAT_CTRL		0x088e
> +#define  HB_READ_START			BIT(10)
> +#define  HB_READ_END			BIT(11)
> +#define  HB_READ_MASK			GENMASK(11, 10)
> +
> +#define NSE_CTRL		0x087f

This one is also out of order.

[snip]
> +struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev)
> +{
> +	struct bcm_ptp_private *priv;
> +	struct ptp_clock *clock;
> +
> +	switch (BRCM_PHY_MODEL(phydev)) {
> +	case PHY_ID_BCM54210E:
> +#ifdef PHY_ID_BCM54213PE
> +	case PHY_ID_BCM54213PE:
> +#endif

This does not exist upstream.
-- 
Florian
