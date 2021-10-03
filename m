Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510CA4203AC
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 21:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhJCTYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 15:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhJCTYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 15:24:21 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33D3C061796
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 12:22:27 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id t16-20020a1c7710000000b003049690d882so17179866wmi.5
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 12:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PNpnL8ZQsgPH+z/F1sT0I4BRmDeqtk9e85L/4fLHn7U=;
        b=qHk0pFUmQaua9Z6qCkrmlYzQsSD1RtUmCaQ2wYUEv0R94CAABxOlNnaM/S4Lc2Boll
         R0Nr9qFIQRSrU0veduqtWRy8S/SxNHEzAHMizBbuHysz2YAZZkUtAQQJ/4cCegyYwuyF
         iMuDuwKQm4MyR9YtHYSRAwwZftV6+jFXY9eRd/vOHHlzQc2ZBHQVLiAiEVGO3nnc3Kax
         rBGwy7/t+7n9IkgQ/jfJlIA+woTMnsVGc2cAO6txXdjem9/KO3En+KzMmAn/ojWTYIDa
         WW8z0kCHVIdT21TBsTM2XhebY23GZEitRXLJ8CmYd72rUdwbE4NnkkMCPsrgPFDdSsMP
         vhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PNpnL8ZQsgPH+z/F1sT0I4BRmDeqtk9e85L/4fLHn7U=;
        b=nOKv7GkrCy8zA8zmQ24W4w8GNoJmJPADTrsF35aDvwUmL62vg5pcTPgJv6F01tlUas
         k/xktbAmLbOb4S1Zx88QAjFwd670N6MxGIDt6StAc5BfC7TE2r83UlmgFtcVHg5tROz6
         pna9hLQTK5isgdWtPklrcq7leu+ZsUZT6rj+l/6pftWqupJrRArQ3fLfFeSsoyTe7osl
         ysl5vfluMMVo5IlL6FERP46CkNK5m+d5pKpBtEN1pTUvi5zISl1N9jQdwPD+IZa7+NKv
         bLlYtM2sS5KbPNkwz53Mhdzvoe4fji+sbSVznE2fVcdz0MopZhIt43rZzEXmVAlAnAbd
         VktA==
X-Gm-Message-State: AOAM530goyVCzDbOirHtIYwVkS0tfxcpT+MTC973gnt1HODBKdvKtbc3
        fDDDpjx57vDoCxW+CHixH8iK9Q==
X-Google-Smtp-Source: ABdhPJzvY4ZHRSimMrDe1tSIQAGyULfdDHglxmmujPfI+cMx5/fKYCELvzLpHfL4QTRb0agzGoVtJA==
X-Received: by 2002:a05:600c:210d:: with SMTP id u13mr5374985wml.146.1633288946586;
        Sun, 03 Oct 2021 12:22:26 -0700 (PDT)
Received: from localhost.localdomain ([149.86.88.77])
        by smtp.gmail.com with ESMTPSA id d3sm14124642wrb.36.2021.10.03.12.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 12:22:26 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 08/10] samples/bpf: update .gitignore
Date:   Sun,  3 Oct 2021 20:22:06 +0100
Message-Id: <20211003192208.6297-9-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003192208.6297-1-quentin@isovalent.com>
References: <20211003192208.6297-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update samples/bpf/.gitignore to ignore files generated when building
the samples. Add:

  - vmlinux.h
  - the generated skeleton files (*.skel.h)
  - the samples/bpf/libbpf/ and .../bpftool/ directories, recently
    introduced as an output directory for building libbpf and bpftool.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 samples/bpf/.gitignore | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index fcba217f0ae2..09a091b8a4f3 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -57,3 +57,7 @@ testfile.img
 hbm_out.log
 iperf.*
 *.out
+*.skel.h
+vmlinux.h
+bpftool/
+libbpf/
-- 
2.30.2

