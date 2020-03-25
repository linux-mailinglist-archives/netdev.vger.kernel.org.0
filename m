Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA5F51923FD
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgCYJ0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:26:02 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:6216
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbgCYJ0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 05:26:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efBhu41IN38vSNBtBy3s6bi6T3Ijd6Pd9Q3hTKJ0VqBWtzrOL8Kf2zvSDs7yFGqqebfAG57GMY9EiVOEyTcpLLMSfkl+kY7Uk1JszRA2mRnC1PTAzakIAKGkpqloJhnP5MOL1HeFrb1srVcPK5ylZE1SvOOeu8u3F9s5mcZY/Jg2Yi6Heoy8k+Ja+qVCEt3Ca4p2at8TGUbR1HrxiyAta7CpnW16e7W7SFwhrfTbU2cKgEpdU+3QHvILN/KqKxCp+/Mn0+RWvsMsKZXkPrIwrElYZrq+syv2egwzn9hD9VJqa309crL+cUvGk7dqRkk2cEP+AbwOAmWl4wq38Jb/yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jmxEf3AKoObp1apnGzg4yVVw12V1mEjjRA0x9XhuZw=;
 b=eLGlNKeeVjH3cjyXIvrvljxft/BTDuJM0FeYcZ/MtlDOTOGbAmSKp+gJ6R5eUYNZ9xQdCZfrsD4X6P1iAQ6GMafVO7LYtCK+EKLJ+sm89AN+XxJCtLqkhJTFAJh/drHVnJFVCnzWfeJ7hjeJH/7fY81O29qBqjHae/wbMJp9N1WHPdrIkD7MUYBWzaci++HnR+s1LoGF5dyznaUVAIuRu6cuLlhQQa0FIrOT6lBUgrUt88s7cyLmhPXwjQjQZzEnd/siUEoDAa2YHwk944KtoIwgSauIUWL1I9bKW7o4u4JDSXMdTZZMmqIwjSLUOByIKf1GFW14lma96kI3jisN7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jmxEf3AKoObp1apnGzg4yVVw12V1mEjjRA0x9XhuZw=;
 b=hS9PLbrFLZ34pef6P6y0wJolibdqa2umLyAPiNnHFd5j85shUurL4lPyTMtqZK3yKvDvAwvlNuSXBYmZGTO4cbZNXZr1tuptZQBv8YCgrxUhTNs3JGeGA1MHAMcYlywMhUCyl3BQDX3hJcDsD8vqPtE10ggHbBGbxy7ha+N/zIE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=danieller@mellanox.com; 
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (20.177.41.151) by
 AM0PR05MB5201.eurprd05.prod.outlook.com (20.178.17.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Wed, 25 Mar 2020 09:25:51 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::cc2c:b342:e59a:775b]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::cc2c:b342:e59a:775b%6]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 09:25:50 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH iproute2-next] bash-completion: devlink: add bash-completion function
Date:   Wed, 25 Mar 2020 11:25:34 +0200
Message-Id: <20200325092534.32451-1-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0017.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::29)
 To AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0017.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Wed, 25 Mar 2020 09:25:50 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ec797b08-9839-4c24-6b7a-08d7d09e824f
