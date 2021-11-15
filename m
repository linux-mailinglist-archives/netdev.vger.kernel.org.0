Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADD2451F8A
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348498AbhKPAmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350958AbhKPAkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 19:40:15 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07752C073AE2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:59:00 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a9so7511031wrr.8
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ntIoOGpBUqK62R78xU+kVL3iJ/TX6m4TbEuagn27zMg=;
        b=H3RvVgPXZs2xIWzoRiHbAvTQkcuASpgtzHZHS9wDyl0Z+EBmiDsqqyr0NYkaqZFRJa
         DLXYUT47Eqwq35UNmdk4jGZPYO+tB2ZmiqgoPqxfPjX6RgKHm7UQmd8BBQHkvksaj6Bo
         jrmMAWm2HL2FcgxQSKl8wGb9XC+1NgtDrqmkJ8VdrQ6DgrKUMYo9MqIu9UfG5kHUCq2j
         9lVeZ9YwE1qPuOTFJQ9hqSf6L8lw7yfLHB3RkZI2z11u3TMsSKwElAHzXXBwdqP/+REm
         PMXLPRteZYYyO0BGrmizaUY4WSWTYyr5URlHYB0dSuMsKGj1M0aeiZevvqbcZH5I+HoH
         ttfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ntIoOGpBUqK62R78xU+kVL3iJ/TX6m4TbEuagn27zMg=;
        b=n0UI/bz5JYKO0NV0OLqc21WidsjPD1dJi61oYw4AEyVTL7YcZQm6IQUzLukwOw3/Wn
         lyQZKQGqb6nj9i8MgPRMRuwWI9wqrNBGzajpfgUlJjEVf0svldGv95UO7rKz+efTZ+7L
         aYKAKeuv93IiG3CpXwL7aZgys9n6pFSsagLRvi+l9xrj1cu6lnsk3DfmbYJ8Z2s2HvCn
         nMtuzODRFUTpLFEhBtR9GpQT7lk9codPHqDqlgLUYUMzaFw91H9kTEiNYjhGWUZRmZGF
         rRGP4kecBa/3AnP+eBkxnvP+D32wJg3TxcBvO9uf8h/BoYgVbxPYIFUFhXZWhJ5UXg3l
         msVQ==
X-Gm-Message-State: AOAM533/zJuqcTJLJ6UhzStQvGI7+z3qUIAkw+ePIs0veDl1dLJ2I54C
        T29X61q/4dV6DTUaJqPR3z+PkBgzBIx0Ew==
X-Google-Smtp-Source: ABdhPJx4BQgo05AotdxDQQa6AMQL6jYJ7Pr+foXmqc1eYDSMmAMr9hkihoFHHxTIEKqs0vkk7q7Gsg==
X-Received: by 2002:a5d:64ea:: with SMTP id g10mr3556395wri.242.1637017138625;
        Mon, 15 Nov 2021 14:58:58 -0800 (PST)
Received: from localhost.localdomain ([149.86.89.157])
        by smtp.gmail.com with ESMTPSA id y12sm15467619wrn.73.2021.11.15.14.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 14:58:58 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/3] bpftool: update documentation and fix checks
Date:   Mon, 15 Nov 2021 22:58:41 +0000
Message-Id: <20211115225844.33943-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set updates the list of options for bpftool commands, as displayed in
the summary of the man pages. It also updates the script that checks those
option lists, to make it more robust, and more reusable if the layout of
bpftool's directory changed.

Checkpatch complained about the missing SPDX tag when I added a new file
under bpftool/Documentation; I fixed it by adding the tag, and while at it,
I also added the tags to all RST files for bpftool's documentation (see
first patch of this set).

Quentin Monnet (3):
  bpftool: Add SPDX tags to RST documentation files
  bpftool: Update doc (use susbtitutions) and test_bpftool_synctypes.py
  selftests/bpf: Configure dir paths via env in
    test_bpftool_synctypes.py

 tools/bpf/bpftool/Documentation/Makefile      |  2 +-
 .../bpf/bpftool/Documentation/bpftool-btf.rst |  7 +-
 .../bpftool/Documentation/bpftool-cgroup.rst  |  7 +-
 .../bpftool/Documentation/bpftool-feature.rst |  6 +-
 .../bpf/bpftool/Documentation/bpftool-gen.rst |  7 +-
 .../bpftool/Documentation/bpftool-iter.rst    |  6 +-
 .../bpftool/Documentation/bpftool-link.rst    |  7 +-
 .../bpf/bpftool/Documentation/bpftool-map.rst |  7 +-
 .../bpf/bpftool/Documentation/bpftool-net.rst |  6 +-
 .../bpftool/Documentation/bpftool-perf.rst    |  6 +-
 .../bpftool/Documentation/bpftool-prog.rst    |  6 +-
 .../Documentation/bpftool-struct_ops.rst      |  6 +-
 tools/bpf/bpftool/Documentation/bpftool.rst   |  7 +-
 .../bpftool/Documentation/common_options.rst  |  2 +
 .../bpftool/Documentation/substitutions.rst   |  3 +
 .../selftests/bpf/test_bpftool_synctypes.py   | 94 ++++++++++++++++---
 16 files changed, 145 insertions(+), 34 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/substitutions.rst

-- 
2.32.0

