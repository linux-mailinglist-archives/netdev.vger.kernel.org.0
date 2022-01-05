Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDAA485918
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243488AbiAETYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:24:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243475AbiAETYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:24:20 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205HhpKd029039;
        Wed, 5 Jan 2022 19:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=un2SwvqOfgwpXgpDgEw1KPu0YtvgczMMQYjNNETeXC0=;
 b=RRXEOqi2lW+lBrWCrhxNUUJ6tY49ZKdBBxZ5zhnQfOSIEzmiIXATwxfviPwB43mjg8a0
 H8wxt6I1fxp7+MoS7q4AnIQhqeDErXgTv5Kk4ntIsyNl8qnYF2o6jYWwFDPlwZOX7Wsc
 kGP+4SZHQ+FH7zpHpUEgaaIgz7z9U1aKw6eLF0YY1EhB9FIqFlE9CWGMzJDqhjy5suyA
 krTJdLrGo8OjC8yUnBa5gBZS6IQouGSfX4Hf5cZBvCD1kPb36McFvQ2W4/ld2ALf0Kx1
 71c8lHJ+90q22X8l6dt/oB4yS+1MnxTkW3YzsodSanFPydcJrrQQjxqkNpXMt4Ue411T fw== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dckgprm3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 19:23:56 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 205JMjwN029613;
        Wed, 5 Jan 2022 19:23:55 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 3daekb4cwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 19:23:55 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 205JNsro6030174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jan 2022 19:23:54 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A111728060;
        Wed,  5 Jan 2022 19:23:54 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B83728074;
        Wed,  5 Jan 2022 19:23:53 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.94.20])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jan 2022 19:23:53 +0000 (GMT)
Subject: Re: [PATCH] ethernet: ibmveth: use default_groups in kobj_type
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Cristobal Forno <cforno12@linux.ibm.com>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
References: <20220105184101.2859410-1-gregkh@linuxfoundation.org>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <c4c5ae29-0e09-1970-bac2-cab1f2ae1efc@linux.ibm.com>
Date:   Wed, 5 Jan 2022 11:23:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20220105184101.2859410-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EMpFhwCOKMdlVXR2fLgVVxI86YvvEgHc
X-Proofpoint-ORIG-GUID: EMpFhwCOKMdlVXR2fLgVVxI86YvvEgHc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_05,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 clxscore=1011
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201050123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 10:41 AM, Greg Kroah-Hartman wrote:
> There are currently 2 ways to create a set of sysfs files for a
> kobj_type, through the default_attrs field, and the default_groups
> field.  Move the ibmveth sysfs code to use default_groups
> field which has been the preferred way since aa30f47cf666 ("kobject: Add
> support for default attribute groups to kobj_type") so that we can soon
> get rid of the obsolete default_attrs field.
> 
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Cristobal Forno <cforno12@linux.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>

