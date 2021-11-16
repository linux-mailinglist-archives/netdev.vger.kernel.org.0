Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D48452C73
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 09:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhKPIN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 03:13:29 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64302 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231701AbhKPIN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 03:13:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AG7KXQD003838;
        Tue, 16 Nov 2021 00:10:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=RoV/3perCx3nA3ocAZ1FkkrS31YYqIs5qPGVY/qK65Q=;
 b=hVvq1Yw+gSX1yuTENkS30zWffcdDDhpcRQuMpg2a5zyNHfE77S3aVzj7jt1xBrIrHPnr
 xoHwgMYXBa8K2nz+GBr5xuzqo0FP9lP+LNy40hMJs57t3YzuIWWq9ubOGQzW3tvoRdVk
 Q2690+JKBC3+GdY1ua4rz6pg4wy/frq6fmHDIMywdlVbMBAMyeKhtwxTfFN4EQtvRgmT
 wyWNLu+AmQg9oU7y6K19kqa/mLtaR6kLDGgrfldiH1RMziV3ZOasSAHq+7x8AERwYgUu
 +CUBvACqG0dyg1mbb+UJ2l0bGGIP4rm1tEZjcYV+MWInXv9qSNs1vsSvJPAw5GaruBPK MA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cc85x85hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 00:10:23 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov
 2021 00:10:16 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 16 Nov 2021 00:10:16 -0800
Received: from alpha-dell-r720.punelab.qlogic.com032qlogic.org032qlogic.com032mv.qlogic.com032av.na032marvell.com (unknown [10.30.46.139])
        by maili.marvell.com (Postfix) with ESMTP id E351C3F70E5;
        Tue, 16 Nov 2021 00:10:06 -0800 (PST)
From:   Alok Prasad <palok@marvell.com>
To:     <paskripkin@gmail.com>
CC:     <aelior@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <skalluru@marvell.com>,
        <mchopra@marvell.com>, <palok@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: remove GR-everest-linux-l2@marvell.com
Date:   Tue, 16 Nov 2021 08:10:04 +0000
Message-ID: <20211116081004.11148-1-palok@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211115202028.26637-1-paskripkin@gmail.com>
References: <20211115202028.26637-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: MJAflol41ctueZp5l-_yz6v79e_q09td
X-Proofpoint-ORIG-GUID: MJAflol41ctueZp5l-_yz6v79e_q09td
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_16,2021-11-15_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I've sent a patch to GR-everest-linux-l2@marvell.com few days ago and
> got a reply from postmaster@marvell.com:
> 
>      Delivery has failed to these recipients or groups:
> 
>      gr-everest-linux-l2@marvell.com<mailto:gr-everest-linux-l2@marvell.com>
>      The email address you entered couldn't be found. Please check the
>      recipient's email address and try to resend the message. If the problem
>      continues, please contact your helpdesk.
> 
> Since this email bounces, let's remove it from MAINTAINERS file.
> 
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> CCed others related maintainers from marvell, maybe they know what
> happened with this email
> 

Pavel,
Yes gr-everest-linux-l2@marvell.com has been disabled, But please
add Manish Chopra <mchopra@marvell.com> to the maintainer list.

Thanks,
Alok

> ---

