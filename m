Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EE71BBD10
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 14:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgD1MH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 08:07:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgD1MHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 08:07:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SC3SLM037296;
        Tue, 28 Apr 2020 12:06:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OSf6jYhMrgn/dtTnYSI73L6/78HrXWbkBlk67OBSPnA=;
 b=rO+Phk3amJ6wJjrSEgneLJoNdCOWQEChKG8r8NYnFFIEcRQh+MJSJkmsknbCkKd2H5Dx
 ke9TGc7Avzv6OaYyC2rfBqo30QZ47ubVU14ZDYQWPvfuthALUDbfhJp1D8zXGJmbev5P
 EjR8fSc9c/KBJXUQADZZur+ram+UBeV7SxiyDrJA2xc7F5lhrQ/2QmfuWp1fyaatlVYp
 5Co6yfDSUUZhzlDsOnhmoCuK45U3TPLZmXQqqpQnTp0r2DsV9D05OnHpq0Af6TfEs793
 G7GfRNfx76JLBlIXEBHZtIgXrwgU9YJrprYYxmrmkEnOqiIf7pWB1pFGg8JRL32a/BPM 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30p2p04qng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 12:06:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SC2AoX004893;
        Tue, 28 Apr 2020 12:04:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30mxwyk421-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 12:04:56 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SC4rdL001889;
        Tue, 28 Apr 2020 12:04:53 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 05:04:52 -0700
Date:   Tue, 28 Apr 2020 15:04:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Rylan Dmello <mail@rylan.coffee>,
        Kaaira Gupta <kgupta@es.iitr.ac.in>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Benjamin Poirier <bpoirier@suse.com>,
        Jiri Pirko <jpirko@redhat.com>
Subject: Re: [PATCH 1/3] staging: qlge: Remove unnecessary parentheses around
 struct field
Message-ID: <20200428120445.GB2014@kadam>
References: <cover.1587959245.git.mail@rylan.coffee>
 <4dea7a7fae6a56c51cc19228b82a3c230029f54b.1587959245.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dea7a7fae6a56c51cc19228b82a3c230029f54b.1587959245.git.mail@rylan.coffee>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=25 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1011
 bulkscore=0 adultscore=7 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 12:14:11AM -0400, Rylan Dmello wrote:
> Remove unnecessary parentheses around a struct field accessor that
> causes a build failure when QL_DEV_DUMP is set.
> 
> Signed-off-by: Rylan Dmello <mail@rylan.coffee>

Add a Fixes tag.

Fixes: 67e6cf7338e1 ("staging: qlge: add braces around macro arguments")

regards,
dan carpenter

