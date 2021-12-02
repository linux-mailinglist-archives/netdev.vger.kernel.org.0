Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAC84661A7
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 11:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354657AbhLBKsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 05:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbhLBKso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 05:48:44 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FA2C06174A;
        Thu,  2 Dec 2021 02:45:21 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id a18so58773644wrn.6;
        Thu, 02 Dec 2021 02:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1MGEQnBIQ3vbOTLy3XTiJ0Tx24PECqKkLHXiDfXBULI=;
        b=HDWJGGkPx/ABcvM2OSRshHQ9Kyk2ejcXoUKfiA9pmPPhTJP/dUDhWff/STpZqhQrkE
         Z9xvdiOKGHgTQoq7l42pKSUvUkZvy0vjr6QhusrKwIsI6zcg26kRPwCknA8MQgiQ6aml
         WpvMalRn6N/FjBSW9eok+MPzzn+qb5LqAxzBt8rXPshy/uOSpw6PVStgZgNWwrjS7DEG
         FdxZhyXRFX9CFHJ2VNKDRZJIlyeoezxRyDtyjzRTRlucji6iqc/ckxpk7xzw3o2cXtTA
         6hys4j8hD0Txo63mP/AOP+rIpF6dvi2USVQmoik7EP0JIveqZ6T6/m68SyCDO25qCNXa
         lD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1MGEQnBIQ3vbOTLy3XTiJ0Tx24PECqKkLHXiDfXBULI=;
        b=UcoROsOMofP2M0EZO9ATpzi+1FuEJ4eb7vu+s9diiqppSWzv6JHyaXdPiwF1Atvu25
         KSxuRTn1NnSIa8XDzGBkPIVgcBR+29rUOt66kxJptkeMBZmObVMV09V59vTOYI+Z4TUz
         f0dLYwe1ok5rmqBY1CZsc4+UBd7KbaTZQhJHwpXHDyJZiHNYHOVxx5YQkRXm3Jv3vIeJ
         tRSDbn+82GFa3wwzxrTCk8q4v7PCcYuiY0/7TUyHmitBJzS+HEXoiUYv/PKcTa/DhUai
         ePBvXpy7dyQEcuByJBlIw45ovESEjC+rd7IbfPibXlvahKwo/XjhAHQHhIFoGgoCL5kl
         cqDw==
X-Gm-Message-State: AOAM530Qcs2aTmgoEMot64/hE97l5QAVvOJ/IaXa6cpdZl9IDoZyxEZy
        tLIyUUBn56TPeCjfcpB5uRM=
X-Google-Smtp-Source: ABdhPJzWyEn2CUtbntLPrC+QRWXyUU/vsr3n9B8lFVwFkEpMv2ykzJgO3Bwz9deLoAWry1TP8gBNIQ==
X-Received: by 2002:a05:6000:188b:: with SMTP id a11mr13249364wri.326.1638441920340;
        Thu, 02 Dec 2021 02:45:20 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:14e3:371c:4e7b:1f65? (p200300ea8f1a0f0014e3371c4e7b1f65.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:14e3:371c:4e7b:1f65])
        by smtp.googlemail.com with ESMTPSA id p8sm2224318wrx.25.2021.12.02.02.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 02:45:19 -0800 (PST)
Message-ID: <cf4accd9-d613-5da4-cf2e-ccd9f06f3786@gmail.com>
Date:   Thu, 2 Dec 2021 11:45:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [EXT] Re: [PATCH net-next 2/2] net: stmmac: make
 stmmac-tx-timeout configurable in Kconfig
Content-Language: en-US
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        Mingkai Hu <mingkai.hu@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20211201014705.6975-1-xiaoliang.yang_1@nxp.com>
 <20211201014705.6975-3-xiaoliang.yang_1@nxp.com>
 <9116dadb-c3a3-1e69-164a-2cffa341b91b@gmail.com>
 <DB8PR04MB5785293BA211B0FD49EA40AFF0699@DB8PR04MB5785.eurprd04.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <DB8PR04MB5785293BA211B0FD49EA40AFF0699@DB8PR04MB5785.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.12.2021 11:28, Xiaoliang Yang wrote:
> Hi Heiner,
> 
> On Dec 02, 2021 at 16:13:20, Heiner Kallweit wrote:
>>> stmmac_tx_timeout() function is called when a queue transmission
>>> timeout. When Strict Priority is used as scheduling algorithms, the
>>> lower priority queue may be blocked by a higher prority queue, which
>>> will lead to tx timeout. We don't want to enable the tx watchdog
>>> timeout in this case. Therefore, this patch make stmmac-tx-timeout
>> configurable.
>>>
>> Your patch just disables the timeout handler, the WARN_ONCE() would still fire.
>> And shouldn't this be a runtime setting rather than a compile-time setting?
>>
> I tried to disable it in stmmac_tx_timeout() at runtime, the WARN_ONCE() will still be called from dev_watchdog() in sch_generic.c. It seems only when the timeout handler is NULL can disable the netdev watchdog up. So I did this in compile-time setting.
> 
The issue you're trying to fix is not driver-specific. Therefore the solution
should be added to net core.

> Regards,
> Xiaoliang
> 

