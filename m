Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850B41C694D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgEFGrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:47:33 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:51597 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728208AbgEFGrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:47:31 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2020 02:47:30 EDT
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 5 May 2020 23:32:21 -0700
Received: from localhost.localdomain (ashwinh-vm-1.vmware.com [10.110.19.225])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 10492404B6;
        Tue,  5 May 2020 23:32:21 -0700 (PDT)
From:   ashwin-h <ashwinh@vmware.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>
CC:     <davem@davemloft.net>, <linux-sctp@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <rostedt@goodmis.org>, <srostedt@vmware.com>,
        <gregkh@linuxfoundation.org>, <ashwin.hiranniah@gmail.com>,
        ashwin-h <ashwinh@vmware.com>
Subject: [PATCH 0/2] Backport to 4.19 - sctp: fully support memory accounting
Date:   Wed, 6 May 2020 19:50:52 +0530
Message-ID: <cover.1588242081.git.ashwinh@vmware.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: ashwinh@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Backport below upstream commits to 4.19 to address CVE-2019-3874.
1033990ac5b2ab6cee93734cb6d301aa3a35bcaa
sctp: implement memory accounting on tx path

9dde27de3e5efa0d032f3c891a0ca833a0d31911
sctp: implement memory accounting on rx path

Xin Long (2):
  sctp: implement memory accounting on tx path
  sctp: implement memory accounting on rx path

 include/net/sctp/sctp.h |  2 +-
 net/sctp/sm_statefuns.c |  6 ++++--
 net/sctp/socket.c       | 10 ++++++++--
 net/sctp/ulpevent.c     | 19 ++++++++-----------
 net/sctp/ulpqueue.c     |  3 ++-
 5 files changed, 23 insertions(+), 17 deletions(-)

-- 
2.7.4