X-MS-TrafficTypeDiagnostic: AM0PR05MB5201:|AM0PR05MB5201:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB520186C6EB92AA43A44DDEA6D5CE0@AM0PR05MB5201.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(107886003)(6512007)(2616005)(36756003)(6666004)(66476007)(66946007)(8936002)(81166006)(8676002)(66556008)(4326008)(956004)(2906002)(81156014)(478600001)(6916009)(186003)(1076003)(30864003)(86362001)(26005)(52116002)(316002)(6486002)(5660300002)(6506007)(16526019)(481834002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5201;H:AM0PR05MB5010.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q5E+01wjsn9cckzSUkb65KKZd8RCoglVqbTZfdfUV4GeOf1y5bDXPKTh/APgSEDuzao2ePr+tUeTzpujSbXk8sjEWSHMvU1L0CCDLp0YEDuyHUn7IaiHhIuX2j0YaLwAXipLnQ0drydKP+bAxktaLxKIjnQNu/B+QjM6CtkA96PY74kuKuaXAvJZZ2Yc6oGBfakwP2lR6WdviN6ABAToGe3YY32YJJQK0xqGVrAWRri9RuOtcAa8ji5d220CZCNF+8ip0FHs3BEtM6vjLqAUcezDxZ9Z11s4pVeE62Tqiuk1BTBGHnoNfxMJRYzilgDgBI/28YZ2UpXvd4uYcbmSp79L95QObOztpWn2w0IeEm0x8qXrCh5jP7PkgydZ4lFn6j2ezBS8mP4rKl5AvwAT6j9iRhhVoRQAlE2JPaMcoGqR5rgGtnfGP5xJ4/dYLEOiVXcxWdwE0n4lTaceJDUUdPFtWCPRAWn0G64PN+YfUPCWJlIzcqeMXuQGwo0zxGEH
X-MS-Exchange-AntiSpam-MessageData: mp/fAiEiRj6jtEPrO1gbNwFqtVutursoNSJNq15iNppK9PvPNgnUoaZsbF7L2719Kj9th4HFLTsDZTmxq1MdIe2zdy5ljabn1PWNby+ywxsFYDJ1F+NKlSyiDtrqS5m9Tnoq8d1qgUuscmOy8Lv2nA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec797b08-9839-4c24-6b7a-08d7d09e824f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 09:25:50.8775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gujFO78+InEbe7qnz5as+rLNvqzBhEHmMwvIb2pvlCwXOf+rdod71XxGPMndN6skXg5dasSpRwysie5Lw0g4cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5201
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add function for command completion for devlink in bash, and update Makefile
to install it under /usr/share/bash-completion/completions/.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
---
 Makefile                |   1 +
 bash-completion/devlink | 822 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 823 insertions(+)
 create mode 100644 bash-completion/devlink

diff --git a/Makefile b/Makefile
index 0b79b1f1..25d05fac 100644
--- a/Makefile
+++ b/Makefile
@@ -90,6 +90,7 @@ install: all
 	install -m 0644 $(shell find etc/iproute2 -maxdepth 1 -type f) $(DESTDIR)$(CONFDIR)
 	install -m 0755 -d $(DESTDIR)$(BASH_COMPDIR)
 	install -m 0644 bash-completion/tc $(DESTDIR)$(BASH_COMPDIR)
+	install -m 0644 bash-completion/devlink $(DESTDIR)$(BASH_COMPDIR)
 	install -m 0644 include/bpf_elf.h $(DESTDIR)$(HDRDIR)
 
 snapshot:
diff --git a/bash-completion/devlink b/bash-completion/devlink
new file mode 100644
index 00000000..45fba75c
--- /dev/null
+++ b/bash-completion/devlink
@@ -0,0 +1,822 @@
+# bash completion for devlink(8)                          -*- shell-script -*-
+
+# Get all the optional commands for devlink
+_devlink_get_optional_commands()
+{
+    local object=$1; shift
+
+    local filter_options=""
+    local options="$(devlink $object help 2>&1 \
+        | command sed -n -e "s/^.*devlink $object //p" \
+        | cut -d " " -f 1)"
+
+    # Remove duplicate options from "devlink $OBJECT help" command
+    local opt
+    for opt in $options; do
+        if [[ $filter_options =~ $opt ]]; then
+            continue
+        else
+            filter_options="$filter_options $opt"
+        fi
+    done
+
+    echo $filter_options
+}
+
+# Complete based on given word, for when an argument or an option name has
+# but a few possible arguments.
+_devlink_direct_complete()
+{
+    local dev port region value
+
+    case $1 in
+        dev)
+            value=$(devlink dev show 2>/dev/null)
+            ;;
+        param_name)
+            dev=${words[4]}
+            value=$(devlink -j dev param show 2>/dev/null \
+                    | jq ".param[\"$dev\"][].name")
+            ;;
+        port)
+            value=$(devlink -j port show 2>/dev/null \
+                    | jq '.port as $ports | $ports | keys[] as $key
+                    | ($ports[$key].netdev // $key)')
+            ;;
+        region)
+            value=$(devlink -j region show 2>/dev/null \
+                    | jq '.regions' | jq 'keys[]')
+            ;;
+        snapshot)
+            region=${words[3]}
+            value=$(devlink -j region show 2>/dev/null \
+                    | jq ".regions[\"$region\"].snapshot[]")
+            ;;
+        trap)
+            dev=${words[3]}
+            value=$(devlink -j trap show 2>/dev/null \
+                    | jq ".trap[\"$dev\"][].name")
+            ;;
+        trap_group)
+            dev=${words[4]}
+            value=$(devlink -j trap group show 2>/dev/null \
+                    | jq ".trap_group[\"$dev\"][].name")
+            ;;
+        health_dev)
+            value=$(devlink -j health show 2>/dev/null | jq '.health' \
+                    | jq 'keys[]')
+            ;;
+        reporter)
+            dev=${words[cword - 2]}
+            value=$(devlink -j health show 2>/dev/null \
+                    | jq ".health[\"$dev\"][].reporter")
+            ;;
+        pool)
+            dev=$pprev
+            value=$(devlink -j sb pool show 2>/dev/null \
+                    | jq ".pool[\"$dev\"][].pool")
+            ;;
+        port_pool)
+            port=${words[5]}
+            value=$(devlink -j sb port pool show 2>/dev/null \
+                    | jq ".port_pool[\"$port\"][].pool")
+            ;;
+        tc)
+            port=$pprev
+            value=$(devlink -j sb tc bind show 2>/dev/null \
+                    | jq ".tc_bind[\"$port\"][].tc")
+            ;;
+    esac
+
+    COMPREPLY+=( $( compgen -W "$value" -- "$cur" ) )
+    # Remove colon containing prefix from COMPREPLY items in order to avoid
+    # wordbreaks with colon.
+    __ltrim_colon_completions "$cur"
+}
+
+# Completion for devlink dev eswitch set
+_devlink_dev_eswitch_set()
+{
+    local -A settings=(
+        [mode]=notseen
+        [inline-mode]=notseen
+        [encap]=notseen
+    )
+
+    if [[ $cword -eq 5 ]]; then
+        COMPREPLY=( $( compgen -W "mode inline-mode encap" -- "$cur" ) )
+    fi
+
+    # Mark seen settings
+    local word
+    for word in "${words[@]:5:${#words[@]}-1}"; do
+        if [[ -n $word ]]; then
+            if [[ "${settings[$word]}" ]]; then
+                settings[$word]=seen
+            fi
+        fi
+    done
+
+    case $prev in
+        mode)
+            COMPREPLY=( $( compgen -W "legacy switchdev" -- "$cur" ) )
+            return
+            ;;
+        inline-mode)
+            COMPREPLY=( $( compgen -W "none link network transport" -- \
+                "$cur" ) )
+            return
+            ;;
+        encap)
+            COMPREPLY=( $( compgen -W "disable enable" -- "$cur" ) )
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
+# Completion for devlink dev eswitch
+_devlink_dev_eswitch()
+{
+    case "$cword" in
+        3)
+            COMPREPLY=( $( compgen -W "show set" -- "$cur" ) )
+            return
+            ;;
+        4)
+            _devlink_direct_complete "dev"
+            return
+            ;;
+    esac
+
+    case "${words[3]}" in
+        set)
+            _devlink_dev_eswitch_set
+            return
+            ;;
+        show)
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink dev param set
+_devlink_dev_param_set()
+{
+    case $cword in
+        7)
+            COMPREPLY=( $( compgen -W "value" -- "$cur" ) )
+            return
+            ;;
+        8)
+            # String argument
+            return
+            ;;
+        9)
+            COMPREPLY=( $( compgen -W "cmode" -- "$cur" ) )
+            return
+            ;;
+        10)
+            COMPREPLY=( $( compgen -W "runtime driverinit permanent" -- \
+                "$cur" ) )
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink dev param
+_devlink_dev_param()
+{
+    case "$cword" in
+        3)
+            COMPREPLY=( $( compgen -W "show set" -- "$cur" ) )
+            return
+            ;;
+        4)
+            _devlink_direct_complete "dev"
+            return
+            ;;
+        5)
+            COMPREPLY=( $( compgen -W "name" -- "$cur" ) )
+            return
+            ;;
+        6)
+            _devlink_direct_complete "param_name"
+            return
+            ;;
+    esac
+
+    if [[ "${words[3]}" == "set" ]]; then
+        _devlink_dev_param_set
+    fi
+}
+
+# Completion for devlink dev reload
+_devlink_dev_reload()
+{
+    case "$cword" in
+        4)
+            COMPREPLY=( $( compgen -W "netns" -- "$cur" ) )
+            return
+            ;;
+        5)
+            local nslist=$( ip netns list 2>/dev/null )
+            COMPREPLY=( $( compgen -W "$nslist" -- "$cur" ) )
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink dev flash
+_devlink_dev_flash()
+{
+    case "$cword" in
+        4)
+            COMPREPLY=( $( compgen -W "file" -- "$cur" ) )
+            return
+            ;;
+        5)
+            _filedir
+            return
+            ;;
+        6)
+            COMPREPLY=( $( compgen -W "component" -- "$cur" ) )
+            return
+            ;;
+     esac
+}
+
+# Completion for devlink dev
+_devlink_dev()
+{
+    case $command in
+        show|reload|info|flash)
+            if [[ $cword -le 3 ]]; then
+                _devlink_direct_complete "dev"
+            elif [[ $command == "reload" || $command == "flash" ]];then
+                _devlink_dev_$command
+            fi
+            return
+            ;;
+        eswitch|param)
+            _devlink_dev_$command
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink port set
+_devlink_port_set()
+{
+    case "$cword" in
+        3)
+            _devlink_direct_complete "port"
+            return
+            ;;
+        4)
+            COMPREPLY=( $( compgen -W "type" -- "$cur" ) )
+            return
+            ;;
+        5)
+            COMPREPLY=( $( compgen -W "eth ib auto" -- "$cur" ) )
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink port split
+_devlink_port_split()
+{
+    case "$cword" in
+        3)
+            _devlink_direct_complete "port"
+            return
+            ;;
+        4)
+            COMPREPLY=( $( compgen -W "count" -- "$cur" ) )
+            return
+            ;;
+        5)
+            # Integer argument
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink port
+_devlink_port()
+{
+    case $command in
+        set)
+            _devlink_port_set
+            return
+            ;;
+        split)
+            _devlink_port_split
+            return
+            ;;
+        show|unsplit)
+            if [[ $cword -eq 3 ]]; then
+                _devlink_direct_complete "port"
+            fi
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink dpipe
+_devlink_dpipe()
+{
+    local options="$(devlink dpipe help 2>&1 \
+                     | command sed -e '/OBJECT-LIST := /!d' \
+                     -e 's/.*{ //' -e 's/}.*//' -e 's/|//g' )"
+
+    if [[ $cword -eq 2 ]]; then
+        COMPREPLY+=( $( compgen -W "$options" -- "$cur" ) )
+    fi
+}
+
+# Completion for devlink monitor
+_devlink_monitor()
+{
+    local options="$(devlink monitor help 2>&1 \
+                     | command sed -e '/OBJECT-LIST := /!d' \
+                     -e 's/.*{ //' -e 's/}.*//' -e 's/|//g' )"
+
+    if [[ $cword -eq 2 ]]; then
+        COMPREPLY+=( $( compgen -W "all $options" -- "$cur" ) )
+    fi
+}
+
+# Completion for the rest of devlink sb $command
+_devlink_sb_command_options()
+{
+    local subcmd
+
+    case $command in
+        pool)
+            subcmd=${words[3]}
+            if [[ $cword -eq 5 ]]; then
+                COMPREPLY=( $( compgen -W "pool" -- "$cur" ) )
+            fi
+            if [[ $subcmd == "set" ]]; then
+                case $cword in
+                    7)
+                        COMPREPLY+=( $( compgen -W "size" -- "$cur" ) )
+                        ;;
+                    9)
+                        COMPREPLY+=( $( compgen -W "thtype" -- "$cur" ) )
+                        ;;
+                esac
+            fi
+            ;;
+        port)
+            subcmd=${words[4]}
+            if [[ $cword -eq 6 ]]; then
+                COMPREPLY+=( $( compgen -W "pool" -- "$cur" ) )
+            fi
+            if [[ $subcmd == "set" ]]; then
+                case $cword in
+                    8)
+                        COMPREPLY+=( $( compgen -W "th" -- "$cur" ) )
+                        ;;
+                esac
+            fi
+            ;;
+        tc)
+            subcmd=${words[4]}
+            case $cword in
+                6)
+                    COMPREPLY+=( $( compgen -W "tc" -- "$cur" ) )
+                    ;;
+                8)
+                    COMPREPLY+=( $( compgen -W "type" -- "$cur" ) )
+                    ;;
+            esac
+            if [[ $subcmd == "set" ]]; then
+                case $cword in
+                    10)
+                        COMPREPLY+=( $( compgen -W "pool" -- "$cur" ) )
+                        ;;
+                    12)
+                        COMPREPLY+=( $( compgen -W "th" -- "$cur" ) )
+                        ;;
+                esac
+            fi
+            ;;
+    esac
+}
+
+# Completion for devlink sb
+_devlink_sb()
+{
+    case $prev in
+        bind)
+            COMPREPLY=( $( compgen -W "set show" -- "$cur" ) )
+            ;;
+        occupancy)
+            COMPREPLY=( $( compgen -W "show snapshot clearmax" -- "$cur" ) )
+            ;;
+        pool)
+            if [[ $cword -eq 3 || $cword -eq 4 ]]; then
+                COMPREPLY=( $( compgen -W "set show" -- "$cur" ) )
+            elif [[ $command == "port" || $command == "tc" ]]; then
+                _devlink_direct_complete "port_pool"
+            else
+                _devlink_direct_complete "pool"
+            fi
+            ;;
+        port)
+            if [[ $cword -eq 3 ]]; then
+                COMPREPLY=( $( compgen -W "pool" -- "$cur" ) )
+            fi
+            ;;
+        show|set|snapshot|clearmax)
+            case $command in
+                show|pool|occupancy)
+                    _devlink_direct_complete "dev"
+                    if [[ $command == "occupancy" && $prev == "show" ]];then
+                        _devlink_direct_complete "port"
+                    fi
+                    ;;
+                port|tc)
+                    _devlink_direct_complete "port"
+                    ;;
+            esac
+            ;;
+        size)
+            # Integer argument
+            ;;
+        thtype)
+            COMPREPLY=( $( compgen -W "static dynamic" -- "$cur" ) )
+            ;;
+        th)
+            # Integer argument
+            ;;
+        tc)
+            if [[ $cword -eq 3 ]]; then
+                COMPREPLY=( $( compgen -W "bind" -- "$cur" ) )
+            else
+                _devlink_direct_complete "tc"
+            fi
+            ;;
+        type)
+            COMPREPLY=( $( compgen -W "ingress egress" -- "$cur" ) )
+            ;;
+    esac
+
+    _devlink_sb_command_options
+    return
+}
+
+# Completion for devlink resource set path argument
+_devlink_resource_path()
+{
+    local path parents parent all_path
+    local dev=${words[3]}
+    local -a path
+
+    local all_path=$(
+        devlink resource show $dev \
+            | sed -E '# Of resource lines, keep only the name itself.
+                    s/name ([^ ]*) .*/\1/
+                    # Drop headers.
+                    /:$/d
+                    # First layer is not aligned enough, align it.
+                    s/^/  /
+                    # Use slashes as unary code for resource depth.
+                    s,    ,/,g
+                    # Separate tally count from resource name.
+                    s,/*,&\t,' \
+            | while read d name; do
+                    while ((${#path[@]} > ${#d})); do
+                        unset path[$((${#path[@]} - 1))]
+                    done
+                    path[$((${#d} - 1))]=$name
+                    echo ${path[@]}
+              done \
+            | sed '# Convert paths to slash-separated
+                    s,^,/,;s, ,/,g;s,$,/,'
+    )
+    COMPREPLY=( ${COMPREPLY[@]:-} $( compgen -W "$all_path" -- "$cur" ) )
+}
+
+# Completion for devlink resource set
+_devlink_resource_set()
+{
+    case "$cword" in
+        3)
+            _devlink_direct_complete "dev"
+            return
+            ;;
+        4)
+            COMPREPLY=( $( compgen -W "path" -- "$cur" ) )
+            return
+            ;;
+        5)
+            _devlink_resource_path
+            return
+            ;;
+        6)
+            COMPREPLY=( $( compgen -W "size" -- "$cur" ) )
+            return
+            ;;
+        7)
+            # Integer argument
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink resource
+_devlink_resource()
+{
+    case $command in
+        show)
+            if [[ $cword -eq 3 ]]; then
+                _devlink_direct_complete "dev"
+            fi
+            return
+            ;;
+        set)
+            _devlink_resource_set
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink region read
+_devlink_region_read()
+{
+    case "$cword" in
+        6)
+            COMPREPLY=( $( compgen -W "address" -- "$cur" ) )
+            return
+            ;;
+        7)
+            # Address argument, for example: 0x10
+            return
+            ;;
+        8)
+            COMPREPLY=( $( compgen -W "length" -- "$cur" ) )
+            return
+            ;;
+        9)
+            # Integer argument
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink region
+_devlink_region()
+{
+    if [[ $cword -eq 3 && $command != "help" ]]; then
+            _devlink_direct_complete "region"
+    fi
+
+    case $command in
+        show)
+            return
+            ;;
+        del|dump|read)
+            case "$cword" in
+                4)
+                    COMPREPLY=( $( compgen -W "snapshot" -- "$cur" ) )
+                    ;;
+                5)
+                    _devlink_direct_complete "snapshot"
+                    ;;
+            esac
+
+            if [[ $command == "read" ]]; then
+                _devlink_region_read
+            fi
+            return
+            ;;
+    esac
+}
+
+# Completion reporter for devlink health
+_devlink_health_reporter()
+{
+    local i=$1; shift
+
+    case $cword in
+        $((3 + $i)))
+            _devlink_direct_complete "health_dev"
+            ;;
+        $((4 + $i)))
+            COMPREPLY=( $( compgen -W "reporter" -- "$cur" ) )
+            ;;
+        $((5 + $i)))
+            _devlink_direct_complete "reporter"
+            ;;
+    esac
+}
+
+# Completion for devlink health
+_devlink_health()
+{
+    case $command in
+        show|recover|diagnose|set)
+            _devlink_health_reporter 0
+            if [[ $command == "set" ]]; then
+                case $cword in
+                    6)
+                        COMPREPLY=( $( compgen -W "grace_period auto_recover" \
+                                   -- "$cur" ) )
+                        ;;
+                    7)
+                        case $prev in
+                            grace_period)
+                                # Integer argument- msec
+                                ;;
+                            auto_recover)
+                                COMPREPLY=( $( compgen -W "true false" -- \
+                                    "$cur" ) )
+                                ;;
+                        esac
+                esac
+            fi
+            return
+            ;;
+        dump)
+            if [[ $cword -eq 3 ]]; then
+                COMPREPLY=( $( compgen -W "show clear" -- "$cur" ) )
+            fi
+
+            _devlink_health_reporter 1
+            return
+            ;;
+    esac
+}
+
+# Completion for action in devlink trap set
+_devlink_trap_set_action()
+{
+    local i=$1; shift
+
+    case $cword in
+        $((6 + $i)))
+            COMPREPLY=( $( compgen -W "action" -- "$cur" ) )
+            ;;
+        $((7 + $i)))
+            COMPREPLY=( $( compgen -W "trap drop" -- "$cur" ) )
+            ;;
+    esac
+}
+
+# Completion for devlink trap group
+_devlink_trap_group()
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
+            COMPREPLY=( $( compgen -W "group" -- "$cur" ) )
+            return
+            ;;
+        6)
+            _devlink_direct_complete "trap_group"
+            return
+            ;;
+    esac
+
+    if [[ ${words[3]} == "set" ]]; then
+        _devlink_trap_set_action 1
+    fi
+}
+
+# Completion for devlink trap
+_devlink_trap()
+{
+    case $command in
+        show|set)
+            case $cword in
+                3)
+                    _devlink_direct_complete "dev"
+                    ;;
+                4)
+                    COMPREPLY=( $( compgen -W "trap" -- "$cur" ) )
+                    ;;
+                5)
+                    _devlink_direct_complete "trap"
+                    ;;
+            esac
+
+            if [[ $command == "set" ]]; then
+                _devlink_trap_set_action 0
+            fi
+            return
+            ;;
+        group)
+            _devlink_trap_$command
+            return
+            ;;
+    esac
+}
+
+# Complete any devlink command
+_devlink()
+{
+    local cur prev words cword
+    local opt='--Version --no-nice-names --json --pretty --verbose \
+        --statistics --force --Netns --batch'
+    local objects="$(devlink help 2>&1 | command sed -e '/OBJECT := /!d' \
+		     -e 's/.*{//' -e 's/}.*//' -e \ 's/|//g' )"
+
+    _init_completion || return
+    # Gets the word-to-complete without considering the colon as word breaks
+    _get_comp_words_by_ref -n : cur prev words cword
+
+    if [[ $cword -eq 1 ]]; then
+	    case $cur in
+	        -*)
+		        COMPREPLY=( $( compgen -W "$opt" -- "$cur" ) )
+		        return 0
+		        ;;
+	        *)
+		        COMPREPLY=( $( compgen -W "$objects" -- "$cur" ) )
+		        return 0
+		        ;;
+	    esac
+    fi
+
+    # Deal with options
+    if [[ $prev == -* ]]; then
+	    case $prev in
+	        -V|--Version)
+		        return 0
+		        ;;
+	        -b|--batch)
+		        _filedir
+		        return 0
+		        ;;
+	        --force)
+                COMPREPLY=( $( compgen -W "--batch" -- "$cur" ) )
+		        return 0
+		        ;;
+	        -N|--Netns)
+		        local nslist=$( ip netns list 2>/dev/null )
+		        COMPREPLY=( $( compgen -W "$nslist" -- "$cur" ) )
+		        return 0
+		        ;;
+	        -j|--json)
+		        COMPREPLY=( $( compgen -W "--pretty $objects" -- "$cur" ) )
+		        return 0
+		        ;;
+            *)
+                COMPREPLY=( $( compgen -W "$objects" -- "$cur" ) )
+		        return 0
+		        ;;
+	    esac
+    fi
+
+    # Remove all options so completions don't have to deal with them.
+    local i
+    for (( i=1; i < ${#words[@]}; )); do
+        if [[ ${words[i]::1} == - ]]; then
+            words=( "${words[@]:0:i}" "${words[@]:i+1}" )
+            [[ $i -le $cword ]] && cword=$(( cword - 1 ))
+        else
+            i=$(( ++i ))
+        fi
+    done
+
+    local object=${words[1]}
+    local command=${words[2]}
+    local pprev=${words[cword - 2]}
+
+    if [[ $objects =~ $object ]]; then
+        if [[ $cword -eq 2 ]]; then
+            COMPREPLY=( $( compgen -W "help" -- "$cur") )
+            if [[ $object != "monitor" && $object != "dpipe" ]]; then
+                COMPREPLY+=( $( compgen -W \
+                    "$(_devlink_get_optional_commands $object)" -- "$cur" ) )
+            fi
+        fi
+        "_devlink_$object"
+    fi
+
+} &&
+complete -F _devlink devlink
+
+# ex: ts=4 sw=4 et filetype=sh
-- 
2.20.1

