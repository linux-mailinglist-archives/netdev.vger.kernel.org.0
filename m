Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4879B1FD5C2
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgFQUKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgFQUKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:10:24 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AC6C06174E;
        Wed, 17 Jun 2020 13:10:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id u8so1497702pje.4;
        Wed, 17 Jun 2020 13:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sf2DciuJci1s3v36ZVasHTC5UZyw/h2w9sDVox6RVzk=;
        b=RTBffP1V6FhXLiGiSWfmmgloSEMevbXsMFLj/Z4NoIZIOFj/rt3p/zwtGaYcSR4X8j
         xhpaIicO51PT7j3zJD4/h22EFuUSU7QgCTw4hxS0NI8HU5ZsF26Jc/VzoqkkwBPza/iC
         S6KVOYIUFaVdxetcGeQjN4rlXfv4Su/0JDo6oyCjec2JNhvM6qfprrGpum4dFKb9+WSL
         vL5RcLKZSUfTKYf7f0710QuNLlqMfI/F6zCECZZz+ouE/q2lBuroRLI7z/GtWw7PN9EU
         sruNEAxI8JwlMVbKRVHpJEnukLOzN0vPxwPhiZ1HkZte6hiRxSygwqMNcDBcpaXrRFCe
         NS5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sf2DciuJci1s3v36ZVasHTC5UZyw/h2w9sDVox6RVzk=;
        b=e9NjbqlxhCsCqywWyhsYz6Z50g0EUfJzFd/rVPGjsKBA9g2YPbap0n+z9yx4ZBM3lQ
         9mIbDC0lQcYWzhpkBBbf4EGijT93HaRwn44CM/mMEYsVr/sUypy+Jf9tLD3mYdtrlh8W
         jDkmmtTYSiMin/Z5vswcJnLqCKRNy2tippvebuE1BQspAzxkA56HFJIwLcLIkTGSVOKB
         1vY+9RaWVE9g/g6ZgBLryPnDU263SNnP5oK5ZODSB/mmONRXMKnSPcr3R1FldYHwBvqV
         WEKNOKVvOmMInWG4djOXqT/UiKJWdxyGnxVxKp/dDJ4PI+2BE1fSuQVq/3COVI+LQsAA
         OGHQ==
X-Gm-Message-State: AOAM532t1J8ceohK6EYpEBhoHzUzBRykX6coPJMIf4fm/3YcMAMKWCdl
        KHW3L3DrIcrpHP0SO9bvN3g=
X-Google-Smtp-Source: ABdhPJyFbaFTHdv2xqTmiazkdjPb7zgLq6KZuCABGV7qeGVfWdDBW2FcCfFGIQw1ZQu4WWCD1U+7bA==
X-Received: by 2002:a17:902:be05:: with SMTP id r5mr637454pls.252.1592424622995;
        Wed, 17 Jun 2020 13:10:22 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id j17sm360969pjy.22.2020.06.17.13.10.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jun 2020 13:10:22 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf 2020-06-17
Date:   Wed, 17 Jun 2020 13:10:20 -0700
Message-Id: <20200617201020.48276-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 10 non-merge commits during the last 2 day(s) which contain
a total of 14 files changed, 158 insertions(+), 59 deletions(-).

The main changes are:

1) Important fix for bpf_probe_read_kernel_str() return value, from Andrii.

2) [gs]etsockopt fix for large optlen, from Stanislav.

3) devmap allocation fix, from Toke.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Christoph Hellwig, Jesper Dangaard Brouer, John 
Fastabend, Xiumei Mu

----------------------------------------------------------------

The following changes since commit c92cbaea3cc0a80807e386922f801eb6d3652c81:

  net: dsa: sja1105: fix PTP timestamping with large tc-taprio cycles (2020-06-15 13:45:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 8030e250d882db174cbcd88273570ffb36a13080:

  bpf: Document optval > PAGE_SIZE behavior for sockopt hooks (2020-06-17 10:54:05 -0700)

----------------------------------------------------------------
Andrii Nakryiko (3):
      bpf: Fix definition of bpf_ringbuf_output() helper in UAPI comments
      tools/bpftool: Add ringbuf map to a list of known map types
      bpf: bpf_probe_read_kernel_str() has to return amount of data read on success

Gaurav Singh (1):
      bpf, xdp, samples: Fix null pointer dereference in *_user code

Hangbin Liu (1):
      xdp: Handle frame_sz in xdp_convert_zc_to_xdp_frame()

Stanislav Fomichev (3):
      bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE
      selftests/bpf: Make sure optvals > PAGE_SIZE are bypassed
      bpf: Document optval > PAGE_SIZE behavior for sockopt hooks

Tobias Klauser (1):
      tools, bpftool: Add ringbuf map type to map command docs

Toke Høiland-Jørgensen (1):
      devmap: Use bpf_map_area_alloc() for allocating hash buckets

 Documentation/bpf/prog_cgroup_sockopt.rst          | 14 ++++++
 include/uapi/linux/bpf.h                           |  2 +-
 kernel/bpf/cgroup.c                                | 53 +++++++++++++--------
 kernel/bpf/devmap.c                                | 10 ++--
 kernel/trace/bpf_trace.c                           |  2 +-
 net/core/xdp.c                                     |  1 +
 samples/bpf/xdp_monitor_user.c                     |  8 +---
 samples/bpf/xdp_redirect_cpu_user.c                |  7 +--
 samples/bpf/xdp_rxq_info_user.c                    | 13 ++----
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |  2 +-
 tools/bpf/bpftool/map.c                            |  3 +-
 tools/include/uapi/linux/bpf.h                     |  2 +-
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  | 46 +++++++++++++++---
 tools/testing/selftests/bpf/progs/sockopt_sk.c     | 54 +++++++++++++++++++++-
 14 files changed, 158 insertions(+), 59 deletions(-)
