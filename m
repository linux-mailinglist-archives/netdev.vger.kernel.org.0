Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFDA38ACD5
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 04:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfHMCqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 22:46:36 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:46042 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHMCqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 22:46:36 -0400
Received: by mail-pl1-f169.google.com with SMTP id y8so6539777plr.12
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 19:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aeYIDCYizWFxh6gGgL45eDxaStQmV50vAqG513aqSM4=;
        b=jVNGgWGoDC/5fTVQQPWgLaSspTLQ357q2rYV09i14CgLM/ENXCQMxIoV/AFD/FckYU
         QeHs7+tvXjTgwJvSOOLkY7tEZ122U2ud2B6k7DNxO0oxU6eCAttOHT9qvQ4NPusu6MyQ
         HtLSnn69ldfHpfuVYzltlbqR9IpgT0vIRt0Y3y4U0hmJYiJ1aBD2ochZ53BWfB30KPWI
         Ca9EX4ghCaj8CtXu4L8TZm328uxKYd6Ld745nQr2tlLz8ny+nm8cjM2WjqQ/z/RsKCos
         gZGlVRaVwh0mFu5X7APAjmeEqBZ1sNA1LM32D9bocPubqPJxbFmliZAYeK0JN3HQkpRL
         UyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aeYIDCYizWFxh6gGgL45eDxaStQmV50vAqG513aqSM4=;
        b=rKzW2bRxwTIS6ElXCBlUUTqCYMn8qX3c5hkMd78CqP+8UM1DjDMO2ZsEupQfDwjRez
         nZyYZQd0H3Oxj+u11La9Ay00s13Nkit/LP2yQppuhZ4miKA/gNhMatBrjhgdqQObkutb
         2I87HTzKS9huZkyi9C6IbtoyoIz2j+ZzzijyJix2RdeWwdWU3q96gIDkwYo0X+PR+39y
         TKqrwr5lDd/xyrmj7WvfYyeC3SK957a5EqqKDGKVBXKagAk2b8tfMvTMoOZF9YPRkxMv
         XCgx2g13VBTJTszSNk/sHGgzQLy2DMQXYhQm1IXJ3Ajx1mc39M4ZEAQMnj7+Wzv5NfvG
         9SIA==
X-Gm-Message-State: APjAAAWfNfQg0a/mR6XWYGPFGFZgAR4EDwzShhb0pDUwRAGhGTmv6Dix
        wXhnd76h+OQgFYUfpsC7VA==
X-Google-Smtp-Source: APXvYqzGrGPEKKnV6/tdUHV/Cdfod31b+82eWEB4a3UQTVjGlvFck4Z63s1HOul1y7xGNWrKQIsjDA==
X-Received: by 2002:a17:902:a607:: with SMTP id u7mr35974709plq.43.1565664395422;
        Mon, 12 Aug 2019 19:46:35 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id h17sm6359826pfo.24.2019.08.12.19.46.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 19:46:34 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v5,3/4] tools: bpftool: add bash-completion for net attach/detach
Date:   Tue, 13 Aug 2019 11:46:20 +0900
Message-Id: <20190813024621.29886-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813024621.29886-1-danieltimlee@gmail.com>
References: <20190813024621.29886-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds bash-completion for new "net attach/detach"
subcommand for attaching XDP program on interface.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 65 +++++++++++++++++++----
 1 file changed, 55 insertions(+), 10 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index c8f42e1fcbc9..dbfcf50d8215 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -201,6 +201,10 @@ _bpftool()
             _bpftool_get_prog_tags
             return 0
             ;;
+        dev)
+            _sysfs_get_netdevs
+            return 0
+            ;;
         file|pinned)
             _filedir
             return 0
@@ -399,10 +403,6 @@ _bpftool()
                             _filedir
                             return 0
                             ;;
-                        dev)
-                            _sysfs_get_netdevs
-                            return 0
-                            ;;
                         *)
                             COMPREPLY=( $( compgen -W "map" -- "$cur" ) )
                             _bpftool_once_attr 'type'
@@ -498,10 +498,6 @@ _bpftool()
                         key|value|flags|name|entries)
                             return 0
                             ;;
-                        dev)
-                            _sysfs_get_netdevs
-                            return 0
-                            ;;
                         *)
                             _bpftool_once_attr 'type'
                             _bpftool_once_attr 'key'
@@ -775,18 +771,67 @@ _bpftool()
             esac
             ;;
         net)
+            local PROG_TYPE='id pinned tag'
+            local ATTACH_TYPES='xdp xdpgeneric xdpdrv xdpoffload'
             case $command in
+                show|list)
+                    [[ $prev != "$command" ]] && return 0
+                    COMPREPLY=( $( compgen -W 'dev' -- "$cur" ) )
+                    return 0
+                    ;;
+                attach)
+                    case $cword in
+                        3)
+                            COMPREPLY=( $( compgen -W "$ATTACH_TYPES" -- "$cur" ) )
+                            return 0
+                            ;;
+                        4)
+                            COMPREPLY=( $( compgen -W "$PROG_TYPE" -- "$cur" ) )
+                            return 0
+                            ;;
+                        5)
+                            case $prev in
+                                id)
+                                    _bpftool_get_prog_ids
+                                    ;;
+                                pinned)
+                                    _filedir
+                                    ;;
+                            esac
+                            return 0
+                            ;;
+                        6)
+                            COMPREPLY=( $( compgen -W 'dev' -- "$cur" ) )
+                            return 0
+                            ;;
+                        8)
+                            _bpftool_once_attr 'overwrite'
+                            return 0
+                            ;;
+                    esac
+                    ;;
+                detach)
+                    case $cword in
+                        3)
+                            COMPREPLY=( $( compgen -W "$ATTACH_TYPES" -- "$cur" ) )
+                            return 0
+                            ;;
+                        4)
+                            COMPREPLY=( $( compgen -W 'dev' -- "$cur" ) )
+                            return 0
+                            ;;
+                    esac
+                    ;;
                 *)
                     [[ $prev == $object ]] && \
                         COMPREPLY=( $( compgen -W 'help \
-                            show list' -- "$cur" ) )
+                            show list attach detach' -- "$cur" ) )
                     ;;
             esac
             ;;
         feature)
             case $command in
                 probe)
-                    [[ $prev == "dev" ]] && _sysfs_get_netdevs && return 0
                     [[ $prev == "prefix" ]] && return 0
                     if _bpftool_search_list 'macros'; then
                         COMPREPLY+=( $( compgen -W 'prefix' -- "$cur" ) )
-- 
2.20.1

