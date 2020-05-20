Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F84A1DBC43
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgETSFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:05:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40596 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgETSFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:05:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KI540T014072;
        Wed, 20 May 2020 11:05:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=FtP2gYMSJrgSCFGO25VRT5kFPHE9iyX1xWaHk4NgBp4=;
 b=BOrVuizTYVKQUhF/VO9l+9PuVulOEq49Amss5h+vyibaFjN9Qkq4iQ2ojVgrp+2NcCCK
 l22QsxW0ZhcRn8Eaxktn1wW+fqCdO11wZM4TEbGPP8t4aPj2OM0itTjTJ7p0CzMxj9sZ
 HZal7RXxb+9CKEJv7rjEh345OIbTkl+gryTlQg1EmT1NZerVeE+QP4pcutQA4/FDXaUt
 bkI0YA7jzOcK+Pqhu7VkDBhAGCbgxZ1BFA1Ohop3s8eqYTLedXj2svtKnuJnybFY57zW
 Sa7vpi/lu54xANRRPVYGtO1E3suNGgn+HEusASSUDjXp5tmS3v+SFFj1Cs5NyMALeGma xw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpp9q0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 11:05:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 11:05:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 11:05:02 -0700
Received: from [10.193.39.5] (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 53CF73F7044;
        Wed, 20 May 2020 11:05:01 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 07/12] net: atlantic: QoS
 implementation: max_rate
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
 <20200520134734.2014-8-irusskikh@marvell.com>
 <20200520101135.31aa1a13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <3042a968-8f74-4a46-0d81-64106206fe99@marvell.com>
Date:   Wed, 20 May 2020 21:05:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:77.0) Gecko/20100101
 Thunderbird/77.0
MIME-Version: 1.0
In-Reply-To: <20200520101135.31aa1a13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_14:2020-05-20,2020-05-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> drivers/net/ethernet/aquantia/atlantic/aq_main.c: In function
> aq_ndo_setup_tc:
> drivers/net/ethernet/aquantia/atlantic/aq_main.c:369:7: warning: variable
> has_max_rate set but not used [-Wunused-but-set-variable]
>  369 |  bool has_max_rate;
>      |       ^~~~~~~~~~~~
> drivers/net/ethernet/aquantia/atlantic/aq_main.c:368:7: warning: variable
> has_min_rate set but not used [-Wunused-but-set-variable]
>  368 |  bool has_min_rate;
>      |       ^~~~~~~~~~~~
> 
> This probably needs to moved to patch 11 where it's used.

Thanks for the review, Jakub, I don't see these on my setup, probably thats
newer gcc or different build config.

Will fix this.

Regards,
  Igor
