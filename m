Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8EB43C794
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 12:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241409AbhJ0KZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:25:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239361AbhJ0KZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 06:25:56 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R7rXsQ012235;
        Wed, 27 Oct 2021 10:23:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=48fLikw6SyOBHDO/H66SAArPE2kSqQj6TDzueBTcFac=;
 b=QJ+fcYkiYmwKyPtJbKa2WTC18xBY6j6Ef19gSnE0mtoL5i1afOW4ZccsqLGRDXcHw3aO
 aMFAVk3sgWp2xj0nIoBHrvCL3TqCvCftrm30LpwhFLo59hMNvew+KVaJdRiX1FgGGOTP
 A7hRhDHB2KIKWKFfBs6P+l6ECdxCcw5VQR+VCLyU4wLX/hHW+vld8ftfW1sLsDTwBnGZ
 0rBOVh7CZQM1XPZpyZl7bJtbGadjJal++h30P/c59/aKMXUZBPiQuHHH8fkTrGhhp5JW
 CNH8RHNWgsYi/IX88VYUPk1Ke27j7N6R9moAzq3paiDvk0CS4R+oCuO8Cuj1I+f6+wRF pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3by2seb09b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:23:29 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19RAMQr7014614;
        Wed, 27 Oct 2021 10:23:29 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3by2seb08j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:23:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19RAEHnD025759;
        Wed, 27 Oct 2021 10:23:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3bx4ern2h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:23:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19RANNqw60293630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 10:23:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD47152067;
        Wed, 27 Oct 2021 10:23:23 +0000 (GMT)
Received: from [9.145.41.29] (unknown [9.145.41.29])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 46C9B52054;
        Wed, 27 Oct 2021 10:23:23 +0000 (GMT)
Message-ID: <64ccbcfb-f360-ed6f-3f64-e4c2fadf91d2@linux.ibm.com>
Date:   Wed, 27 Oct 2021 12:23:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net 3/4] net/smc: Correct spelling mistake to
 TCPF_SYN_RECV
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-4-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211027085208.16048-4-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8g_1oqeDUrAtduL8gU9h6aLE24HtQjsZ
X-Proofpoint-GUID: khizYZWFuJi7QjI_J7z4xvt38YLF7-xM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270062
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 10:52, Tony Lu wrote:
> From: Wen Gu <guwen@linux.alibaba.com>
> 
> There should use TCPF_SYN_RECV instead of TCP_SYN_RECV.

Thanks for fixing this, we will include your patch in our next submission
to the netdev tree.

