Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD313FBB59
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238374AbhH3SBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:01:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38526 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238134AbhH3SBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 14:01:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17UDOVKj027795;
        Mon, 30 Aug 2021 11:00:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=z5aMs9reCfqriLw/L8GT4iQyg5gkF7e0lju0bXjeTGM=;
 b=HMVfZ+dmy0zucaRQZoNJx/krcVQ2tcK43MDyCHVdnh3QHtLbwVlo8TSFlFDdKoSoY1Ga
 J0RiZHLNdzuBQ7NaMq/WfW8jQShayb1kXLTgitaa7oS3apjYENm5I4tAtAA8HjriEZFP
 0SaRT8ESHtX8a5or0DhH3eWfLzUDV4AurXY90O4qw0kUykCmcJsgLJTucv4FbyBYt3Un
 w/yfuhSY4mJKnYSHa8DDvqaVYmT7HZhgwltMj1tXT/lOsyJiDpzNFYcUeUXMbGwmZV7H
 dEe884Ya/7pXFWIOfuiVK12sX782Tz5U3LTFyV8rrNeQv3GEak13Hyd6P/rikgzIGCpJ jQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3as06f9365-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 11:00:55 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 30 Aug
 2021 11:00:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 30 Aug 2021 11:00:53 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 4B7353F707D;
        Mon, 30 Aug 2021 11:00:51 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 0/4] octeontx2-af: Miscellaneous fixes in npc
Date:   Mon, 30 Aug 2021 23:30:42 +0530
Message-ID: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: o3-mk2orwdkZdUoFGOe4oev0kphh5p6R
X-Proofpoint-ORIG-GUID: o3-mk2orwdkZdUoFGOe4oev0kphh5p6R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-30_06,2021-08-30_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset consists of consolidated fixes in
rvu_npc file. Two of the patches prevent infinite
loop which can happen in corner cases. One patch
is for fixing static code analyzer reported issues.
And the last patch is a minor change in npc protocol
checker hardware block to report ipv4 checksum errors
as a known error codes.

Thanks,
Sundeep


Subbaraya Sundeep (3):
  octeontx2-af: Fix loop in free and unmap counter
  octeontx2-af: Fix mailbox errors in nix_rss_flowkey_cfg
  octeontx2-af: Fix static code analyzer reported issues

Sunil Goutham (1):
  octeontx2-af: Set proper errorcode for IPv4 checksum errors

 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

-- 
2.7.4

