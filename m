Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A225CD80
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfGBKZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:25:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfGBKZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 06:25:17 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5449FC05E77A;
        Tue,  2 Jul 2019 10:25:06 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 789496F95D;
        Tue,  2 Jul 2019 10:24:52 +0000 (UTC)
Date:   Tue, 2 Jul 2019 12:24:51 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     lvs-devel@vger.kernel.org, lvs-users@linuxvirtualserver.org,
        Julian Anastasov <ja@ssi.bg>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        "Ryan O'Hara" <rohara@redhat.com>,
        Arthur Gautier <baloo@gandi.net>,
        Quentin Armitage <quentin@armitage.org.uk>,
        Simon Horman <horms@verge.net.au>,
        Wensong Zhang <wensong@linux-vs.org>
Subject: [ANNOUNCE] ipvsadm release v1.30
Message-ID: <20190702122451.556ceb8c@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 02 Jul 2019 10:25:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are happy to announce the release of ipvsadm v1.30.

 ipvsadm is a utility to administer the kernels IPVS/LVS load-balancer service

There have not been a ipvsadm release for far too long. This release is
focused on kernel release v4.18 and below, for adding the missing userspace
side for the schedulers MH, FO and OVF. There are upcoming change for GUE
and GRE, that are not part of this release.

There have been very little development on the tool, but this release still
contains userspace config to kernel side features that span many kernel
releases. Special thanks to Quentin Armitage for adding this userspace side
support, that was missing in ipvsadm.

This release contains userspace support and/or doc for 3 more schedulers:
 - mh:  Maglev Hashing: added in kernel v4.18
 - ovf (doc): Weighted Overflow: added in kernel v4.3
   - https://git.kernel.org/torvalds/c/eefa32d3f3c5
 - fo (doc): Weighted FailOver: added in kernel v3.18
   - https://git.kernel.org/torvalds/c/616a9be25cb9

This release is based on the kernel.org git tree:
  https://git.kernel.org/cgit/utils/kernel/ipvsadm/ipvsadm.git/

You can download the tarballs from:
 https://kernel.org/pub/linux/utils/kernel/ipvsadm/

Git tree:
 git://git.kernel.org/pub/scm/utils/kernel/ipvsadm/ipvsadm.git

Shortlog:

Arthur Gautier (1):
      libipvs: discrepancy with libnl genlmsg_put

Jesper Dangaard Brouer (2):
      Merge: ipvsadm: Document/add support for fo/ovf/mh schedulers
      Release: Version 1.30

Julian Anastasov (2):
      ipvsadm: catch the original errno from netlink answer
      libipvs: fix some buffer sizes

Quentin Armitage (3):
      Document support of fo scheduler
      Document support of ovf scheduler
      Add support for mh scheduler

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
