Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD91F2F809
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 09:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfE3Ho5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 03:44:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43393 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfE3Ho4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 03:44:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id l17so3448752wrm.10
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 00:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ZPN60tHW+fkN7QhWRO4Pw+Ht0a4svKocBgd17LlVcuk=;
        b=ql6rd6yKVcz/rf1KXPSgKGesdv0ZREW2Tk4eJ8MQ7OIPaT2ANJfNhrSIFTsrpIvGz8
         XqYICZewmULQzP6iWLEaNI4S8DbKiS1P4ml7hwP4JIrOPCY5pULsSjVijj55cqrDhQQL
         IA97rxnBU7cM0Ir4YOghvg/XsjmG8DjZ4piUYyAWCQYRMgwJu9w8ycCuCS9QJTFy9PRj
         W9LK8FXUIpu0Z/q6r5vEbSrbuGWj1Wa+25VcsUc6TFobFauMLYFXfSOKhprf5ja0Dyl7
         lmLscXdHplID/Nzq0Nx3t45HrZ/sGw+f7MOIesptNlsS2h7CrypE3dnolO6OkrvNfT0a
         KPRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZPN60tHW+fkN7QhWRO4Pw+Ht0a4svKocBgd17LlVcuk=;
        b=QFfK3R5Eizj1iR9u8UGVwfyURDI2o7LALFmiBJW86vODhis+mSj8x8zsD5oTdrSToE
         vg0QsJRS0wFoOVa2T5DIHwE5ODaJBeuK1XvN/j7zfwv6LkiIyqgvppkwkU5BCFCPyUKC
         2c+LQzpyFw3wwLvQ/gak4GYgfGHb4V5/QZXCvYt9I8/ol5xtFchWGdKkhWAFa1J61U+m
         c6lBFujU9PPA7rE2bl0Qu0B4tfgUaoGUbof6rmzZ2aipOvGtNyrtMFuJ4uVLky5Lhjul
         sJ7X80w6Vuu2+Pe1iXcnziTEd1wronIa6rnlrzS7AwfMcSvdB/rorqr7Yf10o9Uhf8Cl
         LriA==
X-Gm-Message-State: APjAAAWeW+F4eL1Bn+uPqjT5iqWMu7J+2Agbm5ImSf0C4nsHcpxRTOur
        Je7fjpOpL9xQ0qcS5OsqH8HzOqb1tWc=
X-Google-Smtp-Source: APXvYqw5ml6KXwvVIJOtulj/uLhJjCv/pOs6e+ZBjd+xQjftmb9aTPWWLAqtlBq8awPa2eZjJX32Qg==
X-Received: by 2002:adf:f04d:: with SMTP id t13mr1552728wro.36.1559202294613;
        Thu, 30 May 2019 00:44:54 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id w2sm1544001wru.16.2019.05.30.00.44.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 00:44:53 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH bpf-next] bpf: doc: update answer for 32-bit subregister question
Date:   Thu, 30 May 2019 08:44:47 +0100
Message-Id: <1559202287-15553-1-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has been quite a few progress around the two steps mentioned in the
answer to the following question:

  Q: BPF 32-bit subregister requirements

This patch updates the answer to reflect what has been done.

v1:
 - Integrated rephrase from Quentin and Jakub.

Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 Documentation/bpf/bpf_design_QA.rst | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index cb402c5..5092a2a 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -172,11 +172,31 @@ registers which makes BPF inefficient virtual machine for 32-bit
 CPU architectures and 32-bit HW accelerators. Can true 32-bit registers
 be added to BPF in the future?
 
-A: NO. The first thing to improve performance on 32-bit archs is to teach
-LLVM to generate code that uses 32-bit subregisters. Then second step
-is to teach verifier to mark operations where zero-ing upper bits
-is unnecessary. Then JITs can take advantage of those markings and
-drastically reduce size of generated code and improve performance.
+A: NO
+
+But some optimizations on zero-ing the upper 32 bits for BPF registers are
+available, and can be leveraged to improve the performance of JIT compilers
+for 32-bit architectures.
+
+Starting with version 7, LLVM is able to generate instructions that operate
+on 32-bit subregisters, provided the option -mattr=+alu32 is passed for
+compiling a program. Furthermore, the verifier can now mark the
+instructions for which zero-ing the upper bits of the destination register
+is required, and insert an explicit zero-extension (zext) instruction
+(a mov32 variant). This means that for architectures without zext hardware
+support, the JIT back-ends do not need to clear the upper bits for
+subregisters written by alu32 instructions or narrow loads. Instead, the
+back-ends simply need to support code generation for that mov32 variant,
+and to overwrite bpf_jit_needs_zext() to make it return "true" (in order to
+enable zext insertion in the verifier).
+
+Note that it is possible for a JIT back-end to have partial hardware
+support for zext. In that case, if verifier zext insertion is enabled,
+it could lead to the insertion of unnecessary zext instructions. Such
+instructions could be removed by creating a simple peephole inside the JIT
+back-end: if one instruction has hardware support for zext and if the next
+instruction is an explicit zext, then the latter can be skipped when doing
+the code generation.
 
 Q: Does BPF have a stable ABI?
 ------------------------------
-- 
2.7.4

