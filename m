Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5376C89AF
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 15:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfJBNal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 09:30:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbfJBNah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 09:30:37 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 292BB88302
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 13:30:36 +0000 (UTC)
Received: by mail-lj1-f197.google.com with SMTP id m81so4882710lje.4
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 06:30:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pqLC3K0zosC/Ijfelepo4fx24olc2AqeXpVeWBxBt4o=;
        b=gpb/rkdA7D1mYmumIRTNbzIy0I0EfoqEzfvIk9xOrN4lxuNzrbkgVGQs8cvD9ktWLh
         oepMn8g4AzjXZk+IUYcLsJdUMt/tLVrL5+92jTYl0z7nhDPwfbNl2INNsqVfy38ti5u+
         MknLwFSDxPTwnAukafDrLO/p/xyac+6fYNo5CxGeqZOM2GmCuj+RueOqlOnhZZi8VrRs
         98RL0NACBCJ5uy6Aocf8x4mRnP9VGQNHvw5iQv1RG7QeO/9OmtsKSzDk9q1oB1KTh2PV
         cHFP0pH08Jlzlu6VHO0PXMmgFx9zNYDpV2G37n5xeaYgqTdsPRdSDfG92V/4C/7VHGlr
         V+eg==
X-Gm-Message-State: APjAAAV/nqjEMzEwv5LPkH/LM31COj9UypSwWZ3J3BLdmcott07a1fTf
        /SE7bKta79+J1WSS3N0Tc+5eFn73nS+tLzdpHC8AwOQIElDQH6lTANXcDS8rJrWOhoPQaNw1DLA
        b+FhIqs01oV31jrPQ
X-Received: by 2002:a19:ef17:: with SMTP id n23mr2264336lfh.109.1570023034729;
        Wed, 02 Oct 2019 06:30:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyf+i0aehSnS03SCOX01y6ZKk/kXFw701LZVoGDGz5WSDlfP1vxr3k6yYRK8vjW24yO32CIcQ==
X-Received: by 2002:a19:ef17:: with SMTP id n23mr2264329lfh.109.1570023034557;
        Wed, 02 Oct 2019 06:30:34 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id c16sm4543320lfj.8.2019.10.02.06.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 06:30:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 46661180641; Wed,  2 Oct 2019 15:30:32 +0200 (CEST)
Subject: [PATCH bpf-next 7/9] bpftool: Add definitions for xdp_chain map type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 02 Oct 2019 15:30:32 +0200
Message-ID: <157002303220.1302756.13509533392771604835.stgit@alrua-x1>
In-Reply-To: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Adds bash completion and definition types for the xdp_chain map type to
bpftool.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/bpftool/Documentation/bpftool-map.rst |    4 ++--
 tools/bpf/bpftool/bash-completion/bpftool       |    2 +-
 tools/bpf/bpftool/map.c                         |    3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 1c0f7146aab0..9aefcef50b53 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -47,8 +47,8 @@ MAP COMMANDS
 |	*TYPE* := { **hash** | **array** | **prog_array** | **perf_event_array** | **percpu_hash**
 |		| **percpu_array** | **stack_trace** | **cgroup_array** | **lru_hash**
 |		| **lru_percpu_hash** | **lpm_trie** | **array_of_maps** | **hash_of_maps**
-|		| **devmap** | **devmap_hash** | **sockmap** | **cpumap** | **xskmap** | **sockhash**
-|		| **cgroup_storage** | **reuseport_sockarray** | **percpu_cgroup_storage**
+|		| **devmap** | **devmap_hash** | **xdp_chain** | **sockmap** | **cpumap** | **xskmap**
+|		| **sockhash** | **cgroup_storage** | **reuseport_sockarray** | **percpu_cgroup_storage**
 |		| **queue** | **stack** }
 
 DESCRIPTION
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 70493a6da206..95f19191b8d1 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -489,7 +489,7 @@ _bpftool()
                                 perf_event_array percpu_hash percpu_array \
                                 stack_trace cgroup_array lru_hash \
                                 lru_percpu_hash lpm_trie array_of_maps \
-                                hash_of_maps devmap devmap_hash sockmap cpumap \
+                                hash_of_maps devmap devmap_hash xdp_chain sockmap cpumap \
                                 xskmap sockhash cgroup_storage reuseport_sockarray \
                                 percpu_cgroup_storage queue stack' -- \
                                                    "$cur" ) )
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index de61d73b9030..97b5b42df79c 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -38,6 +38,7 @@ const char * const map_type_name[] = {
 	[BPF_MAP_TYPE_HASH_OF_MAPS]		= "hash_of_maps",
 	[BPF_MAP_TYPE_DEVMAP]			= "devmap",
 	[BPF_MAP_TYPE_DEVMAP_HASH]		= "devmap_hash",
+	[BPF_MAP_TYPE_XDP_CHAIN]		= "xdp_chain",
 	[BPF_MAP_TYPE_SOCKMAP]			= "sockmap",
 	[BPF_MAP_TYPE_CPUMAP]			= "cpumap",
 	[BPF_MAP_TYPE_XSKMAP]			= "xskmap",
@@ -1326,7 +1327,7 @@ static int do_help(int argc, char **argv)
 		"       TYPE := { hash | array | prog_array | perf_event_array | percpu_hash |\n"
 		"                 percpu_array | stack_trace | cgroup_array | lru_hash |\n"
 		"                 lru_percpu_hash | lpm_trie | array_of_maps | hash_of_maps |\n"
-		"                 devmap | devmap_hash | sockmap | cpumap | xskmap | sockhash |\n"
+		"                 devmap | devmap_hash | xdp_chain | sockmap | cpumap | xskmap | sockhash |\n"
 		"                 cgroup_storage | reuseport_sockarray | percpu_cgroup_storage }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",

