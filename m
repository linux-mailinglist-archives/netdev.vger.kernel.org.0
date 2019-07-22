Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850E36FB68
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 10:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbfGVIg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 04:36:58 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45527 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbfGVIg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 04:36:57 -0400
Received: by mail-pf1-f195.google.com with SMTP id r1so17024113pfq.12;
        Mon, 22 Jul 2019 01:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j6w1h6MOwLx1qltjlCykcB2n5pu6k9XFgBYb35I9b94=;
        b=IGFPYI95Yb/GP16xfTIPeMHOM4JZYhsIMYXmvzlUFQvJnz8C2K2+EZLuYeSUXn3mh8
         DnJ27UJRGlz9Wyi1P/MH7Qo72mdobaeMo9ZMOeg2dtwt0Aqt6WEe962Cx6bVt4rSkYZY
         GmUbpGREiGiEZzhpOsCQnOCdxsqifZ/L6Nhldq9GuFCCDGOExgLtfzJseBGlWHyzkrxH
         uZSQkqZozxEuT8aLxtVjcCEl8p13FwH/Ts2OKFHaKXakk8Oq4oywxPiND4DhYGSpTjVC
         hSSNUSBKr1bmbMoKUiZ1pl78Z/MoXGBxLnaDhHVg+c39xcL00UpBW8hwevZiR2kBawGB
         WEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j6w1h6MOwLx1qltjlCykcB2n5pu6k9XFgBYb35I9b94=;
        b=E/az6RSSyFS48IUhjgeJoGkg5AMjObZFWtSLHVRaoN97+wfeK3aCqom1tc18tul8qU
         hSoBZXs3Nheen4x5ODl0z15UQua/8iZPfSmZjRMdjMonAfrGBLePEN9pIJUAz5n+C6pi
         Tbm2Ets+76c5nxNKSGpChW4medlVbqvYLquBn6m/19meBNyP+/QiKWNtuH01rz2XZ4jk
         q/sxyLj4ntEwF0atU57ODpppvTTwObDENlVcgjgTznqKaSWtyyKAgcQz3Qk2AsdvXwOA
         Rc2iZNyycEdTy6BolULmeHZZo1nNy6D6ii1OzHNFHfiNTfCkYx1JhxxR5V57CjsRnBD2
         dapw==
X-Gm-Message-State: APjAAAW/RgHcgDFxNWRG6swmfntb/DLIWwGyPYLxt0CCOm+jSw/4pObX
        WpZRxCG6eC68fP4x5NQpEtr7GL8f
X-Google-Smtp-Source: APXvYqxE9h+fM7hcGw7JD2QwWIjJ8hmgwvIvIoFYZ/ar+5y04cBEhjutBjzwJdZVdcq4Aspr0xQZRA==
X-Received: by 2002:a63:e901:: with SMTP id i1mr54098401pgh.451.1563784616653;
        Mon, 22 Jul 2019 01:36:56 -0700 (PDT)
Received: from [192.168.1.38] (59-120-186-245.HINET-IP.hinet.net. [59.120.186.245])
        by smtp.gmail.com with ESMTPSA id a3sm33784096pfl.145.2019.07.22.01.36.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 01:36:56 -0700 (PDT)
Subject: Re: [PATCH V2 1/1] can: sja1000: f81601: add Fintek F81601 support
To:     Marc Kleine-Budde <mkl@pengutronix.de>, wg@grandegger.com,
        peter_hong@fintek.com.tw
Cc:     davem@davemloft.net, f.suligoi@asem.it,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>
References: <1563776521-28317-1-git-send-email-hpeter+linux_kernel@gmail.com>
 <563b0d71-3c60-d32c-cf19-73611f68d45a@pengutronix.de>
From:   "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>
Message-ID: <b7c9026a-a887-bc84-3297-c319d18686c3@gmail.com>
Date:   Mon, 22 Jul 2019 16:36:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <563b0d71-3c60-d32c-cf19-73611f68d45a@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

Marc Kleine-Budde 於 2019/7/22 下午 04:15 寫道:
> On 7/22/19 8:22 AM, Ji-Ze Hong (Peter Hong) wrote: >> +/* Probe F81601 based device for the SJA1000 chips and register each
>> + * available CAN channel to SJA1000 Socket-CAN subsystem.
>> + */
>> +static int f81601_pci_add_card(struct pci_dev *pdev,
>> +			       const struct pci_device_id *ent)
>> +{
>> +	struct sja1000_priv *priv;
>> +	struct net_device *dev;
>> +	struct f81601_pci_card *card;
>> +	int err, i, count;
>> +	u8 tmp;
>> +
>> +	if (pcim_enable_device(pdev) < 0) {
> 
> I'm missing a corresponding disable_device().
> 
I'm using managed pcim_enable_device(), Does it need call
pci_disable_device() ??

Thanks
-- 
With Best Regards,
Peter Hong
