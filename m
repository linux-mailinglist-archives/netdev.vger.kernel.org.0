Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325FE2CCD5D
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgLCDeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 22:34:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14158 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727281AbgLCDeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:34:10 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B33W8KI177429;
        Wed, 2 Dec 2020 22:33:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=/npsrlBudBynMJDZ0gzIRv1BmvFtcTJqlnYkh51T48A=;
 b=JdTw41uKcXkqtra5oCi2meGcszn+ByoDOfQgIiwnP5I23TupwmiLR0rML8d789fOl79+
 XLlmZWdwUC0q/mLJCcIY+oGq5ZOE54x9aCuZEdOo+FUdHJzVP/KBqtlcRnNyjwNhG4W9
 eaLzc44mH8vYM0CgHM8jXPZj5xyBrpF96ZkQcHqzavb0UvwcEaWNyL93QiMQPH+BiD+B
 qYKulOZtKB4o+IbhF8J3WUJWa+GsXlvlGWIpibIINKDFDoTjiwyW5Ezelau9oKDCxrox
 lkhahrCzx0dDnE2iD6Uc9bQbtFkDgOXmXdFP/0HCgTtaN94lyk/Vq14xjKjr0EP4+zFX Dg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355k1a2p6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 22:33:26 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B33ScVw001148;
        Thu, 3 Dec 2020 03:33:25 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 353e69pwr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 03:33:25 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B33XEQM14615076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 03:33:14 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49C39C6055;
        Thu,  3 Dec 2020 03:33:24 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C44BC6057;
        Thu,  3 Dec 2020 03:33:24 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.139.203])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Dec 2020 03:33:23 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 8E0032E0CDB; Wed,  2 Dec 2020 19:33:19 -0800 (PST)
Date:   Wed, 2 Dec 2020 19:33:19 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH net-next v2 1/1] ibmvnic: add some debugs
Message-ID: <20201203033319.GA2305828@us.ibm.com>
References: <20201124043407.2127285-1-sukadev@linux.ibm.com>
 <20201124095949.1828b419@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124095949.1828b419@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_14:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=1 bulkscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Mon, 23 Nov 2020 20:34:07 -0800 Sukadev Bhattiprolu wrote:
> > We sometimes run into situations where a soft/hard reset of the adapter
> > takes a long time or fails to complete. Having additional messages that
> > include important adapter state info will hopefully help understand what
> > is happening, reduce the guess work and minimize requests to reproduce
> > problems with debug patches.
> > 
> > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> > ---
> > 
> > Changelog[v2]
> > 	[Jakub Kacinski] Change an netdev_err() to netdev_info()? Changed
> > 	to netdev_dbg() instead. Also sending to net rather than net-next.
> > 
> > 	Note: this debug patch is based on following bug fixes and a feature
> > 	from Dany Madden and Lijun Pan:
> 
> In which case you need to wait for these prerequisites to be in net-next
> and then repost.

Jakub,

A process question that I could not find an answer to on the netdev FAQ.

With commit 98c41f04a67a ("ibmvnic: reduce wait for completion time")
the pre-requisites for the above patch are in the net tree but not yet
in net-next.

When net-next is open, does it get periodically rebased to net tree or
does the rebase happen only when net-next closes?

If latter, should I resend above patch based on net-next and handle a
manual merge during the rebase? (There is no functional dependence on
the pre-reqs - just needs a manual merge).

Thanks,

Sukadev
