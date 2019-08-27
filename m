Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF859EBE8
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 17:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbfH0PIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 11:08:37 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43380 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfH0PIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 11:08:37 -0400
Received: by mail-ot1-f65.google.com with SMTP id e12so18969470otp.10;
        Tue, 27 Aug 2019 08:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Rywry/EHGhMrNPdqvNtIfK/gHo0RAsE7TRS/X80Y4s4=;
        b=VkEpZvJb0gmx+7uEdng+y2kJ9ScaXxfV8P2tzCCurLOrBzXS8D3C5dwSTu0EVe69ZS
         krPbXIwB3sKs2qjJ4p8AFOdoUmzHIn2CBszY11Cvlv472+CJSiqox1kGs8N7mlIdt+vf
         +tFoaRD6B9Cm+NJ1Fg7+XLSJXpJRt9K9KWjM6qWr4zgk2WVIrZzYEWkeCXwHdlWqb71M
         H5AKajXXVriEPiYfJat9EC1SPVjxfDbC4Sfqc2Y8xqrkm971/31ePysWUhk3C4KWpGzY
         hhNWwdNgjEInlPPf4V68rffEVlRk/fOvgsKBDPURlj3Tna4PteRmh0O8RUFTDQ0A/EFG
         7mqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rywry/EHGhMrNPdqvNtIfK/gHo0RAsE7TRS/X80Y4s4=;
        b=G0lOED8suTaVodAD/sP9O9P+zdmtKSctUOpbxAdU3w2sXwYh1bHfSi1ZN8toC4rdZD
         hyFTeehi2qbbDXBYw8Xa2sRsVAyO+J6vQmZXPAGXPkNa31RyWDkn8aZ1lhDKYH59g4i8
         mQqrMGhzLT0qcH4iUvgP3sc5y7CcHBSx9K5U8E/Zd/UHZpAaLFUhXwWKxGahbhGLuPoe
         MQwduRIrXYYfDnntDM/zFP1v7SZ1aIWovzTLBw7Lw4fVVYZHieNy2ZQT5k7craVvvGBF
         wvD01kChXYvkswoT/B+0UDOQgdri8ONx3f+JlK2ZM9aW2SVV4J9V1wd5Oa+GbU8YmtCH
         ObVQ==
X-Gm-Message-State: APjAAAVvhFJ+aWCbzzzxL/NEC4tJ8C8N6J3Ci+cmgJNSEjNAktMxcTgv
        oBkRM07i1EiEmA65mwIUe1E=
X-Google-Smtp-Source: APXvYqwwpfSNQV0d79ewTSzoXmpjC+BUdGsqjBOlWIoOpw5l5bLSC7WYnAWjzKmutUoji/llHQz9DQ==
X-Received: by 2002:a9d:77cc:: with SMTP id w12mr13034784otl.207.1566918516092;
        Tue, 27 Aug 2019 08:08:36 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 20sm5690300otd.71.2019.08.27.08.08.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 08:08:35 -0700 (PDT)
Subject: Re: [PATCH v1 net-next 4/4] net: stmmac: setup higher frequency clk
 support for EHL & TGL
To:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
References: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
 <1566869891-29239-5-git-send-email-weifeng.voon@intel.com>
 <7d43e0c6-6f51-0d71-0af8-89f22b0234f9@gmail.com>
 <20190826201346.GJ2168@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC814758DB5@PGSMSX103.gar.corp.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <7da534fa-9b7e-9980-e801-3c3e0429b885@gmail.com>
Date:   Tue, 27 Aug 2019 08:08:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC814758DB5@PGSMSX103.gar.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/2019 3:38 AM, Voon, Weifeng wrote:
>>>> +#include <linux/clk-provider.h>
>>>>  #include <linux/pci.h>
>>>>  #include <linux/dmi.h>
>>>>
>>>> @@ -174,6 +175,19 @@ static int intel_mgbe_common_data(struct
>> pci_dev *pdev,
>>>>  	plat->axi->axi_blen[1] = 8;
>>>>  	plat->axi->axi_blen[2] = 16;
>>>>
>>>> +	plat->ptp_max_adj = plat->clk_ptp_rate;
>>>> +
>>>> +	/* Set system clock */
>>>> +	plat->stmmac_clk = clk_register_fixed_rate(&pdev->dev,
>>>> +						   "stmmac-clk", NULL, 0,
>>>> +						   plat->clk_ptp_rate);
>>>> +
>>>> +	if (IS_ERR(plat->stmmac_clk)) {
>>>> +		dev_warn(&pdev->dev, "Fail to register stmmac-clk\n");
>>>> +		plat->stmmac_clk = NULL;
>>>
>>> Don't you need to propagate at least EPROBE_DEFER here?
>>
>> Hi Florian
>>
>> Isn't a fixed rate clock a complete fake. There is no hardware behind it.
>> So can it return EPROBE_DEFER?
>>
>>     Andrew
> 
> Yes, there is no hardware behind it. So, I don't think we need to deferred probe
> and a warning message should be sufficient. Anyhow, please point it out if I miss
> out anything.

Looks good to me, thanks both for clarifying.
-- 
Florian
