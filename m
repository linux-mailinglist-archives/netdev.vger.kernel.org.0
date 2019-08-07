Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B437A8426E
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfHGCZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 22:25:26 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:33767 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbfHGCZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 22:25:25 -0400
Received: by mail-pf1-f174.google.com with SMTP id g2so42568679pfq.0
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 19:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=plUmgSq1AS3BekwE3nGgJ8WDdPpxfjKKHqb2I0XLHVo=;
        b=DcOCAQJGfq8ASa4tJXQdpEzNJXEA/sJNPm7GnHvup095ucskeEVP4tv12oFCWHyZXx
         znLkOZKIDiAaTU0pOskXjzXU4CFqs1aMiFYopBpDE3Yer+rHlVJykyoCyMfdOGVDG4ax
         aCiIyufqXwSlGFOj8ISbxv1IDIQX4Vir2JD5x+hYR9F+nnQAs34imImh8HZdL6sTjODM
         V9nubAE2HTLCOy80+Q3es+tUzSzf0NJsS1fJouNe/sy4U3duFIjE2AwdTG0p5eeyG7Aw
         ELQPJU39DBxmpBuOg6VahaUtDkepEWrulGHT9oTZfzk/QRYYhXcU3gm/6UbMgXCRxZNe
         Rl4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=plUmgSq1AS3BekwE3nGgJ8WDdPpxfjKKHqb2I0XLHVo=;
        b=L9bWa1VNdY/EmMz1fsntcIJfxVXak6Ej4ImIbHl7MJlFIG8aIQEKgW8/VAe77heRf0
         ZiiP2vr9MAjnOHgOKeY45ZdjummSFD3XKqqYSU5TOeY8Gt5d82/lcXxAlsUmU/gAk3zk
         l9DasS+h8I/XfmHHpnVi8Xheatfr6ZhgJvvzTonzom1PcxFkBiyFvVUpU5ixn2pjaEyR
         7R+1kq+FSnba6wj1m8ajdL26FjSGZrVZKAGkHgAt5rIKbOhe17FOUW/Z0I61Fb4PH3bt
         cGO9b9zUA70p+OPkX4zVqoHKDVjvAvzHEQcVNFP7bCzL2UlGqJqCv8ihQG7k3dS2rY/a
         PQiA==
X-Gm-Message-State: APjAAAUQTM2d2veEuufAlFtVNPhVO4Fahusq0R6D526EZLCKTe1IbnMT
        PthZbiYYf5cny04cT/G1x27GCkSb6w==
X-Google-Smtp-Source: APXvYqw5YF8946wvz/oco5Y1Mgj1fM8RyvcFeNOySGALzCcVSZcpua7w0Ow9pwroGeLKLlEbU30c8Q==
X-Received: by 2002:a63:121b:: with SMTP id h27mr5685489pgl.335.1565144724780;
        Tue, 06 Aug 2019 19:25:24 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id b126sm129275991pfa.126.2019.08.06.19.25.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 19:25:24 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v3,3/4] tools: bpftool: add bash-completion for net attach/detach
Date:   Wed,  7 Aug 2019 11:25:08 +0900
Message-Id: <20190807022509.4214-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807022509.4214-1-danieltimlee@gmail.com>
References: <20190807022509.4214-1-danieltimlee@gmail.com>
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
 tools/bpf/bpftool/bash-completion/bpftool | 64 +++++++++++++++++++----
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index c8f42e1fcbc9..1d81cb09d478 100644
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
@@ -775,11 +771,61 @@ _bpftool()
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
-- 
2.20.1

