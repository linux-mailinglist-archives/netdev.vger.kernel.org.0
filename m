Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3153449F2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhCVP5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:57:03 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53818 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230134AbhCVP4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:56:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12MFpPun014020;
        Mon, 22 Mar 2021 08:56:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=YEgiwQSusQxj3lZOUq2K6+1KjkgfNBb/7IIwqWNUUKo=;
 b=SgQCTM99QjdGkCRD8txfKnK7ac68JfJoPU/N/1jDZvSy70miHsv9+Xaz8ASyp7ZY6VrR
 ha+HAx2pZ9NBoyj5Ujcup04HgqZlsGFD4Nd8s5r5j945gEwEsmFmQEtTCkOxt25mlzyK
 3bB5X9ztMAsJr79yg0vJJ5tFzfnbhnkq7TZgeagMd/gPrB9fbuA4aUqB3bOVVZhwpY+e
 BhHBeMNWX+H8TRRO4U07IpJVubSVl6dbZ+zTo5OF6N4jHhgknuo6mleeshgYlgVoCEyA
 Ycfh7k05FhDON2i4LTwhyUQBO3XZo0cyyKzEaU/Dt9essmMNTJiIzQuKccJcaYFlP8rZ GA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnwhn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 08:56:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 08:56:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 08:56:20 -0700
Received: from [10.193.38.106] (unknown [10.193.38.106])
        by maili.marvell.com (Postfix) with ESMTP id C90EE3F704D;
        Mon, 22 Mar 2021 08:56:16 -0700 (PDT)
Message-ID: <4c953b24-974c-9425-b9be-cb386b15c9fb@marvell.com>
Date:   Mon, 22 Mar 2021 16:56:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [EXT] [PATCH] linux/qed: Mundane spelling fixes throughout the
 file
Content-Language: en-US
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <rdunlap@infradead.org>
References: <20210322025516.968396-1-unixbhaskar@gmail.com>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <20210322025516.968396-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_08:2021-03-22,2021-03-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> s/unrequired/"not required"/
> s/consme/consume/ .....two different places
> s/accros/across/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Igor Russkikh <irusskikh@marvell.com>

Thanks
  Igor
