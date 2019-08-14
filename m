Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AD48D85C
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfHNQrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:47:46 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:43332 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfHNQrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:47:46 -0400
Received: by mail-vk1-f202.google.com with SMTP id s17so587914vkm.10
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 09:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FPuI57Gwp6Wac6Fi4cTNK0HXdqhfqqrfPDHjjOcr8Bw=;
        b=L6+4a2vUg7jyTQ7kgadz00cPI0WU08mtGoMFsuKPq/xQxXgTiYnru1b8OCqzKANMBA
         9I7xseSeeHKBQ386E7VibqNQ83lGJUqBMySO9+fGbhhY3s+7ccKWOwIFN54QnRL1XBRn
         45lSlLMnMPXbXXvQIR72UKqbU2/xFYoMlUe0TBLRt28c6gQ1pH8AIJuT5O7Ml7vFoBc6
         omEzHbLeTwYbvGDses6PVc6ayRDfahZOkHKuBDfYS7VXFks1Bn5VVP6sxdfoFiprVPnf
         /vIWm2u3EvjF8swmxn2K8gLvR4moBeME3Xq1cKvIuS9WHC1UQI1tLuygtB8Q21zJjZmr
         Lq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FPuI57Gwp6Wac6Fi4cTNK0HXdqhfqqrfPDHjjOcr8Bw=;
        b=ecu0TOVGPNyr4wBSSgN5HuAm6GR/HCve7lyIEmr3PKawOBlFp6ue308+ZjyFmod1wQ
         umeC3YojI/LI7nY851z+GzkbL1pIHrLG2bg4aogkm2u4gypXdMWUbReiZHPKpM33jTFh
         fMDJqELjIFg6s0h7hBPwLcF24jCWpDgIsW/NoJxCyW/g7lSy0h6LuCHsk2gvKowWS9gA
         ZJJtHjj3S1I+HZYweuEnvXWx2QlSIsb1PLKbSC8vxbrBy6tlCVHApKPjiblK4sg31ZSW
         bIRRA6YrQxNVvac6NkniOHaLUtn4B/d0y4vhEd5dfB7FESAinkreN9dwuuYtyh/DHOgW
         0jDg==
X-Gm-Message-State: APjAAAWILeT3V/dYT4ElraTIcAacNtxMolR4KsNtpK2PmxmdWZi577Iy
        b/y5WZGrlLsq7H5OS1O5qVPo36e6EuEdosquhlgrGKP3WSGy5A9hxrwScIxC3V2reJ3ahgiCHd/
        qb+fCufGT+zsLMuEQ2hTEAJgPWL9rv8Bg7E7N3RpNkVYCktuZ7BiA4w==
X-Google-Smtp-Source: APXvYqxs88uisoBK0TpmlGkLAwrocAYqPq1bS41Z7Acmj+peWMYkXuraXSDo5YE15Ysd+zTQ8I1IBvE=
X-Received: by 2002:a1f:1288:: with SMTP id 130mr86504vks.12.1565801264638;
 Wed, 14 Aug 2019 09:47:44 -0700 (PDT)
Date:   Wed, 14 Aug 2019 09:47:38 -0700
Message-Id: <20190814164742.208909-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next 0/4] selftests/bpf: test_progs: misc fixes
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* make output a bit easier to follow
* add test__skip to indicate skipped tests
* remove global success/error counts (use environment)
* remove asserts from the tests

Cc: Andrii Nakryiko <andriin@fb.com>

Stanislav Fomichev (4):
  selftests/bpf: test_progs: change formatting of the condenced output
  selftests/bpf: test_progs: test__skip
  selftests/bpf: test_progs: remove global fail/success counts
  selftests/bpf: test_progs: remove asserts from subtests

 .../selftests/bpf/prog_tests/bpf_obj_id.c     | 32 +++++--
 .../bpf/prog_tests/bpf_verif_scale.c          | 10 +-
 .../selftests/bpf/prog_tests/flow_dissector.c |  2 +-
 .../bpf/prog_tests/get_stack_raw_tp.c         |  2 +-
 .../selftests/bpf/prog_tests/global_data.c    | 10 +-
 .../selftests/bpf/prog_tests/l4lb_all.c       |  4 +-
 .../selftests/bpf/prog_tests/map_lock.c       | 28 +++---
 .../selftests/bpf/prog_tests/pkt_access.c     |  2 +-
 .../selftests/bpf/prog_tests/pkt_md_access.c  |  2 +-
 .../bpf/prog_tests/queue_stack_map.c          |  4 +-
 .../bpf/prog_tests/reference_tracking.c       |  2 +-
 .../selftests/bpf/prog_tests/send_signal.c    |  1 +
 .../selftests/bpf/prog_tests/spinlock.c       | 12 ++-
 .../bpf/prog_tests/stacktrace_build_id.c      | 11 ++-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  | 11 ++-
 .../selftests/bpf/prog_tests/stacktrace_map.c |  2 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c    |  2 +-
 .../bpf/prog_tests/task_fd_query_rawtp.c      |  2 +-
 .../bpf/prog_tests/task_fd_query_tp.c         |  2 +-
 .../selftests/bpf/prog_tests/tcp_estats.c     |  2 +-
 tools/testing/selftests/bpf/prog_tests/xdp.c  |  2 +-
 .../bpf/prog_tests/xdp_adjust_tail.c          |  2 +-
 .../selftests/bpf/prog_tests/xdp_noinline.c   |  4 +-
 tools/testing/selftests/bpf/test_progs.c      | 93 +++++++++++--------
 tools/testing/selftests/bpf/test_progs.h      | 28 +++++-
 25 files changed, 165 insertions(+), 107 deletions(-)

-- 
2.23.0.rc1.153.gdeed80330f-goog
