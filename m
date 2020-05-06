Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFE81C71B1
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgEFNaG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 09:30:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38805 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728592AbgEFNaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 09:30:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-Z2uYOvmOPFir5JhdXVpm0Q-1; Wed, 06 May 2020 09:30:00 -0400
X-MC-Unique: Z2uYOvmOPFir5JhdXVpm0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2964460;
        Wed,  6 May 2020 13:29:58 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8271664430;
        Wed,  6 May 2020 13:29:55 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/9] bpf: Add d_path whitelist
Date:   Wed,  6 May 2020 15:29:39 +0200
Message-Id: <20200506132946.2164578-3-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-1-jolsa@kernel.org>
References: <20200506132946.2164578-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding whitelist for d_path helper under:
  kernel/bpf/helpers-whitelist/d_path

Currently it's just list of test functions, which will
be replaced by list promised by Brendan ;-)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/helpers-whitelist/d_path | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 kernel/bpf/helpers-whitelist/d_path

diff --git a/kernel/bpf/helpers-whitelist/d_path b/kernel/bpf/helpers-whitelist/d_path
new file mode 100644
index 000000000000..e5adf2a9e1cb
--- /dev/null
+++ b/kernel/bpf/helpers-whitelist/d_path
@@ -0,0 +1,8 @@
+do_truncate
+vfs_fallocate
+finish_open
+vfs_open
+generic_file_open
+filp_close
+dentry_open
+vfs_getattr
-- 
2.25.4

