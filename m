Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF62FB8D1
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394792AbhASNsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:48:47 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5844 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389317AbhASKCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 05:02:33 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10JA0JM6030222;
        Tue, 19 Jan 2021 02:01:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=Kh9q9u/xG55ISzvAI4DfruvcHIjdxsqiAz9/TsQGgho=;
 b=dqVRXZxnMP3E2gqb3ePyhdORQfk8b5PpISoWXqduDgEizTK67uelXBorY2+niTT729g7
 f81fUD3Zr5T9hk+yc+LjpOUDv3fQhtM1pshZ4OETkGWI0HrcjuEHJPx3GGth7sM8qud6
 HS/d6IZQnaH95bfD8lMWHjd4kSL8DfLgNQgXJ8j/49ZQXxtUYrX6BuxWQoCQX+8gJh5c
 Te94nNloIg7VuGulcoPiYrMbUY65FnnO7EGx+IH6dhlrQ4InLuvF+vBu0dDTODE5flZM
 LLNcmJYhZYU3moBl84nHl/+4VkK3KcY8nnVIWvZ4+OKQRVl8/yMjcxXBGzuVb3eS9f69 tg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 363xcue7ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 02:01:26 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 Jan
 2021 02:01:24 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 Jan
 2021 02:01:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 19 Jan 2021 02:01:24 -0800
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id A0BDA3F7048;
        Tue, 19 Jan 2021 02:01:21 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <george.cherian@marvell.com>, <corbet@lwn.net>
Subject: [PATCH net-next 0/2] Add devlink health reporters for NIX block
Date:   Tue, 19 Jan 2021 15:31:18 +0530
Message-ID: <20210119100120.2614730-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink health reporters are added for the NIX block.

Address Jakub's comment to add devlink support for error reporting.
https://www.spinics.net/lists/netdev/msg670712.html

This series is in continuation to
https://www.spinics.net/lists/netdev/msg707798.html

Added Documentation for the same.

George Cherian (2):
  octeontx2-af: Add devlink health reporters for NIX
  docs: octeontx2: Add Documentation for NIX health reporters

 .../ethernet/marvell/octeontx2.rst            |  70 ++
 .../marvell/octeontx2/af/rvu_devlink.c        | 652 +++++++++++++++++-
 .../marvell/octeontx2/af/rvu_devlink.h        |  27 +
 .../marvell/octeontx2/af/rvu_struct.h         |  10 +
 4 files changed, 758 insertions(+), 1 deletion(-)

-- 
2.25.1

