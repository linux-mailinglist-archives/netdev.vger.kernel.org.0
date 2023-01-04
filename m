Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B7E65DD54
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbjADT7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjADT7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:59:51 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC791C5;
        Wed,  4 Jan 2023 11:59:49 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id i17-20020a05600c355100b003d99434b1cfso17226959wmq.1;
        Wed, 04 Jan 2023 11:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s+/hKz08BYW613SwzPDOji0Uda/OZFrDaRrXnjaH9QA=;
        b=jBMrIWAvjZ5EACoeq+/3r6G3NvAOVTAjdRt0wx4sapMr3oZqyBC3+0YOjPGmWSx3QU
         Yfz+PXnxDApmC8xhK9FyCSn0zoDVZzAP4j3ENZrkC3e8yKu2l+LbMSZaLBU6HR+nlBkS
         6kxFJfkOue7RxVayfstH/UJ31NrvO2MtqNSSlNVYm2Zl1JRro5/dMzPheBjyP7R864Pq
         /1sGAwPPiNh1Yl371HGsrJcpfK6E5LtPxV+u48t5Rgox4LMXIMTamCWOKgcMNT2aKVbt
         Lz2DSxUXu0n8R215tQ8kZoVcBmhFoc+/HCXnJBR0Xl6RxLgW8KRA4pFqZFbXiWc2QWjB
         fQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s+/hKz08BYW613SwzPDOji0Uda/OZFrDaRrXnjaH9QA=;
        b=LyRxlrLqK+xIrF698uCiXeWKstfLfOnmul5GuWLQu91ose3pWvm4P+JIVwprK3ZJPJ
         VwmqZB+JUemeI6j4zNl1P0oy9+NNd6NoujDBFreVAXtvvICGJgujzjS3bW3o6TRL7aSj
         E9Zgg9ivYoI3fHwtX+EmzKBJssObk5Pa8HjjBtY2zBzIgYNy/G2elmDgf0YoSN3Eb++r
         IGPcFA/XMQuznzoJgG8MsTm/JaKlDgjL0yo3pHyVlMWj6zAwF6iVN/bobFpdSPxz60PF
         x7bbGxHcQT2JaN0N9H9NzIC9BlD6B+tkliPPc+Er6N4X2IDaNqkiOuebUuNyIZiMXw/q
         QPzg==
X-Gm-Message-State: AFqh2krq12pF7CJFeVXMi1QsfUF2ifkM8DggES4Om+ZJUDfd6XX0g5Jd
        WkelEGCJQZY/TJC1qyAYPEk=
X-Google-Smtp-Source: AMrXdXt+1KnGVZk9G4+sTWDpqpUHC/UWvKj30a4r7Vg7IB1LT/jgkVarK5m6YHIRZeukXX4BAvftKA==
X-Received: by 2002:a05:600c:5399:b0:3d9:c6f5:c643 with SMTP id hg25-20020a05600c539900b003d9c6f5c643mr3691505wmb.29.1672862388314;
        Wed, 04 Jan 2023 11:59:48 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.114])
        by smtp.gmail.com with ESMTPSA id p12-20020a05600c468c00b003cf5ec79bf9sm46787543wmo.40.2023.01.04.11.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 11:59:47 -0800 (PST)
Message-ID: <0acf173d-a425-dcca-ad2f-f0f0f13a9f5e@gmail.com>
Date:   Wed, 4 Jan 2023 21:59:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based
 RTL8821CS chipset
To:     Chris Morgan <macroalpha82@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
 <63b4b3e1.050a0220.791fb.767c@mx.google.com>
Content-Language: en-US
In-Reply-To: <63b4b3e1.050a0220.791fb.767c@mx.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/01/2023 01:01, Chris Morgan wrote:
> On Wed, Dec 28, 2022 at 12:30:20AM +0100, Martin Blumenstingl wrote:
>> Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
>> well as the existing RTL8821C chipset code.
>>
> 
> Unfortunately, this doesn't work for me. I applied it on top of 6.2-rc2
> master and I get errors during probe (it appears the firmware never
> loads).
> 
> Relevant dmesg logs are as follows:
> 
> [    0.989545] mmc2: new high speed SDIO card at address 0001
> [    0.989993] rtw_8821cs mmc2:0001:1: Firmware version 24.8.0, H2C version 12
> [    1.005684] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x14): -110
> [    1.005737] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1080): -110
> [    1.005789] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x11080): -110
> [    1.005840] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x3): -110
> [    1.005920] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x1103): -110
> [    1.005998] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x80): -110
> [    1.006078] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1700): -110
> 
> The error of "sdio read32 failed (0x1700): -110" then repeats several
> hundred times, then I get this:
> 
> [    1.066294] rtw_8821cs mmc2:0001:1: failed to download firmware
> [    1.066367] rtw_8821cs mmc2:0001:1: sdio read16 failed (0x80): -110
> [    1.066417] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x100): -110
> [    1.066697] rtw_8821cs mmc2:0001:1: failed to setup chip efuse info
> [    1.066703] rtw_8821cs mmc2:0001:1: failed to setup chip information
> [    1.066839] rtw_8821cs: probe of mmc2:0001:1 failed with error -16
> 
> The hardware I am using is an rtl8821cs that I can confirm was working
> with a previous driver.
> 
> Thank you.
> 
The USB-based RTL8811CU also doesn't work, with suspiciously similar
errors:

Dec 25 21:43:37 home kernel: rtw_8821cu 1-2:1.0: Firmware version 24.11.0, H2C version 12
Dec 25 21:43:37 home kernel: rtw_8821cu 1-2:1.0 wlp0s20f0u2: renamed from wlan0
Dec 25 21:43:40 home kernel: rtw_8821cu 1-2:1.0: read register 0x5 failed with -110
Dec 25 21:43:41 home kernel: rtw_8821cu 1-2:1.0: read register 0x20 failed with -110
Dec 25 21:44:11 home kernel: rtw_8821cu 1-2:1.0: write register 0x20 failed with -110
Dec 25 21:44:12 home kernel: rtw_8821cu 1-2:1.0: read register 0x7c failed with -110
Dec 25 21:44:43 home kernel: rtw_8821cu 1-2:1.0: write register 0x7c failed with -110
Dec 25 21:44:44 home kernel: rtw_8821cu 1-2:1.0: read register 0x1080 failed with -110
Dec 25 21:45:16 home kernel: rtw_8821cu 1-2:1.0: write register 0x1080 failed with -110


Dec 25 21:46:47 home kernel: rtw_8821cu 1-3:1.0: Firmware version 24.11.0, H2C version 12
Dec 25 21:46:47 home kernel: rtw_8821cu 1-3:1.0 wlp0s20f0u3: renamed from wlan0
Dec 25 21:46:55 home kernel: rtw_8821cu 1-3:1.0: failed to poll offset=0x5 mask=0x1 value=0x0
Dec 25 21:46:55 home kernel: rtw_8821cu 1-3:1.0: mac power on failed
Dec 25 21:46:55 home kernel: rtw_8821cu 1-3:1.0: failed to power on mac

I tested with https://github.com/lwfinger/rtw88/ which should have the
same code as wireless-next currently.
