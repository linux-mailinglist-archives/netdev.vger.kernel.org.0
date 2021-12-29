Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1164815F9
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 19:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241184AbhL2SDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 13:03:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28688 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229778AbhL2SDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 13:03:36 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BT9SYsD007769;
        Wed, 29 Dec 2021 10:03:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=GfXDW6nsQK6FRgOsN7x2ez8cdVd1GJO9eUvP/t4Uv1c=;
 b=cdWcVn8hqfF9B5iSVuG2xz0msr8pr4cyzND4vD7rNEZzxG0QV1CZgFpcMBUe3yhU9Hf4
 1qvgpHxGHB45Gv8LwUO6PxMKNybbkWZDRMBIUepUxs7IDotCw+MJlCu4aSLCp8OvUjid
 ygVKN/+IYgXd0xpn2+/+ho5ywtQmk2QNrznJheY2f+Pu8MQ1R5PFDMio7Ilm7T3yVEfJ
 Lvaid3V0IqdNDnvB15EL3N8xOxpvQa8zAqNXMz8rZHHHksO+IID0Sl35ZH62cSNHvFGv
 nIe4mEHl7MSyBf91KArRZBdxyqVjjIS/D9FLHdlqquvGi6IWfXavEh36sDVf88teoaer cA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3d8n2vhcbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 10:03:31 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Dec
 2021 10:03:30 -0800
Received: from ahp-hp.devlab.local (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Dec 2021 10:03:30 -0800
From:   Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
To:     <andrew@lunn.ch>
CC:     <aelior@marvell.com>, <netdev@vger.kernel.org>,
        <palok@marvell.com>, <vbhavaraju@marvell.com>
Subject: Re: [PATCH net-next v2 1/1] qed: add prints if request_firmware() failed
Date:   Wed, 29 Dec 2021 03:02:32 -0800
Message-ID: <20211229110232.336845-1-vbhavaraju@marvell.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <YcrmpvMAD5zKHqTE@lunn.ch>
References: <YcrmpvMAD5zKHqTE@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 435mYj5O50PdIpgOn2Ec-QTUg5RvZyaD
X-Proofpoint-GUID: 435mYj5O50PdIpgOn2Ec-QTUg5RvZyaD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_06,2021-12-29_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Venkata
> 
> When you decide to do something different to what has been requested,
> it is a good idea to say why. There might be a very good reason for
> this, but unless you explain it, i have no idea what it is.
> 
>    Andrew

Hello Andrew,

I moved the FW_REPO macro to qed_if.h under include/linux since I didn't
want to bloat something like include/linux/firmware.h. It's really used
(exact URL in a print after request_firmware() fails) at two other places.

If you think it's more useful in include/linux/firmware.h so that other
drivers can make use of it in future, I can move it there.

-Venkata
