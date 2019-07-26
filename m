Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB0076E85
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfGZQHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:07:03 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33677 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbfGZQHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 12:07:02 -0400
Received: by mail-ed1-f65.google.com with SMTP id i11so53742046edq.0
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 09:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QUSRDGhQvpw6WT0H2taZqTzTOf4dWCkoNKTleIiH9jI=;
        b=FvTh4n/+QHXbNtHtrKxCNEfv3Imwmhnzle+KWdpBAsaHD97MGNJwAh+aBz2wQZydjC
         xGronsi1be6nBUw+jVG5zAK2B2ZgVf+iDa+Qh9/VaNu2jaG8ltZA3PKSnLvgLfFGzgSR
         QAqVdDBgGOoZd4L/Ss7KsaknV4ZE3rXYMspVnYkAZXR1erfSLgU3B2TMi9nz7dMs153l
         guIjWGgXYkGPf5GJwgivK9zBBO8qYRdtjT4JJtoVna8ejRwfpC7WQotoYy4pMDJMEgKQ
         uFau8ET/Q4EhuE2Y4gsjGWZAWaUcz0AGkRna1y6i8pRx+47mjPY6d4w9aycqnaf/jMif
         Wsaw==
X-Gm-Message-State: APjAAAW8yyu+YCv/CcUQBN35/dFAkVEX1HYPmkInX6nLjH/IC0Nt9tro
        RUY86FIbXVu3nhxdofT+nYokJA==
X-Google-Smtp-Source: APXvYqxjyEGFSqB2NLQTkxCNJKyAiVg82M2UfZu2h/Va/9TiGfNKnsPK1X9R16wD92SfU7zIjT7uIA==
X-Received: by 2002:a17:906:d154:: with SMTP id br20mr71277876ejb.76.1564157220324;
        Fri, 26 Jul 2019 09:07:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id f12sm10524050ejj.32.2019.07.26.09.06.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 09:06:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CB6631800C5; Fri, 26 Jul 2019 18:06:58 +0200 (CEST)
Subject: [PATCH bpf-next v5 6/6] tools: Add definitions for devmap_hash map
 type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Fri, 26 Jul 2019 18:06:58 +0200
Message-ID: <156415721858.13581.13229682989409553007.stgit@alrua-x1>
In-Reply-To: <156415721066.13581.737309854787645225.stgit@alrua-x1>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds selftest and bpftool updates for the devmap_hash map type.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/bpftool/Documentation/bpftool-map.rst |    2 +-
 tools/bpf/bpftool/bash-completion/bpftool       |    4 ++--
 tools/bpf/bpftool/map.c                         |    3 ++-
 tools/testing/selftests/bpf/test_maps.c         |   16 ++++++++++++++++
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 490b4501cb6e..61d1d270eb5e 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -46,7 +46,7 @@ MAP COMMANDS
 |	*TYPE* := { **hash** | **array** | **prog_array** | **perf_event_array** | **percpu_hash**
 |		| **percpu_array** | **stack_trace** | **cgroup_array** | **lru_hash**
 |		| **lru_percpu_hash** | **lpm_trie** | **array_of_maps** | **hash_of_maps**
-|		| **devmap** | **sockmap** | **cpumap** | **xskmap** | **sockhash**
+|		| **devmap** | **devmap_hash** | **sockmap** | **cpumap** | **xskmap** | **sockhash**
 |		| **cgroup_storage** | **reuseport_sockarray** | **percpu_cgroup_storage**
 |		| **queue** | **stack** }
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index c8f42e1fcbc9..6b961a5ed100 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -489,8 +489,8 @@ _bpftool()
                                 perf_event_array percpu_hash percpu_array \
                                 stack_trace cgroup_array lru_hash \
                                 lru_percpu_hash lpm_trie array_of_maps \
-                                hash_of_maps devmap sockmap cpumap xskmap \
-                                sockhash cgroup_storage reuseport_sockarray \
+                                hash_of_maps devmap devmap_hash sockmap cpumap \
+                                xskmap sockhash cgroup_storage reuseport_sockarray \
                                 percpu_cgroup_storage queue stack' -- \
                                                    "$cur" ) )
                             return 0
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 5da5a7311f13..bfbbc6b4cb83 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -37,6 +37,7 @@ const char * const map_type_name[] = {
 	[BPF_MAP_TYPE_ARRAY_OF_MAPS]		= "array_of_maps",
 	[BPF_MAP_TYPE_HASH_OF_MAPS]		= "hash_of_maps",
 	[BPF_MAP_TYPE_DEVMAP]			= "devmap",
+	[BPF_MAP_TYPE_DEVMAP_HASH]		= "devmap_hash",
 	[BPF_MAP_TYPE_SOCKMAP]			= "sockmap",
 	[BPF_MAP_TYPE_CPUMAP]			= "cpumap",
 	[BPF_MAP_TYPE_XSKMAP]			= "xskmap",
@@ -1271,7 +1272,7 @@ static int do_help(int argc, char **argv)
 		"       TYPE := { hash | array | prog_array | perf_event_array | percpu_hash |\n"
 		"                 percpu_array | stack_trace | cgroup_array | lru_hash |\n"
 		"                 lru_percpu_hash | lpm_trie | array_of_maps | hash_of_maps |\n"
-		"                 devmap | sockmap | cpumap | xskmap | sockhash |\n"
+		"                 devmap | devmap_hash | sockmap | cpumap | xskmap | sockhash |\n"
 		"                 cgroup_storage | reuseport_sockarray | percpu_cgroup_storage }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 5443b9bd75ed..e1f1becda529 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -508,6 +508,21 @@ static void test_devmap(unsigned int task, void *data)
 	close(fd);
 }
 
+static void test_devmap_hash(unsigned int task, void *data)
+{
+	int fd;
+	__u32 key, value;
+
+	fd = bpf_create_map(BPF_MAP_TYPE_DEVMAP_HASH, sizeof(key), sizeof(value),
+			    2, 0);
+	if (fd < 0) {
+		printf("Failed to create devmap_hash '%s'!\n", strerror(errno));
+		exit(1);
+	}
+
+	close(fd);
+}
+
 static void test_queuemap(unsigned int task, void *data)
 {
 	const int MAP_SIZE = 32;
@@ -1684,6 +1699,7 @@ static void run_all_tests(void)
 	test_arraymap_percpu_many_keys();
 
 	test_devmap(0, NULL);
+	test_devmap_hash(0, NULL);
 	test_sockmap(0, NULL);
 
 	test_map_large();

