Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A83017051F
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgBZQ7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 11:59:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:36244 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbgBZQ7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 11:59:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A232EAEAF;
        Wed, 26 Feb 2020 16:59:52 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v4 4/5] bpftool: Update bash completion for "bpftool feature" command
Date:   Wed, 26 Feb 2020 17:59:38 +0100
Message-Id: <20200226165941.6379-5-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226165941.6379-1-mrostecki@opensuse.org>
References: <20200226165941.6379-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update bash completion for "bpftool feature" command with the new
argument: "full".

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/bpf/bpftool/bash-completion/bpftool | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index ad4133b1f0cf..f2838a658339 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -984,11 +984,12 @@ _bpftool()
                 probe)
                     [[ $prev == "prefix" ]] && return 0
                     if _bpftool_search_list 'macros'; then
-                        COMPREPLY+=( $( compgen -W 'prefix' -- "$cur" ) )
+                        _bpftool_once_attr 'prefix'
                     else
                         COMPREPLY+=( $( compgen -W 'macros' -- "$cur" ) )
                     fi
                     _bpftool_one_of_list 'kernel dev'
+                    _bpftool_once_attr 'full'
                     return 0
                     ;;
                 *)
-- 
2.25.1

