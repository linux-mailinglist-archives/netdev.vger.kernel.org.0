Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D38231D38C
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhBQBJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhBQBJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:08 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70531C0613D6;
        Tue, 16 Feb 2021 17:08:28 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id a24so6481837plm.11;
        Tue, 16 Feb 2021 17:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o2PntT/PZBPShGrlPRMhXSlITkIcU8upNDVyjrUKWoM=;
        b=g/wz8dpYu251qY7UBgKIc+0fSzqkTqwxNNA9qrICkAtHrhrm0UPA1a31WEm9eg9qSc
         9+GqihIj45hTibkAt/pnzKp7x5HRBIN+cfdMvB9zSxRz3KijW/SAILGbTuk/0pJhTW4V
         liWtPeVelTs3jhVC6/ixABetkrXG9Lm3nDwqL3BldPormw6y9uLXwR3JxsxVwcDIawPf
         cVgHrXi+1UphHGgaHDRgWkzID+pRX0tBHEqWxEkvg4ojnaNOoe2cWfFAzo0Pn8Oaye4k
         RaKS7L5bU6F2iQDi1S6M5bNDuV0WSzErCitlDTsMaGHSadSIkotIrwR/zH1sg2LnwLGh
         FjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=o2PntT/PZBPShGrlPRMhXSlITkIcU8upNDVyjrUKWoM=;
        b=eVXomKEkOKmhWjHivd4QdgqqHWerGYjrhZeaIDtQI/sYwdJDkzVKOF1Ki9Q15ZCpk8
         djVrdHkux+lu3EaSPweeDGRUX3ZfoCqldVKwPmt8Jbm3C04Jme7iXbsSHK4KGsTA5myx
         +xCDDkO2W7I8Xc6mynWegfZ3ilUebmYCiydOsPUai1ppQ1U9KGgdyMT7q0P0kdsrZGZH
         acBg11EfNDactSAsO4UjpAdwuEdnij3gMnPwuzzdMUkwzUtXW4Bz2VckhdIG2Pa9exFj
         zwPcwaF2Uz+Z6uX9jgkSL4MXBdJUWcN1UI/DL17xql9A0GfL3EiXOqiscgoNxZ6MfHcS
         xVng==
X-Gm-Message-State: AOAM530kMNNnPZmD+UmqwPa9Knc4V8uJUPl9bopJEFyJv5X7ghrcuUFa
        8bbiMZhvBYxvAMg2jBU3z888qI0oTj/1Kg==
X-Google-Smtp-Source: ABdhPJwHlXjeLiuwOzseZca4p1bHGsLY2lUCuyw1Qb1Db4NwWmILmDyfCY/lYFa36Jcq/xc3LBq99g==
X-Received: by 2002:a17:90a:7e94:: with SMTP id j20mr6930649pjl.218.1613524107587;
        Tue, 16 Feb 2021 17:08:27 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:26 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, linux-man@vger.kernel.org,
        netdev@vger.kernel.org, mtk.manpages@gmail.com, ast@kernel.org,
        brianvv@google.com, daniel@iogearbox.net, daniel@zonque.org,
        john.fastabend@gmail.com, ppenkov@google.com,
        quentin@isovalent.com, sean@mess.org, yhs@fb.com
Subject: [PATCH bpf-next 00/17] Improve BPF syscall command documentation
Date:   Tue, 16 Feb 2021 17:08:04 -0800
Message-Id: <20210217010821.1810741-1-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

The state of bpf(2) manual pages today is not exactly ideal. For the
most part, it was written several years ago and has not kept up with the
pace of development in the kernel tree. For instance, out of a total of
~35 commands to the BPF syscall available today, when I pull the
kernel-man-pages tree today I find just 6 documented commands: The very
basics of map interaction and program load.

In contrast, looking at bpf-helpers(7), I am able today to run one
command[0] to fetch API documentation of the very latest eBPF helpers
that have been added to the kernel. This documentation is up to date
because kernel maintainers enforce documenting the APIs as part of
the feature submission process. As far as I can tell, we rely on manual
synchronization from the kernel tree to the kernel-man-pages tree to
distribute these more widely, so all locations may not be completely up
to date. That said, the documentation does in fact exist in the first
place which is a major initial hurdle to overcome.

