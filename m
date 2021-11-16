Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABC1452C8B
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 09:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhKPITM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 03:19:12 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39456 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231520AbhKPITM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 03:19:12 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AG3t2Zs003936;
        Tue, 16 Nov 2021 00:16:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=qxuJlRg65JPV1zmIpBAQLzYzlBvbVF8S50/LrrL2bk4=;
 b=jhHZg1aZegxVPcwlEjMF0EPrePOJEdbf6M6+mk9jGu+lBE8GhaDqLIEWaQVYwYkLPUiZ
 48023SHIzX3MXaI0fmltD9Ky4Yaq/c6erQa0uIQcCXsXoCaaHhryNbNUfLpgOydpPYGl
 63Q1iYY+6TJhVA2u8eV9/J4dZI0JHNJTXSO/AzlX4+clcfsnAjbBIO9pcq3FPiU2v5cm
 Jx8DvsKQ4TNKGOpmaSg3nsGnDEGMyOuWJDu8jXPpsvy9U8HAHaAZO9h9kAmIpw1LC2ve
 aaORQUgZQxmaLzknwWDLDa6Mm55UpUAK4OempUMLgd4SWBn1a2m6XXKDZQEdezjBFeCq SQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cc55n0s7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 00:16:09 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov
 2021 00:16:08 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 16 Nov 2021 00:16:07 -0800
Received: from alpha-dell-r720.punelab.qlogic.com032qlogic.org032qlogic.com032mv.qlogic.com032av.na032marvell.com (unknown [10.30.46.139])
        by maili.marvell.com (Postfix) with ESMTP id ADD733F7059;
        Tue, 16 Nov 2021 00:16:05 -0800 (PST)
From:   Alok Prasad <palok@marvell.com>
To:     <palok@marvell.com>
CC:     <aelior@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <manishc@marvell.com>, <netdev@vger.kernel.org>,
        <paskripkin@gmail.com>, <skalluru@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: remove GR-everest-linux-l2@marvell.com
Date:   Tue, 16 Nov 2021 08:16:01 +0000
Message-ID: <20211116081601.11208-1-palok@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116081004.11148-1-palok@marvell.com>
References: <20211116081004.11148-1-palok@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: KYwWF00n48xIrHqKqgmudyClM97MnL1y
X-Proofpoint-ORIG-GUID: KYwWF00n48xIrHqKqgmudyClM97MnL1y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_16,2021-11-15_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> Pavel,
> Yes gr-everest-linux-l2@marvell.com has been disabled, But please
> add Manish Chopra <mchopra@marvell.com> to the maintainer list.

Sorry , Correction it should Manish Chopra <manishc@marvell.com>

> 
> Thanks,
> Alok



