Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67C444CA05
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 21:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhKJUHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 15:07:22 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:50475 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230230AbhKJUHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 15:07:22 -0500
Received: from [128.177.79.46] (helo=[10.118.101.22])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mktpe-000YUv-Gt; Wed, 10 Nov 2021 15:04:30 -0500
Subject: [PATCH v3 0/3] Update VMware maintainer entries
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com
Cc:     Vishal Bhakta <vbhakta@vmware.com>, linux-scsi@vger.kernel.org,
        Ronak Doshi <doshir@vmware.com>, Nadav Amit <namit@vmware.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Zack Rusin <zackr@vmware.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Deep Shah <sdeep@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        linux-input@vger.kernel.org, linux-graphics-maintainer@vmware.com,
        Alexey Makhalov <amakhalov@vmware.com>, amakhalov@vmware.com,
        sdeep@vmware.com, virtualization@lists.linux-foundation.org,
        keerthanak@vmware.com, srivatsab@vmware.com, anishs@vmware.com,
        vithampi@vmware.com, linux-kernel@vger.kernel.org,
        srivatsa@csail.mit.edu, namit@vmware.com, joe@perches.com,
        kuba@kernel.org, rostedt@goodmis.org
Date:   Wed, 10 Nov 2021 12:07:44 -0800
Message-ID: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
User-Agent: StGit/0.21
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


 MAINTAINERS |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

