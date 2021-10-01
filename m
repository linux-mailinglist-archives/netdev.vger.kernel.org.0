Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4710541EB8D
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353774AbhJALP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353773AbhJALLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:11:16 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB94C0613E3
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:09:30 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k7so14758102wrd.13
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 04:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LZNCtgJESuuBglLRSxSP+yMWbcKos3toNZIRMOdvxc4=;
        b=Mfv5vvP15OR8E1Y8a9L+d3tTQ7LbH5kKmRVd3+3TXPrgFXxjC70dt9CE9eG0WXAOtz
         P8MygFZcq2QmRR2+PbMGPhpVUE+Obo5pZJ4ETTUruXlitxOO/1T2AZ8P1hyx/9ax9xHx
         yEGGwo+a4DhoxDQmGHQ9hjXxAbIf6meqE3WyyugZaDNfX0i118Hbsv3C0iexWuvgpJMg
         2l6VT5PATlmTM++iNCVDIGOfPaWGn6mOQjWudTXP3TXOUFN7MuOkaypGGrlfnRrGTCUS
         +6MuDQsM7PYQplBRuR0aPnn/l/yuW1E32EOEZ8xQrdAHxa39n12TmTBjKUFWmcpFZAMQ
         JGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LZNCtgJESuuBglLRSxSP+yMWbcKos3toNZIRMOdvxc4=;
        b=eMZdxRvzmnOi4Szk+H4vYAwdTfPZJ3rTvK9ZbRZS9jj2uj7fK9uJA7E7GJGdh6dSsz
         ihHa7ANjz6TqHgFNYasIsLeCx56+aqwk2ffchCACFRzisnmnx3acpn2mOy9Nafay5YhE
         EDfDn+U4D5za/8WjkXLyBBdi7+lGvLEEqIceAv+HsZTeu/n7rrATgstQh3fqzUAP0ZM/
         VdyEkgzsQAjuHs1YD5lfpScLlPpLi9Vh33mevAz430mv1mfU+5J1zUmIuZ8/o/z0ZBOq
         es6lo0a49YBbNaZOZGWs/gwNjAoIOS4ZehkeaK3J1C9WTfE/vGMVe4BH4SCfcMne3Xde
         j5yg==
X-Gm-Message-State: AOAM531tlGXTXIGSEQIcYzPNNn4GNxPLxLTNFAHwnjCEb6kVTIEEH7xG
        2yAW+TaqPcOJ+kcLuM8u8NiAWA==
X-Google-Smtp-Source: ABdhPJzyzCovRIsfB/xwUiwIEYlTY9UvAnCfUA8lOoffqUTKuzclXcz4btF9mnf3TPb1nonpQ63cTA==
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr11363714wrw.376.1633086569059;
        Fri, 01 Oct 2021 04:09:29 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.69])
        by smtp.gmail.com with ESMTPSA id v17sm5903271wro.34.2021.10.01.04.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:09:28 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 8/9] samples/bpf: update .gitignore
Date:   Fri,  1 Oct 2021 12:08:55 +0100
Message-Id: <20211001110856.14730-9-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001110856.14730-1-quentin@isovalent.com>
References: <20211001110856.14730-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update samples/bpf/.gitignore to ignore files generated when building
the samples. Add:

  - vmlinux.h
  - the generated skeleton files (*.skel.h)
  - the samples/bpf/libbpf/ directory, recently introduced as an output
    directory for building libbpf and installing its headers.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 samples/bpf/.gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index fcba217f0ae2..01f94ce79df8 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -57,3 +57,6 @@ testfile.img
 hbm_out.log
 iperf.*
 *.out
+*.skel.h
+vmlinux.h
+libbpf/
-- 
2.30.2

