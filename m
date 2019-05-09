Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E1F19593
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfEIXEe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 May 2019 19:04:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41104 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbfEIXEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:04:34 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49MxMEc001595
        for <netdev@vger.kernel.org>; Thu, 9 May 2019 16:04:33 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sctr0gksx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 16:04:33 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 9 May 2019 16:04:32 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 8CFCB7609CC; Thu,  9 May 2019 16:04:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf 2019-05-09
Date:   Thu, 9 May 2019 16:04:31 -0700
Message-ID: <20190509230431.3084008-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) three small fixes from Gary, Jiong and Lorenz.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 494bc1d281b5a9f02a81249fa566d8c7e390c50c:

  net/tcp: use deferred jump label for TCP acked data hook (2019-05-09 11:13:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 3ef4641fbf870ee1ecd5f890a54881b7f0e20b90:

  docs/btf: fix the missing section marks (2019-05-09 15:59:59 -0700)

----------------------------------------------------------------
Gary Lin (1):
      docs/btf: fix the missing section marks

Jiong Wang (1):
      nfp: bpf: fix static check error through tightening shift amount adjustment

Lorenz Bauer (1):
      selftests: bpf: initialize bpf_object pointers where needed

 Documentation/bpf/btf.rst                                 |  2 ++
 drivers/net/ethernet/netronome/nfp/bpf/jit.c              | 13 ++++++++++++-
 tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c  |  2 +-
 tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c |  2 +-
 tools/testing/selftests/bpf/prog_tests/tp_attach_query.c  |  3 +++
 5 files changed, 19 insertions(+), 3 deletions(-)
