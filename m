Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E0F476471
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 22:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhLOVRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 16:17:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36422 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhLOVRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 16:17:31 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFInvWV001442;
        Wed, 15 Dec 2021 21:17:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=74ZFvkMrdHAXb2y1KAXMhEUvBp7jYgu6p6QBZ3c3DE4=;
 b=KkiXmuglHTbKOeBumGYZcl6omjFGuuMP9t3XOIJyUtUgcE+UeodJs6z8QVqZKY8UTsh0
 U8H9z63RShGQ/HRsmnXODiJxfBgqkFmuASf/JlUBJQ0iE7t1PrFQSIasZgJlXY2hAnJ2
 gHp9kiXGoS90JuBuvLIN7KGMuSy+sGa6QCaZpJPKEhekK9Mt+FSpgxOMAFfQybpWlgcW
 nq3EqXLy+T6o+cuDdPZ/AZqO+yyhG+4WOfuBEtWVnR54FHWRsWzvtxw05Keyn2tRDQV8
 8IyeaTFQyk7lS+N6cbJ88w2IzRJT6d0evf3xkt2hUnPHSI+Vs1WdbEyfHYxKSYNrZXIo og== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyp04jrnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 21:17:30 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BFLCtXa017487;
        Wed, 15 Dec 2021 21:17:30 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 3cy7gbc26f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 21:17:30 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BFLHTcY13107768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 21:17:29 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49694C607B;
        Wed, 15 Dec 2021 21:17:29 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A117FC6061;
        Wed, 15 Dec 2021 21:17:28 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.65.207.4])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with SMTP;
        Wed, 15 Dec 2021 21:17:28 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 4411D2E0B34; Wed, 15 Dec 2021 13:17:23 -0800 (PST)
Date:   Wed, 15 Dec 2021 13:17:23 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, ricklind@linux.ibm.com,
        brking@linux.ibm.com, otis@otisroot.com
Subject: Re: [PATCH net 1/2] ibmvnic: Update driver return codes
Message-ID: <YbpbYxKo1csrV7Lr@us.ibm.com>
References: <20211214051748.511675-1-drt@linux.ibm.com>
 <20211214051748.511675-2-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214051748.511675-2-drt@linux.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Vz0owlyz8YN8F4tFVvD7-m9wy3mTA6es
X-Proofpoint-ORIG-GUID: Vz0owlyz8YN8F4tFVvD7-m9wy3mTA6es
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_12,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=986 spamscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dany Madden [drt@linux.ibm.com] wrote:
> Update return codes to be more informative.
> 
> Signed-off-by: Jacob Root <otis@otisroot.com>
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
