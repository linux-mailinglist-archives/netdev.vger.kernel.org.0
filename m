Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8552A52F19E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352205AbiETRYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352226AbiETRY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:24:29 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6F3187DB4
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:24:27 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id q4so7888909plr.11
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j9OnJD8AgznJr7ZxIelXFq08wCQe8qejX8gaUgGwwlg=;
        b=LiPd39P/GVTopnDDCisgTCTDoPB0ZdttUAUMYjx+qMQAzR9rbNoAGNEcaTzW1w6UN0
         /sHn3noK3alOxmSrx2ne5ovfvUYrn7BbGo359XH04Bc9duhucU+7U9wRghX3x7eCHf8j
         y8lFmvRiPvsTn79WeFbPUiIEEA8n2uFujbKgl+y1TjGPXW9ZPwwbCdUuaZvdqFrUeeHC
         mBtGp4naZtHAAAzIzUXz8FjFaYG0USol5PY27Mn9CIn2dFVyzRHa6yGeCcD9hiuJR24d
         +0buOyBxQHWYZwMOdkH04y/3za/a36aDFczcxPM4cg0hSz3xDXJPTrx6EssjgFrSL0fz
         eBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j9OnJD8AgznJr7ZxIelXFq08wCQe8qejX8gaUgGwwlg=;
        b=AfKH4X1NypEmexZwTwk0o5/aRViVQ/vtU8dWj7aYagzuuEtxv5jDDx7hrGIz9hrc97
         j+KRlQZL16Q69kFAIWjsO4BG7BTZdxvaSfNYQNrhf9IFHbyYxGGZ0CaFPKiCJy8f3bpI
         WbgKZ52QM0H6S2PAI0cASb2aPhZvZr1OW3lEDakp0t1AnDpNayDEIN/V6JU0Fnd/8Syd
         XsllEngDVEL6uTy+I6znhFCkfqcsgbs8n5KgV3Q0zWlEwIvOavaShFg6dLktygHbDSpS
         /wgJVri6ZSAa9oJiiP+iarkuUKRf4KEx0YgUbKZeBfX1k92x1QuEDO/NBAQuC3SY4goG
         9LCQ==
X-Gm-Message-State: AOAM533/ULddzcO0fbg8fLHvkOrmtCECfHysa9ZXUwTGEiVWur1ygP2T
        hLZpqsEddlECwLSn1FATz5k=
X-Google-Smtp-Source: ABdhPJyQIZA6RsoJyiLpc7L5p3ECy9f9TGXP1hW59A7kFhd4kumsuTK1bk3aFIWKq9ULYHh2qQ94JQ==
X-Received: by 2002:a17:902:e5c2:b0:161:fb68:cd28 with SMTP id u2-20020a170902e5c200b00161fb68cd28mr1924186plf.133.1653067467026;
        Fri, 20 May 2022 10:24:27 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s1-20020a170902ea0100b0015e8d4eb1c1sm29874plg.11.2022.05.20.10.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 10:24:26 -0700 (PDT)
Message-ID: <f5963ddb-01bb-6935-ecdd-0f9e7c0afda0@gmail.com>
Date:   Fri, 20 May 2022 10:24:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v5 2/2] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, bcm-kernel-feedback-list@broadcom.com,
        kernel-team@fb.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
References: <20220518223935.2312426-1-jonathan.lemon@gmail.com>
 <20220518223935.2312426-3-jonathan.lemon@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220518223935.2312426-3-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/2022 3:39 PM, Jonathan Lemon wrote:
> This adds PTP support for BCM54210E Broadcom PHYs, in particular,
> the BCM54213PE, as used in the Rasperry PI CM4.  It has only been
> tested on that hardware.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
[snip]

Looks good to me, just one question below:

> +static void bcm_ptp_init(struct bcm_ptp_private *priv)
> +{
> +	priv->nse_ctrl = NSE_GMODE_EN;
> +
> +	mutex_init(&priv->mutex);
> +	skb_queue_head_init(&priv->tx_queue);
> +
> +	priv->mii_ts.rxtstamp = bcm_ptp_rxtstamp;
> +	priv->mii_ts.txtstamp = bcm_ptp_txtstamp;
> +	priv->mii_ts.hwtstamp = bcm_ptp_hwtstamp;
> +	priv->mii_ts.ts_info = bcm_ptp_ts_info;
> +
> +	priv->phydev->mii_ts = &priv->mii_ts;
> +
> +	INIT_DELAYED_WORK(&priv->out_work, bcm_ptp_fsync_work);

Do we need to make sure that we cancel the workqueue in an 
bcm_ptp_exit() function?

I would imagine that the Ethernet MAC attached to that PHY device having 
stopped its receiver and transmitter should ensure no more packets 
coming in or out, however since this is a delayed/asynchronous work, do 
not we need to protect against use after free?
-- 
Florian
