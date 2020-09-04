Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83FB25DF97
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgIDQPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgIDQPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:15:05 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7268C061245
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 09:15:04 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a17so7280126wrn.6
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 09:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5LPQmPEkxJnCkF/UpdToOFRR/yXgvFNfch1xEMrbLuA=;
        b=gqSV2dX6WmxCYVM6gGeIZBoKrkKaTPwGkMhvwhamR3yoUwwrZ77xvCyEYRjqI+qbIg
         LOGJ/2yzcTo5kbWSqIYdlGMCQ0gIpSh1CtqfKHdbs6EtuPU9wKfujWoe5y0fc8GtBhCu
         DBID2cYhxyuRMv7mipAbuOczRhn4k43Pr6ZCCvCmzZ3ZD29yrSDoXBnWFf5WLzFD7ba7
         LdjFc5zISPOVSmRODyI3ouDueL9YIdDtVJoMbe4hnCRnYhkvuSjsL/f7piftSqL4kzUw
         xVj/zRFNvjF8TLb2sS+KdWhQQn2GZlFiW1nD+ScT3Pn2Oq13AwmupbAYPV9AKFX5VQDz
         IZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5LPQmPEkxJnCkF/UpdToOFRR/yXgvFNfch1xEMrbLuA=;
        b=K1QAPbnZZ0MrWrawdv6VLnHprT5u1Nk3wWB85+ba3MUyGQmzPVWuVCZeR1D5Hm19kK
         E+Cg7htxQbIXvGCUk+Wc6Or9/1FPFyHJT7wUkH5kcu5VtcBZtvj0piMIT1FMhdhCiPsl
         ju3pjCNMe0PxMPr2LJ2dCLGAG0NdmT8ScgMpPt6EayrdgFq6QXlqeN12q8ZkUCoJGc7l
         XIZm+56ALvCKrwj0bmzFFR/FupJhMifzChaQYjOMS9zK9aYiHlMqcQFiji2jSI1/09iE
         czhoo3FQjrz5lnNKuUxAexlrAqQBcRW2N5y6w/5uHROQV0ykYDXOV8A8/nxEE4QIscsk
         sNaA==
X-Gm-Message-State: AOAM531Ti1oII/lIoo2knEXwnA2UJwNsJlFnbplhaW3V02llUjB8ts+H
        L2AyQFqpU0kMIqMtOapfQs41Krg4yBPcstY7
X-Google-Smtp-Source: ABdhPJxlTQqo2ni8QNz+eYD1KAn/FAyE1GA28s8gerIVRJWYIE/EY1fzzMvlp/2vexYR90o8itfotA==
X-Received: by 2002:a5d:570b:: with SMTP id a11mr4871009wrv.139.1599236101105;
        Fri, 04 Sep 2020 09:15:01 -0700 (PDT)
Received: from localhost.localdomain ([194.35.117.187])
        by smtp.gmail.com with ESMTPSA id p1sm28859352wma.0.2020.09.04.09.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 09:15:00 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/3] bpf: format fixes for BPF helpers and bpftool documentation
Date:   Fri,  4 Sep 2020 17:14:51 +0100
Message-Id: <20200904161454.31135-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains minor fixes (or harmonisation edits) for the
bpftool-link documentation (first patch) and BPF helpers documentation
(last two patches), so that all related man pages can build without errors.

Quentin Monnet (3):
  tools: bpftool: fix formatting in bpftool-link documentation
  bpf: fix formatting in documentation for BPF helpers
  tools, bpf: synchronise BPF UAPI header with tools

 include/uapi/linux/bpf.h                      | 87 ++++++++++---------
 .../bpftool/Documentation/bpftool-link.rst    |  2 +-
 tools/include/uapi/linux/bpf.h                | 87 ++++++++++---------
 3 files changed, 91 insertions(+), 85 deletions(-)

-- 
2.20.1

