Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5858E4C392A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 23:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbiBXWui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 17:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbiBXWui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 17:50:38 -0500
Received: from outgoing-stata.csail.mit.edu (outgoing-stata.csail.mit.edu [128.30.2.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2AA3120F7D;
        Thu, 24 Feb 2022 14:50:07 -0800 (PST)
Received: from [128.177.79.46] (helo=[10.118.101.22])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1nNMSg-000HH6-Ik; Thu, 24 Feb 2022 17:19:46 -0500
Subject: [PATCH v5 0/3] Update VMware maintainer entries
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com,
        tglx@linutronix.de, bp@alien8.de
Cc:     linux-graphics-maintainer@vmware.com, Deep Shah <sdeep@vmware.com>,
        Joe Perches <joe@perches.com>, linux-rdma@vger.kernel.org,
        Ronak Doshi <doshir@vmware.com>, Nadav Amit <namit@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Zack Rusin <zackr@vmware.com>, linux-input@vger.kernel.org,
        Vivek Thampi <vithampi@vmware.com>, linux-scsi@vger.kernel.org,
        Vishal Bhakta <vbhakta@vmware.com>, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, sdeep@vmware.com,
        vithampi@vmware.com, amakhalov@vmware.com, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, joe@perches.com,
        kuba@kernel.org, rostedt@goodmis.org, srivatsa@csail.mit.edu
Date:   Thu, 24 Feb 2022 14:23:48 -0800
Message-ID: <164574138686.654750.10250173565414769119.stgit@csail.mit.edu>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series updates a few maintainer entries for VMware-maintained
subsystems and cleans up references to VMware's private mailing lists
to make it clear that they are effectively email-aliases to reach out
to reviewers.

Changes from v4->v5:
- Add Alexey as reviewer for paravirt ops.

Changes from v3->v4:
- Remove Cc: stable@vger.kernel.org from patches 1 and 2.

Changes from v1->v3:
- Add Zack as the named maintainer for vmmouse driver
- Use R: to denote email-aliases for VMware reviewers

Regards,
Srivatsa
VMware Photon OS

---

Srivatsa S. Bhat (VMware) (3):
      MAINTAINERS: Update maintainers for paravirt ops and VMware hypervisor interface
      MAINTAINERS: Add Zack as maintainer of vmmouse driver
      MAINTAINERS: Mark VMware mailing list entries as email aliases


 MAINTAINERS | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

