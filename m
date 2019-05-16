Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF72320483
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfEPLVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:21:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:33932 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbfEPLV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:21:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CDC6CAEC6;
        Thu, 16 May 2019 11:21:27 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-newbies@vger.kernel.org
Subject: [PATCH bpf-next 0/2] Move bpf_printk to bpf_helpers.h
Date:   Thu, 16 May 2019 13:20:56 +0200
Message-Id: <20190516112105.12887-1-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches move the commonly used bpf_printk macro to
bpf_helpers.h which is already included in all BPF programs which
defined that macro on their own.

Michal Rostecki (2):
  selftests: bpf: Move bpf_printk to bpf_helpers.h
  samples: bpf: Do not define bpf_printk macro

 samples/bpf/hbm_kern.h                               | 12 +++---------
 samples/bpf/hbm_out_kern.c                           |  2 ++
 samples/bpf/tcp_basertt_kern.c                       |  7 -------
 samples/bpf/tcp_bufs_kern.c                          |  7 -------
 samples/bpf/tcp_clamp_kern.c                         |  7 -------
 samples/bpf/tcp_cong_kern.c                          |  7 -------
 samples/bpf/tcp_iw_kern.c                            |  7 -------
 samples/bpf/tcp_rwnd_kern.c                          |  7 -------
 samples/bpf/tcp_synrto_kern.c                        |  7 -------
 samples/bpf/tcp_tos_reflect_kern.c                   |  7 -------
 samples/bpf/xdp_sample_pkts_kern.c                   |  7 -------
 tools/testing/selftests/bpf/bpf_helpers.h            |  8 ++++++++
 .../testing/selftests/bpf/progs/sockmap_parse_prog.c |  7 -------
 .../selftests/bpf/progs/sockmap_tcp_msg_prog.c       |  7 -------
 .../selftests/bpf/progs/sockmap_verdict_prog.c       |  7 -------
 .../testing/selftests/bpf/progs/test_lwt_seg6local.c |  7 -------
 .../testing/selftests/bpf/progs/test_xdp_noinline.c  |  7 -------
 tools/testing/selftests/bpf/test_sockmap_kern.h      |  7 -------
 18 files changed, 13 insertions(+), 114 deletions(-)

-- 
2.21.0

