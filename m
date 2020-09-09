Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42C826359F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIISKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:10:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1410 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbgIISKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:10:30 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 089I2Bm4178311;
        Wed, 9 Sep 2020 14:10:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SiHYjGluMRfDG59mtv6zEykHLJVg0oTFitkp2ewiU7Y=;
 b=c4fbNyqFBkM4g5x9/3jTDBE6Q5loTT/ARGstWWgQI9nS/z+ISp/Z4cKRYKPejDrRisHx
 RBd7dFp73hUWwxqS/wTFeQ334hXrFVHxK8+suS4sJbfAMx2Fu85JJZ/UvBSb5hpIk9r8
 pGK2vqsHGV1ivf9/GMqggn4+6HDcIDs9L8G9JzZJ/2RUwh4S/z83K9Z2XLi51hvCOcWQ
 h9FCOnf0lggVAn14vpQRQkSHVVcAouN8xL7TDdXvST1wEl9EVPnwAzVCSrLdGJLxgLue
 jHkeBcIVhljDy8e3MHPPxS9y1sPDViauXg/m+y85Igq752ImflDYYO65eXqttYBqeXMd pw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33f3c91ny8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 14:10:22 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 089I8KYQ018941;
        Wed, 9 Sep 2020 18:10:21 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 33c2a99t8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 18:10:21 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 089IAKEI50397464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Sep 2020 18:10:20 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F38B62805A;
        Wed,  9 Sep 2020 18:10:19 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 428F72805C;
        Wed,  9 Sep 2020 18:10:19 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.212.245])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  9 Sep 2020 18:10:19 +0000 (GMT)
Subject: Re: [PATCH net] ibmvnic: add missing parenthesis in do_reset()
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, mmc@linux.vnet.ibm.com, drt@linux.ibm.com,
        jallen@linux.ibm.com
References: <20200905040749.2450572-1-kuba@kernel.org>
 <20200907140751.299c82ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <5ffbf039-fe8f-0896-2e08-71efdcc59006@linux.ibm.com>
Date:   Wed, 9 Sep 2020 13:10:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200907140751.299c82ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_12:2020-09-09,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/7/20 4:07 PM, Jakub Kicinski wrote:
> On Fri,  4 Sep 2020 21:07:49 -0700 Jakub Kicinski wrote:
>> Indentation and logic clearly show that this code is missing
>> parenthesis.
>>
>> Fixes: 9f1345737790 ("ibmvnic fix NULL tx_pools and rx_tools issue at do_reset")
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Applied now.
Thanks for noticing that!
