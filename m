Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7BD27FD23
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbgJAKSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:18:17 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26110 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725938AbgJAKSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:18:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091AFFpB022503;
        Thu, 1 Oct 2020 03:18:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=OfpztRI0JJDJilO4Mcakn+/zpzHPGyttVsf9FikTj6E=;
 b=e7VAiJu6GPhfWX4owkuT2Rwzgn6yrhvpio3OmRdbDG67muEHADmIqCyM5pu6+whiK/jB
 HOe+3xF6jj1QSuwJ0zFrKpQ+msdTVpy/3iinWOKhnuoDq5hoiesbKF+tbrK8gkMMlxmn
 4fn79VkqH4KJ2cYpFgtzlt3XgNHoLkSZzguu+oWHYRQ9eWbi7jFyTmZhE5MkOBmDXiHp
 RTLto880NVKJgMpQMBjRTxs+Y7Gllt+otMmXjayS8XulWg5ZyrOgYrqjVm0DmvnyiuN1
 DFgVXK6FeeCYtNxos1amAZp42pEUR/V+QFZSENKt7Uc2/9JH3RDj3f/FmIEmlTRO0qAD 3w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemm59v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 03:18:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Oct
 2020 03:18:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 1 Oct 2020 03:18:09 -0700
Received: from [10.193.39.7] (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id DB0643F703F;
        Thu,  1 Oct 2020 03:18:07 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 3/3] net: atlantic: implement media
 detect feature via phy tunables
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929161307.542-4-irusskikh@marvell.com>
 <20200929171815.GD3996795@lunn.ch>
 <b43fb357-3fd1-c1a5-e2ff-894eb11c2bbb@marvell.com>
 <20200930142204.GK3996795@lunn.ch>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <04e72671-aa3e-ac11-ef92-bb17fc633a60@marvell.com>
Date:   Thu, 1 Oct 2020 13:18:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101
 Thunderbird/82.0
MIME-Version: 1.0
In-Reply-To: <20200930142204.GK3996795@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_03:2020-10-01,2020-10-01 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> Since this is your own PHY, not some magical black box, i assume you
> actually know what value it is using? It probably even lists it in the
> data sheet.
> 
> So just hard code that value in the driver. That has got to be better
> than saying the incorrect value of 1ms.

You mean always return that value in get_, and ignore what we get in set_ ?
That could be done, will investigate.

Thanks for the review,
  Igor
