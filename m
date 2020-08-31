Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1172258415
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 00:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgHaWab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 18:30:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728083AbgHaWaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 18:30:30 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VM2ZB8027573;
        Mon, 31 Aug 2020 18:30:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mQ8ozyfAso7+rmhLKcsianZiY7XaOYoesJId1Z6OXxU=;
 b=pZ4hizwSEzo0INAheH/DZaFW8RoHvt+nov38SL3mUi/X30Iru6zc8EOsqqqcsIrGdpSx
 ANzWrTXkT3ivOutD7JJYK46Gcdg7+dn2EzI7I7ZSjseChoWiLYYul3npEiJQ0QVqmRBc
 jz5xMzlwxEYhyNEU4Js/MCDwxbRZDrqOgJDjfVclym0p9SZMZgCCghZoaInAyiqWyyxk
 GLthgbaFeGI/WwcDK0+EHDAQ5iJZIPdON08zmggqFUOy4rJJMSQMyvZ9nY2gayIvFBn0
 dUyfvGObSkcv/QWEpNDSIR088ZQLQiQSFq0y2+zVULtiDHG4AFpC/bYyB7eMKNHdL3sw TA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3398g3j7pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 18:30:29 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VMR94S018943;
        Mon, 31 Aug 2020 22:30:27 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma05wdc.us.ibm.com with ESMTP id 337en93cgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 22:30:27 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VMUR5K42336604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 22:30:27 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63B722805A;
        Mon, 31 Aug 2020 22:30:27 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B661128058;
        Mon, 31 Aug 2020 22:30:26 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 22:30:26 +0000 (GMT)
Subject: Re: [PATCH net-next 5/5] ibmvnic: Provide documentation for ACL sysfs
 files
To:     David Miller <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, ljp@linux.vnet.ibm.com,
        cforno12@linux.ibm.com
References: <20200831131158.03ac2d86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <fa1d1efb-d799-a1e1-5e1e-8795d5d6cda7@linux.ibm.com>
 <20200831150050.3cadde6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200831.151757.1112716052657607181.davem@davemloft.net>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <785321e0-aded-357a-0305-f3b2d2b7df87@linux.ibm.com>
Date:   Mon, 31 Aug 2020 17:30:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200831.151757.1112716052657607181.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_10:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/20 5:17 PM, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Mon, 31 Aug 2020 15:00:50 -0700
>
>> On Mon, 31 Aug 2020 16:44:06 -0500 Thomas Falcon wrote:
>>> On 8/31/20 3:11 PM, Jakub Kicinski wrote:
>>>> This seems similar to normal SR-IOV operation, but I've not heard of
>>>> use cases for them VM to know what its pvid is. Could you elaborate?
>>> It's provided for informational purposes.
>> Seems like an information leak :S and since it's equivalent to the
>> standard SR-IOV functionality - we'd strongly prefer a common
>> interface for all use cases. sysfs won't be it. Jiri & Mellanox had
>> been working on something in devlink for quite some time.
> Agreed, Thomas please work with Jiri et al. so that you can provide
> this information using a standard facility.
>
> Thanks.

Thank you for the feedback. I will look into that.

