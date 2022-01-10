Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFDB48A269
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 23:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345240AbiAJWFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 17:05:40 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30892 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241701AbiAJWFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 17:05:33 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlXpW026179;
        Mon, 10 Jan 2022 22:04:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=wGcp09mZhBF7/XPqabHSsScYVXwvFU4zogbZn4w8Jo0=;
 b=PNfrIQhmeMKNdwfaq2NsaMvc3xhsBkg0/e7HzhwUVUUB1UVsdQZsyYJ9WtwT8AQtttKM
 AWLDmE3MBPSg+jxO9CMOLlfatAH9EkxhhhECk9B5TonY0bg+nufI+1kco0OmDuqybW9C
 fpY35MtNVPS4QlswoHqHxoXuen55mKBCSx/UVJhBcn80lUfcXn154sUQgvWhbTFhnpmg
 7r+ANABR0R0kVw52lzlTSnFfLelUNUnFxQ2UZWUDIl0vtGjA0EsQMLdCrGZq7T7GLIwv
 q5IPM3FrGckq6VOCs6veKNbHCmOIVb+Bwi2/WezWLnAIAal9Q2khT04+PZiZ78pYBiIi Dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjtg9svh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ALtvuh139009;
        Mon, 10 Jan 2022 22:04:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:50 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 20AM4iC8174082;
        Mon, 10 Jan 2022 22:04:50 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqp8-6;
        Mon, 10 Jan 2022 22:04:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, jejb@linux.ibm.com,
        skashyap@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jhasan@marvell.com, linux@armlinux.org.uk
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] scsi: qedf: potential dereference of null pointer
Date:   Mon, 10 Jan 2022 17:04:38 -0500
Message-Id: <164182835583.13635.8893897852615126704.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211216101449.375953-1-jiasheng@iscas.ac.cn>
References: <20211216101449.375953-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: zmYrn3xPA90eC91y0V1gBAtVbL4Ywu8X
X-Proofpoint-ORIG-GUID: zmYrn3xPA90eC91y0V1gBAtVbL4Ywu8X
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 18:14:49 +0800, Jiasheng Jiang wrote:

> The return value of dma_alloc_coherent() needs to be checked.
> To avoid use of null pointer in case of the failure of alloc.
> 
> 

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi: qedf: potential dereference of null pointer
      https://git.kernel.org/mkp/scsi/c/aa7069d840da

-- 
Martin K. Petersen	Oracle Linux Engineering
