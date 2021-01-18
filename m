Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7433D2F9AE8
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 09:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbhARIBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 03:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733306AbhARIAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 03:00:54 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA944C061573;
        Mon, 18 Jan 2021 00:00:13 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id 6so8170194wri.3;
        Mon, 18 Jan 2021 00:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QrqziBluAm2S7jXEhlyaBX23uYOu5nIn+17iqFzqPgc=;
        b=PoKTj57akzrAzBOa8fvLRnZicOvuIP3BcIDUm6snh/3aqOytbhsto0hj+3DpxwZuWd
         demfto64a5AT8fDUlK0KIIUq6VDCKBryqDLDW/I45kUexbFy+eyH7Dob5BrcgQAaPuA8
         avdA0wzGnqgHFIJhdnaqQlGGf6NJ8SEsjTjLOIjg3mYfFK0N2sKxOuNyM/RBkFW1vIt0
         niCgRTGRFSSlcSFARrgjI8cWKlGHlVZc3IuXAh6+vTp5jbruNdbTiRF0NxPK/zTER3cq
         o0WrL30jI+l+1kWLRSmsE5Zf4IbVAalV7oW+GAHSONCPNu4LpL57WHJioU6Z22TimKmE
         ayOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QrqziBluAm2S7jXEhlyaBX23uYOu5nIn+17iqFzqPgc=;
        b=VoaRpxXEvhVZaOhedZghmx+Q8PcfoET/cBnNqZeWFa6ZxcUKHBdj2RNmycyO1Gd6nz
         YWzb0K9jtYQBSeyS3V9rCgpaePBGRw+TernZKBUVVDtfk8wnd3vaqmLJMAqUQDQNOc8k
         ccs9TF6GKcN8mWi12KkrfaU3kou8RZjyQlu9hk2f2cb3hVM+Cbs0zNqBI8+gExSpBRfT
         DgM51qyUfrqIOWADvVC8VTtF5/CiW3hpV+8j5pp9kX4y650wvFawYeU5L8MhGsGYlL3K
         DzO8pgb2bK+G15asBwb233bMPlMwgdbpLmdtRlIJyYSrv+K0qr8k0FO90teDzunUqPnR
         Q52g==
X-Gm-Message-State: AOAM533I8/tWyt9bDIONao0jxyhn+s1n9ZvY4LNFo6PeP+pVKs63+MZa
        2BZUQJlUnlk/zqgbton4av8=
X-Google-Smtp-Source: ABdhPJxPXOD2LCsasbBNvZyD+MIQMWFrvrBqRcYhmt58KixPQUATj7Mv6o5OThbKodVhcZs9avJ0/A==
X-Received: by 2002:adf:b359:: with SMTP id k25mr25033448wrd.98.1610956812441;
        Mon, 18 Jan 2021 00:00:12 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2d3e:6800:ad77:727f:e0e1:17c4])
        by smtp.gmail.com with ESMTPSA id i11sm23187419wmq.10.2021.01.18.00.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 00:00:11 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Brendan Jackman <jackmanb@google.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH for bpf-next] docs: bpf: add minimal markup to address doc warning
Date:   Mon, 18 Jan 2021 09:00:04 +0100
Message-Id: <20210118080004.6367-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 91c960b00566 ("bpf: Rename BPF_XADD and prepare to encode other
atomics in .imm") modified the BPF documentation, but missed some ReST
markup.

Hence, make htmldocs warns on Documentation/networking/filter.rst:1053:

  WARNING: Inline emphasis start-string without end-string.

Add some minimal markup to address this warning.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on next-20210118

Brendan, please ack.

Alexei, please pick this minor cleanup patch on your bpf-next.

 Documentation/networking/filter.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
index f6d8f90e9a56..45f6fde1776c 100644
--- a/Documentation/networking/filter.rst
+++ b/Documentation/networking/filter.rst
@@ -1048,12 +1048,12 @@ Unlike classic BPF instruction set, eBPF has generic load/store operations::
 Where size is one of: BPF_B or BPF_H or BPF_W or BPF_DW.
 
 It also includes atomic operations, which use the immediate field for extra
-encoding.
+encoding::
 
    .imm = BPF_ADD, .code = BPF_ATOMIC | BPF_W  | BPF_STX: lock xadd *(u32 *)(dst_reg + off16) += src_reg
    .imm = BPF_ADD, .code = BPF_ATOMIC | BPF_DW | BPF_STX: lock xadd *(u64 *)(dst_reg + off16) += src_reg
 
-The basic atomic operations supported are:
+The basic atomic operations supported are::
 
     BPF_ADD
     BPF_AND
-- 
2.17.1

