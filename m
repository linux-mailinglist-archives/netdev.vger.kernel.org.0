Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496DA40D6BD
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbhIPJ5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235798AbhIPJ4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 310CA61207;
        Thu, 16 Sep 2021 09:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631786126;
        bh=83vkFWOnmUdHmvdZYCb71ZYm+RoKY7l/VWT0C4zUsJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fquf9bYIq5SlSufpDS1BDsZ19/XUMK5RAlO+U5fsudwHtCD+/l5NdxtjD8AEi+eKQ
         qjngZ4Aoi453AdyK88FH6Hk4mHN/dvzNMEur4FL44Pp2K3dQaZVYpQRSsQaJuSqIOM
         jjfU6me+8hAcPtevDwJb2c8O7mfrZwTc3lNCL+VnEq9uSrRwe+9kw0U3N5Gjn9JAlX
         +whcAbbHkZSkRWsD6LoO0m+C2sdRCLSBeJk7qC5tGoGxhj1z+DNThl+kmh85DqAef/
         0ixJ0ZDm84i3tPrj1p+RexpxrVCFgDepYcMHOOtLmZBkUpffpOZ2RScdBSajSplp/2
         8abhky0XkdPMA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQo72-001vTf-BQ; Thu, 16 Sep 2021 11:55:24 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Grant Seltzer <grantseltzer@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 06/23] libbpf: update index.rst reference
Date:   Thu, 16 Sep 2021 11:55:05 +0200
Message-Id: <854e410df660c62e4e4c8f22c4ae9c6f6594f4a1.1631785820.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631785820.git.mchehab+huawei@kernel.org>
References: <cover.1631785820.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset d20b41115ad5 ("libbpf: Rename libbpf documentation index file")
renamed: Documentation/bpf/libbpf/libbpf.rst
to: Documentation/bpf/libbpf/index.rst.

Update its cross-reference accordingly.

Fixes: d20b41115ad5 ("libbpf: Rename libbpf documentation index file")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/bpf/index.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index 1ceb5d704a97..817a201a1282 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -15,7 +15,7 @@ that goes into great technical depth about the BPF Architecture.
 libbpf
 ======
 
-Documentation/bpf/libbpf/libbpf.rst is a userspace library for loading and interacting with bpf programs.
+Documentation/bpf/libbpf/index.rst is a userspace library for loading and interacting with bpf programs.
 
 BPF Type Format (BTF)
 =====================
-- 
2.31.1

