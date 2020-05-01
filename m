Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC591C1EC1
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 22:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgEAUmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 16:42:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18456 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbgEAUmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 16:42:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041KVgME015276;
        Fri, 1 May 2020 13:42:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=zdGCSE0RfOtLTaR0vOTzhigwD7PziyAalGU9rSI0oLs=;
 b=HqdoT0+WYLkYD+aCGGzWhizAhm+WILTVkB7g0rAG5YljfwvpUi6xWL+DqCRXl4BedWeb
 oJ8XlRrZ+xruYUW7NjLeFfiGKObTHd0rdHdzOmjkVmCdKtkox1MVZo48pv3L/06G8QQ5
 oHCobV2U9NAxzbVgII8zSjkJRR0QChYNb3SYhUvnVwHmhkdwMdOORvDOLPtJaEp3Z8vy
 OBclkUL+9pRsF+w0yK1mQEkGGG9PKlTEr28VeB9Th73Zf+2Ty1iOJ9gKv90YHpOydBKw
 MeeLkbd4fcZUlmygCJlikjOEg8VpJw38MY3v23B8J0I0fYihAQPt53MIwTe99m+ruhIi PA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30r7e8mamc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 13:42:47 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 1 May
 2020 13:42:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 1 May 2020 13:42:45 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 95B623F7040;
        Fri,  1 May 2020 13:42:43 -0700 (PDT)
Subject: Re: [EXT] [PATCH 15/37] docs: networking: device drivers: convert
 aquantia/atlantic.txt to ReST
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
 <f6d8605f322899e9fa1a71248b165e7ad3840ab7.1588344146.git.mchehab+huawei@kernel.org>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <c8976fe3-52fc-36e4-e75e-e0d505f11a25@marvell.com>
Date:   Fri, 1 May 2020 23:42:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <f6d8605f322899e9fa1a71248b165e7ad3840ab7.1588344146.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_14:2020-05-01,2020-05-01 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/05/2020 5:44 pm, Mauro Carvalho Chehab wrote:
> External Email
> 
> ----------------------------------------------------------------------
> - add SPDX header;
> - use copyright symbol;
> - adjust title and its markup;
> - comment out text-only TOC from html/pdf output;
> - mark code blocks and literals as such;
> - adjust identation, whitespaces and blank lines where needed;
> - add to networking/index.rst.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Acked-by: Igor Russkikh <irusskikh@marvell.com>

Thanks alot, Mauro, for this conversion!

  Igor
