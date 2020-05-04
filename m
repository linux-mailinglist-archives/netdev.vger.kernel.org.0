Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E011C32EE
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 08:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgEDG30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 02:29:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9962 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726330AbgEDG30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 02:29:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0446Q65a003072;
        Sun, 3 May 2020 23:29:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=H3Yef4DR1TA8BqBfsPt6CVmCbyysakUA2xM6nyMkuHY=;
 b=iPs1yFWsbF7OlGzJicqM3nQfyekwIX04Js+g0Qjk/9CV/JULEHspSE1tAg5MEtT3YM9L
 7FLvB0J7dFCIMCREKq0BCDYAuX3WrOLSPSuqIv2ZXDTBuw9mNXDo5gtlaLGcuJ1weaxy
 o+hxU6bqhuj7s4wmUVs5vme+XzA+Y2iSjMWFR6AVHTSSkgdO3g//FLExwO9oVvOIbh3w
 T1hET+pRoUoImioJFI5pcDElwFNEMNPtRpS34Fe/bGES8wwxJUVWbJS3Jg0B/AbOd59i
 n5tIUY24H1wIRA3Tp/1L8Ui0qJ1YsW3wmDUKsh6Bk5Rs8hRatSut8k0k2f/V2xNGxrNY Pw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30s67q5syx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 23:29:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 3 May
 2020 23:29:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 3 May 2020 23:29:23 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 48DF93F703F;
        Sun,  3 May 2020 23:29:22 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v2 net-next 00/17] net: atlantic: A2 support
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
 <20200501.153853.168779057910060484.davem@davemloft.net>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <1cae44fe-fb20-e365-0812-e1e0bcbc8e4f@marvell.com>
Date:   Mon, 4 May 2020 09:29:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200501.153853.168779057910060484.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_03:2020-05-01,2020-05-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 
> Series applied.
> 
> Please follow up with a patch that makes the new structures use
> "__packed" instead of the full expanion.

Thanks, David!

Sure will do this.

Regards
  Igor
