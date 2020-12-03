Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237C52CE03C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387446AbgLCU4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgLCU4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:56:55 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D635C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 12:56:09 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id p8so3273320wrx.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 12:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=quJoSkrf9r+uBGgZk5HzBcJLLWJ7Nef137ioRwykshg=;
        b=OQzYhcSPgEKO4m/g6nmIRJBFWsQowA6Qbq1jhBfDyAa6B29dr8iz1o1W6wThSKR/91
         sfnBlYkxbH7ewedap0WLqAWptPgeHUKId5N7UEKUKFvjFmHpK1QZqoIE1sPHECoHq0qj
         my/D+cuynaq/eAARDJJP3dwRiczxOe/xEGy/oL18eYuykX+TkRIOsURK3mTKfQO7cjR2
         l1kZew9wjTCI3bPwcV9no+2ho9+ROyL5rynI09ypjPzlxifzzhprXO/i8lkm6fvkm2bO
         FxBycypt02G6dsZyaFDtlBZDpEdl5cMD/jbMYIIjG3jWE2cbawrqksMUCyooT5sAW1a+
         ZdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=quJoSkrf9r+uBGgZk5HzBcJLLWJ7Nef137ioRwykshg=;
        b=Gd5hv6/7rfygfGFqjm+n1p/v3HHW+bQI70bZyjt/wDsNv6zplnpT0xP+eyld1Na6sv
         plTl7axn0DC2hjUw9sK86cxpYQVH9PAP/DQb5+U8MyWaChCKCa7d25UCPn6tMw8E7I4f
         ZWGDLhhaAtber2ooCo72q4+v5elabPbqtTvCTmXXgcvxHE14gxTkDmhjHStIIhQJhe7X
         XgUzquUO9zEvI8Gk+Su4V1DIGgoMuXeK7/ttO5R9mb18KQuUjT/UzZJTK1FC/qUIq41+
         lPnL0BUvF7Qeid5K7VlAwq/AuPm3xRf0zx2dg2/X6egkT9zQo4jH2Im9NmosQiZw4/r+
         6sZg==
X-Gm-Message-State: AOAM532/vdXnIas10TTsQr3bn9gVf8PchLMqvmrb7/P0+J+KMK00LFvY
        dXPB5N6xyXCYYkRyE6IBi7I=
X-Google-Smtp-Source: ABdhPJxSPGHZ2uq0xgyLCA3JoM9qV9g2BsSMVkAywqou8GP909ztWXWJmJAiekVBJRREP1Y+EMvYHA==
X-Received: by 2002:adf:a3d1:: with SMTP id m17mr1093723wrb.289.1607028967593;
        Thu, 03 Dec 2020 12:56:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2f:8a00:10c1:68a8:fe25:16bd? (p200300ea8f2f8a0010c168a8fe2516bd.dip0.t-ipconnect.de. [2003:ea:8f2f:8a00:10c1:68a8:fe25:16bd])
        by smtp.googlemail.com with ESMTPSA id i16sm767253wru.92.2020.12.03.12.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 12:56:06 -0800 (PST)
Subject: Re: [PATCH V3 net-next 1/9] net: ena: use constant value for
 net_device allocation
To:     "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
References: <1606939410-26718-1-git-send-email-akiyano@amazon.com>
 <1606939410-26718-2-git-send-email-akiyano@amazon.com>
 <10a1c719-1408-5305-38fd-254213f8a42b@gmail.com>
 <fa4653d9d4d54f9d8ffc982fb809b618@EX13D22EUA004.ant.amazon.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8297c879-49d3-9c38-6b74-aa9118ddfdee@gmail.com>
