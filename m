Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6900EAC9D3
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 01:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfIGXMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 19:12:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfIGXMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 19:12:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87NAJ6P064905;
        Sat, 7 Sep 2019 23:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=hIWyXcoK3+h6Jp74LVEDjNf/BZDNg7TGD7azm5U2TTY=;
 b=ZKmqkuX1L88/eZ6RrFoFe8TCStIhl94s9HoXtxpiBuI2N5wn7L0GW7c46UbgDUgTlzpm
 XX/GFvtYevfw1uZhgfNpYbwpqXGi02Bmb54KfFSItdrgq2PiIqVRkT+YlcIuRrkZKQAL
 a90OA85fx6ShjLf3NHdhFftXKrJSZej+SSKaYHA51euynrxTYTVSOYK7nhKuXQZAlFj3
 6AWHdrsdQ3D8vTE14aEcvhe7l7W9gBXq9fspQCMgsu9QmmL/Z0aX/1MqaMyui9auoGWT
 T3mBg2eOAmhIF7Pmupg8TtbW577Og3XtWwcB1K51EmhYTqdAUNQhZ2z2BIJ30puGmIWZ Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2uvnw3005y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 23:10:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87LbYoo177995;
        Sat, 7 Sep 2019 21:42:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uv4d0g9vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:42:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x87LgdMs005258;
        Sat, 7 Sep 2019 21:42:39 GMT
Received: from dhcp-10-175-169-153.vpn.oracle.com (/10.175.169.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 14:42:39 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        quentin.monnet@netronome.com, rdna@fb.com, joe@wand.net.nz,
        acme@redhat.com, jolsa@kernel.org, alexey.budankov@linux.intel.com,
        gregkh@linuxfoundation.org, namhyung@kernel.org, sdf@google.com,
        f.fainelli@gmail.com, shuah@kernel.org, peter@lekensteyn.nl,
        ivan@cloudflare.com, andriin@fb.com,
        bhole_prashant_q7@lab.ntt.co.jp, david.calavera@gmail.com,
        danieltimlee@gmail.com, ctakshak@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 6/7] bpf: add documentation for bpftool pcap subcommand
Date:   Sat,  7 Sep 2019 22:40:43 +0100
Message-Id: <1567892444-16344-7-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
References: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070235
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070253
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document supported "bpf pcap" subcommands.

"prog" is used to capture packets from already-loaded programs.
"trace" loads/atttaches tracing programs to capture packets.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   1 +
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   1 +
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |   1 +
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   1 +
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |   1 +
 tools/bpf/bpftool/Documentation/bpftool-pcap.rst   | 119 +++++++++++++++++++++
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |   1 +
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   1 +
 tools/bpf/bpftool/Documentation/bpftool.rst        |   1 +
 9 files changed, 127 insertions(+)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-pcap.rst

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 39615f8..54045f0 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -235,4 +235,5 @@ SEE ALSO
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
 	**bpftool-net**\ (8),
+	**bpftool-pcap**\ (8),
 	**bpftool-perf**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 06a28b0..1df98e1 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -164,5 +164,6 @@ SEE ALSO
 	**bpftool-map**\ (8),
 	**bpftool-feature**\ (8),
 	**bpftool-net**\ (8),
+	**bpftool-pcap**\ (8),
 	**bpftool-perf**\ (8),
 	**bpftool-btf**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index 4d08f35..0f36ad8 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -86,5 +86,6 @@ SEE ALSO
 	**bpftool-map**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-net**\ (8),
+	**bpftool-pcap**\ (8),
 	**bpftool-perf**\ (8),
 	**bpftool-btf**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 1c0f714..8408022 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -271,5 +271,6 @@ SEE ALSO
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
 	**bpftool-net**\ (8),
+	**bpftool-pcap**\ (8),
 	**bpftool-perf**\ (8),
 	**bpftool-btf**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index 8651b00..6bd24bb 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -198,5 +198,6 @@ SEE ALSO
 	**bpftool-map**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-pcap**\ (8),
 	**bpftool-perf**\ (8),
 	**bpftool-btf**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-pcap.rst b/tools/bpf/bpftool/Documentation/bpftool-pcap.rst
