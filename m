Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42853A925F
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFPGaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231481AbhFPG3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 02:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0EC3613DC;
        Wed, 16 Jun 2021 06:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623824868;
        bh=TBS6JoAxPmOD9dx9GzeTj3rbPrTu3AsIuW9k8qlWnzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvf48LwFRDgIKhclCtr3FEhmUOggvXofz9CCdHQx+jkk1DsZU88KPa2K02jfFJdmX
         ZnjjYQi5XeedFfmI2YJnM3qIcYkSsPFaRwyNSTnYqVH/wzsXbopt388skz2FHQ0pOJ
         6yObsuhaidcj3nLZJBeVVr8b7DEqWxax/HxEaK+dQv4Nt9aupErg/RIaLlWPzfAeOz
         ULynHSIpC3JsEtI20GSQSrCud5Jt4pX5wKI5OxoLKE4NqkK1wcPZx1bpFqiZjJqVfJ
         tn/gilM5g5C8nVZMU8PWQhHIGu0A5NFipdro3QdQVBuC2lKm2jdfdkVY7AsMpAapAG
         xqqYp4741lazQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1ltP1e-004kIk-65; Wed, 16 Jun 2021 08:27:46 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Brendan Jackman <jackmanb@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Florent Revest <revest@chromium.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 07/29] docs: bpf: bpf_lsm.rst: avoid using ReST :doc:`foo` markup
Date:   Wed, 16 Jun 2021 08:27:22 +0200
Message-Id: <fcee73b9bb55a8d0efd07cf04076c66278a42db4.1623824363.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623824363.git.mchehab+huawei@kernel.org>
References: <cover.1623824363.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The :doc:`foo` tag is auto-generated via automarkup.py.
So, use the filename at the sources, instead of :doc:`foo`.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/bpf/bpf_lsm.rst | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/bpf/bpf_lsm.rst b/Documentation/bpf/bpf_lsm.rst
index 1c0a75a51d79..0dc3fb0d9544 100644
--- a/Documentation/bpf/bpf_lsm.rst
+++ b/Documentation/bpf/bpf_lsm.rst
@@ -20,10 +20,10 @@ LSM hook:
 Other LSM hooks which can be instrumented can be found in
 ``include/linux/lsm_hooks.h``.
 
-eBPF programs that use :doc:`/bpf/btf` do not need to include kernel headers
-for accessing information from the attached eBPF program's context. They can
-simply declare the structures in the eBPF program and only specify the fields
-that need to be accessed.
+eBPF programs that use Documentation/bpf/btf.rst do not need to include kernel
+headers for accessing information from the attached eBPF program's context.
+They can simply declare the structures in the eBPF program and only specify
+the fields that need to be accessed.
 
 .. code-block:: c
 
@@ -88,8 +88,9 @@ example:
 
 The ``__attribute__((preserve_access_index))`` is a clang feature that allows
 the BPF verifier to update the offsets for the access at runtime using the
-:doc:`/bpf/btf` information. Since the BPF verifier is aware of the types, it
-also validates all the accesses made to the various types in the eBPF program.
+Documentation/bpf/btf.rst information. Since the BPF verifier is aware of the
+types, it also validates all the accesses made to the various types in the
+eBPF program.
 
 Loading
 -------
-- 
2.31.1

