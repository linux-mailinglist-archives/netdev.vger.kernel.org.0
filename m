Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849311BBD16
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 14:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgD1MIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 08:08:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgD1MIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 08:08:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SC3Sq7037375;
        Tue, 28 Apr 2020 12:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gANKfJoeceEgfA8OPvEctrQTZEimU2IEnD1yXfT1iDY=;
 b=CGnFDgP8uGkoeRuGsBIUkgjTJxg2ILIBDd8WrEJmIdaft/z/jcsiGdF5e9rYtysQJGIz
 PEXV5SZKIYfeyy1geKu7TkifjYTZJPhFCcdT535lIb0VShmiPVVa0s/FapYhJixilscE
 P+7NgfQ4EcVjxL1bsv9ffp94k7ZDfXl0bW6DhlhouGcsPnxy3NyBBGWO0jKaX/LinNFN
 cGZHf0RtYvARScQpb3oKOHbIlon5RMlKJmZgsb43rZM2TfUswI+8kz3u2fvqj2VayWHE
 6msE6b0VQ2X6g6sRUZYlnYDdnz8W3NkgL6uHJZUOVzwaPKPEIben6hcFGCc2CbefUr3i jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30p2p04qu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 12:08:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SC37pf112483;
        Tue, 28 Apr 2020 12:08:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30mxpftfqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 12:08:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03SC85KX032436;
        Tue, 28 Apr 2020 12:08:05 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 05:08:05 -0700
Date:   Tue, 28 Apr 2020 15:07:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Rylan Dmello <mail@rylan.coffee>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Benjamin Poirier <bpoirier@suse.com>,
        Jiri Pirko <jpirko@redhat.com>
Subject: Re: [PATCH 3/3] staging: qlge: Remove print statements for
 lbq_clean_idx and lbq_free_cnt
Message-ID: <20200428120757.GD2014@kadam>
References: <cover.1587959245.git.mail@rylan.coffee>
 <aa7e0197f4e34cec0855124e45696e33dd9527e5.1587959245.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa7e0197f4e34cec0855124e45696e33dd9527e5.1587959245.git.mail@rylan.coffee>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=2
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=2 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 12:15:18AM -0400, Rylan Dmello wrote:
> Remove debug print statements referring to non-existent fields
> 'lbq_clean_idx' and 'lbq_free_cnt' in the 'rx_ring' struct, which causes
> a compilation failure when QL_DEV_DUMP is set.
> 
> These fields were initially removed as a part of commit aec626d2092f
> ("staging: qlge: Update buffer queue prod index despite oom") in 2019.
> 
> Their replacement fields ('next_to_use' and 'next_to_clean') are already
> being printed, so this patch does not add new debug statements for them.
> 
> Signed-off-by: Rylan Dmello <mail@rylan.coffee>


Fixes: aec626d2092f ("staging: qlge: Update buffer queue prod index despite oom")

regards,
dan carpenter

