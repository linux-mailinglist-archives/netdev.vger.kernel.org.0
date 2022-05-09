Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A69C52045C
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240135AbiEISVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 14:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240103AbiEISVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 14:21:21 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0527C26C4FD
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 11:17:27 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 204so10146786pfx.3
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 11:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oWkDpHsNQcU//WqyA+dRFFfwiFMMIS/Sy6GPIt6kPDw=;
        b=qk8GjUGeSy2GhEECdOFRgQvet7NqgsoXiCDpaQVkJXIGpivqsucxXxWlRSKWV/+3YD
         fyD8Qy8vBsXh0Jd8wwAebDGYXUHHLPHytiGe6ULGMGzgpUFmST0at3yiBVp2/6259vQ5
         l0Ee4B731CGzI9tQwsZgH0+PhQ6DxXIZeW55dJFmwOYIBpAzwrpDHi+GTCVXVERYybWz
         z4pXAEQWKqvkMF9rQuI60cfFvT3X83oEwWE5ttZxe8Phl9YZmf1ww3UJYB+pFRtxbnys
         iF/SLpqxleF87J0PvzJHx6mC120TTu4ZdLX41Vb+K0HLCExfC9j6p+6is94sG0v8fREp
         O/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oWkDpHsNQcU//WqyA+dRFFfwiFMMIS/Sy6GPIt6kPDw=;
        b=wuJF+Y8iSeD6Xh+4aGc3co7yHJScxjmt0zOb2/Wxb65bbW/NzrKj9/eqRfjuT9SR5k
         N4SSN9M91zZefTWmmqrJuWUYmNuNSMIjZunkx3EdWaTUJqtem4gyceqb1XckZRaU0ZX0
         7rl5BlbTMdd4/FA3bergZN4Zuc96cuOGrZL2SDK/RJkPwvlUKM4ZVInaXTnQJ6wWVFeA
         AfqWWFleXyXJaWixjyslhwMujqdskMIJIkKMD65P7lHNLYU0L/ZJT9IJC9lewA4n/O27
         bHGwNy/Yn2/p10HwFkSCll9DIVnZSq9fpZxY1wnr5Aec88bdqC7GzyA2NSo/8/b/NcOJ
         2kUQ==
X-Gm-Message-State: AOAM530DkiquOfaM530fsdFHOz1sy0xi4aUS3Ge9Q5xww6gQ4h6qyWv7
        KoR1O4MLCcKb9pu7oO3D4XE=
X-Google-Smtp-Source: ABdhPJymrOIkfw+N5oS9yuMgYEkR248qhs02vGECPTuhaAbPiMS0Poxua9wMF73oSC4/pPWGfBeMng==
X-Received: by 2002:a63:385b:0:b0:3c1:3f5e:1d2a with SMTP id h27-20020a63385b000000b003c13f5e1d2amr14097855pgn.30.1652120246374;
        Mon, 09 May 2022 11:17:26 -0700 (PDT)
Received: from localhost.localdomain ([98.97.39.30])
        by smtp.gmail.com with ESMTPSA id lw17-20020a17090b181100b001dcf9fe5cddsm4600213pjb.38.2022.05.09.11.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 11:17:25 -0700 (PDT)
Subject: [PATCH 0/2] Replacements for patches 2 and 7 in Big TCP series
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     edumazet@google.com
Cc:     alexander.duyck@gmail.com, davem@davemloft.net,
        eric.dumazet@gmail.com, kuba@kernel.org, lixiaoyan@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com
Date:   Mon, 09 May 2022 11:17:24 -0700
Message-ID: <165212006050.5729.9059171256935942562.stgit@localhost.localdomain>
In-Reply-To: <CANn89iJW9GCUWBRtutv1=KHYn0Gpj8ue6bGWMO9LLGXqvgWhmQ@mail.gmail.com>
References: <CANn89iJW9GCUWBRtutv1=KHYn0Gpj8ue6bGWMO9LLGXqvgWhmQ@mail.gmail.com>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is meant to replace patches 2 and 7 in the Big TCP series.
From what I can tell it looks like they can just be dropped from the series
and these two patches could be added to the end of the set.

With these patches I have verified that both the loopback and mlx5 drivers
are able to send and receive IPv6 jumbogram frames when configured with a
g[sr]o_max_size value larger than 64K.

Note I had to make one minor change to iproute2 to allow submitting a value
larger than 64K in that I removed a check that was limiting gso_max_size to
no more than 65536. In the future an alternative might be to fetch the
IFLA_TSO_MAX_SIZE attribute if it exists and use that, and if not then use
65536 as the limit.

---

Alexander Duyck (2):
      net: Allow gso_max_size to exceed 65536
      net: Allow gro_max_size to exceed 65536


 drivers/net/ethernet/amd/xgbe/xgbe.h            |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |  2 +-
 drivers/net/ethernet/sfc/ef100_nic.c            |  3 ++-
 drivers/net/ethernet/sfc/falcon/tx.c            |  3 ++-
 drivers/net/ethernet/sfc/tx_common.c            |  3 ++-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h      |  3 ++-
 drivers/net/hyperv/rndis_filter.c               |  2 +-
 drivers/scsi/fcoe/fcoe.c                        |  2 +-
 include/linux/netdevice.h                       |  6 ++++--
 include/net/ipv6.h                              |  2 +-
 net/bpf/test_run.c                              |  2 +-
 net/core/dev.c                                  |  7 ++++---
 net/core/gro.c                                  |  8 ++++++++
 net/core/rtnetlink.c                            | 10 +---------
 net/core/sock.c                                 |  4 ++++
 net/ipv4/tcp_bbr.c                              |  2 +-
 net/ipv4/tcp_output.c                           |  2 +-
 net/sctp/output.c                               |  3 ++-
 18 files changed, 40 insertions(+), 27 deletions(-)

--

