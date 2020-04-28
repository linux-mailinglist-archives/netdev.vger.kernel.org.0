Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6691BBD0F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 14:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgD1MHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 08:07:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58536 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgD1MHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 08:07:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SC3Stt037299;
        Tue, 28 Apr 2020 12:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=j1knl4efA5HJz7/bt0BDQ/AlQvPa1aZVt2yz7Wxx5D4=;
 b=sJAafU8K1pPo6h6EsDFIg3hhRDtlCE+2ft5cwucLMB5neN2u1Plz+Dx+4oWSMuVHwAgM
 eV2UdrRHHXlibpJoC+yWFcOawIwJFVeg6rQGTyhB/weoOIjh8dmT3yZHndT13pQRCzpH
 Qlt/DXQqHSv4Qy1JlrQQWk2NVBce5c5K+kVY2eg9+mD3yWqcyPT0Cm2CVDntWaOQAC/e
 WJHFZ6YJ5b5tGIhN3GjpdSWZFoY3rq/hCjzXXn83kKcf3tPF3Jdof56JqD/ZUfw7zkUH
 8JMq3aU8ueAVTQjHGgQKYuKNWRxf1BLxZQ8jP5KAZR5NHReJYuecdUXDKz6grIdO5YJu hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30p2p04qpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 12:07:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SC2woT111435;
        Tue, 28 Apr 2020 12:07:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30mxpftdcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 12:07:06 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03SC74e1032072;
        Tue, 28 Apr 2020 12:07:04 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 05:07:04 -0700
Date:   Tue, 28 Apr 2020 15:06:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Rylan Dmello <mail@rylan.coffee>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Benjamin Poirier <bpoirier@suse.com>,
        Jiri Pirko <jpirko@redhat.com>
Subject: Re: [PATCH 2/3] staging: qlge: Remove print statement for vlgrp field
Message-ID: <20200428120655.GC2014@kadam>
References: <cover.1587959245.git.mail@rylan.coffee>
 <51bae37a54d414491779e4a3329508cc864ab900.1587959245.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51bae37a54d414491779e4a3329508cc864ab900.1587959245.git.mail@rylan.coffee>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=722 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=777 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 12:14:44AM -0400, Rylan Dmello wrote:
> Remove statement that tries to print the non-existent 'vlgrp' field
> in the 'ql_adapter' struct, which causes a compilation failure when
> QL_DEV_DUMP is set.
> 
> vlgrp seems to have been removed from ql_adapter as a part of
> commit 18c49b91777c ("qlge: do vlan cleanup") in 2011.
> 
> vlgrp might be replaced by the 'active_vlans' array introduced in the
> aforementioned commit. But I'm not sure if printing all 64 values of
> that array would help with debugging this driver, so I'm leaving it
> out of the debug code in this patch.
> 
> Signed-off-by: Rylan Dmello <mail@rylan.coffee>

Fixes: 18c49b91777c ("qlge: do vlan cleanup")

regards,
dan carpenter

