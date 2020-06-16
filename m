Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4241FA74A
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 06:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgFPEAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 00:00:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgFPEAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 00:00:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3w8xb194145;
        Tue, 16 Jun 2020 04:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=TkXWLHBUcq6GrqGb8B/sbaIZ/YHDymjYC75g5tesDI8=;
 b=s0bTOq51QseDHq3DCV1eok86CuoPzPpKYMVoC9U62ArE0saDMsnZyPLX69xmMmiHf234
 GhtCzXclPyAD2lvezqNJX8FgmH65sQ9KccDDY5XWfo8Aa7QHwrwmkBM3HdBxQgVizkwR
 TWYYw16ccvp5fkc32sMx4T+djKHsND99VSK/XK3ZASboQzuMEu3UqLhJCMYcF1rztbLF
 8thcP+Q59Z1RQaqEhadQSZY1Ppzp8aM+nArYVhqLkdXswKRcQPS43Kk7a4rkdXR3hFtv
 lGelrDKD8kNKh9uCoaCrNMnAejMfsXhLT4QgfQMCt4BhcPh9j0Tooxa1V88YIFFXPo+U 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31p6e5vda1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 04:00:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3xOvH131174;
        Tue, 16 Jun 2020 04:00:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31p6dcadma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 04:00:09 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05G406xx021363;
        Tue, 16 Jun 2020 04:00:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 21:00:06 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        netdev@vger.kernel.org, linux-input@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-usb@vger.kernel.org, linux-gpio@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 00/17] spelling.txt: /decriptors/descriptors/
Date:   Mon, 15 Jun 2020 23:59:55 -0400
Message-Id: <159227986422.24883.1110692977647896521.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200609124610.3445662-1-kieran.bingham+renesas@ideasonboard.com>
References: <20200609124610.3445662-1-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1011
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160027
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Jun 2020 13:45:53 +0100, Kieran Bingham wrote:

> I wouldn't normally go through spelling fixes, but I caught sight of
> this typo twice, and then foolishly grepped the tree for it, and saw how
> pervasive it was.
> 
> so here I am ... fixing a typo globally... but with an addition in
> scripts/spelling.txt so it shouldn't re-appear ;-)
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[06/17] scsi: Fix trivial spelling
        https://git.kernel.org/mkp/scsi/c/0a19a725c0ed

-- 
Martin K. Petersen	Oracle Linux Engineering
