Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0F11B2DAC
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgDUREQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgDUREO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 13:04:14 -0400
Received: from mail.kernel.org (ip5f5ad4d8.dynamic.kabel-deutschland.de [95.90.212.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED9F22071C;
        Tue, 21 Apr 2020 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587488654;
        bh=TKwQ9ykgax7V0in9J67Gf5It6T8tA6kFCL0qRblfIrI=;
        h=From:To:Cc:Subject:Date:From;
        b=LafIXWddU/e0Xydt4GgYYdU5GaDFxqylQCmJxnpFAsQ2UlzspnKjfAIwz2UuDLwVR
         gVRmCny6BzaRVHvJXgLBylroC8orFZoRb4sX4+u8lcB7JlovofGV6Wl8JEqDnyKk4s
         6Hxr9plhj/JBx6aui9oOtVZHaggRYuIbiXDgG/rM=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jQwJg-00CmLT-1Q; Tue, 21 Apr 2020 19:04:12 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Joe Stringer <joe@wand.net.nz>,
        Joel Fernandes <joel@joelfernandes.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jakub Sitnicki <jakub@cloudflare.com>, rcu@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        zhanglin <zhang.lin16@zte.com.cn>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 00/10] Manually convert RCU text files to ReST format
Date:   Tue, 21 Apr 2020 19:04:01 +0200
Message-Id: <cover.1587488137.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series convert RCU patches to ReST.

One interesting point to be noticed hereis that the RTFP.txt file contain a 
broken TeX bib file. I suspect that someone added some new articles
directly there without trying to use LaTeX to check if the addition is
valid. Or maybe it is just due to some version differences from the time
such references were added.

During the RTFP.txt conversion, I fixed the bibtex problems in order for it
to be properly parsed by LaTeX, and used the fixed file to produce a list of
the actually used references inside the RTFP.txt file., manually adding them
to the converted RTFP.rst. 

As not all references were mentioned there, I opted to preserve the 
converted RTFP.bib, as it could be useful for someone doing any 
research around RCU.

The results of those changes (together with other changes from my pending
doc patches) are available at:

   https://www.infradead.org/~mchehab/kernel_docs/RCU/index.html

And the series is on my git tree:

  https://git.linuxtv.org/mchehab/experimental.git/log/?h=rcu-docs

Mauro Carvalho Chehab (10):
  docs: RCU: convert checklist.txt to ReST
  docs: RCU: convert lockdep-splat.txt to ReST
  docs: RCU: convert lockdep.txt to ReST
  docs: RCU: convert rculist_nulls.txt to ReST
  docs: RCU: convert torture.txt to ReST
  docs: RCU: convert rcuref.txt to ReST
  docs: RCU: RTFP: fix bibtex entries
  docs: RCU: convert RTFP.txt to ReST
  docs: RCU: stallwarn.txt: convert it to ReST
  docs: RCU: rculist_nulls.rst: don't duplicate chapter names

 Documentation/RCU/{RTFP.txt => RTFP.bib}      | 323 ++--------
 Documentation/RCU/RTFP.rst                    | 593 ++++++++++++++++++
 .../RCU/{checklist.txt => checklist.rst}      |  17 +-
 Documentation/RCU/index.rst                   |  11 +
 .../{lockdep-splat.txt => lockdep-splat.rst}  |  99 +--
 .../RCU/{lockdep.txt => lockdep.rst}          |  12 +-
 Documentation/RCU/rcu.rst                     |   4 +-
 Documentation/RCU/rculist_nulls.rst           | 200 ++++++
 Documentation/RCU/rculist_nulls.txt           | 172 -----
 Documentation/RCU/{rcuref.txt => rcuref.rst}  | 193 +++---
 .../RCU/{stallwarn.txt => stallwarn.rst}      |  55 +-
 .../RCU/{torture.txt => torture.rst}          | 115 ++--
 Documentation/locking/locktorture.rst         |   2 +-
 MAINTAINERS                                   |   4 +-
 include/linux/rculist_nulls.h                 |   2 +-
 kernel/rcu/rcutorture.c                       |   2 +-
 kernel/rcu/tree_stall.h                       |   4 +-
 net/core/sock.c                               |   4 +-
 18 files changed, 1139 insertions(+), 673 deletions(-)
 rename Documentation/RCU/{RTFP.txt => RTFP.bib} (82%)
 create mode 100644 Documentation/RCU/RTFP.rst
 rename Documentation/RCU/{checklist.txt => checklist.rst} (98%)
 rename Documentation/RCU/{lockdep-splat.txt => lockdep-splat.rst} (54%)
 rename Documentation/RCU/{lockdep.txt => lockdep.rst} (96%)
 create mode 100644 Documentation/RCU/rculist_nulls.rst
 delete mode 100644 Documentation/RCU/rculist_nulls.txt
 rename Documentation/RCU/{rcuref.txt => rcuref.rst} (50%)
 rename Documentation/RCU/{stallwarn.txt => stallwarn.rst} (90%)
 rename Documentation/RCU/{torture.txt => torture.rst} (76%)

-- 
2.25.2


