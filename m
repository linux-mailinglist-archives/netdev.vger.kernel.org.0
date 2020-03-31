Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909BE198EC1
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 10:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgCaInb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 04:43:31 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46441 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730099AbgCaIna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 04:43:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BF7135C047C;
        Tue, 31 Mar 2020 04:43:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 31 Mar 2020 04:43:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=e4mfaS9hUAp63vycEAazH1O4uJ4R9sRr2lUI8brDBJE=; b=yIa8lOPr
        wlfjXwkl2sPI+JRD71doHES4adWDNCYtPgt+S+aFhoHpXdyuV3NfRiyGp/k4V0a0
        Bs0voscGrWqVNtwL81m12SA+a/gKBLBTuBOa6d7jsxtro90gEBYlBGTnI88k7YCl
        42VoabuFISkafftoVkf1DrQH3r6j4H4oqxWzNZTcg4JQnxWeRNoIkfJzZuXvM6mu
        F0KEu6VGhq0GmQOVP3bmETX0ClqQcVLPUy150pvXAOjr1+/Qdu8/X+fFOTU2ifaN
        iTsH6fOKgvgvsXDXN2W3qIZxPZkvoec5jnBRuVvC6AK2+TiOd1PDTVNqSJASsCHn
        SvSst056l3Ypkw==
X-ME-Sender: <xms:sAKDXphKY-_XpS1wWRI1xDZu9K74nYLMyxnJ3OonT_3PGL2heLpAZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeijedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:sAKDXjRcasW_oC0AmN7f_T6x1MSDXVVmT1szvP3oW2yZn5zy19b-2A>
    <xmx:sAKDXqyZo40pYXhADfOVhSfm6xlgby95XOAeJqOB3e8cPZtG223iww>
    <xmx:sAKDXmfskVETlEWBaj6cvzbJGHj7L0FJ0fK1RpAn1CrLtIKr9gbItg>
    <xmx:sAKDXtWPyxFur6saUwZbbxsIrOcLBCAaHYvY2CKYGxoZtanfRfQJxQ>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 761CF3280063;
        Tue, 31 Mar 2020 04:43:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2 3/3] bash-completion: devlink: Extend bash-completion for new commands
Date:   Tue, 31 Mar 2020 11:42:53 +0300
Message-Id: <20200331084253.2377588-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331084253.2377588-1-idosch@idosch.org>
References: <20200331084253.2377588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Extend bash-completion for two new commands:

devlink trap policer set DEV policer POLICER [ rate RATE ] [ burst BURST ]
devlink trap policer show DEV policer POLICER

And for "policer" / "nopolicer" parameters in existing command:

devlink trap group set DEV group GROUP [ action { trap | drop } ]
                       [ policer POLICER ] [ nopolicer ]

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 bash-completion/devlink | 131 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 130 insertions(+), 1 deletion(-)

diff --git a/bash-completion/devlink b/bash-completion/devlink
index 45fba75c1539..45ca1fe6231e 100644
--- a/bash-completion/devlink
+++ b/bash-completion/devlink
@@ -62,6 +62,11 @@ _devlink_direct_complete()
             value=$(devlink -j trap group show 2>/dev/null \
                     | jq ".trap_group[\"$dev\"][].name")
             ;;
+        trap_policer)
+            dev=${words[4]}
+            value=$(devlink -j trap policer show 2>/dev/null \
+                    | jq ".trap_policer[\"$dev\"][].policer")
+            ;;
         health_dev)
             value=$(devlink -j health show 2>/dev/null | jq '.health' \
                     | jq 'keys[]')
@@ -678,6 +683,53 @@ _devlink_trap_set_action()
     esac
 }
 
+# Completion for devlink trap group set
+_devlink_trap_group_set()
+{
+    local -A settings=(
+        [action]=notseen
+        [policer]=notseen
+        [nopolicer]=notseen
+    )
+
+    if [[ $cword -eq 7 ]]; then
+        COMPREPLY=( $( compgen -W "action policer nopolicer" -- "$cur" ) )
+    fi
+
+    # Mark seen settings
+    local word
+    for word in "${words[@]:7:${#words[@]}-1}"; do
+        if [[ -n $word ]]; then
+            if [[ "${settings[$word]}" ]]; then
+                settings[$word]=seen
+            fi
+        fi
+    done
+
+    case $prev in
+        action)
+            COMPREPLY=( $( compgen -W "trap drop" -- "$cur" ) )
+            return
+            ;;
+        policer)
+            _devlink_direct_complete "trap_policer"
+            return
+            ;;
+    esac
+
+    local -a comp_words=()
+
+    # Add settings not seen to completions
+    local setting
+    for setting in "${!settings[@]}"; do
+        if [ "${settings[$setting]}" = notseen ]; then
+            comp_words+=( "$setting" )
+        fi
+    done
+
+    COMPREPLY=( $( compgen -W "${comp_words[*]}" -- "$cur" ) )
+}
+
 # Completion for devlink trap group
 _devlink_trap_group()
 {
@@ -701,7 +753,80 @@ _devlink_trap_group()
     esac
 
     if [[ ${words[3]} == "set" ]]; then
-        _devlink_trap_set_action 1
+        _devlink_trap_group_set
+    fi
+}
+
+# Completion for devlink trap policer set
+_devlink_trap_policer_set()
+{
+    local -A settings=(
+        [rate]=notseen
+        [burst]=notseen
+    )
+
+    if [[ $cword -eq 7 ]]; then
+        COMPREPLY=( $( compgen -W "rate burst" -- "$cur" ) )
+    fi
+
+    # Mark seen settings
+    local word
+    for word in "${words[@]:7:${#words[@]}-1}"; do
+        if [[ -n $word ]]; then
+            if [[ "${settings[$word]}" ]]; then
+                settings[$word]=seen
+            fi
+        fi
+    done
+
+    case $prev in
+        rate)
+            # Integer argument
+            return
+            ;;
+        burst)
+            # Integer argument
+            return
+            ;;
+    esac
+
+    local -a comp_words=()
+
+    # Add settings not seen to completions
+    local setting
+    for setting in "${!settings[@]}"; do
+        if [ "${settings[$setting]}" = notseen ]; then
+            comp_words+=( "$setting" )
+        fi
+    done
+
+    COMPREPLY=( $( compgen -W "${comp_words[*]}" -- "$cur" ) )
+}
+
+# Completion for devlink trap policer
+_devlink_trap_policer()
+{
+    case $cword in
+        3)
+            COMPREPLY=( $( compgen -W "set show" -- "$cur" ) )
+            return
+            ;;
+        4)
+            _devlink_direct_complete "dev"
+            return
+            ;;
+        5)
+            COMPREPLY=( $( compgen -W "policer" -- "$cur" ) )
+            return
+            ;;
+        6)
+            _devlink_direct_complete "trap_policer"
+            return
+            ;;
+    esac
+
+    if [[ ${words[3]} == "set" ]]; then
+        _devlink_trap_policer_set
     fi
 }
 
@@ -731,6 +856,10 @@ _devlink_trap()
             _devlink_trap_$command
             return
             ;;
+        policer)
+            _devlink_trap_$command
+            return
+            ;;
     esac
 }
 
-- 
2.24.1

