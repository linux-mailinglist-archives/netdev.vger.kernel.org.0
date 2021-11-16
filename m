Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDBB4531E1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 13:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbhKPMOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 07:14:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235927AbhKPMOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 07:14:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED3F61B3F;
        Tue, 16 Nov 2021 12:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637064686;
        bh=vq95HKLfHO9piwN5lsf/MCq9657Jh2pFENCGhyxmjLo=;
        h=From:To:Cc:Subject:Date:From;
        b=SGZM9xNJKSSd9zG64wbGKiexBM6w+eZXR08apIpufSrM9cni6UGZ7lPrrHiB75CeL
         rHJb+z39/th7FCQuXO5pPiitXv0fw12QpxOsxiKREduVjglCmDJgitnVlnmSBRLw/x
         us3Sy7Hnu2QaYoNqizRvyAP22VcHW1DCdSQxQ/jdqnRn859aNByM6HQAl5TXZbZKcl
         8WoeJoRFFXs6EbSE/a1jePnDacyUUKxLnbXmh5WMn1vtB5AJCH9cBk4duqW6cRERv7
         J5C5zQM47FcF0zSNe/lN8hjKpBpmtjpQSDKeLh3GtuB+CXQ492809BlXN9w9JOnBS6
         BEURxXLKLvNnA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mmxJ6-00A9LO-AD; Tue, 16 Nov 2021 12:11:24 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/4] Address some bad references to Kernel docs
Date:   Tue, 16 Nov 2021 12:11:19 +0000
Message-Id: <cover.1637064577.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,

It follows 4 patches addressing some issues during the 5.16 Kernel development
cycle that were sent to the MLs but weren't merged yet. 

They apply cleanly on the top of 5.16-rc1.

Regards,

Mauro Carvalho Chehab (4):
  libbpf: update index.rst reference
  docs: accounting: update delay-accounting.rst reference
  Documentation: update vcpu-requests.rst reference
  Documentation/process: fix a cross reference

 Documentation/admin-guide/sysctl/kernel.rst  | 2 +-
 Documentation/bpf/index.rst                  | 2 +-
 Documentation/process/submitting-patches.rst | 4 ++--
 arch/riscv/kvm/vcpu.c                        | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.33.1


