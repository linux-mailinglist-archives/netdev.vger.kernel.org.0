Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DF62A28B6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgKBLFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:05:33 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:2656 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728253AbgKBLFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:05:32 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2B2ptP020099;
        Mon, 2 Nov 2020 12:04:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=c46BUwKMyDOK+b3xICLc4SPGOwqFHPWlLu+N0eBiDsc=;
 b=qlgXi6rP2TqaGZFGGpTYwMqvPmL90+2jNgkIDUekhb1daD59BN2gIpspD9UJNonwWatj
 OHUgUW/gkuHA03EmB0FarCr3OF9wq9SA2yCiOWRX+Ek9VIR1j/QRToM/UC2lNjWAf3Kq
 Gq1pybeCkQlXMIpdTOQ7P/iFELEu7O6whhQllNenKEe5/XK6+0VIIemg87dHr4bkgTaI
 jiPcxx/TlvDgIqRR4jdhdt3eOubNpSinANuzNPCvX7gJnJy8bY2eDVhF2FtvabV8/mVh
 TOcw0QoQ4k7AwJJMs4NADeWVkO0Uncs5SNpNP0tOBNteIl80ydQPyt/xaWqAI4BRaYqI hQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 34h031a3kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 12:04:45 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 614FF100034;
        Mon,  2 Nov 2020 12:04:43 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag1node3.st.com [10.75.127.3])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 96E252AD9F8;
        Mon,  2 Nov 2020 12:04:42 +0100 (CET)
Received: from [10.211.2.101] (10.75.127.45) by SFHDAG1NODE3.st.com
 (10.75.127.3) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 2 Nov
 2020 12:04:37 +0100
Subject: Re: [PATCH v2 20/39] docs: ABI: testing: make the files compatible
 with ReST output
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Felipe Balbi <balbi@kernel.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Kranthi Kuntala <kranthi.kuntala@intel.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Len Brown <lenb@kernel.org>,
        Leonid Maksymchuk <leonmaxx@gmail.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Mark Gross <mgross@linux.intel.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Orson Zhai <orsonzhai@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Peter Rosin <peda@axentia.se>, Petr Mladek <pmladek@suse.com>,
        Philippe Bergheaud <felix@linux.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Rix <trix@redhat.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Vineela Tummalapalli <vineela.tummalapalli@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        <linux-acpi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-usb@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <netdev@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
References: <cover.1604042072.git.mchehab+huawei@kernel.org>
 <58cf3c2d611e0197fb215652719ebd82ca2658db.1604042072.git.mchehab+huawei@kernel.org>
 <5326488b-4185-9d67-fc09-79b911fbb3b8@st.com>
 <20201030110925.3e09d59e@coco.lan>
From:   Fabrice Gasnier <fabrice.gasnier@st.com>
Message-ID: <cb586ea3-b6e6-4e48-2344-2bd641e5323f@st.com>
Date:   Mon, 2 Nov 2020 12:04:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030110925.3e09d59e@coco.lan>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.45]
X-ClientProxiedBy: SFHDAG4NODE2.st.com (10.75.127.11) To SFHDAG1NODE3.st.com
 (10.75.127.3)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_03:2020-11-02,2020-11-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/20 11:09 AM, Mauro Carvalho Chehab wrote:
> Em Fri, 30 Oct 2020 10:19:12 +0100
> Fabrice Gasnier <fabrice.gasnier@st.com> escreveu:
> 
>> Hi Mauro,
>>
>> [...]
>>
>>>  
>>> +What:		/sys/bus/iio/devices/iio:deviceX/in_count_quadrature_mode_available
>>> +KernelVersion:	4.12
>>> +Contact:	benjamin.gaignard@st.com
>>> +Description:
>>> +		Reading returns the list possible quadrature modes.
>>> +
>>> +What:		/sys/bus/iio/devices/iio:deviceX/in_count0_quadrature_mode
>>> +KernelVersion:	4.12
>>> +Contact:	benjamin.gaignard@st.com
>>> +Description:
>>> +		Configure the device counter quadrature modes:
>>> +
>>> +		channel_A:
>>> +			Encoder A input servers as the count input and B as
>>> +			the UP/DOWN direction control input.
>>> +
>>> +		channel_B:
>>> +			Encoder B input serves as the count input and A as
>>> +			the UP/DOWN direction control input.
>>> +
>>> +		quadrature:
>>> +			Encoder A and B inputs are mixed to get direction
>>> +			and count with a scale of 0.25.
>>> +  
>>
> 
> Hi Fabrice,
> 
>> I just noticed that since Jonathan question in v1.
>>
>> Above ABI has been moved in the past as discussed in [1]. You can take a
>> look at:
>> b299d00 IIO: stm32: Remove quadrature related functions from trigger driver
>>
>> Could you please remove the above chunk ?
>>
>> With that, for the stm32 part:
>> Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
> 
> 
> Hmm... probably those were re-introduced due to a rebase. This
> series were originally written about 1,5 years ago.
> 
> I'll drop those hunks.

Hi Mauro, Greg,

I just figured out this patch has been applied with above hunk.

This should be dropped: is there a fix on its way already ?
(I may have missed it)

Please advise,
Fabrice
> 
> Thanks!
> Mauro
> 
