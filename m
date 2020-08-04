Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8850A23B580
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 09:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgHDHVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 03:21:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50264 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726974AbgHDHVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 03:21:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0747LJWZ018747;
        Tue, 4 Aug 2020 00:21:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=gyPmE7c6eT6+4/obyK99xW07JK9AVvx/HJLuUt1f1Vg=;
 b=hTJPUiOJedwp0GsOkoLJ6JU0QVvQmdW3f4Q1TJk1DkKD6Wn9JpEazx5LJjcKpfHuMis6
 TJP/0dTqyDDP21mlXYtHM6M5OvHhrithJldUwkGoDNDz/b++cQ0+QNOnc/YGjumDP9bc
 vPBFRkIzxkmkuVVq222NCdeV1HyQSO+/+e1BglThssVKgeFBOtW4fy561uDq64XD6M27
 l4yxqtSALA0/8jEMlWsgBv2MMDJ8jcVwyYcufcTo9KfuHSlUh5LCtWeG7IKP6WNIt2P1
 g57ubka4drgNBXnfr1R5ZCwF6yDd1YKmMeZ4ZP17U/LRxEAp8Zta2f5ESbPUYfWMIIlo eA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32n6cgjg5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 04 Aug 2020 00:21:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 00:21:25 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 00:21:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 4 Aug 2020 00:21:24 -0700
Received: from [10.193.54.28] (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 273973F703F;
        Tue,  4 Aug 2020 00:21:21 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v5 net-next 04/10] qed: implement devlink info
 request
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Ariel Elior" <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Denis Bolotin" <dbolotin@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Alexander Lobakin" <alobakin@marvell.com>
References: <20200802100834.383-1-irusskikh@marvell.com>
 <20200802100834.383-5-irusskikh@marvell.com>
 <20200803142951.4c92f1ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <79e9a8ca-3c6b-8ded-8a6a-1f4455e4e752@marvell.com>
Date:   Tue, 4 Aug 2020 10:21:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101
 Thunderbird/79.0
MIME-Version: 1.0
In-Reply-To: <20200803142951.4c92f1ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-04_03:2020-08-03,2020-08-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Jakub,

On 04/08/2020 12:29 am, Jakub Kicinski wrote:

>> ~$ sudo ~/iproute2/devlink/devlink  dev info
>> pci/0000:01:00.0:
>>   driver qed
>>   serial_number REE1915E44552
> 
> Just to confirm - this is not:
> 
>    * - ``board.serial_number``
>      - Board serial number of the device.
> 
>        This is usually the serial number of the board, often available in
>        PCI *Vital Product Data*.

I'm not sure on difference between board. or just serial_number, but lspci
shows this ID as a part of vital product data.

Considering this you are right, its better to change to "board.serial_number".

>> Running FW (or fastpath FW) is an embedded microprogram implementing
>> all the packet processing, offloads, etc. This FW is being loaded
>> on each start by the driver from FW binary blob.
> 
> Sounds like you should use:
> 
> fw.app - Data path microcode controlling high-speed packet processing.

Thanks, agreed.

Jakub, David, I'll prepare v6. Should I postpone posting v6 until the next
cycle then?

Regards,
  Igor
