Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39C22C14BA
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbgKWTsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:48:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730764AbgKWTsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:48:22 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJW4GO081859;
        Mon, 23 Nov 2020 14:48:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=DueikaWdt4eAgq6mXBuQOf4tVyxdnsqeGtZbgVApeC4=;
 b=mKPTsGI9KQAegykXslejFtYgC9y3vYuREGR62I9pMCl6n8hvRW5CJKbDuhf19mD0j6Ct
 9NRInEtmECfsuVXqUEqGWPWqJK4vDJ6MUyCy3LBi3Ku09DbUQi0t94l0oAa/neAwGEXe
 yo+rKC+DfawlmsW0/3orM1YptMbebxneKlAyVpf/4srVPX3ladrCQgNW+zSnbdVK6LG8
 lxGUWUj878GdnpxAhl14BIxeeFukHjdRTLJ/49W+HVZOSVD1qeWoIYxm8gq1s6Miiqy4
 Uar13q2u9LSWKeMEEo0QqLojY/mPi6zLM7L2FV6cul7qGv9vlnUwtoANuluiZ3CxplQ+ dw== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350fe71efx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 14:48:20 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJkpBY014362;
        Mon, 23 Nov 2020 19:48:19 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 34xth8ss1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 19:48:19 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANJm9Aw13500938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 19:48:09 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D38E8136053;
        Mon, 23 Nov 2020 19:48:18 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96AC413604F;
        Mon, 23 Nov 2020 19:48:18 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.207.248])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 19:48:18 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 230752E0643; Mon, 23 Nov 2020 11:48:15 -0800 (PST)
Date:   Mon, 23 Nov 2020 11:48:14 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        drt@linux.ibm.com
Subject: Re: [PATCH net 15/15] ibmvnic: add some debugs
Message-ID: <20201123194814.GA2084825@us.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
 <20201120224049.46933-16-ljp@linux.ibm.com>
 <20201121154549.10f6fb7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121154549.10f6fb7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1011 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Fri, 20 Nov 2020 16:40:49 -0600 Lijun Pan wrote:
> > From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> > 
> > We sometimes run into situations where a soft/hard reset of the adapter
> > takes a long time or fails to complete. Having additional messages that
> > include important adapter state info will hopefully help understand what
> > is happening, reduce the guess work and minimize requests to reproduce
> > problems with debug patches.
> 
> This doesn't qualify as a bug fix, please send it to net-next.

Ok.

> 
> > +	netdev_err(adapter->netdev,
> > +		   "[S:%d FRR:%d WFR:%d] Done processing resets\n",
> > +		   adapter->state, adapter->force_reset_recovery,
> > +		   adapter->wait_for_reset);
> 
> Does reset only happen as a result of an error? Should this be a
> netdev_info() instead?

It is an informational message, will change to netdev_info().

Thanks,

Sukadev
