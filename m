Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD742A0C72
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgJ3R1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:27:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11348 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727139AbgJ3R1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:27:48 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UH4JbG086980;
        Fri, 30 Oct 2020 13:26:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kRv/mdN0gxrWM4bjmBGarbvn1q9ZLkvFoS6y5DzvQks=;
 b=UWWtqWmXJl3nSrq5VxzL3fA7gftqPT2l/7zujH5kX5UvHZQ2eMEv18xIFli+pDzv7TND
 NhYhOuFvYct9W6WTKfBbUytZ8/Cf+k1x8aeC7Oe5QD8YYyP+4VpoSpOUMvDWDIAhxnB6
 c5FhsgKRalTM6aUBHcNHDfpT9wtGJzgUJ5nY4j/m0uXK5U6stXBYO3eHSNoVzcotT/Xy
 9WS3NIpRpBYAz5DKkKDBBTsOJC2EE7S2Jsz0m9qB01bvBxEWMhFx70vhSmjAfeVZzs6/
 v05iYc3aUMt+dm/aSv5oejFCOaASxJm22fB+sZfWIK+97WfQXSV6rjYLkmgp0HqWCmHh bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gm93xm0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 13:26:38 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UH5286089727;
        Fri, 30 Oct 2020 13:26:37 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gm93xm01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 13:26:37 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UHH2Ts031290;
        Fri, 30 Oct 2020 17:26:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 34dwh0jff3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:26:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UHQWf831130076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 17:26:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81EE111C05C;
        Fri, 30 Oct 2020 17:26:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60F4211C050;
        Fri, 30 Oct 2020 17:26:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.85.67])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 17:26:30 +0000 (GMT)
Subject: Re: [PATCH v2 20/39] docs: ABI: testing: make the files compatible
 with ReST output
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
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
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
References: <cover.1604042072.git.mchehab+huawei@kernel.org>
 <58cf3c2d611e0197fb215652719ebd82ca2658db.1604042072.git.mchehab+huawei@kernel.org>
From:   Frederic Barrat <fbarrat@linux.ibm.com>
Message-ID: <94520e35-6b73-c951-206e-0031d41ebf83@linux.ibm.com>
Date:   Fri, 30 Oct 2020 18:26:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <58cf3c2d611e0197fb215652719ebd82ca2658db.1604042072.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_07:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 clxscore=1011 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 30/10/2020 à 08:40, Mauro Carvalho Chehab a écrit :
> Some files over there won't parse well by Sphinx.
> 
> Fix them.
> 
> Acked-by: Jonathan Cameron<Jonathan.Cameron@huawei.com>  # for IIO
> Signed-off-by: Mauro Carvalho Chehab<mchehab+huawei@kernel.org>
> ---
...
>   Documentation/ABI/testing/sysfs-class-cxl     |  15 +-
...
>   Documentation/ABI/testing/sysfs-class-ocxl    |   3 +


Patches 20, 28 and 31 look good for cxl and ocxl.
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>

   Fred
