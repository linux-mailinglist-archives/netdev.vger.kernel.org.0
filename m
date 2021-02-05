Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EA0311638
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 00:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhBEW55 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Feb 2021 17:57:57 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:40632 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232214AbhBEMl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 07:41:29 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-ELyE_vpNNOiQyxonvvGvSw-1; Fri, 05 Feb 2021 07:40:26 -0500
X-MC-Unique: ELyE_vpNNOiQyxonvvGvSw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 389F6804036;
        Fri,  5 Feb 2021 12:40:24 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24DAA60936;
        Fri,  5 Feb 2021 12:40:20 +0000 (UTC)
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
Subject: [PATCHv2 bpf-next 0/4] kbuild/resolve_btfids: Invoke resolve_btfids clean in root Makefile
Date:   Fri,  5 Feb 2021 13:40:16 +0100
Message-Id: <20210205124020.683286-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

v2 changes:
  - add Song's acks on patches 1 and 4 (others changed) [Song]
  - add missing / [Andrii]
  - change srctree variable initialization [Andrii]
  - shifted ifdef for clean target [Andrii]

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
 tools/bpf/resolve_btfids/Makefile   | 44 ++++++++++++++++++++++----------------------
 3 files changed, 28 insertions(+), 25 deletions(-)

