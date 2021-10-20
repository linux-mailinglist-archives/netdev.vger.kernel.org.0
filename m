Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0654355DC
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhJTWcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:32:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhJTWcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:32:47 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KKqXHX019402;
        Wed, 20 Oct 2021 18:30:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/2tM2Tu0qg6Ckz7lDSXiFvjULjfikI2A8y55SgthWJs=;
 b=fES68q1ucoo8uX/FSQUvofMuWiui+1og54WGObw4QtSBfE1FNqc6v/jX+9MJvBPvAtHY
 qiz0B2ttGKljV+XRnoYnYbeZJQ0oF7uroY8Nx8equ8+oaKv/Z+fwzVx5MD3n3eb2tqj8
 De/lSvfeXPwagPSqv151qje8rirxhZKly3LdDk8XdgIInhea1p8WefBzgmAXC7U9oMfP
 3N1S0H5Xnio6+0gUeXghm2EwjfXNcN/WJ0inoEJOaTP+Lo+pXySkdEnXDMf0wfICJJc+
 zlnPuEnLf5GwNZy3lXhcq/TrUtu21CHzcr0nnc7ht/qWeiSyPthvVETugPRxtRwUMbMc Xw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btthk9hm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 18:30:31 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19KMINMu012012;
        Wed, 20 Oct 2021 22:30:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpcb0we4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 22:30:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19KMUOqS5243452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 22:30:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 338A54C058;
        Wed, 20 Oct 2021 22:30:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D65634C052;
        Wed, 20 Oct 2021 22:30:23 +0000 (GMT)
Received: from [9.171.8.207] (unknown [9.171.8.207])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Oct 2021 22:30:23 +0000 (GMT)
Message-ID: <a028714d-6e69-dc7b-1b94-d946a7ecc942@linux.ibm.com>
Date:   Thu, 21 Oct 2021 00:30:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 09/12] net: s390: constify and use
 eth_hw_addr_set()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org
References: <20211020155617.1721694-1-kuba@kernel.org>
 <20211020155617.1721694-10-kuba@kernel.org>
From:   Julian Wiedmann <jwi@linux.ibm.com>
In-Reply-To: <20211020155617.1721694-10-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5h63jMOcDGiP5PWi0TpM_qORtmSmaVqC
X-Proofpoint-GUID: 5h63jMOcDGiP5PWi0TpM_qORtmSmaVqC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_06,2021-10-20_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.10.21 17:56, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Make sure local references to netdev->dev_addr are constant.
> 

Acked-by: Julian Wiedmann <jwi@linux.ibm.com>

Thanks Jakub. I suppose at some point __dev_addr_set() will then
become more than just a memcpy, correct?
