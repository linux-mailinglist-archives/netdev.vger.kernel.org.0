Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B068333B1CB
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCOLzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:55:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49928 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229830AbhCOLza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:55:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12FBp6ZE023352;
        Mon, 15 Mar 2021 04:55:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=/4GbhxSI8mqBPbsBNIDoodK+Jb48f523LZ/OvVb7r+o=;
 b=kthj/1vDilyCvKdLRnNa0iSc2KfLBXzDuiEPzLt/+A8VYnUJ/caJB1QQTP7UlT9lh7GX
 TlG1JDsyo5480/hrUi1JTAZnX8TaPWY7IuCO+whnrRGvtR3xxIRmMo3ibbX37edW0y3I
 2GNQu/mr2THzRzt2zpmNMTfByGd3dJTEzrvJ+2dHvOGhj/snc+GE3cd9LMZKf8Z/BY55
 RWVkK4Tpxm6C52gc6JMBXOCcDziNtyvmwOPqjgDJ10Kz9Hq0OlpZChEDdEvAzp4SlDbq
 DFFk0yPVxVdxMDhEO7xw1xId+a7nOpmZKPvX4raWvVOD4VatzlyKN1s0nlVqliofQPMO Bg== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtcdmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 04:55:26 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Mar 2021 07:55:24 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 07:55:24 -0400
Received: from [10.193.38.106] (unknown [10.193.38.106])
        by maili.marvell.com (Postfix) with ESMTP id 7FC7E3F703F;
        Mon, 15 Mar 2021 04:55:23 -0700 (PDT)
Message-ID: <141b34a2-af41-b66f-6a85-b202e77c904c@marvell.com>
Date:   Mon, 15 Mar 2021 12:55:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [EXT] Re: [PATCH v3 net-next 0/2] pktgen: scripts improvements
Content-Language: en-US
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
References: <20210311103253.14676-1-irusskikh@marvell.com>
 <20210315094530.6a77018f@carbon>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <20210315094530.6a77018f@carbon>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_05:2021-03-15,2021-03-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> v3: change us to ns in docs
>> v2: Review comments from Jesper
>>
>> CC: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> Did a quick review and everything looks okay.
> The patches are already applied, but you will still get my ACK,
> even-though it will not make it to the commit log.
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks for the review, Jesper!

  Igor
