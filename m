Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907A21B8E0F
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 10:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgDZIu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 04:50:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40636 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726108AbgDZIuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 04:50:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03Q8oHwW032492;
        Sun, 26 Apr 2020 01:50:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=aumqPdP70nQp5wnKBr8YBLd0bjsA5Dcj4TlWgHVwn/w=;
 b=PwYc547jYn0KTbspC9HQsQbeyy3M9TCALnQI5CsMg4kyfyus8dKTOuiUhpsXXHSb+4JK
 NV0F0GNGJuzP1wgGAc3KvQp0zsEt9tTptMClh11navMFcAtzjo/g2G/fFxgsdwTuCmam
 b2CZIjVNr/STKkVlU8kWrw86PGiATRuavaq+TMZPiJmgXSQ/DRqLzivK0fFzN/n+RbcH
 qvTK34tM/QHW2lj0u48DULWMYTTuTL7OBldYscmxpFuT2wioKgvFaUHfs50+5KhXZNyd
 GqdPHH0+lp/gZltxTfyRNPm+Nlbcad0Av1BIDv8JRvzWWbpK3KrMwDT+oww91YmM+JYr ug== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjq3pdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 Apr 2020 01:50:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 26 Apr
 2020 01:50:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 26 Apr 2020 01:50:22 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id D90A53F703F;
        Sun, 26 Apr 2020 01:50:20 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 08/17] net: atlantic: A2
 driver-firmware interface
To:     David Miller <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
 <20200424072729.953-9-irusskikh@marvell.com>
 <20200424174447.0c9a3291@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200424.182532.868703272847758939.davem@davemloft.net>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <d02ab18b-11b4-163c-f376-79161f232f3e@marvell.com>
Date:   Sun, 26 Apr 2020 11:50:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200424.182532.868703272847758939.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-26_01:2020-04-24,2020-04-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Date: Fri, 24 Apr 2020 17:44:47 -0700
> 
>> On Fri, 24 Apr 2020 10:27:20 +0300 Igor Russkikh wrote:
>>> +/* Start of HW byte packed interface declaration */
>>> +#pragma pack(push, 1)
>>
>> Does any structure here actually require packing?
> 
> Yes, please use the packed attribute as an absolute _last_ resort.

These are HW bit-mapped layout API, without packing compiler may screw up
alignments in some of these structures.

Regards,
  Igor
