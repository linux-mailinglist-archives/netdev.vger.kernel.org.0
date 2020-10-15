Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA2028F8F7
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391218AbgJOS4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391214AbgJOS4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 14:56:24 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AA5C0613D2
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 11:56:24 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b8so4958344wrn.0
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 11:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cXs4hUYRVclH6j8zAxy6/2zdQDBAGWMQY89L0oKolHs=;
        b=GVKEmx4waEu53LT/RjrdnVs9/lKN9cUyIgLbW6XOpU+OQJF5orIGMpHNv0d4C5J8Re
         jExLGW95Q2pNyg5MeKIj2DlAi9fN5gipCaz3UeJa7L+r4fz42jkrufjmZldJ3SfT2kqg
         oPnbU37tsOT1an8sqnliLW4PlniR41eIYPSw3BW8mPDZlpxWRie/dw24LvGE3dh6NnVr
         Qnp9jWJ5mNAUJ6X/KcHghuLJp7jVSsTEhkMqDG9y715Yk1JckWCy5fogg5iHdhkyJHHv
         gvh+qg9Ia3vmRFjzLFuYdersFjrE3rv36DrR/QPHuOGk5G+8aOd0v5JPutzrkEKxZVQN
         hk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cXs4hUYRVclH6j8zAxy6/2zdQDBAGWMQY89L0oKolHs=;
        b=QbCPBC515xFi2Gmb/EYKoq4coPHWTlJC4yj+95jRUSzDKfcIWjTAowB51MqkQWF19g
         n5bmpi5WmbDlX+SewAsXi6YpDir7/6NJZkgxJJ28MBTpXLqVQQbSEjiHCE81z21vmm1m
         7cOVBaIrKO9ADdnZ6vkukcy5ZQHYHjObubCHW7Bhfa3JW1Ws8Tmhvy9yegfFp96auCTE
         8oStl1+kSsB/n4ZCn1R7NAKeV1mgp+xncG6kQYLsXjb2jps0uANKthwyvs6uo/FVDvPi
         xPvFj33mp/WU6Qcw3btwUkHYD09BKz5Vyzv7Algo+0JsbUxzisay9DMeCLKSI6mW0tBf
         x9TQ==
X-Gm-Message-State: AOAM53318d0bHi9sNy3tSBhO+OYjBDibq+pDhF51ztlKK0l3ossL2Q+x
        pyHO2LKmodqBL+USU6XSPjg=
X-Google-Smtp-Source: ABdhPJw908lnK494837NkqaMLHeSf0DLEsv2vaKCS0Uo+QbNnzgR5vT+3Fniy8cJqX0wvVVcGB46bQ==
X-Received: by 2002:a5d:5482:: with SMTP id h2mr5821042wrv.165.1602788182875;
        Thu, 15 Oct 2020 11:56:22 -0700 (PDT)
Received: from [192.168.8.147] ([37.165.69.53])
        by smtp.gmail.com with ESMTPSA id 24sm251793wmg.8.2020.10.15.11.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 11:56:22 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] net: Add mhi-net driver
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
References: <1602757888-3507-1-git-send-email-loic.poulain@linaro.org>
 <ec2a1d76-d51f-7ec5-e2c1-5ed0eaf9a537@gmail.com>
 <CAMZdPi93Ma4dGMNr_2JHqYJqDE6VSx6vEpRR3_Y2wbpT1QAvTA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <62605ecb-3974-38a9-1f64-b08df6a72663@gmail.com>
Date:   Thu, 15 Oct 2020 20:56:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMZdPi93Ma4dGMNr_2JHqYJqDE6VSx6vEpRR3_Y2wbpT1QAvTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/15/20 3:29 PM, Loic Poulain wrote:
> On Thu, 15 Oct 2020 at 14:41, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 10/15/20 12:31 PM, Loic Poulain wrote:
>>> This patch adds a new network driver implementing MHI transport for
>>> network packets. Packets can be in any format, though QMAP (rmnet)
>>> is the usual protocol (flow control + PDN mux).
>>>
>>> It support two MHI devices, IP_HW0 which is, the path to the IPA
>>> (IP accelerator) on qcom modem, And IP_SW0 which is the software
>>> driven IP path (to modem CPU).
>>>
>>>
>>> +static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
>>> +{
>>> +     struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
>>> +     struct mhi_device *mdev = mhi_netdev->mdev;
>>> +     int err;
>>> +
>>> +     skb_tx_timestamp(skb);
>>> +
>>> +     /* mhi_queue_skb is not thread-safe, but xmit is serialized by the
>>> +      * network core. Once MHI core will be thread save, migrate to
>>> +      * NETIF_F_LLTX support.
>>> +      */
>>> +     err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
>>> +     if (err == -ENOMEM) {
>>> +             netif_stop_queue(ndev);
>>
>> If you return NETDEV_TX_BUSY, this means this skb will be requeues,
>> then sent again right away, and this will potentially loop forever.
> 
> The TX queue is stopped in that case, so the net core will not loop, right?

-ENOMEM suggests a memory allocation failed.

What is going to restart the queue when memory is available ?

-ENOMEM seems weird if used for queue being full.

> 
>>
>> Also skb_tx_timestamp() would be called multiple times.
> 
> OK so I'm going to remove that, maybe the MHI layer should mark
> timestamp instead.

Yes, probably.

