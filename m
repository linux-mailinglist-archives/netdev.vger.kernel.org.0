Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50130432FE9
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbhJSHpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230207AbhJSHpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 03:45:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B9E761374;
        Tue, 19 Oct 2021 07:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634629376;
        bh=SO5fYejgKA+nOb49D+W5pbFFKzUDjz05kUsN/v0JTbY=;
        h=From:To:Cc:Subject:Date:From;
        b=Y7sv6CKyz/k3rbP3js7CQqHoAPoRn6VSnZ1ud+vlz2d4+AJu+0dq+2d8axT/DTBw/
         xZ/oz2tQ382OvUX8Q4NRzI7xyBAH1XtxKK8e8vL1fGslzx3aIF3bPjeZYPUoPZ25RD
         EnuX+crW7sJFo0/6wxR52QzyYl+Y0BpzNfpHIvtTDmAyRg1r0Ge6LvNYB427CBrUWi
         ghYmOmdkbYffAda/fn3as8KizjIx6uR3LwFF8a6pM6CiSKIliOU7+Rjr1sLwzZ6jHH
         1A1zPbttqeQ8/QOPM6XpeM6Tjk1ESbbcmle7+xzCEO86dpEmkYqYpxE8OTmQbqnkww
         Q9RmXyogaDnlw==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mcjlt-001nLe-6o; Tue, 19 Oct 2021 08:42:53 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/2] Two fixes for documentation-file-ref-check
Date:   Tue, 19 Oct 2021 08:42:49 +0100
Message-Id: <cover.1634629094.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,

This small series contain two fixes for  documentation-file-ref-check,
in order to remove some (false) positives.

The first one makes it to ignore files that start with a dot. It
prevents the script to try parsing hidden files. 

The second one shuts up (currently) two false-positives for some
documents under:

	tools/bpf/bpftool/Documentation/

Mauro Carvalho Chehab (2):
  scripts: documentation-file-ref-check: ignore hidden files
  scripts: documentation-file-ref-check: fix bpf selftests path

 scripts/documentation-file-ref-check | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.31.1


