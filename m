Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAA8553686
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 17:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353077AbiFUPo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 11:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353052AbiFUPo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 11:44:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B670B2C13B;
        Tue, 21 Jun 2022 08:44:55 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LFfivU026322;
        Tue, 21 Jun 2022 15:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jwoinGwigM1Rz9eS0VWIGtgXQJd3BqSXbIXRF/4T1+E=;
 b=aa7+xLaxqINxa2FN69V6g7NPY4VxrW0VQ5OpL21uGUrJlEsmmEwPQSAM5uZ0oUqFKnYT
 QSX+Jf1Xi8fkXNB1eKwqBL+tjDCN3Y9iSNfWZBxjcyGSz1gNicqWgNInpP2Lgtdje8Vw
 QU0qKhRRoWtl8Q7tepznXzKG82CNvZzSUpn/LweyxfSF1dHttJBjVjGoXr7b/nglewqi
 vjyh0A5zzXsFHY2DEN1umvb1Moxei/T0XscuWcPH6hrlzQNjGtkN0CyjpjDlw+LZKKku
 cT9hMm/xpDCh2pdsXFDsuxwsmAvnefLMqwGysRQfAnghwJg+O4yneYlv+sylO6+9OSnW cQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugurr2gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:44:49 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFYng9005399;
        Tue, 21 Jun 2022 15:44:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3gs6b93c8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:44:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFinlw25624854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:44:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 616DFA404D;
        Tue, 21 Jun 2022 15:44:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3F80A4040;
        Tue, 21 Jun 2022 15:44:43 +0000 (GMT)
Received: from [9.152.224.195] (unknown [9.152.224.195])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:44:43 +0000 (GMT)
Message-ID: <7a935730-f3a5-0b1f-2bdc-a629711a3a01@linux.ibm.com>
Date:   Tue, 21 Jun 2022 17:44:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] net: s390: drop unexpected word "the" in the comments
Content-Language: en-US
To:     Joe Perches <joe@perches.com>, Jiang Jian <jiangjian@cdjrlc.com>
Cc:     wenjia@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220621113740.103317-1-jiangjian@cdjrlc.com>
 <09b411b2-0e1f-26d5-c0ea-8ee6504bdcfd@linux.ibm.com>
 <a502003f9ba31c660ddb9c9d8683b7b2a01d12f7.camel@perches.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <a502003f9ba31c660ddb9c9d8683b7b2a01d12f7.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RCjcwSm8FOCiCXSe8SwVBSETVHwew8Y0
X-Proofpoint-ORIG-GUID: RCjcwSm8FOCiCXSe8SwVBSETVHwew8Y0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1011 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.06.22 17:01, Joe Perches wrote:
> On Tue, 2022-06-21 at 13:58 +0200, Alexandra Winter wrote:
>> On 21.06.22 13:37, Jiang Jian wrote:
>>> there is an unexpected word "the" in the comments that need to be dropped
> []
>>> * have to request a PCI to be sure the the PCI
>>> * have to request a PCI to be sure the PCI
> []
>>> diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
> []
>>> @@ -3565,7 +3565,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
>>>  			if (!atomic_read(&queue->set_pci_flags_count)) {
>>>  				/*
>>>  				 * there's no outstanding PCI any more, so we
>>> -				 * have to request a PCI to be sure the the PCI
> 
> Might have intended "that the" and not "the the"
> 
>>> +				 * have to request a PCI to be sure the PCI
>>>  				 * will wake at some time in the future then we
>>>  				 * can flush packed buffers that might still be
>>>  				 * hanging around, which can happen if no
> 
> And this is a relatively long sentence.
> 
> Perhaps something like:
> 
> 			if (!atomic_read(&queue->set_pci_flags_count)) {
> 				/*
> 				 * there's no outstanding PCI any more so:
> 				 * o request a PCI to be sure that the PCI
> 				 *   will wake at some time in the future
> 				 * o flush packed buffers that might still be
> 				 *   hanging around (which can happen if no
> 				 *   further send was requested by the stack)
> 				 */
> 

No, don't remove the word 'then'
Not-Acked-by: Alexandra Winter <wintera@linux.ibm.com>

Jiang, if you want to submit another patch, 
You could split the long sentence:
			if (!atomic_read(&queue->set_pci_flags_count)) {
 				/*
 				 * there's no outstanding PCI any more, so we
-				 * have to request a PCI to be sure the the PCI
- 				 * will wake at some time in the future then we
+				 * have to request a PCI to be sure the PCI
+ 				 * will wake at some time in the future. Then we
 				 * can flush packed buffers that might still be
 				 * hanging around, which can happen if no

I don't think this is a significant improvement in readability, though.
