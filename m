Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A23887B2F
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407096AbfHINdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:33:16 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:44355 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406150AbfHINdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:33:15 -0400
Received: by mail-pg1-f179.google.com with SMTP id i18so45885529pgl.11
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 06:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aeYIDCYizWFxh6gGgL45eDxaStQmV50vAqG513aqSM4=;
        b=q4c76nkQlCRJvh8a0gRdlsbFOeenZqniXZD2Ye0DJS0XuE/rfK58N0Iyy6kZSX/usw
         tRqvvfBphTZCABZaWxQscrnCIYql/a9ECT80X1O3d6pCfqd0bAoKbMqBTbNvR3R1evCi
         iOfV8r1x8/atPcId9LLKZqjFIhKsYPpKYG5JpZ90pvbmjudgRuBv41d2HIDx9O35DA+e
         Cv8o+UchLdVRtvcnbCgqsRt+TSr39wZhObCxDrYU+Vu/1JtFPd2Rv8Acvu0zT8ux2FbE
         swRtBkyJnHD8O/2ND9RQKr0OKaE56lzNidfX27owgp06vwbL1Kv+L2+pdjgLenqxrKjH
         KSkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aeYIDCYizWFxh6gGgL45eDxaStQmV50vAqG513aqSM4=;
        b=fNttuq7vDtRY9rqSfKMEU0CiUuY3l1F7+Nfc0lIjA/v76ZxjHIMCAnnv80A+5veelV
         rZJFKC3+t21npkrfZXrFL9zXxL9iFoGiYfY7gS6qpd5aLw/6Pzuef5pxeYATudKEJRLO
         f3ZbfWg27RZcVR1sI0w6/w1wposGTmO+zsUkMb4Frhzviv/SGZA719QFgTiLRGYk/p/A
         6L92jX0ZM9gGD3vUsN8RwUOFaRexOO1YLvEKPW6lXVhKi+f0l02dQ68llzWev5jXRkfD
         ofI5JDV6wNDaLwH6o4Wh98nEBhS1z3E5xHWJprovc/5dmBBqyD3uKziGfQ2ZvgSaRu8J
         4JUA==
X-Gm-Message-State: APjAAAVD1vDB2IMn/Hml0viQKXJj70/QmgKqIgmvJ6gMDk1iFLtyS53a
        j0d8c0f7lccpxpfUcfDZJw==
X-Google-Smtp-Source: APXvYqzuLLBr1ygbm/Gzf6eZUTGRNQiFwz49N16UZD0vWFKw9qPOfUO4sEdYRhEfVcAFX8oPVQTSMg==
X-Received: by 2002:a17:90a:8a17:: with SMTP id w23mr9238582pjn.139.1565357594466;
        Fri, 09 Aug 2019 06:33:14 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id f15sm7242912pje.17.2019.08.09.06.33.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 06:33:13 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v4,3/4] tools: bpftool: add bash-completion for net attach/detach
Date:   Fri,  9 Aug 2019 22:32:47 +0900
Message-Id: <20190809133248.19788-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133248.19788-1-danieltimlee@gmail.com>
References: <20190809133248.19788-1-danieltimlee@gmail.com>
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