new file mode 100644
index 0000000..53ed226d
--- /dev/null
+++ b/tools/bpf/bpftool/Documentation/bpftool-pcap.rst
@@ -0,0 +1,119 @@
+================
+bpftool-pcap
+================
+-------------------------------------------------------------------------------
+tool for inspection and simple manipulation of eBPF progs
+-------------------------------------------------------------------------------
+
+:Manual section: 8
+
+SYNOPSIS
+========
+
+	**bpftool** [*OPTIONS*] **pcap** *COMMAND*
+
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-f** | **--bpffs** } }
+
+	*COMMANDS* :=
+	{ **prog** | **trace** | **help** }
+
+PCAP COMMANDS
+=============
+
+|	**bpftool** **pcap** **prog **  *PROG* [{**data_out** *FILE* | **proto** *PROTOCOL* | **len** *MAXLEN* | **pages** *NUMPAGES*}]
+|	**bpftool** **pcap** **trace** [*OBJ*] *TRACE* [{**data_out** *FILE* | **proto** *PROTOCOL* | **len** *MAXLEN* | **dev** *DEVNAME* | **pages** *NUMPAGES*}]
+|	**bpftool** **pcap help**
+|
+|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
+|	*PROTOCOL* := {
+|		**eth** | **ip** | **ieee_80211** | ... }
+|       *TRACE* := {
+|		**kprobe**|**tracepoint**:*probename*[:arg{1-4}] }
+
+
+DESCRIPTION
+===========
+	**bpftool pcap prog [*PROG*] *PROG* [{**data_out** *FILE* | **proto** *PROTOCOL* | **len** *MAXLEN* | **pages** *NUMPAGES*}]
+
+		  Capture packet data from perf event map associated with
+		  program specified.  By default capture data is displayed on
+		  stdout, but if a capture file is preferred the data_out FILE
+		  option can be used.  The link type (termed DLT_TYPE in
+		  libpcap) is assumed to be Ethernet if not explicitly
+		  specified via the **proto** option.
+
+		  Maximum capture length can be adjusted via the **len**
+		  option.
+
+		  To work with bpftool pcap, the associated BPF program must
+		  at least define a perf event map, but if config options
+		  (protocol, max len) are to be supported it should also
+		  provide an array map with a single value of at least
+		  *struct bpf_pcap_conf* size.
+
+	**bpftool** **pcap** **trace** [*OBJ*] *TRACE* [{**data_out** *FILE* | **proto** *PROTOCOL* | **len** *MAXLEN* | **dev** *DEV* | **pages** *NUMPAGES*}]
+
+		  Attach the specified program in *OBJ* or load a
+		  pre-existing BPF kprobe/tracepoint program capable
+		  of capturing packets.
+
+		  Trace specification is of the form
+
+			trace_type:probe[:arg]
+
+		  For example tracepoint:iwlwifi_dev_tx_tb:arg2 will
+		  capture packet data from the second argument to the
+		  iwlwifi_dev_tx_tb tracepoint.  *DEV* can be used to
+		  limit capture to a specific incoming interface.
+
+	**bpftool prog help**
+		  Print short help message.
+
+OPTIONS
+=======
+	-h, --help
+		  Print short generic help message (similar to **bpftool help**).
+
+	-V, --version
+		  Print version number (similar to **bpftool version**).
+
+	-j, --json
+		  Generate JSON output. For commands that cannot produce JSON, this
+		  option has no effect.
+
+	-p, --pretty
+		  Generate human-readable JSON output. Implies **-j**.
+
+	-f, --bpffs
+		  When showing BPF programs, show file names of pinned
+		  programs.
+
+	-m, --mapcompat
+		  Allow loading maps with unknown map definitions.
+
+	-n, --nomount
+		  Do not automatically attempt to mount any virtual file system
+		  (such as tracefs or BPF virtual file system) when necessary.
+
+	-d, --debug
+		  Print all logs available, even debug-level information. This
+		  includes logs from libbpf as well as from the verifier, when
+		  attempting to load programs.
+
+EXAMPLES
+========
+**# bpftool pcap trace tracepoint:net_dev_xmit:arg1 proto eth | tcpdump -r -**
+reading from file -, link-type EN10MB (Ethernet)
+00:16:49.150880 IP 10.11.12.13 > 10.11.12.14: ICMP echo reply, id 10519, seq 1, length 64
+
+SEE ALSO
+========
+	**bpf**\ (2),
+	**bpf-helpers**\ (7),
+	**bpftool**\ (8),
+	**bpftool-map**\ (8),
+	**bpftool-cgroup**\ (8),
+	**bpftool-feature**\ (8),
+	**bpftool-net**\ (8),
+	**bpftool-perf**\ (8),
+	**bpftool-btf**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-perf.rst b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
index e252bd0..d618bbd 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-perf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
@@ -90,4 +90,5 @@ SEE ALSO
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
 	**bpftool-net**\ (8),
+	**bpftool-pcap**\ (8),
 	**bpftool-btf**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 7a374b3..b4dd779 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -311,5 +311,6 @@ SEE ALSO
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
 	**bpftool-net**\ (8),
+	**bpftool-pcap**\ (8),
 	**bpftool-perf**\ (8),
 	**bpftool-btf**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index 6a9c52e..4126246 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -80,5 +80,6 @@ SEE ALSO
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
 	**bpftool-net**\ (8),
+	**bpftool-pcap**\ (8),
 	**bpftool-perf**\ (8),
 	**bpftool-btf**\ (8)
-- 
1.8.3.1