Given the relative success of the process around bpf-helpers(7) to
encourage developers to document their user-facing changes, in this
patch series I explore applying this technique to bpf(2) as well.
Unfortunately, even with bpf(2) being so out-of-date, there is still a
lot of content to convert over. In particular, I've identified at least
the following aspects of the bpf syscall which could individually be
generated from separate documentation in the header:
* BPF syscall commands
* BPF map types
* BPF program types
* BPF attachment points

Rather than tackle everything at once, I have focused in this series on
the syscall commands, "enum bpf_cmd". This series is structured to first
import what useful descriptions there are from the kernel-man-pages
tree, then piece-by-piece document a few of the syscalls in more detail
in cases where I could find useful documentation from the git tree or
from a casual read of the code. Not all documentation is comprehensive
at this point, but a basis is provided with examples that can be further
enhanced with subsequent follow-up patches. Note, the series in its
current state only includes documentation around the syscall commands
themselves, so in the short term it doesn't allow us to automate bpf(2)
generation; Only one section of the man page could be replaced. Though
if there is appetite for this approach, this should be trivial to
improve on, even if just by importing the remaining static text from the
kernel-man-pages tree.

Following that, the series enhances the python scripting around parsing
the descriptions from the header files and generating dedicated
ReStructured Text and troff output. Finally, to expose the new text and
reduce the likelihood of having it get out of date or break the docs
parser, it is added to the selftests and exposed through the kernel
documentation web pages.

At this point I'd like to put this out for comments. In my mind, the
ideal eventuation of this work would be to extend kernel UAPI headers
such that each of the categories I had listed above (commands, maps,
progs, hooks) have dedicated documentation in the kernel tree, and that
developers must update the comments in the headers to document the APIs
prior to patch acceptance, and that we could auto-generate the latest
version of the bpf(2) manual pages based on a few static description
sections combined with the dynamically-generated output from the header.

Thanks also to Quentin Monnet for initial review.

[0]: make -C tools/bpf -f Makefile.docs bpf-helpers.7

Joe Stringer (17):
  bpf: Import syscall arg documentation
  bpf: Add minimal bpf() command documentation
  bpf: Document BPF_F_LOCK in syscall commands
  bpf: Document BPF_PROG_PIN syscall command
  bpf: Document BPF_PROG_ATTACH syscall command
  bpf: Document BPF_PROG_TEST_RUN syscall command
  bpf: Document BPF_PROG_QUERY syscall command
  bpf: Document BPF_MAP_*_BATCH syscall commands
  scripts/bpf: Rename bpf_helpers_doc.py -> bpf_doc.py
  scripts/bpf: Abstract eBPF API target parameter
  scripts/bpf: Add syscall commands printer
  tools/bpf: Rename Makefile.{helpers,docs}
  tools/bpf: Templatize man page generation
  tools/bpf: Build bpf-sycall.2 in Makefile.docs
  selftests/bpf: Add docs target
  docs/bpf: Add bpf() syscall command reference
  tools: Sync uapi bpf.h header with latest changes

 Documentation/Makefile                        |   2 +
 Documentation/bpf/Makefile                    |  28 +
 Documentation/bpf/bpf_commands.rst            |   5 +
 Documentation/bpf/index.rst                   |  14 +-
 include/uapi/linux/bpf.h                      | 709 +++++++++++++++++-
 scripts/{bpf_helpers_doc.py => bpf_doc.py}    | 189 ++++-
 tools/bpf/Makefile.docs                       |  88 +++
 tools/bpf/Makefile.helpers                    |  60 --
 tools/bpf/bpftool/Documentation/Makefile      |  12 +-
 tools/include/uapi/linux/bpf.h                | 709 +++++++++++++++++-
 tools/lib/bpf/Makefile                        |   2 +-
 tools/perf/MANIFEST                           |   2 +-
 tools/testing/selftests/bpf/Makefile          |  20 +-
 .../selftests/bpf/test_bpftool_build.sh       |  21 -
 tools/testing/selftests/bpf/test_doc_build.sh |  13 +
 15 files changed, 1736 insertions(+), 138 deletions(-)
 create mode 100644 Documentation/bpf/Makefile
 create mode 100644 Documentation/bpf/bpf_commands.rst
 rename scripts/{bpf_helpers_doc.py => bpf_doc.py} (82%)
 create mode 100644 tools/bpf/Makefile.docs
 delete mode 100644 tools/bpf/Makefile.helpers
 create mode 100755 tools/testing/selftests/bpf/test_doc_build.sh

-- 
2.27.0

