Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F68327046D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgIRSzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRSzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:55:37 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96297C0613CE;
        Fri, 18 Sep 2020 11:55:36 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gr14so9533065ejb.1;
        Fri, 18 Sep 2020 11:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WNM04UE29uKK3wuddyaGzKe7MOJATBofLHcEB320/PU=;
        b=kYt7LzIcrvpwqmMbdRI4hVqkpGAD7KxGijYF6mTQ3/5ONN12qgv/k5ziY2mQdb+SeP
         KNPx1Y/ZVFNZmI2GTqg72XriWkAleHufZsVYNQKU7LFwNFeTh9r7QrEhoWMdbnhUL68U
         4fbU0Ok6TdApx4BqA+EcEgZnceEYdFgHPcF32rDsfai2DnCUvTWcAaPrKrGr90/uqIHx
         BGX4f8MFP4WS1LoB1WW0pUONRCPzbPcvTk2IVhYdMPt6DTpVwaz5A+DD5RslYI7dusGB
         GOFbFLZjf5ueQmvs8M/LO9yIW04SriR7hlArvhBLSJxG3ELdHuFMWlYMGKKJSubN+fDw
         1G6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WNM04UE29uKK3wuddyaGzKe7MOJATBofLHcEB320/PU=;
        b=AMPtqjHYiqJdh1ZiK1FZ2YWIm3HXd3Q1DxBst6tHFPyFjrPnffzMoHQPOnxr81MUS6
         etV+UXcQqDsy3xKc4aj8B7mvtYdzA5itk1ERDqQTb/uoS6Fhjqvlx7GwKYTEB+UxeLLP
         7E/tVX1yeaCpuFi4DinitTWslxa3LDDS0xdsEpp37KoZJ5HjjonGGlhvROyxLrDR2wFU
         9FnkgMr2u4/g+MR6iN0Qdpf9yGpBXcVmmi0ItH2NaJnLCpuI0C1PA2O2G1v1OzrxZRFK
         eBDOOznjTsFNjw90tEHEH/jsW1cDxha+Mrxv1ylyryR1vmYSYV4CSJRQIM8SYlbh8bBI
         noFg==
X-Gm-Message-State: AOAM532qlEAlUnU16WWnrCvf7O8qB/bAofxfRlwjrm+4NeDlNdOPG3r2
        4by6/NVoo/O8ya00oTCvCP4=
X-Google-Smtp-Source: ABdhPJw6Je8MyCyx1IKpKToYRbax3WHJephEh6KetCjzQlLc6TjZ+XzB332+bwWysX/YLfSGb3jebA==
X-Received: by 2002:a17:906:4d97:: with SMTP id s23mr38635830eju.157.1600455335218;
        Fri, 18 Sep 2020 11:55:35 -0700 (PDT)
Received: from debian64.daheim (p5b0d776c.dip0.t-ipconnect.de. [91.13.119.108])
        by smtp.gmail.com with ESMTPSA id e15sm2728253eds.5.2020.09.18.11.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 11:55:34 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1kJLXZ-002oKt-Oq; Fri, 18 Sep 2020 20:55:30 +0200
Subject: Re: R: [PATCH 2/2] dt: bindings: ath10k: Document qcom,
 ath10k-pre-calibration-data-mtd
To:     ansuelsmth@gmail.com, 'Kalle Valo' <kvalo@codeaurora.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org,
        "'David S. Miller'" <davem@davemloft.net>,
        'Rob Herring' <robh+dt@kernel.org>,
        'Jakub Kicinski' <kuba@kernel.org>,
        linux-mtd@lists.infradead.org,
        'Srinivas Kandagatla' <srinivas.kandagatla@linaro.org>,
        'Bartosz Golaszewski' <bgolaszewski@baylibre.com>
References: <20200918162928.14335-1-ansuelsmth@gmail.com>
 <20200918162928.14335-2-ansuelsmth@gmail.com>
 <8f886e3d-e2ee-cbf8-a676-28ebed4977aa@gmail.com>
 <000001d68de9$e7916450$b6b42cf0$@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <ea0efd8f-6dd4-8b46-caeb-d49240882cb2@gmail.com>
Date:   Fri, 18 Sep 2020 20:55:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <000001d68de9$e7916450$b6b42cf0$@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-18 20:31, ansuelsmth@gmail.com wrote:
> 
> 
>> -----Messaggio originale-----
>> Da: Christian Lamparter <chunkeey@gmail.com>
>> Inviato: venerdì 18 settembre 2020 18:54
>> A: Ansuel Smith <ansuelsmth@gmail.com>; Kalle Valo
>> <kvalo@codeaurora.org>
>> Cc: devicetree@vger.kernel.org; netdev@vger.kernel.org; linux-
>> wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
>> ath10k@lists.infradead.org; David S. Miller <davem@davemloft.net>; Rob
>> Herring <robh+dt@kernel.org>; Jakub Kicinski <kuba@kernel.org>; linux-
>> mtd@lists.infradead.org; Srinivas Kandagatla
>> <srinivas.kandagatla@linaro.org>; Bartosz Golaszewski
>> <bgolaszewski@baylibre.com>
>> Oggetto: Re: [PATCH 2/2] dt: bindings: ath10k: Document qcom, ath10k-
>> pre-calibration-data-mtd
>>
>> On 2020-09-18 18:29, Ansuel Smith wrote:
>>> Document use of qcom,ath10k-pre-calibration-data-mtd bindings used to
>>> define from where the driver will load the pre-cal data in the defined
>>> mtd partition.
>>>
>>> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
>>
>> Q: Doesn't mtd now come with nvmem support from the get go? So
>> the MAC-Addresses and pre-caldata could be specified as a
>> nvmem-node in the devicetree? I remember seeing that this was
>> worked on or was this mtd->nvmem dropped?
>>
>> Cheers,
>> Christian
> 
> Sorry a lot for the double email... I think I found what you are talking about.
> It looks like the code was merged but not the documentation.
> Will do some test and check if this works.
> 
> This should be the related patch.
> https://patchwork.ozlabs.org/project/linux-mtd/patch/1521933899-362-4-git-send-email-albeu@free.fr/
> 

Well, I guess the version that was merged:

|commit c4dfa25ab307a277eafa7067cd927fbe4d9be4ba
|Author: Alban Bedel <albeu@free.fr>
|Date:   Tue Nov 13 15:01:10 2018 +0100
|
|    mtd: add support for reading MTD devices via the nvmem API
|
|    Allow drivers that use the nvmem API to read data stored on MTD devices.
|    For this the mtd devices are registered as read-only NVMEM providers.
|
| >>>We don't support device tree systems for now.<<<

answers this. Sorry for the noise. Yee, this likely isn't going to work
as it is still disabled on purpose.

Regards,
Christian
