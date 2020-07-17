Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29F12239B3
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgGQKtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:49:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13406 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbgGQKtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:49:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HAgfch010272;
        Fri, 17 Jul 2020 03:49:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=LI15vtc1sBeo327JWQg5OChc27nKdjqnS+CvYVaEkSI=;
 b=RC/p++b7vs/nXZkKXSTqs4tbnWek2/uCjopTPXaUIqUoTA53FqZuxC1ZQfrdOlCQQLJO
 vo6KuivqdPbfVWmmBB1r2Rk45bHKyVGbN5C++65f4dbvbRE3UN3/3wDzpI3o0LSdCjyT
 TLQlst4pYryyh7C0CwMHCPUBoNkv0qog9kftWoIK5Y61+WvImWhWs3EL3ZinzYH/2QsJ
 CgomND5vicxMogd6qyrhI9wNNysNfgGkVhrLZbLQQ87Hla7VR1LEAZz9r6eSyjM4Xvza
 TSXtJm9siMq4e+oy6EyOKvGRgvLsgXpVA7bw/wQB1cEQNPsG1gGZ2lHycy0p6WiXAiIF yw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32ap7vcw11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 03:49:39 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 03:49:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Jul 2020 03:49:38 -0700
Received: from [10.193.54.28] (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 8D2FC3F7041;
        Fri, 17 Jul 2020 03:49:34 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 10/13] qed: add support for new port
 modes
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@marvell.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@cavium.com>, <netdev@vger.kernel.org>
References: <20200716115446.994-1-alobakin@marvell.com>
 <20200716115446.994-11-alobakin@marvell.com>
 <20200716181853.502dd619@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <27939848-7e83-2897-36f9-44f47d1bfb9c@marvell.com>
Date:   Fri, 17 Jul 2020 13:49:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200716181853.502dd619@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_06:2020-07-17,2020-07-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> ----------------------------------------------------------------------
> On Thu, 16 Jul 2020 14:54:43 +0300 Alexander Lobakin wrote:
>> These ports ship on new boards revisions and are supported by newer
>> firmware versions.
>>
>> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
>> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> 
> What is the driver actually doing with them, tho?
> 
> Looks like you translate some firmware specific field to a driver
> specific field, but I can't figure out what part of the code cares
> about hw_info.port_mode

Hi Jakub,

You are right, this info is never used/reported.

Alexander is extending already existing non used field with new values from
our latest hardware revisions.

I thought devlink info could be a good place to output such kind of information.

Thats basically a layout of *Physical* ports on device - quite useful info I
think.

Important thing is these ports may not be directly mapped to PCI PFs. So
reading `ethtool eth*` may not explain you the real device capabilities.

Do you think it makes sense adding such info to `devlink info` then?

Thanks
  Igor
