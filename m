Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868432F1DDE
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390265AbhAKSVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:21:32 -0500
Received: from foss.arm.com ([217.140.110.172]:34214 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbhAKSVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 13:21:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FBC3101E;
        Mon, 11 Jan 2021 10:20:45 -0800 (PST)
Received: from e107158-lin.cambridge.arm.com (unknown [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57E663F70D;
        Mon, 11 Jan 2021 10:20:44 -0800 (PST)
From:   Qais Yousef <qais.yousef@arm.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH bpf-next 0/2] Allow attaching to bare tracepoints
Date:   Mon, 11 Jan 2021 18:20:25 +0000
Message-Id: <20210111182027.1448538-1-qais.yousef@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some missing glue logic to teach bpf about bare tracepoints - tracepoints
without any trace event associated with them.

Bare tracepoints are declare with DECLARE_TRACE(). Full tracepoints are declare
with TRACE_EVENT().

BPF can attach to these tracepoints as RAW_TRACEPOINT() only as there's no
events in tracefs created with them.

Qais Yousef (2):
  trace: bpf: Allow bpf to attach to bare tracepoints
  selftests: bpf: Add a new test for bare tracepoints

 Documentation/bpf/bpf_design_QA.rst                  |  6 ++++++
 include/trace/bpf_probe.h                            | 12 ++++++++++--
 .../selftests/bpf/bpf_testmod/bpf_testmod-events.h   |  6 ++++++
 .../testing/selftests/bpf/bpf_testmod/bpf_testmod.c  |  2 ++
 .../testing/selftests/bpf/prog_tests/module_attach.c |  1 +
 .../testing/selftests/bpf/progs/test_module_attach.c | 10 ++++++++++
 6 files changed, 35 insertions(+), 2 deletions(-)

-- 
2.25.1

