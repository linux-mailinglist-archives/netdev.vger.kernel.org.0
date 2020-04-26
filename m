Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED2B1B8CEA
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 08:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgDZGf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 02:35:27 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2906 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725864AbgDZGf1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 02:35:27 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EF2F031EE3ABAF99E1B2;
        Sun, 26 Apr 2020 14:35:18 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sun, 26 Apr 2020 14:35:16 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <andrii.nakryiko@gmail.com>, <dan.carpenter@oracle.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH bpf-next v3 0/2] Change return code if failed to load
Date:   Sun, 26 Apr 2020 14:36:33 +0800
Message-ID: <20200426063635.130680-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch change return code from -EINVAL to -EOPNOTSUPP,
the second patch quote the err value returned by bpf_object__load().

v3: delete pr_warn for first patch.
v2: Adjust line breaks at 72 characters for commit log, and pr_warn
alignment as suggested by dan carpenter. For second patch, add
Acked-by tag as well.

Mao Wenan (2):
  bpf: Change error code when ops is NULL
  libbpf: Return err if bpf_object__load failed

 kernel/bpf/syscall.c   | 2 +-
 tools/lib/bpf/libbpf.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.20.1

