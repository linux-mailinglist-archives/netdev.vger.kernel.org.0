Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D581F794
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 17:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbfEOPbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 11:31:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33668 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfEOPbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 11:31:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4FFNsAX013479;
        Wed, 15 May 2019 15:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=BdPtnDR11Vdn7XWeNGSG6wyyu26x7E5yMudl0+Igi6Y=;
 b=uWWnZxvML88GDB2B0uUzOE8auo8d+Kcumm+yrje6UE4Io8lI4TzL64qQi9UaCu7LKHh9
 mmdesnwP0yVIdC38FHD1l3lgcXIxoxpkD3TlNEAgG5wY9zjeRkdva9ipeNaEmZR3ns5k
 hSQNSiNi9KNrPBUcHjXxcQEZzCHsLxVdhTA7PQHAnKbfxAy9a2nyuu+T28HTLfqBBHdd
 xZnwUVFMakHOPllfGxS4wkzapMc51X8c/nZVIqsYtie+2ksPEaTsFeWTszM4VqGs+AiD
 j+QKUOAfaCM9kSGPmxHAlKRdmEmRsXbwysXN/Sl/RWEDtN8h28+Rzt3wkYwjQLs3FZbb 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sdnttwnuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 15:31:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4FFTMHe069829;
        Wed, 15 May 2019 15:31:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sgk76jtdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 15:31:03 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4FFV1mJ022122;
        Wed, 15 May 2019 15:31:02 GMT
Received: from lap1 (/77.138.183.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 May 2019 08:31:01 -0700
Date:   Wed, 15 May 2019 18:30:51 +0300
From:   Yuval Shaia <yuval.shaia@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>
Subject: Re: CFP: 4th RDMA Mini-Summit at LPC 2019
Message-ID: <20190515153050.GB2356@lap1>
References: <20190514122321.GH6425@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514122321.GH6425@mtr-leonro.mtl.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9257 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905150095
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9257 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905150095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 03:23:21PM +0300, Leon Romanovsky wrote:
> This is a call for proposals for the 4th RDMA mini-summit at the Linux
> Plumbers Conference in Lisbon, Portugal, which will be happening on
> September 9-11h, 2019.
> 
> We are looking for topics with focus on active audience discussions
> and problem solving. The preferable topic is up to 30 minutes with
> 3-5 slides maximum.

Abstract: Expand the virtio portfolio with RDMA 

Description:
Data center backends use more and more RDMA or RoCE devices and more and
more software runs in virtualized environment.
There is a need for a standard to enable RDMA/RoCE on Virtual Machines.
Virtio is the optimal solution since is the de-facto para-virtualizaton
technology and also because the Virtio specification allows Hardware
Vendors to support Virtio protocol natively in order to achieve bare metal
performance.
This talk addresses challenges in defining the RDMA/RoCE Virtio
Specification and a look forward on possible implementation techniques.

> 
> This year, the LPC will include netdev track too and it is
> collocated with Kernel Summit, such timing makes an excellent
> opportunity to drive cross-tree solutions.
> 
> BTW, RDMA is not accepted yet as a track in LPC, but let's think
> positive and start collect topics.
> 
> Thanks
