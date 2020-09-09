Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAFF2631BF
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgIIQZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730937AbgIIQXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:23:08 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B60DC061756
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:22:55 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e16so3654696wrm.2
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lUTQ7wjwTJ+TAAblcFAmVW5okwBV1FuPt1Figo65gko=;
        b=SA8mxauCZHhys4AY9RnLusQACh/4c3QjGYXAfds8TZfUIwXDOWF7VVrg/hQyjIJk86
         ycXtmyUSiREfFLGxwtps9e/IJetitYFiMwzLaljUTSgev+0o2CGUFooRIrx77w3BOozD
         mSWKinjNGps4UDzHhA9Oe4E0R1mPM0h88H7AL18UJFESZtvy4Hinn78RVlpk+9G49Slj
         hqFk3jVcR6Rzzpl2S1O1fU2TT8BPCUAdDRIfQf6gLhyD7cKDI3rzNLVEIexB9X9+mmL9
         +T3VmQalbPouKLl2wLRJCoRGTb6YsPy0LCW+DA4KLkQ4cB8VJH8Vyj9XjxIjg24tGV/c
         Y16w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lUTQ7wjwTJ+TAAblcFAmVW5okwBV1FuPt1Figo65gko=;
        b=VYrtqbkFkXGp7Qox/VTALOh8hbjSspx8AxQIIgnjFvTOXVB1A05Wa96QUVIHIwCcOd
         f9GgJr9mVRFYeL5iBL23GNA3Hq8SSAsLQMISbTaIvbycoBf3pUNcGWI0XDIh+DW/hePe
         2s8vIWGCSmwk4XqICv2Vppj3PIVdDSycOHgBbLOXxZ69/KFffC2F7GysbGXMO7aPbfPO
         eh3FKySwzcNbx/zOSG9snzgWCZ1XHZylSGp0qv+uQzhzYA2EUDvR9k108KUsV6l5oWmx
         AfpY5Oyy1OTvBwa9cxYgqzZqFiEJXscE0Ydh8rl3lEZewLa+S03vBHzpCCuVox4kSHe+
         86zQ==
X-Gm-Message-State: AOAM530JiX1LZQWYu2GgrjZZJNyt6OjVjHdUyNtYg+WmL3FipOzoqd/c
        xMlcA8PawSXFtGYPKIPQHbry2g==
X-Google-Smtp-Source: ABdhPJxWjRBMchnrLLSUaxfRCoZrWEzjzCUuxR411iSq7GyrTXMlZOgbT8bUKL99RTCZwc1+IvugYw==
X-Received: by 2002:a5d:4c52:: with SMTP id n18mr4583138wrt.267.1599668573655;
        Wed, 09 Sep 2020 09:22:53 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.149])
        by smtp.gmail.com with ESMTPSA id m1sm4747787wmc.28.2020.09.09.09.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 09:22:53 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 0/2] bpf: detect build errors for man pages for bpftool and eBPF helpers
Date:   Wed,  9 Sep 2020 17:22:49 +0100
Message-Id: <20200909162251.15498-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set aims at improving the checks for building bpftool's documentation
(including the man page for eBPF helper functions). The first patch lowers
the log-level from rst2man and fix the reported informational messages. The
second one extends the script used to build bpftool in the eBPF selftests,
so that we also check a documentation build.

This is after a suggestion from Andrii Nakryiko.

v2:
- Pass rst2man option through a dedicated variable, use it to ask for a
  non-zero exit value on errors.
- Also build doc right after bpftool when building (not only running) the
  selftests.

Quentin Monnet (2):
  tools: bpftool: log info-level messages when building bpftool man
    pages
  selftests, bpftool: add bpftool (and eBPF helpers) documentation build

 tools/bpf/bpftool/Documentation/Makefile      |  3 ++-
 .../bpf/bpftool/Documentation/bpftool-btf.rst |  3 +++
 .../bpf/bpftool/Documentation/bpftool-gen.rst |  4 ++++
 .../bpf/bpftool/Documentation/bpftool-map.rst |  3 +++
 tools/testing/selftests/bpf/Makefile          |  5 +++++
 .../selftests/bpf/test_bpftool_build.sh       | 21 +++++++++++++++++++
 6 files changed, 38 insertions(+), 1 deletion(-)

-- 
2.25.1

