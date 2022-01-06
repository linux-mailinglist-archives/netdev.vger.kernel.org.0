Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAAC486F4F
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344077AbiAGA7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:59:39 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50756 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344992AbiAGA7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:59:38 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 206HVkbn007681;
        Thu, 6 Jan 2022 16:59:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=Bk+dPGW8LN0k/tKon82YN/k/twWQw8NQnho0m+1l4XU=;
 b=g8P0cXOkP0YijcyWCsdXW8hZOB9S0cQ93+cAoJfhsm2xVMhlfSs5htxEMppuoJivGWTq
 4o7bpg4QhumPxlzN+DIWfJ9TZ4M1S2Ms/iIui1uQCQlJRpMqMI/kekqfhyUQhTzhVaL/
 skZDOYQ3faN1LLjmyia8ITN+4AiFPzYHELyz1iBJRc1tgqC3geQKMhZ963fuKFFv69oy
 j84qQOmAH2EU4n0ZX3wny6IwmNJA+hkvQjlIKkxff2u8SqiF+YIcwsJnC+7GMMq6Mkrc
 9rXvwocJbdnxBuyIeczB269uJFxvpJZTJDu6h7OdpOK62tFjf0Y65Ey/LV4YJlHKdRXF Og== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3de4w5h9j8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 16:59:35 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 6 Jan
 2022 16:59:33 -0800
Received: from ahp-hp.devlab.local (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 6 Jan 2022 16:59:33 -0800
From:   Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
To:     <andrew@lunn.ch>
CC:     <aelior@marvell.com>, <netdev@vger.kernel.org>,
        <palok@marvell.com>, <vbhavaraju@marvell.com>
Subject: Re: [PATCH net-next v2 1/1] qed: add prints if request_firmware() failed
Date:   Thu, 6 Jan 2022 09:58:26 -0800
Message-ID: <20220106175826.667160-1-vbhavaraju@marvell.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <Yc3hN/BTYtoKBLnC@lunn.ch>
References: <Yc3hN/BTYtoKBLnC@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: FRtHNRZ9GqejyOlIbaFIvsJUTpIdjavh
X-Proofpoint-GUID: FRtHNRZ9GqejyOlIbaFIvsJUTpIdjavh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_10,2022-01-06_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Anyway, from what Jakub is saying, you don't need the print at all.
> 

Thanks for the inputs. We can close this patch request.
