Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56ACB5307CA
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 04:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345519AbiEWCtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 22:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiEWCtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 22:49:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1C836E1D
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 19:49:22 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ev18so12774063pjb.4
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 19:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JUb2RTlT+IZglRnDyHTq14AHdKEeDChqzxcTkCPvkpY=;
        b=nonjOb4hotiLX5UUe8J/gf1SECe6Z8aH143j9DwllQutSIG2gHWEMn5pD6oLPSbH7s
         2ghhmyX9B1jvBmflAzVzo7kxM1KuOiyhB2tdWk7ODaF4S5NI25jRDrNhRSwyhHmAZtHl
         TJHm0gtYlPOOTGqXGR/P6xBleAoIucnsF+8ZuYascm645+s5RrGCn+b6gzeWd3KhVOe+
         4+xyRyBWpTHI7wK4dXNtwXsFIrWhMW6UZvvjSF7FfA3HG05HsX46Fvbgjjxfafer/P87
         0eB+1zf5A1y7gZ/rYfwt5DvX97nDd3yoPQWrfLsNWBZSvDbMCgeb1lATBXDrh2FilVsr
         RENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JUb2RTlT+IZglRnDyHTq14AHdKEeDChqzxcTkCPvkpY=;
        b=p/44qWnABaSLVz9GbsAhgwfXf7WLxODc3sefxW7r88NzuI6yqaub5MfIVM8/vmgHiO
         MZCDKhCmHOHFXrV9vrBhUUgMDN1a0a5Gb2GXjB+gE1l8kSsrvRLp8N5ZhNQPo7sBb1i7
         kAdZzfwSp1SzmboXTavSVY3yXDJ7J9drI2qCrcqj84fmywgeId7KwV30w5kdhwxF8woF
         A2/ibwWkqxskMREErGSe5q+WWfL4Qk2ORL9HEHg5utiqX7tpp2ASk867/R4FOceGQQaj
         WRRFnp5M4SoWppAmm2nWp/BY9wYyfDlndfcWWX6wLWQlwUN7xwEN8hHf5rqtmZD5wBih
         tyVw==
X-Gm-Message-State: AOAM532P2Ph7Ez+6qaCcWryr4i5FGSIC/irmZJOVGkhsQ2ai5ORdvfar
        Qlb8HfWUClMk0/lpKQuoVME=
X-Google-Smtp-Source: ABdhPJyLQbOuFH7gl2zEod9sFLqO0z9R7iTGrMGce+Yk9+XcGDmNFCmazh115lXzkNkB8POkyE4R2Q==
X-Received: by 2002:a17:902:a58b:b0:161:67a0:d2b2 with SMTP id az11-20020a170902a58b00b0016167a0d2b2mr20721686plb.131.1653274161831;
        Sun, 22 May 2022 19:49:21 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:7d80:5130:9847:28b6? ([2600:8802:b00:4a48:7d80:5130:9847:28b6])
        by smtp.gmail.com with ESMTPSA id jb4-20020a170903258400b0015e8d4eb1fcsm3803604plb.70.2022.05.22.19.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 19:49:21 -0700 (PDT)
Message-ID: <dd55b6ce-204e-557b-ef70-1c91f80e5f8d@gmail.com>
Date:   Sun, 22 May 2022 19:49:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v5 2/2] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, bcm-kernel-feedback-list@broadcom.com,
        kernel-team@fb.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
References: <20220518223935.2312426-1-jonathan.lemon@gmail.com>
 <20220518223935.2312426-3-jonathan.lemon@gmail.com>
 <f5963ddb-01bb-6935-ecdd-0f9e7c0afda0@gmail.com>
 <20220521020456.fkgx7s5ymtxd5y2q@bsd-mbp.local>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220521020456.fkgx7s5ymtxd5y2q@bsd-mbp.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/2022 7:04 PM, Jonathan Lemon wrote:
> On Fri, May 20, 2022 at 10:24:25AM -0700, Florian Fainelli wrote:
>>
>>
>> On 5/18/2022 3:39 PM, Jonathan Lemon wrote:
>>> This adds PTP support for BCM54210E Broadcom PHYs, in particular,
>>> the BCM54213PE, as used in the Rasperry PI CM4.  It has only been
>>> tested on that hardware.
>>>
>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>>> ---
>> [snip]
>>
>> Looks good to me, just one question below:
>>
>>> +static void bcm_ptp_init(struct bcm_ptp_private *priv)
>>> +{
>>> +	priv->nse_ctrl = NSE_GMODE_EN;
>>> +
>>> +	mutex_init(&priv->mutex);
>>> +	skb_queue_head_init(&priv->tx_queue);
>>> +
>>> +	priv->mii_ts.rxtstamp = bcm_ptp_rxtstamp;
>>> +	priv->mii_ts.txtstamp = bcm_ptp_txtstamp;
>>> +	priv->mii_ts.hwtstamp = bcm_ptp_hwtstamp;
>>> +	priv->mii_ts.ts_info = bcm_ptp_ts_info;
>>> +
>>> +	priv->phydev->mii_ts = &priv->mii_ts;
>>> +
>>> +	INIT_DELAYED_WORK(&priv->out_work, bcm_ptp_fsync_work);
>>
>> Do we need to make sure that we cancel the workqueue in an bcm_ptp_exit()
>> function?
>>
>> I would imagine that the Ethernet MAC attached to that PHY device having
>> stopped its receiver and transmitter should ensure no more packets coming in
>> or out, however since this is a delayed/asynchronous work, do not we need to
>> protect against use after free?
> 
> The workqueue is just mamually creatimg a 1PPS pulse on the SYNC_OUT
> pin, no packet activity.  Arguably, the .suspend hook could stop all work,
> but that seems out of scope here? (and this phy does not suspend/resume)

The BCM54210E entry does have a suspend/resume entry so it seems to me 
that we do need to cancel the workqueue as the PHY library will not do 
that on our behalf. What I imagine could happen is that this workqueue 
generates spurious MDIO accesses *after* both the PHY and the bus have 
been suspended (and their driver's clock possibly gated already).
-- 
Florian
