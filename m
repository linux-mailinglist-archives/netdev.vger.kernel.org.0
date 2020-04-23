Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B071B5328
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgDWDbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:31:53 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37984 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726581AbgDWDbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 23:31:52 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 34F44B96E9C6D696D198;
        Thu, 23 Apr 2020 11:31:49 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Apr 2020 11:31:47 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <dan.carpenter@oracle.com>,
        <andrii.nakryiko@gmail.com>
Subject: [PATCH bpf-next v2 0/2] Change return code if failed to load object
Date:   Thu, 23 Apr 2020 11:33:12 +0800
Message-ID: <20200423033314.49205-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200422093329.GI2659@kadam>
References: <20200422093329.GI2659@kadam>
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

v2: Adjust line breaks at 72 characters for commit log, and pr_warn alignment as suggested by dan carpenter. For second patch, add Acked-by tag as well.

Mao Wenan (2):
  bpf: Change error code when ops is NULL
  libbpf: Return err if bpf_object__load failed

 kernel/bpf/syscall.c   | 7 ++++---
 tools/lib/bpf/libbpf.c | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.20.1

