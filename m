Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD741B3A09
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgDVI2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:28:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2833 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbgDVI2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 04:28:43 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F0402F77B6BB4EF88F18;
        Wed, 22 Apr 2020 16:28:40 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 22 Apr 2020 16:28:39 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH bpf-next 0/2] Change return code if failed to load object
Date:   Wed, 22 Apr 2020 16:30:08 +0800
Message-ID: <20200422083010.28000-1-maowenan@huawei.com>
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

Mao Wenan (2):
  bpf: Change error code when ops is NULL
  libbpf: Return err if bpf_object__load failed

 kernel/bpf/syscall.c   | 8 +++++---
 tools/lib/bpf/libbpf.c | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.20.1

