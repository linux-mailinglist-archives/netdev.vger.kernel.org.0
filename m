Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C939D3A1871
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhFIPFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:05:10 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:59664 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbhFIPFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 11:05:07 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 159F340Y076944;
        Wed, 9 Jun 2021 10:03:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623250984;
        bh=OAtpdMKEWVQ9YW9nLXIwRCyDoKCWVnm+kcDeskm2VhE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qTscTW8MlD4ZMspi1VbyTX8rP8GEDeRiIOQaMzC555nKy54aE+9fmogM2dK6HmTfE
         4L/Ol15dsOQJQq/4F2oO9ni25yUhd1/sYWVVkl2XVUFGZj+pwJLyOKfpGn4/UiefnZ
         QtxpiJlWldFkgQLQ45xO/tKj5j/0jzJ4NPFM87V4=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 159F34VZ026197
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 9 Jun 2021 10:03:04 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 10:03:04 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 9 Jun 2021 10:03:04 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 159F31nI019469;
        Wed, 9 Jun 2021 10:03:02 -0500
Subject: Re: [RFT net-next] net: ti: add pp skb recycling support
To:     Matteo Croce <mcroce@linux.microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <ef808c4d8447ee8cf832821a985ba68939455461.1623239847.git.lorenzo@kernel.org>
 <CAFnufp11ANN3MRNDAWBN5AifJbfKMPrVD+6THhZHtuyqZCUmqg@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <e2ac36df-42a7-37d8-3101-ff03fd40510a@ti.com>
Date:   Wed, 9 Jun 2021 18:02:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAFnufp11ANN3MRNDAWBN5AifJbfKMPrVD+6THhZHtuyqZCUmqg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi

On 09/06/2021 15:20, Matteo Croce wrote:
> On Wed, Jun 9, 2021 at 2:01 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>>
>> As already done for mvneta and mvpp2, enable skb recycling for ti
>> ethernet drivers
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Looks good! If someone with the HW could provide a with and without
> the patch, that would be nice!
> 

What test would you recommend to run?

-- 
Best regards,
grygorii
