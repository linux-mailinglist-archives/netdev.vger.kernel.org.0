Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501D5282AD6
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 15:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgJDNOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 09:14:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbgJDNOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 09:14:00 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 094D24QU028104;
        Sun, 4 Oct 2020 09:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=N845iz62l3kxl4ppjLCORup8geNzRAgQW4mhB3gQHbg=;
 b=Hlyxb8BhrO8NCJUBBbiehnblIOMYXgorDUWIo4CYcxhiWJhBlixJ+ZrN2wuYT6o2LuJP
 UPuaeJJvEwcOqGQ+ej3Lazl8FtGxsYUDSv8kV6ikpZ4dBfK8larEnKEPdvsbBE4WzUmV
 j1JmQ98IS5lPFZYwwqVeM9UaquAKD+5vymvMPMjSKFQvoHpy1cKN6k3qSY/tSGgYN/GS
 FPxvH1djBGCVFOhkqL8r6oXclpXn6ltdX8fSHDLrSWrXy6vYF10KN65ifUVxopiUMhve
 4nKTiRrYHPhjYAzKqhHnEvbHOUWudo4QH5arSEUq4DiD2amEZNnuVpX2QZxrzANOc8W2 dA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33yewrg6ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 04 Oct 2020 09:13:58 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 094D8qd7020041;
        Sun, 4 Oct 2020 13:13:56 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 33xgx80ksf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 04 Oct 2020 13:13:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 094DDrp732571800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 4 Oct 2020 13:13:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9AF111C04A;
        Sun,  4 Oct 2020 13:13:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4249611C04C;
        Sun,  4 Oct 2020 13:13:53 +0000 (GMT)
Received: from LAPTOP-VCUDA2TK (unknown [9.145.163.16])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun,  4 Oct 2020 13:13:53 +0000 (GMT)
Date:   Sun, 4 Oct 2020 15:14:00 +0200
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 1/2] net/smc: send ISM devices with unique chid
 in CLC proposal
Message-Id: <20201004151400.bb5b1aa84b08e45ea79b54e9@linux.ibm.com>
In-Reply-To: <20201003.170538.1607088552412478587.davem@davemloft.net>
References: <20201002150927.72261-1-kgraul@linux.ibm.com>
        <20201002150927.72261-2-kgraul@linux.ibm.com>
        <20201003.170538.1607088552412478587.davem@davemloft.net>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.30; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-04_09:2020-10-02,2020-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=795 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010040096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 03 Oct 2020 17:05:38 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> Series applied, but could you send a proper patch series in the future
> with a "[PATCH 0/N] ..." header posting?  It must explain what the
> patch series does at a high level, how it is doing it, and why it is
> doing it that way.
> 
> Thank you.

Hi Dave, not sure what went wrong but I sent the header posting along with
the patches, see https://lists.openwall.net/netdev/2020/10/02/197

-- 
Karsten Graul <kgraul@linux.ibm.com>
