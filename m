Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E03355F4C3
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiF2EAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiF2EAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:00:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299993193B;
        Tue, 28 Jun 2022 21:00:11 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w19-20020a17090a8a1300b001ec79064d8dso18026498pjn.2;
        Tue, 28 Jun 2022 21:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=k7DngibUnT+ItaNOgowcLkkewFPcMFOrPMA2cD6INTw=;
        b=MUc5knluDO9nLpuqEDeF91dvitB/m2ZFo9RUzw52yszxX1R9gCFgs1SMwjb0KVeoXv
         bd9gbtoD0QqZZj7aPL3lp/EJXmo5jXIyqiBb7jwE6EylL9Ar6WxgQFlTWJdvE0WdznOp
         kzGq+dOQETlJyjWiErZ+5xdl5izjt5cvHsRUKs9nm6qKh5t98PpNSkGQiQNp211O555c
         bSVoHDBc8BkBJVUdj14/+i/h1C5CtGs6PmThhQgiWMY0XXjXVL2MtwMTLUnPMmQtDTWQ
         hnKY3wTmH1LJq7D0fV4ukOE7CHOPa8IdIMA/k3i3PtDL6AlTM3QyQ1+x6WR5dmVS/MS8
         l4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=k7DngibUnT+ItaNOgowcLkkewFPcMFOrPMA2cD6INTw=;
        b=kdyrwgqlHROizFiu6+tVdo2UL2jp+/evwXBXfShZbF2WacP0QFAHsnN4jEZHfsvLp6
         NgQ9rOG/yXZrSRCyO/WTarN6FSi7ARS1lZu2VBNkskgHprYrecTt1WoWSPzIXFP7ZArm
         ctLKMmqVAktjOqzgkF4UZabLfxIugfV3gZ6xBTQaO915t0nkaP778QAF1eHSL1E3KkDI
         N2iqI1LYlCmw9A265hs+M4U4QTdOc5sbyaVECkPjNrDoPGcVs0e0Q1LosVpiiyPYCS4m
         iov0lNJ3reM7ePXsFDqi4YIoeevR85blfPqOfvSbdngD/k6oiEWUsCHznlKUfNIa3Pe0
         iBQQ==
X-Gm-Message-State: AJIora/1c26lVEetSHvXGMIaLXp2ZT8YHEgwR/vufg/Z7WzcgkUOdl1R
        eFHVwNp0Qcpv2Wql8TXcRBw=
X-Google-Smtp-Source: AGRyM1vGPFqOHcf5q4Ku3swiOuWMjQNzbUmYnUzh8IgDNQQEvWGFFpxL+yylnXbFSlH9sA1Ox/jGBA==
X-Received: by 2002:a17:902:ccc4:b0:156:5d37:b42f with SMTP id z4-20020a170902ccc400b001565d37b42fmr7027326ple.157.1656475210689;
        Tue, 28 Jun 2022 21:00:10 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-13.three.co.id. [180.214.232.13])
        by smtp.gmail.com with ESMTPSA id ca27-20020a056a00419b00b00525133f98adsm10456763pfb.146.2022.06.28.21.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 21:00:09 -0700 (PDT)
Message-ID: <9f2760f9-5778-b600-0709-a354062c677d@gmail.com>
Date:   Wed, 29 Jun 2022 11:00:04 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.10 1/3] commit 5d6651fe8583 ("rtw88: 8821c: support RFE
 type2 wifi NIC")
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Meng Tang <tangmeng@uniontech.com>
Cc:     stable@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo-Feng Fan <vincent_fann@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
References: <20220628133046.2474-1-tangmeng@uniontech.com>
 <YrsSJLqq/ZoKw8MP@kroah.com> <YrsSNGN6fDMtGufl@kroah.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <YrsSNGN6fDMtGufl@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/22 21:37, Greg KH wrote:
> On Tue, Jun 28, 2022 at 04:37:24PM +0200, Greg KH wrote:
>> On Tue, Jun 28, 2022 at 09:30:44PM +0800, Meng Tang wrote:
>>> From: Guo-Feng Fan <vincent_fann@realtek.com>
>>>
>>> RFE type2 is a new NIC which has one RF antenna shares with BT.
>>> Update phy parameter to verstion V57 to allow initial procedure
>>> to load extra AGC table for sharing antenna NIC.
>>>
>>> Signed-off-by: Guo-Feng Fan <vincent_fann@realtek.com>
>>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>>> Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>> Link: https://lore.kernel.org/r/20210202055012.8296-4-pkshih@realtek.com
>>> Signed-off-by: Meng Tang <tangmeng@uniontech.com>
>>> ---
>>>  drivers/net/wireless/realtek/rtw88/main.c     |   2 +
>>>  drivers/net/wireless/realtek/rtw88/main.h     |   7 +
>>>  drivers/net/wireless/realtek/rtw88/rtw8821c.c |  47 +++
>>>  drivers/net/wireless/realtek/rtw88/rtw8821c.h |  14 +
>>>  .../wireless/realtek/rtw88/rtw8821c_table.c   | 397 ++++++++++++++++++
>>>  .../wireless/realtek/rtw88/rtw8821c_table.h   |   1 +
>>>  6 files changed, 468 insertions(+)
>>>
>>
>> <formletter>
>>
>> This is not the correct way to submit patches for inclusion in the
>> stable kernel tree.  Please read:
>>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>> for how to do this properly.
>>
>> </formletter>
> 
> Sorry, no, this is all good, my fault.

Hi Greg,

The problem here is patch title. If this is indeed a backport, the patch
title should be same as in the mainline. Also, mainline (upstream)
commit should be noted in the backport.

-- 
An old man doll... just what I always wanted! - Clara
