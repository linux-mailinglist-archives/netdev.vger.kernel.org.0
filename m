Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5805E30FF2E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBDVT3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 4 Feb 2021 16:19:29 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:27622 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhBDVT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:19:28 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-1IYQS6XkO4G7LpkQ6OwGVA-1; Thu, 04 Feb 2021 16:18:31 -0500
X-MC-Unique: 1IYQS6XkO4G7LpkQ6OwGVA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7232680364B;
        Thu,  4 Feb 2021 21:18:29 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CC965B695;
        Thu,  4 Feb 2021 21:18:26 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH bpf-next 0/4] kbuild/resolve_btfids: Invoke resolve_btfids clean in root Makefile
Date:   Thu,  4 Feb 2021 22:18:21 +0100
Message-Id: <20210204211825.588160-1-jolsa@kernel.org>
In-Reply-To: <20210129134855.195810-1-jolsa@redhat.com>
References: <20210129134855.195810-1-jolsa@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
resolve_btfids tool is used during the kernel build,
so we should clean it on kernel's make clean.
    
thanks,
jirka


---
Jiri Olsa (4):
      tools/resolve_btfids: Build libbpf and libsubcmd in separate directories
      tools/resolve_btfids: Check objects before removing
      tools/resolve_btfids: Set srctree variable unconditionally
      kbuild: Add resolve_btfids clean to root clean target

 Makefile                            |  7 ++++++-
 tools/bpf/resolve_btfids/.gitignore |  2 --
 tools/bpf/resolve_btfids/Makefile   | 38 ++++++++++++++++++++------------------
 3 files changed, 26 insertions(+), 21 deletions(-)

