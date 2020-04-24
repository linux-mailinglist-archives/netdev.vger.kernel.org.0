Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572D31B7031
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgDXJCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:02:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41282 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgDXJCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 05:02:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O9084E016870;
        Fri, 24 Apr 2020 02:02:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=3rsoiV+3vh5jqDCR3dDHjQ75/XaQonbI9BUJPj7zpvQ=;
 b=keztfnIDTcwBToxUGad6QCwsNWb/dKQ6apoIuBYs2NScOiUaLfimOI67uKEv4pSzKCrx
 Q1U8HMLLNpcAtyt2c3YEg2bBTRANDqAsKvCMpnnv1+SBkiui1ffPXG1uEiJf8RIuaXt3
 8L83L7gZJ7lqDYjUdf+7NDwCzy8DAW3tqbsZlXmKU2Md/2EcOfEH+Ooo70kUsfNoEZop
 35jhLLmDCXWDZEqkK3VWhxWsguUp+nkO1Y+5Z2sSqIJG7vESVMqNUo7hBr3YaRhKt47J
 EgocpXHuHBWABH4xkF1cmshlKVoDEpvhiYVFQJZX6lwYXD315sPJz7HC/b2UJxdpBoqR WQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsbf2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 02:02:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 02:02:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 02:02:24 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 873D93F703F;
        Fri, 24 Apr 2020 02:02:23 -0700 (PDT)
Subject: Re: [EXT] [PATCH -next] net: atlantic: Remove unneeded semicolon
To:     Zheng Bin <zhengbin13@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <20200424090428.93485-1-zhengbin13@huawei.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <05826d5f-69d6-3735-d890-38e1b7fe0fd1@marvell.com>
Date:   Fri, 24 Apr 2020 12:02:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200424090428.93485-1-zhengbin13@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_03:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Fixes coccicheck warning:
> 
> drivers/net/ethernet/aquantia/atlantic/aq_macsec.c:404:2-3: Unneeded
> semicolon
> drivers/net/ethernet/aquantia/atlantic/aq_macsec.c:420:2-3: Unneeded
> semicolon
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Thanks,

Acked-by: Igor Russkikh <irusskikh@marvell.com>

