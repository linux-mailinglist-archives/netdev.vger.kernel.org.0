Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE312AF205
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgKKNYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:24:37 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:35576 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgKKNYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:24:37 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0ABDOKM8046731;
        Wed, 11 Nov 2020 07:24:20 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605101060;
        bh=Q6sOgNRAnnGfgqlURmRzcwNSVvUxAcDKCR46RUyCdUA=;
        h=From:Subject:To:CC:References:Date:In-Reply-To;
        b=ZZ1ut0CzsUcaiI0VpkfEcJ9tvN+nRsv9GZUC3prAlbPw/1FluMvjqjhYVfUc1D63g
         NXNOYw8FwaK0xVahUsLinwa8rG5SQ3vq1uCvmv6rR6Bbql6tYjA92sDMwKRP+g4gGs
         ytqiU3kVz/p8zM+oM2MlLMDTZHfT39cE7XRAyv5I=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0ABDOKIc031284
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 07:24:20 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 11
 Nov 2020 07:24:20 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 11 Nov 2020 07:24:20 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0ABDOHkQ033420;
        Wed, 11 Nov 2020 07:24:18 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when ptp_clock is
 ERROR
To:     Richard Cochran <richardcochran@gmail.com>,
        Wang Qing <wangqing@vivo.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1605086686-5140-1-git-send-email-wangqing@vivo.com>
 <20201111123224.GB29159@hoboy.vegasvil.org>
Message-ID: <cd2aa8a1-183c-fb15-0a74-07852afb0cb8@ti.com>
Date:   Wed, 11 Nov 2020 15:24:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201111123224.GB29159@hoboy.vegasvil.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Jakub,

On 11/11/2020 14:32, Richard Cochran wrote:
> On Wed, Nov 11, 2020 at 05:24:41PM +0800, Wang Qing wrote:
>> We always have to update the value of ret, otherwise the error value
>>   may be the previous one. And ptp_clock_register() never return NULL
>>   when PTP_1588_CLOCK enable.
> 
> NAK.
> 
> Your code must handle the possibility that ptp_clock_register() can
> return NULL.  Why?
> 
> 1. Because that follows the documented API.
> 
> 2. Because people will copy/paste this driver.
> 
> 3. Because the Kconfig for your driver can change without warning.

Following Richard's comments v1 of the patch has to be applied [1].
I've also added my Reviewed-by there.

[1] https://lore.kernel.org/patchwork/patch/1334067/
-- 
Best regards,
grygorii
