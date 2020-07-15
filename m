Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FC3220668
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 09:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbgGOHmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 03:42:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8948 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729377AbgGOHmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 03:42:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06F7YuJg002377;
        Wed, 15 Jul 2020 00:41:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=PG39e9KdVZSb3YFrRffy6OOZof10MHzfIAWWDm2CNH8=;
 b=FL0crd4G4jWbOJHM7Wug2Pp7TDxivw4vm7yZUbwKa8TgSUYL8ZJHiHOKxUDJFG8Km3rz
 SXMMY635zwn7bXulKK0AeIu5hoCTa3NxRdupTPL+6VakokDGEnsCkXyjV0xlxQ6FCv5f
 llyBC+68ZF4r6z23BkTG6u9/Syw49sSnIoaAVYiYBGrE+W/7Ii2HqjO/Q/Oz4W55431D
 MO3UMuRRbZAY7s3tOldVRV9+U3+wQlDvD3T9eK1a4aBVFbAW1ecm2M5r5sPDyXatklfT
 lRBg5Y/5qCfzrzTSEyDtehj4ueZ1GvR1hH3qVNZIUZ3+sVvx2KY7db06gQZz78XSHaOf CA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asngh07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 00:41:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 00:41:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 00:41:56 -0700
Received: from [10.193.54.28] (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 7845F3F703F;
        Wed, 15 Jul 2020 00:41:54 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 01/10] net: atlantic: media detect
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200713114233.436-1-irusskikh@marvell.com>
 <20200713114233.436-2-irusskikh@marvell.com>
 <20200713142500.GB1078057@lunn.ch>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <f4870c58-14ff-cb30-c793-f577b02336c1@marvell.com>
Date:   Wed, 15 Jul 2020 10:41:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200713142500.GB1078057@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_05:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Mon, Jul 13, 2020 at 02:42:24PM +0300, Igor Russkikh wrote:
>> This patch adds support for low-power autoneg in PHY (media detect).
>> This is a custom feature of AQC107 builtin PHY, but configuration is
> only
>> done through MAC management firmware.
> 
> Hi Igor
> 
> Do the standalone PHYs also support this? It would be nice to have the
> same user space API for both.
> 
> There is no reason why phy tuneables cannot be implemented by the MAC
> driver. It just needs another ethtool op and some plumbing in
> net/ethtool. That would give a more uniform solution.

Hi Andrew,

Unfortunately I can't verify this on standalone PHY, but some models similar
to what in AQC107 in theory should.

Whats your opinion then? Add this feature with phy tunable with ability to
handle in netdev driver?

Thanks,
  Igor
