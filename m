Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC76453C48
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 23:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhKPWkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 17:40:00 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:33680 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232034AbhKPWkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 17:40:00 -0500
Received: from [128.177.79.46] (helo=[10.118.101.22])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mn74W-000IT4-Hu; Tue, 16 Nov 2021 17:37:00 -0500
Subject: [PATCH v4  0/3] Update VMware maintainer entries
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com
Cc:     Nadav Amit <namit@vmware.com>, Ronak Doshi <doshir@vmware.com>,
        dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org,
        linux-graphics-maintainer@vmware.com, linux-input@vger.kernel.org,
        Alexey Makhalov <amakhalov@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>, netdev@vger.kernel.org,
        Zack Rusin <zackr@vmware.com>, linux-rdma@vger.kernel.org,
        Deep Shah <sdeep@vmware.com>, sdeep@vmware.com,
        vithampi@vmware.com, amakhalov@vmware.com, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, joe@perches.com,
        kuba@kernel.org, rostedt@goodmis.org, srivatsa@csail.mit.edu
Date:   Tue, 16 Nov 2021 14:40:17 -0800
Message-ID: <163710239472.123451.5004514369130059881.stgit@csail.mit.edu>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series updates a few maintainer entries for VMware-maintained
subsystems and cleans up references to VMware's private mailing lists
to make it clear that they are effectively email-aliases to reach out
to reviewers.

Changes from v3->v4:
- Remove Cc: stable@vger.kernel.org from patches 1 and 2.

Changes from v1->v3:
- Add Zack as the named maintainer for vmmouse driver
- Use R: to denote email-aliases for VMware reviewers

Regards,
Srivatsa

---

Srivatsa S. Bhat (VMware) (3):
      MAINTAINERS: Update maintainers for paravirt ops and VMware hypervisor interface
      MAINTAINERS: Add Zack as maintainer of vmmouse driver
      MAINTAINERS: Mark VMware mailing list entries as email aliases


 MAINTAINERS | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

