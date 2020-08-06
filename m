Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0524023E30F
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 22:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgHFUUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 16:20:22 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:36526 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgHFUUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 16:20:22 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 076KJqPn085323;
        Thu, 6 Aug 2020 15:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596745192;
        bh=ZUrVIV9a/HB6pdfYWlnxoyCs4L1mTouSCTB1BHdWEwE=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=FcxToDvSFg82La4qIiBDrzEoU622ni3NoRCndwjCBW7eMDK/jLFosVY08NMlWChAY
         t/Mjryolm2Zgto/ZxVb2pvO99xXlnUxJDYJ40QGj7vH9r2G3kYSBf43fyG/Ozik9mv
         /anuIAGHUyfaBiqhqL0sHAL63mkYk57/8FIzgdq8=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 076KJqsr020504
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Aug 2020 15:19:52 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 6 Aug
 2020 15:19:52 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 6 Aug 2020 15:19:51 -0500
Received: from [10.250.53.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 076KJp1M112395;
        Thu, 6 Aug 2020 15:19:51 -0500
Subject: Re: [net-next iproute2 PATCH v3 1/2] iplink: hsr: add support for
 creating PRP device similar to HSR
To:     David Ahern <dsahern@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>, <stephen@networkplumber.org>,
        <kuznet@ms2.inr.ac.ru>
References: <20200717152205.826-1-m-karicheri2@ti.com>
 <e6ac459e-b81c-48ee-d82c-36a533e2aa29@ti.com>
 <6632128c-1c4b-4538-81a9-48dd752c8ab3@gmail.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <9bc91459-73f1-df6e-176a-b078a7cc309f@ti.com>
Date:   Thu, 6 Aug 2020 16:19:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6632128c-1c4b-4538-81a9-48dd752c8ab3@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/6/20 1:12 PM, David Ahern wrote:
> On 8/6/20 10:04 AM, Murali Karicheri wrote:
>> that the maintainers are different than the netdev maintainers. My bad.
>> The PRP driver support in kernel is merged by Dave to net-next and this
>> iproute2 change has to go with it. So please review and apply this if it
>> looks good. The kernel part merged is at
> 
> there was a long delay between iproute2 and commit to net-next. You need
> to re-send the iproute2 patches.
> 
OK. Will do. Thanks
-- 
Murali Karicheri
Texas Instruments