Date:   Thu, 3 Dec 2020 21:56:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <fa4653d9d4d54f9d8ffc982fb809b618@EX13D22EUA004.ant.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 03.12.2020 um 15:38 schrieb Kiyanovski, Arthur:
> 
> 
>> -----Original Message-----
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Sent: Wednesday, December 2, 2020 11:55 PM
>> To: Kiyanovski, Arthur <akiyano@amazon.com>; kuba@kernel.org;
>> netdev@vger.kernel.org
>> Cc: Woodhouse, David <dwmw@amazon.co.uk>; Machulsky, Zorik
>> <zorik@amazon.com>; Matushevsky, Alexander <matua@amazon.com>;
>> Bshara, Saeed <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>;
>> Liguori, Anthony <aliguori@amazon.com>; Bshara, Nafea
>> <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>; Belgazal,
>> Netanel <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>;
>> Herrenschmidt, Benjamin <benh@amazon.com>; Dagan, Noam
>> <ndagan@amazon.com>; Agroskin, Shay <shayagr@amazon.com>; Jubran,
>> Samih <sameehj@amazon.com>
>> Subject: RE: [EXTERNAL] [PATCH V3 net-next 1/9] net: ena: use constant
>> value for net_device allocation
>>
>> CAUTION: This email originated from outside of the organization. Do not click
>> links or open attachments unless you can confirm the sender and know the
>> content is safe.
>>
>>
>>
>> Am 02.12.2020 um 21:03 schrieb akiyano@amazon.com:
>>> From: Arthur Kiyanovski <akiyano@amazon.com>
>>>
>>> The patch changes the maximum number of RX/TX queues it advertises to
>>> the kernel (via alloc_etherdev_mq()) from a value received from the
>>> device to a constant value which is the minimum between 128 and the
>>> number of CPUs in the system.
>>>
>>> By allocating the net_device struct with a constant number of queues,
>>> the driver is able to allocate it at a much earlier stage, before
>>> calling any ena_com functions. This would allow to make all log prints
>>> in ena_com to use netdev_* log functions instead or current pr_* ones.
>>>
>>
>> Did you test this? Usually using netdev_* before the net_device is registered
>> results in quite ugly messages. Therefore there's a number of patches doing
>> the opposite, replacing netdev_* with dev_* before register_netdev(). See
>> e.g.
>> 22148df0d0bd ("r8169: don't use netif_info et al before net_device has been
>> registered")
> 
> Thanks for your comment.
> Yes we did test it.
> Please see the discussion which led to this patch in a previous thread here:
> https://www.mail-archive.com/netdev@vger.kernel.org/msg353590.html
>  

Ah, I see. After reading the mail thread your motivation is clear.
You accept ugly messages when ena_com functions are called from probe()
for the sake of better messages when the same ena_com functions are
called later from other parts of the driver. Maybe an explanation of
this tradeoff would have been good in the commit message (or a link
to the mail thread).

>>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>>> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>>> ---
>>>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 46
>>> ++++++++++----------
>>>  1 file changed, 23 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>> index df1884d57d1a..985dea1870b5 100644
>>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>> @@ -29,6 +29,8 @@ MODULE_LICENSE("GPL");
>>>  /* Time in jiffies before concluding the transmitter is hung. */
>>> #define TX_TIMEOUT  (5 * HZ)
>>>
>>> +#define ENA_MAX_RINGS min_t(unsigned int,
>> ENA_MAX_NUM_IO_QUEUES,
>>> +num_possible_cpus())
>>> +
>>>  #define ENA_NAPI_BUDGET 64
>>>
>>>  #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE
>> |
>>> NETIF_MSG_IFUP | \ @@ -4176,18 +4178,34 @@ static int
>> ena_probe(struct
>>> pci_dev *pdev, const struct pci_device_id *ent)
>>>
>>>       ena_dev->dmadev = &pdev->dev;
>>>
>>> +     netdev = alloc_etherdev_mq(sizeof(struct ena_adapter),
>> ENA_MAX_RINGS);
>>> +     if (!netdev) {
>>> +             dev_err(&pdev->dev, "alloc_etherdev_mq failed\n");
>>> +             rc = -ENOMEM;
>>> +             goto err_free_region;
>>> +     }
>>> +
>>> +     SET_NETDEV_DEV(netdev, &pdev->dev);
>>> +     adapter = netdev_priv(netdev);
>>> +     adapter->ena_dev = ena_dev;
>>> +     adapter->netdev = netdev;
>>> +     adapter->pdev = pdev;
>>> +     adapter->msg_enable = netif_msg_init(debug,
>> DEFAULT_MSG_ENABLE);
>>> +
>>> +     pci_set_drvdata(pdev, adapter);
>>> +
>>>       rc = ena_device_init(ena_dev, pdev, &get_feat_ctx, &wd_state);
>>>       if (rc) {
>>>               dev_err(&pdev->dev, "ENA device init failed\n");
>>>               if (rc == -ETIME)
>>>                       rc = -EPROBE_DEFER;
>>> -             goto err_free_region;
>>> +             goto err_netdev_destroy;
>>>       }
>>>
>>>       rc = ena_map_llq_mem_bar(pdev, ena_dev, bars);
>>>       if (rc) {
>>>               dev_err(&pdev->dev, "ENA llq bar mapping failed\n");
>>> -             goto err_free_ena_dev;
>>> +             goto err_device_destroy;
>>>       }
>>>
>>>       calc_queue_ctx.ena_dev = ena_dev; @@ -4207,26 +4225,8 @@ static
>>> int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>               goto err_device_destroy;
>>>       }
>>>
>>> -     /* dev zeroed in init_etherdev */
>>> -     netdev = alloc_etherdev_mq(sizeof(struct ena_adapter),
>> max_num_io_queues);
>>> -     if (!netdev) {
>>> -             dev_err(&pdev->dev, "alloc_etherdev_mq failed\n");
>>> -             rc = -ENOMEM;
>>> -             goto err_device_destroy;
>>> -     }
>>> -
>>> -     SET_NETDEV_DEV(netdev, &pdev->dev);
>>> -
>>> -     adapter = netdev_priv(netdev);
>>> -     pci_set_drvdata(pdev, adapter);
>>> -
>>> -     adapter->ena_dev = ena_dev;
>>> -     adapter->netdev = netdev;
>>> -     adapter->pdev = pdev;
>>> -
>>>       ena_set_conf_feat_params(adapter, &get_feat_ctx);
>>>
>>> -     adapter->msg_enable = netif_msg_init(debug,
>> DEFAULT_MSG_ENABLE);
>>>       adapter->reset_reason = ENA_REGS_RESET_NORMAL;
>>>
>>>       adapter->requested_tx_ring_size = calc_queue_ctx.tx_queue_size;
>>> @@ -4257,7 +4257,7 @@ static int ena_probe(struct pci_dev *pdev, const
>> struct pci_device_id *ent)
>>>       if (rc) {
>>>               dev_err(&pdev->dev,
>>>                       "Failed to query interrupt moderation feature\n");
>>> -             goto err_netdev_destroy;
>>> +             goto err_device_destroy;
>>>       }
>>>       ena_init_io_rings(adapter,
>>>                         0,
>>> @@ -4335,11 +4335,11 @@ static int ena_probe(struct pci_dev *pdev,
>> const struct pci_device_id *ent)
>>>       ena_disable_msix(adapter);
>>>  err_worker_destroy:
>>>       del_timer(&adapter->timer_service);
>>> -err_netdev_destroy:
>>> -     free_netdev(netdev);
>>>  err_device_destroy:
>>>       ena_com_delete_host_info(ena_dev);
>>>       ena_com_admin_destroy(ena_dev);
>>> +err_netdev_destroy:
>>> +     free_netdev(netdev);
>>>  err_free_region:
>>>       ena_release_bars(ena_dev, pdev);
>>>  err_free_ena_dev:
>>>
> 

