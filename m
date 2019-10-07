Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8A0CE4B8
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfJGOIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:08:44 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:3768 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727324AbfJGOIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 10:08:44 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97E5xiV002187;
        Mon, 7 Oct 2019 16:08:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=klXRWCSbmhcmHuPY/bDJHkMbLakbKnFtshdjqE+GnyY=;
 b=Mz/2iiOKhwLjeTp22Jq2dcTNxXiDYGyuJ6/IuMGfwVty8fF90AZtnozG5MQXzNppkdj3
 9j6lmhAu8osbLVGPajspUCDLwnY+GbA6oTywYf7dlwght0s7Gq6a3uGC7uqL64n/1Z9D
 6VnqBvVk3Y9l35C8Y72/pzIW1HrcZjwKFAVqEyYS9jKMZU/c5OJjZX3TEMl8FNgSTaYt
 83dCXJ2+6nFBDkmdBOVmTZ4EV778ldK5fVbEagbvaoYktgpONT3Q7CnBtsMRxSplaAOT
 /fAM6OCeS+TCh0FV+qKVOdiZNSpZ6iXWfc6WnvuT4099f0xURv255Q75BHcys5MFwJzV oQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2vegagu49g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 16:08:29 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 040B1100034;
        Mon,  7 Oct 2019 16:08:29 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E9DD02B1E5F;
        Mon,  7 Oct 2019 16:08:28 +0200 (CEST)
Received: from lmecxl0912.lme.st.com (10.75.127.48) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 7 Oct
 2019 16:08:28 +0200
Subject: Re: [PATCH 1/3] dt-bindings: media: Fix id path for sun4i-a10-csi
To:     Maxime Ripard <mripard@kernel.org>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Alexandru Ardelean <alexaundru.ardelean@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20191007102552.19808-1-alexandre.torgue@st.com>
 <20191007102552.19808-2-alexandre.torgue@st.com>
 <20191007110040.2mt5uxroos3hz6ic@gilmour>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <3d01e1b5-95ff-f4bd-f57a-a809054e0ba1@st.com>
Date:   Mon, 7 Oct 2019 16:08:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191007110040.2mt5uxroos3hz6ic@gilmour>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG3NODE2.st.com (10.75.127.8) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_02:2019-10-07,2019-10-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/19 1:00 PM, Maxime Ripard wrote:
> Hi Alexandre,
> 
> On Mon, Oct 07, 2019 at 12:25:50PM +0200, Alexandre Torgue wrote:
>> This commit fixes id path of allwinner,sun4i-a10-csi.yaml location.
>>
>> Fixes: c5e8f4ccd775 ("media: dt-bindings: media: Add Allwinner A10 CSI binding")
>> Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
> 
> I just merged a patch addressing the same issue earlier today.
> 

Ok. Thanks Maxime.

Regards
Alex

> Thanks!
> Maxime
> 
