Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A3025822A
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgHaTyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:54:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34854 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728724AbgHaTyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:54:11 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VJVxd9025210;
        Mon, 31 Aug 2020 15:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=e3FkAHH1RAOyd7YyA/GypPugp9u3XfGHSATM4hc66K4=;
 b=evFtesMSoPAm+OoRGMJcvC01Xf4Sp2xB/hUfTg1tm2s1l+4kGiPh0RtOBBDKabPtGkoI
 P8mmMyjFi2M9zQfmgElZK+ec0KjdQWjuNwbTGjmer9XE6lM7jnjScrnyMTyy2BBo38jM
 I29+yba/sq38Z8dA47VvdSADRnmpIpn0ebCwUfUyBac0TWxlDfWLS+hw2Q7D9cmTuuLX
 FiU+UPXxsAvrFjJpLsAb9tML2zRqhqGX6oXvFx/smOSIL6g6TNN4KSowmtb0DORTuOU5
 CApGibO/VPNuuo1EjxYd6tz3f5tWb+uH0sMpfpK5FqtoE8FShTRa3kE+DXs4MjMGy0DX /g== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3396e321q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 15:54:09 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VJpkEE017369;
        Mon, 31 Aug 2020 19:54:08 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 337en8q5b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 19:54:08 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VJs76R51315050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 19:54:08 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C926728058;
        Mon, 31 Aug 2020 19:54:07 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DEE028059;
        Mon, 31 Aug 2020 19:54:07 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 19:54:07 +0000 (GMT)
Subject: Re: [PATCH net-next 5/5] ibmvnic: Provide documentation for ACL sysfs
 files
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, ljp@linux.vnet.ibm.com,
        cforno12@linux.ibm.com
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
 <1598893093-14280-6-git-send-email-tlfalcon@linux.ibm.com>
 <20200831122653.5bdef2f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <d88edd04-458e-b5a5-4cc0-e91c4931d1af@linux.ibm.com>
Date:   Mon, 31 Aug 2020 14:54:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200831122653.5bdef2f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_09:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=963
 spamscore=0 impostorscore=0 clxscore=1011 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/20 2:26 PM, Jakub Kicinski wrote:
> On Mon, 31 Aug 2020 11:58:13 -0500 Thomas Falcon wrote:
>> Provide documentation for ibmvnic device Access Control List
>> files.
> What API is used to set those parameters in the first place?
>
These parameters are specified in the system's IBM Hardware Management 
Console (HMC) when the VNIC device is create.
