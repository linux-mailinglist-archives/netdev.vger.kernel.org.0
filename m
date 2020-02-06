Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18565154788
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgBFPST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38220 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgBFPSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:18:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Y1ByLhD+7eUcc85WHnSMB+pvEH9lhQMORfxSdXA1juI=; b=gCgMWlJEJ92LVt509rh6RFBcTM
        Stcxyi05w59R2RFC67uKcaEPx4OJfsh3mkeJIguazgw9mFmJm4O9R1LVwbItUzlzd42BhmRdcOBUN
        WKwLpm1Zi7EsbjasVJqqzUJA751aGIme7mhb/D+h2OoPrlAxooFDei04YIYyqDLLAZZF3DyVzyx2d
        UFvdfbMcbB9jqTTbKc+8pjAlyTsso6bJ1D31keXVmOxKn2+yixXTzrB9RoxSUVsKyPIQkK8oLQtkG
        mqbr3W3y+2vIG09zR585r4Ye+lDEBtYeyHWSLHFJPSbnDqG4jHlApY8RUm+o2Wed2BCYFBcTVcqFn
        4q1kcPIA==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005j8-40; Thu, 06 Feb 2020 15:18:01 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oWA-Ot; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 22/28] docs: networking: convert filter.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:42 +0100
Message-Id: <3e284a9ecbbc320e1128b40d43a95ba78b620116.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- use footnote markup;
- mark tables as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{filter.txt => filter.rst}     | 850 ++++++++++--------
 Documentation/networking/index.rst            |   1 +
 2 files changed, 479 insertions(+), 372 deletions(-)
 rename Documentation/networking/{filter.txt => filter.rst} (77%)

diff --git a/Documentation/networking/filter.txt b/Documentation/networking/filter.rst
similarity index 77%
rename from Documentation/networking/filter.txt
rename to Documentation/networking/filter.rst
index c4a328f2d57a..948ce59097f6 100644
--- a/Documentation/networking/filter.txt
+++ b/Documentation/networking/filter.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================================================
 Linux Socket Filtering aka Berkeley Packet Filter (BPF)
 =======================================================
 
@@ -42,10 +45,10 @@ displays what is being placed into this structure.
 
 Although we were only speaking about sockets here, BPF in Linux is used
 in many more places. There's xt_bpf for netfilter, cls_bpf in the kernel
-qdisc layer, SECCOMP-BPF (SECure COMPuting [1]), and lots of other places
+qdisc layer, SECCOMP-BPF (SECure COMPuting [1]_), and lots of other places
 such as team driver, PTP code, etc where BPF is being used.
 
- [1] Documentation/userspace-api/seccomp_filter.rst
+.. [1] Documentation/userspace-api/seccomp_filter.rst
 
 Original BPF paper:
 
@@ -59,23 +62,23 @@ Structure
 ---------
 
 User space applications include <linux/filter.h> which contains the
-following relevant structures:
+following relevant structures::
 
-struct sock_filter {	/* Filter block */
-	__u16	code;   /* Actual filter code */
-	__u8	jt;	/* Jump true */
-	__u8	jf;	/* Jump false */
-	__u32	k;      /* Generic multiuse field */
-};
+	struct sock_filter {	/* Filter block */
+		__u16	code;   /* Actual filter code */
+		__u8	jt;	/* Jump true */
+		__u8	jf;	/* Jump false */
+		__u32	k;      /* Generic multiuse field */
+	};
 
 Such a structure is assembled as an array of 4-tuples, that contains
 a code, jt, jf and k value. jt and jf are jump offsets and k a generic
-value to be used for a provided code.
+value to be used for a provided code::
 
-struct sock_fprog {			/* Required for SO_ATTACH_FILTER. */
-	unsigned short		   len;	/* Number of filter blocks */
-	struct sock_filter __user *filter;
-};
+	struct sock_fprog {			/* Required for SO_ATTACH_FILTER. */
+		unsigned short		   len;	/* Number of filter blocks */
+		struct sock_filter __user *filter;
+	};
 
 For socket filtering, a pointer to this structure (as shown in
 follow-up example) is being passed to the kernel through setsockopt(2).
@@ -83,55 +86,57 @@ follow-up example) is being passed to the kernel through setsockopt(2).
 Example
 -------
 
-#include <sys/socket.h>
-#include <sys/types.h>
-#include <arpa/inet.h>
-#include <linux/if_ether.h>
-/* ... */
+::
 
-/* From the example above: tcpdump -i em1 port 22 -dd */
-struct sock_filter code[] = {
-	{ 0x28,  0,  0, 0x0000000c },
-	{ 0x15,  0,  8, 0x000086dd },
-	{ 0x30,  0,  0, 0x00000014 },
-	{ 0x15,  2,  0, 0x00000084 },
-	{ 0x15,  1,  0, 0x00000006 },
-	{ 0x15,  0, 17, 0x00000011 },
-	{ 0x28,  0,  0, 0x00000036 },
-	{ 0x15, 14,  0, 0x00000016 },
-	{ 0x28,  0,  0, 0x00000038 },
-	{ 0x15, 12, 13, 0x00000016 },
-	{ 0x15,  0, 12, 0x00000800 },
-	{ 0x30,  0,  0, 0x00000017 },
-	{ 0x15,  2,  0, 0x00000084 },
-	{ 0x15,  1,  0, 0x00000006 },
-	{ 0x15,  0,  8, 0x00000011 },
-	{ 0x28,  0,  0, 0x00000014 },
-	{ 0x45,  6,  0, 0x00001fff },
-	{ 0xb1,  0,  0, 0x0000000e },
-	{ 0x48,  0,  0, 0x0000000e },
-	{ 0x15,  2,  0, 0x00000016 },
-	{ 0x48,  0,  0, 0x00000010 },
-	{ 0x15,  0,  1, 0x00000016 },
-	{ 0x06,  0,  0, 0x0000ffff },
-	{ 0x06,  0,  0, 0x00000000 },
-};
+    #include <sys/socket.h>
+    #include <sys/types.h>
+    #include <arpa/inet.h>
+    #include <linux/if_ether.h>
+    /* ... */
 
-struct sock_fprog bpf = {
-	.len = ARRAY_SIZE(code),
-	.filter = code,
-};
+    /* From the example above: tcpdump -i em1 port 22 -dd */
+    struct sock_filter code[] = {
+	    { 0x28,  0,  0, 0x0000000c },
+	    { 0x15,  0,  8, 0x000086dd },
+	    { 0x30,  0,  0, 0x00000014 },
+	    { 0x15,  2,  0, 0x00000084 },
+	    { 0x15,  1,  0, 0x00000006 },
+	    { 0x15,  0, 17, 0x00000011 },
+	    { 0x28,  0,  0, 0x00000036 },
+	    { 0x15, 14,  0, 0x00000016 },
+	    { 0x28,  0,  0, 0x00000038 },
+	    { 0x15, 12, 13, 0x00000016 },
+	    { 0x15,  0, 12, 0x00000800 },
+	    { 0x30,  0,  0, 0x00000017 },
+	    { 0x15,  2,  0, 0x00000084 },
+	    { 0x15,  1,  0, 0x00000006 },
+	    { 0x15,  0,  8, 0x00000011 },
+	    { 0x28,  0,  0, 0x00000014 },
+	    { 0x45,  6,  0, 0x00001fff },
+	    { 0xb1,  0,  0, 0x0000000e },
+	    { 0x48,  0,  0, 0x0000000e },
+	    { 0x15,  2,  0, 0x00000016 },
+	    { 0x48,  0,  0, 0x00000010 },
+	    { 0x15,  0,  1, 0x00000016 },
+	    { 0x06,  0,  0, 0x0000ffff },
+	    { 0x06,  0,  0, 0x00000000 },
+    };
 
-sock = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
-if (sock < 0)
-	/* ... bail out ... */
+    struct sock_fprog bpf = {
+	    .len = ARRAY_SIZE(code),
+	    .filter = code,
+    };
 
-ret = setsockopt(sock, SOL_SOCKET, SO_ATTACH_FILTER, &bpf, sizeof(bpf));
-if (ret < 0)
-	/* ... bail out ... */
+    sock = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
+    if (sock < 0)
+	    /* ... bail out ... */
 
-/* ... */
-close(sock);
+    ret = setsockopt(sock, SOL_SOCKET, SO_ATTACH_FILTER, &bpf, sizeof(bpf));
+    if (ret < 0)
+	    /* ... bail out ... */
+
+    /* ... */
+    close(sock);
 
 The above example code attaches a socket filter for a PF_PACKET socket
 in order to let all IPv4/IPv6 packets with port 22 pass. The rest will
@@ -178,15 +183,17 @@ closely modelled after Steven McCanne's and Van Jacobson's BPF paper.
 
 The BPF architecture consists of the following basic elements:
 
+  =======          ====================================================
   Element          Description
-
+  =======          ====================================================
   A                32 bit wide accumulator
   X                32 bit wide X register
   M[]              16 x 32 bit wide misc registers aka "scratch memory
-                   store", addressable from 0 to 15
+		   store", addressable from 0 to 15
+  =======          ====================================================
 
 A program, that is translated by bpf_asm into "opcodes" is an array that
-consists of the following elements (as already mentioned):
+consists of the following elements (as already mentioned)::
 
   op:16, jt:8, jf:8, k:32
 
@@ -201,8 +208,9 @@ and return instructions that are also represented in bpf_asm syntax. This
 table lists all bpf_asm instructions available resp. what their underlying
 opcodes as defined in linux/filter.h stand for:
 
+  ===========      ===================  =====================
   Instruction      Addressing mode      Description
-
+  ===========      ===================  =====================
   ld               1, 2, 3, 4, 12       Load word into A
   ldi              4                    Load word into A
   ldh              1, 2                 Load half-word into A
@@ -241,11 +249,13 @@ opcodes as defined in linux/filter.h stand for:
   txa                                   Copy X into A
 
   ret              4, 11                Return
+  ===========      ===================  =====================
 
 The next table shows addressing formats from the 2nd column:
 
+  ===============  ===================  ===============================================
   Addressing mode  Syntax               Description
-
+  ===============  ===================  ===============================================
    0               x/%x                 Register X
    1               [k]                  BHW at byte offset k in the packet
    2               [x + k]              BHW at the offset X + k in the packet
@@ -259,6 +269,7 @@ The next table shows addressing formats from the 2nd column:
   10               x/%x,Lt              Jump to Lt if predicate is true
   11               a/%a                 Accumulator A
   12               extension            BPF extension
+  ===============  ===================  ===============================================
 
 The Linux kernel also has a couple of BPF extensions that are used along
 with the class of load instructions by "overloading" the k argument with
@@ -267,8 +278,9 @@ extensions are loaded into A.
 
 Possible BPF extensions are shown in the following table:
 
+  ===================================   =================================================
   Extension                             Description
-
+  ===================================   =================================================
   len                                   skb->len
   proto                                 skb->protocol
   type                                  skb->pkt_type
@@ -285,18 +297,19 @@ Possible BPF extensions are shown in the following table:
   vlan_avail                            skb_vlan_tag_present(skb)
   vlan_tpid                             skb->vlan_proto
   rand                                  prandom_u32()
+  ===================================   =================================================
 
 These extensions can also be prefixed with '#'.
 Examples for low-level BPF:
 
-** ARP packets:
+**ARP packets**::
 
   ldh [12]
   jne #0x806, drop
   ret #-1
   drop: ret #0
 
-** IPv4 TCP packets:
+**IPv4 TCP packets**::
 
   ldh [12]
   jne #0x800, drop
@@ -305,14 +318,15 @@ Examples for low-level BPF:
   ret #-1
   drop: ret #0
 
-** (Accelerated) VLAN w/ id 10:
+**(Accelerated) VLAN w/ id 10**::
 
   ld vlan_tci
   jneq #10, drop
   ret #-1
   drop: ret #0
 
-** icmp random packet sampling, 1 in 4
+**icmp random packet sampling, 1 in 4**:
+
   ldh [12]
   jne #0x800, drop
   ldb [23]
@@ -324,7 +338,7 @@ Examples for low-level BPF:
   ret #-1
   drop: ret #0
 
-** SECCOMP filter example:
+**SECCOMP filter example**::
 
   ld [4]                  /* offsetof(struct seccomp_data, arch) */
   jne #0xc000003e, bad    /* AUDIT_ARCH_X86_64 */
@@ -345,18 +359,18 @@ Examples for low-level BPF:
 The above example code can be placed into a file (here called "foo"), and
 then be passed to the bpf_asm tool for generating opcodes, output that xt_bpf
 and cls_bpf understands and can directly be loaded with. Example with above
-ARP code:
+ARP code::
 
-$ ./bpf_asm foo
-4,40 0 0 12,21 0 1 2054,6 0 0 4294967295,6 0 0 0,
+    $ ./bpf_asm foo
+    4,40 0 0 12,21 0 1 2054,6 0 0 4294967295,6 0 0 0,
 
-In copy and paste C-like output:
+In copy and paste C-like output::
 
-$ ./bpf_asm -c foo
-{ 0x28,  0,  0, 0x0000000c },
-{ 0x15,  0,  1, 0x00000806 },
-{ 0x06,  0,  0, 0xffffffff },
-{ 0x06,  0,  0, 0000000000 },
+    $ ./bpf_asm -c foo
+    { 0x28,  0,  0, 0x0000000c },
+    { 0x15,  0,  1, 0x00000806 },
+    { 0x06,  0,  0, 0xffffffff },
+    { 0x06,  0,  0, 0000000000 },
 
 In particular, as usage with xt_bpf or cls_bpf can result in more complex BPF
 filters that might not be obvious at first, it's good to test filters before
@@ -365,9 +379,9 @@ bpf_dbg under tools/bpf/ in the kernel source directory. This debugger allows
 for testing BPF filters against given pcap files, single stepping through the
 BPF code on the pcap's packets and to do BPF machine register dumps.
 
-Starting bpf_dbg is trivial and just requires issuing:
+Starting bpf_dbg is trivial and just requires issuing::
 
-# ./bpf_dbg
+    # ./bpf_dbg
 
 In case input and output do not equal stdin/stdout, bpf_dbg takes an
 alternative stdin source as a first argument, and an alternative stdout
@@ -381,84 +395,100 @@ Interaction in bpf_dbg happens through a shell that also has auto-completion
 support (follow-up example commands starting with '>' denote bpf_dbg shell).
 The usual workflow would be to ...
 
-> load bpf 6,40 0 0 12,21 0 3 2048,48 0 0 23,21 0 1 1,6 0 0 65535,6 0 0 0
+* load bpf 6,40 0 0 12,21 0 3 2048,48 0 0 23,21 0 1 1,6 0 0 65535,6 0 0 0
   Loads a BPF filter from standard output of bpf_asm, or transformed via
-  e.g. `tcpdump -iem1 -ddd port 22 | tr '\n' ','`. Note that for JIT
+  e.g. ``tcpdump -iem1 -ddd port 22 | tr '\n' ','``. Note that for JIT
   debugging (next section), this command creates a temporary socket and
   loads the BPF code into the kernel. Thus, this will also be useful for
   JIT developers.
 
-> load pcap foo.pcap
+* load pcap foo.pcap
+
   Loads standard tcpdump pcap file.
 
-> run [<n>]
+* run [<n>]
+
 bpf passes:1 fails:9
   Runs through all packets from a pcap to account how many passes and fails
   the filter will generate. A limit of packets to traverse can be given.
 
-> disassemble
-l0:	ldh [12]
-l1:	jeq #0x800, l2, l5
-l2:	ldb [23]
-l3:	jeq #0x1, l4, l5
-l4:	ret #0xffff
-l5:	ret #0
+* disassemble::
+
+	l0:	ldh [12]
+	l1:	jeq #0x800, l2, l5
+	l2:	ldb [23]
+	l3:	jeq #0x1, l4, l5
+	l4:	ret #0xffff
+	l5:	ret #0
+
   Prints out BPF code disassembly.
 
-> dump
-/* { op, jt, jf, k }, */
-{ 0x28,  0,  0, 0x0000000c },
-{ 0x15,  0,  3, 0x00000800 },
-{ 0x30,  0,  0, 0x00000017 },
-{ 0x15,  0,  1, 0x00000001 },
-{ 0x06,  0,  0, 0x0000ffff },
-{ 0x06,  0,  0, 0000000000 },
+* dump::
+
+	/* { op, jt, jf, k }, */
+	{ 0x28,  0,  0, 0x0000000c },
+	{ 0x15,  0,  3, 0x00000800 },
+	{ 0x30,  0,  0, 0x00000017 },
+	{ 0x15,  0,  1, 0x00000001 },
+	{ 0x06,  0,  0, 0x0000ffff },
+	{ 0x06,  0,  0, 0000000000 },
+
   Prints out C-style BPF code dump.
 
-> breakpoint 0
-breakpoint at: l0:	ldh [12]
-> breakpoint 1
-breakpoint at: l1:	jeq #0x800, l2, l5
+* breakpoint 0::
+
+	breakpoint at: l0:	ldh [12]
+
+* breakpoint 1::
+
+	breakpoint at: l1:	jeq #0x800, l2, l5
+
   ...
+
   Sets breakpoints at particular BPF instructions. Issuing a `run` command
   will walk through the pcap file continuing from the current packet and
   break when a breakpoint is being hit (another `run` will continue from
   the currently active breakpoint executing next instructions):
 
-  > run
-  -- register dump --
-  pc:       [0]                       <-- program counter
-  code:     [40] jt[0] jf[0] k[12]    <-- plain BPF code of current instruction
-  curr:     l0:	ldh [12]              <-- disassembly of current instruction
-  A:        [00000000][0]             <-- content of A (hex, decimal)
-  X:        [00000000][0]             <-- content of X (hex, decimal)
-  M[0,15]:  [00000000][0]             <-- folded content of M (hex, decimal)
-  -- packet dump --                   <-- Current packet from pcap (hex)
-  len: 42
-    0: 00 19 cb 55 55 a4 00 14 a4 43 78 69 08 06 00 01
-   16: 08 00 06 04 00 01 00 14 a4 43 78 69 0a 3b 01 26
-   32: 00 00 00 00 00 00 0a 3b 01 01
-  (breakpoint)
-  >
+  * run::
 
-> breakpoint
-breakpoints: 0 1
-  Prints currently set breakpoints.
+	-- register dump --
+	pc:       [0]                       <-- program counter
+	code:     [40] jt[0] jf[0] k[12]    <-- plain BPF code of current instruction
+	curr:     l0:	ldh [12]              <-- disassembly of current instruction
+	A:        [00000000][0]             <-- content of A (hex, decimal)
+	X:        [00000000][0]             <-- content of X (hex, decimal)
+	M[0,15]:  [00000000][0]             <-- folded content of M (hex, decimal)
+	-- packet dump --                   <-- Current packet from pcap (hex)
+	len: 42
+	    0: 00 19 cb 55 55 a4 00 14 a4 43 78 69 08 06 00 01
+	16: 08 00 06 04 00 01 00 14 a4 43 78 69 0a 3b 01 26
+	32: 00 00 00 00 00 00 0a 3b 01 01
+	(breakpoint)
+	>
+
+  * breakpoint::
+
+	breakpoints: 0 1
+
+    Prints currently set breakpoints.
+
+* step [-<n>, +<n>]
 
-> step [-<n>, +<n>]
   Performs single stepping through the BPF program from the current pc
   offset. Thus, on each step invocation, above register dump is issued.
   This can go forwards and backwards in time, a plain `step` will break
   on the next BPF instruction, thus +1. (No `run` needs to be issued here.)
 
-> select <n>
+* select <n>
+
   Selects a given packet from the pcap file to continue from. Thus, on
   the next `run` or `step`, the BPF program is being evaluated against
   the user pre-selected packet. Numbering starts just as in Wireshark
   with index 1.
 
-> quit
-#
+* quit
+
   Exits bpf_dbg.
 
 JIT compiler
@@ -468,23 +498,23 @@ The Linux kernel has a built-in BPF JIT compiler for x86_64, SPARC,
 PowerPC, ARM, ARM64, MIPS, RISC-V and s390 and can be enabled through
 CONFIG_BPF_JIT. The JIT compiler is transparently invoked for each
 attached filter from user space or for internal kernel users if it has
-been previously enabled by root:
+been previously enabled by root::
 
   echo 1 > /proc/sys/net/core/bpf_jit_enable
 
 For JIT developers, doing audits etc, each compile run can output the generated
-opcode image into the kernel log via:
+opcode image into the kernel log via::
 
   echo 2 > /proc/sys/net/core/bpf_jit_enable
 
-Example output from dmesg:
+Example output from dmesg::
 
-[ 3389.935842] flen=6 proglen=70 pass=3 image=ffffffffa0069c8f
-[ 3389.935847] JIT code: 00000000: 55 48 89 e5 48 83 ec 60 48 89 5d f8 44 8b 4f 68
-[ 3389.935849] JIT code: 00000010: 44 2b 4f 6c 4c 8b 87 d8 00 00 00 be 0c 00 00 00
-[ 3389.935850] JIT code: 00000020: e8 1d 94 ff e0 3d 00 08 00 00 75 16 be 17 00 00
-[ 3389.935851] JIT code: 00000030: 00 e8 28 94 ff e0 83 f8 01 75 07 b8 ff ff 00 00
-[ 3389.935852] JIT code: 00000040: eb 02 31 c0 c9 c3
+    [ 3389.935842] flen=6 proglen=70 pass=3 image=ffffffffa0069c8f
+    [ 3389.935847] JIT code: 00000000: 55 48 89 e5 48 83 ec 60 48 89 5d f8 44 8b 4f 68
+    [ 3389.935849] JIT code: 00000010: 44 2b 4f 6c 4c 8b 87 d8 00 00 00 be 0c 00 00 00
+    [ 3389.935850] JIT code: 00000020: e8 1d 94 ff e0 3d 00 08 00 00 75 16 be 17 00 00
+    [ 3389.935851] JIT code: 00000030: 00 e8 28 94 ff e0 83 f8 01 75 07 b8 ff ff 00 00
+    [ 3389.935852] JIT code: 00000040: eb 02 31 c0 c9 c3
 
 When CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently set to 1 and
 setting any other value than that will return in failure. This is even the case for
@@ -493,78 +523,78 @@ is discouraged and introspection through bpftool (under tools/bpf/bpftool/) is t
 generally recommended approach instead.
 
 In the kernel source tree under tools/bpf/, there's bpf_jit_disasm for
-generating disassembly out of the kernel log's hexdump:
+generating disassembly out of the kernel log's hexdump::
 
-# ./bpf_jit_disasm
-70 bytes emitted from JIT compiler (pass:3, flen:6)
-ffffffffa0069c8f + <x>:
-   0:	push   %rbp
-   1:	mov    %rsp,%rbp
-   4:	sub    $0x60,%rsp
-   8:	mov    %rbx,-0x8(%rbp)
-   c:	mov    0x68(%rdi),%r9d
-  10:	sub    0x6c(%rdi),%r9d
-  14:	mov    0xd8(%rdi),%r8
-  1b:	mov    $0xc,%esi
-  20:	callq  0xffffffffe0ff9442
-  25:	cmp    $0x800,%eax
-  2a:	jne    0x0000000000000042
-  2c:	mov    $0x17,%esi
-  31:	callq  0xffffffffe0ff945e
-  36:	cmp    $0x1,%eax
-  39:	jne    0x0000000000000042
-  3b:	mov    $0xffff,%eax
-  40:	jmp    0x0000000000000044
-  42:	xor    %eax,%eax
-  44:	leaveq
-  45:	retq
+	# ./bpf_jit_disasm
+	70 bytes emitted from JIT compiler (pass:3, flen:6)
+	ffffffffa0069c8f + <x>:
+	0:	push   %rbp
+	1:	mov    %rsp,%rbp
+	4:	sub    $0x60,%rsp
+	8:	mov    %rbx,-0x8(%rbp)
+	c:	mov    0x68(%rdi),%r9d
+	10:	sub    0x6c(%rdi),%r9d
+	14:	mov    0xd8(%rdi),%r8
+	1b:	mov    $0xc,%esi
+	20:	callq  0xffffffffe0ff9442
+	25:	cmp    $0x800,%eax
+	2a:	jne    0x0000000000000042
+	2c:	mov    $0x17,%esi
+	31:	callq  0xffffffffe0ff945e
+	36:	cmp    $0x1,%eax
+	39:	jne    0x0000000000000042
+	3b:	mov    $0xffff,%eax
+	40:	jmp    0x0000000000000044
+	42:	xor    %eax,%eax
+	44:	leaveq
+	45:	retq
 
-Issuing option `-o` will "annotate" opcodes to resulting assembler
-instructions, which can be very useful for JIT developers:
+	Issuing option `-o` will "annotate" opcodes to resulting assembler
+	instructions, which can be very useful for JIT developers:
 
-# ./bpf_jit_disasm -o
-70 bytes emitted from JIT compiler (pass:3, flen:6)
-ffffffffa0069c8f + <x>:
-   0:	push   %rbp
-	55
-   1:	mov    %rsp,%rbp
-	48 89 e5
-   4:	sub    $0x60,%rsp
-	48 83 ec 60
-   8:	mov    %rbx,-0x8(%rbp)
-	48 89 5d f8
-   c:	mov    0x68(%rdi),%r9d
-	44 8b 4f 68
-  10:	sub    0x6c(%rdi),%r9d
-	44 2b 4f 6c
-  14:	mov    0xd8(%rdi),%r8
-	4c 8b 87 d8 00 00 00
-  1b:	mov    $0xc,%esi
-	be 0c 00 00 00
-  20:	callq  0xffffffffe0ff9442
-	e8 1d 94 ff e0
-  25:	cmp    $0x800,%eax
-	3d 00 08 00 00
-  2a:	jne    0x0000000000000042
-	75 16
-  2c:	mov    $0x17,%esi
-	be 17 00 00 00
-  31:	callq  0xffffffffe0ff945e
-	e8 28 94 ff e0
-  36:	cmp    $0x1,%eax
-	83 f8 01
-  39:	jne    0x0000000000000042
-	75 07
-  3b:	mov    $0xffff,%eax
-	b8 ff ff 00 00
-  40:	jmp    0x0000000000000044
-	eb 02
-  42:	xor    %eax,%eax
-	31 c0
-  44:	leaveq
-	c9
-  45:	retq
-	c3
+	# ./bpf_jit_disasm -o
+	70 bytes emitted from JIT compiler (pass:3, flen:6)
+	ffffffffa0069c8f + <x>:
+	0:	push   %rbp
+		55
+	1:	mov    %rsp,%rbp
+		48 89 e5
+	4:	sub    $0x60,%rsp
+		48 83 ec 60
+	8:	mov    %rbx,-0x8(%rbp)
+		48 89 5d f8
+	c:	mov    0x68(%rdi),%r9d
+		44 8b 4f 68
+	10:	sub    0x6c(%rdi),%r9d
+		44 2b 4f 6c
+	14:	mov    0xd8(%rdi),%r8
+		4c 8b 87 d8 00 00 00
+	1b:	mov    $0xc,%esi
+		be 0c 00 00 00
+	20:	callq  0xffffffffe0ff9442
+		e8 1d 94 ff e0
+	25:	cmp    $0x800,%eax
+		3d 00 08 00 00
+	2a:	jne    0x0000000000000042
+		75 16
+	2c:	mov    $0x17,%esi
+		be 17 00 00 00
+	31:	callq  0xffffffffe0ff945e
+		e8 28 94 ff e0
+	36:	cmp    $0x1,%eax
+		83 f8 01
+	39:	jne    0x0000000000000042
+		75 07
+	3b:	mov    $0xffff,%eax
+		b8 ff ff 00 00
+	40:	jmp    0x0000000000000044
+		eb 02
+	42:	xor    %eax,%eax
+		31 c0
+	44:	leaveq
+		c9
+	45:	retq
+		c3
 
 For BPF JIT developers, bpf_jit_disasm, bpf_asm and bpf_dbg provides a useful
 toolchain for developing and testing the kernel's JIT compiler.
@@ -663,9 +693,9 @@ Some core changes of the new internal format:
 
 - Conditional jt/jf targets replaced with jt/fall-through:
 
-  While the original design has constructs such as "if (cond) jump_true;
-  else jump_false;", they are being replaced into alternative constructs like
-  "if (cond) jump_true; /* else fall-through */".
+  While the original design has constructs such as ``if (cond) jump_true;
+  else jump_false;``, they are being replaced into alternative constructs like
+  ``if (cond) jump_true; /* else fall-through */``.
 
 - Introduces bpf_call insn and register passing convention for zero overhead
   calls from/to other kernel functions:
@@ -684,32 +714,32 @@ Some core changes of the new internal format:
   a return value of the function. Since R6 - R9 are callee saved, their state
   is preserved across the call.
 
-  For example, consider three C functions:
+  For example, consider three C functions::
 
-  u64 f1() { return (*_f2)(1); }
-  u64 f2(u64 a) { return f3(a + 1, a); }
-  u64 f3(u64 a, u64 b) { return a - b; }
+    u64 f1() { return (*_f2)(1); }
+    u64 f2(u64 a) { return f3(a + 1, a); }
+    u64 f3(u64 a, u64 b) { return a - b; }
 
-  GCC can compile f1, f3 into x86_64:
+  GCC can compile f1, f3 into x86_64::
 
-  f1:
-    movl $1, %edi
-    movq _f2(%rip), %rax
-    jmp  *%rax
-  f3:
-    movq %rdi, %rax
-    subq %rsi, %rax
-    ret
+    f1:
+	movl $1, %edi
+	movq _f2(%rip), %rax
+	jmp  *%rax
+    f3:
+	movq %rdi, %rax
+	subq %rsi, %rax
+	ret
 
-  Function f2 in eBPF may look like:
+  Function f2 in eBPF may look like::
 
-  f2:
-    bpf_mov R2, R1
-    bpf_add R1, 1
-    bpf_call f3
-    bpf_exit
+    f2:
+	bpf_mov R2, R1
+	bpf_add R1, 1
+	bpf_call f3
+	bpf_exit
 
-  If f2 is JITed and the pointer stored to '_f2'. The calls f1 -> f2 -> f3 and
+  If f2 is JITed and the pointer stored to ``_f2``. The calls f1 -> f2 -> f3 and
   returns will be seamless. Without JIT, __bpf_prog_run() interpreter needs to
   be used to call into f2.
 
@@ -722,6 +752,8 @@ Some core changes of the new internal format:
   On 64-bit architectures all register map to HW registers one to one. For
   example, x86_64 JIT compiler can map them as ...
 
+  ::
+
     R0 - rax
     R1 - rdi
     R2 - rsi
@@ -737,7 +769,7 @@ Some core changes of the new internal format:
   ... since x86_64 ABI mandates rdi, rsi, rdx, rcx, r8, r9 for argument passing
   and rbx, r12 - r15 are callee saved.
 
-  Then the following internal BPF pseudo-program:
+  Then the following internal BPF pseudo-program::
 
     bpf_mov R6, R1 /* save ctx */
     bpf_mov R2, 2
@@ -755,7 +787,7 @@ Some core changes of the new internal format:
     bpf_add R0, R7
     bpf_exit
 
-  After JIT to x86_64 may look like:
+  After JIT to x86_64 may look like::
 
     push %rbp
     mov %rsp,%rbp
@@ -781,21 +813,21 @@ Some core changes of the new internal format:
     leaveq
     retq
 
-  Which is in this example equivalent in C to:
+  Which is in this example equivalent in C to::
 
     u64 bpf_filter(u64 ctx)
     {
-        return foo(ctx, 2, 3, 4, 5) + bar(ctx, 6, 7, 8, 9);
+	return foo(ctx, 2, 3, 4, 5) + bar(ctx, 6, 7, 8, 9);
     }
 
   In-kernel functions foo() and bar() with prototype: u64 (*)(u64 arg1, u64
   arg2, u64 arg3, u64 arg4, u64 arg5); will receive arguments in proper
-  registers and place their return value into '%rax' which is R0 in eBPF.
+  registers and place their return value into ``%rax`` which is R0 in eBPF.
   Prologue and epilogue are emitted by JIT and are implicit in the
   interpreter. R0-R5 are scratch registers, so eBPF program needs to preserve
   them across the calls as defined by calling convention.
 
-  For example the following program is invalid:
+  For example the following program is invalid::
 
     bpf_mov R1, 1
     bpf_call foo
@@ -814,7 +846,7 @@ The input context pointer for invoking the interpreter function is generic,
 its content is defined by a specific use case. For seccomp register R1 points
 to seccomp_data, for converted BPF filters R1 points to a skb.
 
-A program, that is translated internally consists of the following elements:
+A program, that is translated internally consists of the following elements::
 
   op:16, jt:8, jf:8, k:32    ==>    op:8, dst_reg:4, src_reg:4, off:16, imm:32
 
@@ -824,7 +856,7 @@ instructions must be multiple of 8 bytes to preserve backward compatibility.
 
 Internal BPF is a general purpose RISC instruction set. Not every register and
 every instruction are used during translation from original BPF to new format.
-For example, socket filters are not using 'exclusive add' instruction, but
+For example, socket filters are not using ``exclusive add`` instruction, but
 tracing filters may do to maintain counters of events, for example. Register R9
 is not used by socket filters either, but more complex filters may be running
 out of registers and would have to resort to spill/fill to stack.
@@ -849,7 +881,7 @@ eBPF opcode encoding
 
 eBPF is reusing most of the opcode encoding from classic to simplify conversion
 of classic BPF to eBPF. For arithmetic and jump instructions the 8-bit 'code'
-field is divided into three parts:
+field is divided into three parts::
 
   +----------------+--------+--------------------+
   |   4 bits       |  1 bit |   3 bits           |
@@ -859,8 +891,9 @@ field is divided into three parts:
 
 Three LSB bits store instruction class which is one of:
 
-  Classic BPF classes:    eBPF classes:
-
+  ===================     ===============
+  Classic BPF classes     eBPF classes
+  ===================     ===============
   BPF_LD    0x00          BPF_LD    0x00
   BPF_LDX   0x01          BPF_LDX   0x01
   BPF_ST    0x02          BPF_ST    0x02
@@ -869,25 +902,28 @@ Three LSB bits store instruction class which is one of:
   BPF_JMP   0x05          BPF_JMP   0x05
   BPF_RET   0x06          BPF_JMP32 0x06
   BPF_MISC  0x07          BPF_ALU64 0x07
+  ===================     ===============
 
 When BPF_CLASS(code) == BPF_ALU or BPF_JMP, 4th bit encodes source operand ...
 
-  BPF_K     0x00
-  BPF_X     0x08
+    ::
 
- * in classic BPF, this means:
+	BPF_K     0x00
+	BPF_X     0x08
 
-  BPF_SRC(code) == BPF_X - use register X as source operand
-  BPF_SRC(code) == BPF_K - use 32-bit immediate as source operand
+ * in classic BPF, this means::
 
- * in eBPF, this means:
+	BPF_SRC(code) == BPF_X - use register X as source operand
+	BPF_SRC(code) == BPF_K - use 32-bit immediate as source operand
 
-  BPF_SRC(code) == BPF_X - use 'src_reg' register as source operand
-  BPF_SRC(code) == BPF_K - use 32-bit immediate as source operand
+ * in eBPF, this means::
+
+	BPF_SRC(code) == BPF_X - use 'src_reg' register as source operand
+	BPF_SRC(code) == BPF_K - use 32-bit immediate as source operand
 
 ... and four MSB bits store operation code.
 
-If BPF_CLASS(code) == BPF_ALU or BPF_ALU64 [ in eBPF ], BPF_OP(code) is one of:
+If BPF_CLASS(code) == BPF_ALU or BPF_ALU64 [ in eBPF ], BPF_OP(code) is one of::
 
   BPF_ADD   0x00
   BPF_SUB   0x10
@@ -904,7 +940,7 @@ If BPF_CLASS(code) == BPF_ALU or BPF_ALU64 [ in eBPF ], BPF_OP(code) is one of:
   BPF_ARSH  0xc0  /* eBPF only: sign extending shift right */
   BPF_END   0xd0  /* eBPF only: endianness conversion */
 
-If BPF_CLASS(code) == BPF_JMP or BPF_JMP32 [ in eBPF ], BPF_OP(code) is one of:
+If BPF_CLASS(code) == BPF_JMP or BPF_JMP32 [ in eBPF ], BPF_OP(code) is one of::
 
   BPF_JA    0x00  /* BPF_JMP only */
   BPF_JEQ   0x10
@@ -934,7 +970,7 @@ exactly the same operations as BPF_ALU, but with 64-bit wide operands
 instead. So BPF_ADD | BPF_X | BPF_ALU64 means 64-bit addition, i.e.:
 dst_reg = dst_reg + src_reg
 
-Classic BPF wastes the whole BPF_RET class to represent a single 'ret'
+Classic BPF wastes the whole BPF_RET class to represent a single ``ret``
 operation. Classic BPF_RET | BPF_K means copy imm32 into return register
 and perform function exit. eBPF is modeled to match CPU, so BPF_JMP | BPF_EXIT
 in eBPF means function exit only. The eBPF program needs to store return
@@ -942,7 +978,7 @@ value into register R0 before doing a BPF_EXIT. Class 6 in eBPF is used as
 BPF_JMP32 to mean exactly the same operations as BPF_JMP, but with 32-bit wide
 operands for the comparisons instead.
 
-For load and store instructions the 8-bit 'code' field is divided as:
+For load and store instructions the 8-bit 'code' field is divided as::
 
   +--------+--------+-------------------+
   | 3 bits | 2 bits |   3 bits          |
@@ -952,19 +988,21 @@ For load and store instructions the 8-bit 'code' field is divided as:
 
 Size modifier is one of ...
 
+::
+
   BPF_W   0x00    /* word */
   BPF_H   0x08    /* half word */
   BPF_B   0x10    /* byte */
   BPF_DW  0x18    /* eBPF only, double word */
 
-... which encodes size of load/store operation:
+... which encodes size of load/store operation::
 
  B  - 1 byte
  H  - 2 byte
  W  - 4 byte
  DW - 8 byte (eBPF only)
 
-Mode modifier is one of:
+Mode modifier is one of::
 
   BPF_IMM  0x00  /* used for 32-bit mov in classic BPF and 64-bit in eBPF */
   BPF_ABS  0x20
@@ -979,7 +1017,7 @@ eBPF has two non-generic instructions: (BPF_ABS | <size> | BPF_LD) and
 
 They had to be carried over from classic to have strong performance of
 socket filters running in eBPF interpreter. These instructions can only
-be used when interpreter context is a pointer to 'struct sk_buff' and
+be used when interpreter context is a pointer to ``struct sk_buff`` and
 have seven implicit operands. Register R6 is an implicit input that must
 contain pointer to sk_buff. Register R0 is an implicit output which contains
 the data fetched from the packet. Registers R1-R5 are scratch registers
@@ -992,26 +1030,26 @@ the interpreter will abort the execution of the program. JIT compilers
 therefore must preserve this property. src_reg and imm32 fields are
 explicit inputs to these instructions.
 
-For example:
+For example::
 
   BPF_IND | BPF_W | BPF_LD means:
 
     R0 = ntohl(*(u32 *) (((struct sk_buff *) R6)->data + src_reg + imm32))
     and R1 - R5 were scratched.
 
-Unlike classic BPF instruction set, eBPF has generic load/store operations:
+Unlike classic BPF instruction set, eBPF has generic load/store operations::
 
-BPF_MEM | <size> | BPF_STX:  *(size *) (dst_reg + off) = src_reg
-BPF_MEM | <size> | BPF_ST:   *(size *) (dst_reg + off) = imm32
-BPF_MEM | <size> | BPF_LDX:  dst_reg = *(size *) (src_reg + off)
-BPF_XADD | BPF_W  | BPF_STX: lock xadd *(u32 *)(dst_reg + off16) += src_reg
-BPF_XADD | BPF_DW | BPF_STX: lock xadd *(u64 *)(dst_reg + off16) += src_reg
+    BPF_MEM | <size> | BPF_STX:  *(size *) (dst_reg + off) = src_reg
+    BPF_MEM | <size> | BPF_ST:   *(size *) (dst_reg + off) = imm32
+    BPF_MEM | <size> | BPF_LDX:  dst_reg = *(size *) (src_reg + off)
+    BPF_XADD | BPF_W  | BPF_STX: lock xadd *(u32 *)(dst_reg + off16) += src_reg
+    BPF_XADD | BPF_DW | BPF_STX: lock xadd *(u64 *)(dst_reg + off16) += src_reg
 
 Where size is one of: BPF_B or BPF_H or BPF_W or BPF_DW. Note that 1 and
 2 byte atomic increments are not supported.
 
 eBPF has one 16-byte instruction: BPF_LD | BPF_DW | BPF_IMM which consists
-of two consecutive 'struct bpf_insn' 8-byte blocks and interpreted as single
+of two consecutive ``struct bpf_insn`` 8-byte blocks and interpreted as single
 instruction that loads 64-bit immediate value into a dst_reg.
 Classic BPF has similar instruction: BPF_LD | BPF_W | BPF_IMM which loads
 32-bit immediate value into a register.
@@ -1037,38 +1075,48 @@ since addition of two valid pointers makes invalid pointer.
 (In 'secure' mode verifier will reject any type of pointer arithmetic to make
 sure that kernel addresses don't leak to unprivileged users)
 
-If register was never written to, it's not readable:
+If register was never written to, it's not readable::
+
   bpf_mov R0 = R2
   bpf_exit
+
 will be rejected, since R2 is unreadable at the start of the program.
 
 After kernel function call, R1-R5 are reset to unreadable and
 R0 has a return type of the function.
 
 Since R6-R9 are callee saved, their state is preserved across the call.
+
+::
+
   bpf_mov R6 = 1
   bpf_call foo
   bpf_mov R0 = R6
   bpf_exit
+
 is a correct program. If there was R1 instead of R6, it would have
 been rejected.
 
 load/store instructions are allowed only with registers of valid types, which
 are PTR_TO_CTX, PTR_TO_MAP, PTR_TO_STACK. They are bounds and alignment checked.
-For example:
+For example::
+
  bpf_mov R1 = 1
  bpf_mov R2 = 2
  bpf_xadd *(u32 *)(R1 + 3) += R2
  bpf_exit
+
 will be rejected, since R1 doesn't have a valid pointer type at the time of
 execution of instruction bpf_xadd.
 
-At the start R1 type is PTR_TO_CTX (a pointer to generic 'struct bpf_context')
+At the start R1 type is PTR_TO_CTX (a pointer to generic ``struct bpf_context``)
 A callback is used to customize verifier to restrict eBPF program access to only
 certain fields within ctx structure with specified size and alignment.
 
-For example, the following insn:
+For example, the following insn::
+
   bpf_ld R0 = *(u32 *)(R6 + 8)
+
 intends to load a word from address R6 + 8 and store it into R0
 If R6=PTR_TO_CTX, via is_valid_access() callback the verifier will know
 that offset 8 of size 4 bytes can be accessed for reading, otherwise
@@ -1079,10 +1127,13 @@ so it will fail verification, since it's out of bounds.
 
 The verifier will allow eBPF program to read data from stack only after
 it wrote into it.
+
 Classic BPF verifier does similar check with M[0-15] memory slots.
-For example:
+For example::
+
   bpf_ld R0 = *(u32 *)(R10 - 4)
   bpf_exit
+
 is invalid program.
 Though R10 is correct read-only register and has type PTR_TO_STACK
 and R10 - 4 is within stack bounds, there were no stores into that location.
@@ -1113,48 +1164,61 @@ Register value tracking
 -----------------------
 In order to determine the safety of an eBPF program, the verifier must track
 the range of possible values in each register and also in each stack slot.
-This is done with 'struct bpf_reg_state', defined in include/linux/
+This is done with ``struct bpf_reg_state``, defined in include/linux/
 bpf_verifier.h, which unifies tracking of scalar and pointer values.  Each
 register state has a type, which is either NOT_INIT (the register has not been
 written to), SCALAR_VALUE (some value which is not usable as a pointer), or a
 pointer type.  The types of pointers describe their base, as follows:
-    PTR_TO_CTX          Pointer to bpf_context.
-    CONST_PTR_TO_MAP    Pointer to struct bpf_map.  "Const" because arithmetic
-                        on these pointers is forbidden.
-    PTR_TO_MAP_VALUE    Pointer to the value stored in a map element.
+
+
+    PTR_TO_CTX
+			Pointer to bpf_context.
+    CONST_PTR_TO_MAP
+			Pointer to struct bpf_map.  "Const" because arithmetic
+			on these pointers is forbidden.
+    PTR_TO_MAP_VALUE
+			Pointer to the value stored in a map element.
     PTR_TO_MAP_VALUE_OR_NULL
-                        Either a pointer to a map value, or NULL; map accesses
-                        (see section 'eBPF maps', below) return this type,
-                        which becomes a PTR_TO_MAP_VALUE when checked != NULL.
-                        Arithmetic on these pointers is forbidden.
-    PTR_TO_STACK        Frame pointer.
-    PTR_TO_PACKET       skb->data.
-    PTR_TO_PACKET_END   skb->data + headlen; arithmetic forbidden.
-    PTR_TO_SOCKET       Pointer to struct bpf_sock_ops, implicitly refcounted.
+			Either a pointer to a map value, or NULL; map accesses
+			(see section 'eBPF maps', below) return this type,
+			which becomes a PTR_TO_MAP_VALUE when checked != NULL.
+			Arithmetic on these pointers is forbidden.
+    PTR_TO_STACK
+			Frame pointer.
+    PTR_TO_PACKET
+			skb->data.
+    PTR_TO_PACKET_END
+			skb->data + headlen; arithmetic forbidden.
+    PTR_TO_SOCKET
+			Pointer to struct bpf_sock_ops, implicitly refcounted.
     PTR_TO_SOCKET_OR_NULL
-                        Either a pointer to a socket, or NULL; socket lookup
-                        returns this type, which becomes a PTR_TO_SOCKET when
-                        checked != NULL. PTR_TO_SOCKET is reference-counted,
-                        so programs must release the reference through the
-                        socket release function before the end of the program.
-                        Arithmetic on these pointers is forbidden.
+			Either a pointer to a socket, or NULL; socket lookup
+			returns this type, which becomes a PTR_TO_SOCKET when
+			checked != NULL. PTR_TO_SOCKET is reference-counted,
+			so programs must release the reference through the
+			socket release function before the end of the program.
+			Arithmetic on these pointers is forbidden.
+
 However, a pointer may be offset from this base (as a result of pointer
 arithmetic), and this is tracked in two parts: the 'fixed offset' and 'variable
 offset'.  The former is used when an exactly-known value (e.g. an immediate
 operand) is added to a pointer, while the latter is used for values which are
 not exactly known.  The variable offset is also used in SCALAR_VALUEs, to track
 the range of possible values in the register.
+
 The verifier's knowledge about the variable offset consists of:
+
 * minimum and maximum values as unsigned
 * minimum and maximum values as signed
+
 * knowledge of the values of individual bits, in the form of a 'tnum': a u64
-'mask' and a u64 'value'.  1s in the mask represent bits whose value is unknown;
-1s in the value represent bits known to be 1.  Bits known to be 0 have 0 in both
-mask and value; no bit should ever be 1 in both.  For example, if a byte is read
-into a register from memory, the register's top 56 bits are known zero, while
-the low 8 are unknown - which is represented as the tnum (0x0; 0xff).  If we
-then OR this with 0x40, we get (0x40; 0xbf), then if we add 1 we get (0x0;
-0x1ff), because of potential carries.
+  'mask' and a u64 'value'.  1s in the mask represent bits whose value is unknown;
+  1s in the value represent bits known to be 1.  Bits known to be 0 have 0 in both
+  mask and value; no bit should ever be 1 in both.  For example, if a byte is read
+  into a register from memory, the register's top 56 bits are known zero, while
+  the low 8 are unknown - which is represented as the tnum (0x0; 0xff).  If we
+  then OR this with 0x40, we get (0x40; 0xbf), then if we add 1 we get (0x0;
+  0x1ff), because of potential carries.
 
 Besides arithmetic, the register state can also be updated by conditional
 branches.  For instance, if a SCALAR_VALUE is compared > 8, in the 'true' branch
@@ -1188,7 +1252,7 @@ The 'id' field is also used on PTR_TO_SOCKET and PTR_TO_SOCKET_OR_NULL, common
 to all copies of the pointer returned from a socket lookup. This has similar
 behaviour to the handling for PTR_TO_MAP_VALUE_OR_NULL->PTR_TO_MAP_VALUE, but
 it also handles reference tracking for the pointer. PTR_TO_SOCKET implicitly
-represents a reference to the corresponding 'struct sock'. To ensure that the
+represents a reference to the corresponding ``struct sock``. To ensure that the
 reference is not leaked, it is imperative to NULL-check the reference and in
 the non-NULL case, and pass the valid reference to the socket release function.
 
@@ -1196,17 +1260,18 @@ Direct packet access
 --------------------
 In cls_bpf and act_bpf programs the verifier allows direct access to the packet
 data via skb->data and skb->data_end pointers.
-Ex:
-1:  r4 = *(u32 *)(r1 +80)  /* load skb->data_end */
-2:  r3 = *(u32 *)(r1 +76)  /* load skb->data */
-3:  r5 = r3
-4:  r5 += 14
-5:  if r5 > r4 goto pc+16
-R1=ctx R3=pkt(id=0,off=0,r=14) R4=pkt_end R5=pkt(id=0,off=14,r=14) R10=fp
-6:  r0 = *(u16 *)(r3 +12) /* access 12 and 13 bytes of the packet */
+Ex::
+
+    1:  r4 = *(u32 *)(r1 +80)  /* load skb->data_end */
+    2:  r3 = *(u32 *)(r1 +76)  /* load skb->data */
+    3:  r5 = r3
+    4:  r5 += 14
+    5:  if r5 > r4 goto pc+16
+    R1=ctx R3=pkt(id=0,off=0,r=14) R4=pkt_end R5=pkt(id=0,off=14,r=14) R10=fp
+    6:  r0 = *(u16 *)(r3 +12) /* access 12 and 13 bytes of the packet */
 
 this 2byte load from the packet is safe to do, since the program author
-did check 'if (skb->data + 14 > skb->data_end) goto err' at insn #5 which
+did check ``if (skb->data + 14 > skb->data_end) goto err`` at insn #5 which
 means that in the fall-through case the register R3 (which points to skb->data)
 has at least 14 directly accessible bytes. The verifier marks it
 as R3=pkt(id=0,off=0,r=14).
@@ -1215,52 +1280,58 @@ off=0 means that no additional constants were added.
 r=14 is the range of safe access which means that bytes [R3, R3 + 14) are ok.
 Note that R5 is marked as R5=pkt(id=0,off=14,r=14). It also points
 to the packet data, but constant 14 was added to the register, so
-it now points to 'skb->data + 14' and accessible range is [R5, R5 + 14 - 14)
+it now points to ``skb->data + 14`` and accessible range is [R5, R5 + 14 - 14)
 which is zero bytes.
 
-More complex packet access may look like:
- R0=inv1 R1=ctx R3=pkt(id=0,off=0,r=14) R4=pkt_end R5=pkt(id=0,off=14,r=14) R10=fp
- 6:  r0 = *(u8 *)(r3 +7) /* load 7th byte from the packet */
- 7:  r4 = *(u8 *)(r3 +12)
- 8:  r4 *= 14
- 9:  r3 = *(u32 *)(r1 +76) /* load skb->data */
-10:  r3 += r4
-11:  r2 = r1
-12:  r2 <<= 48
-13:  r2 >>= 48
-14:  r3 += r2
-15:  r2 = r3
-16:  r2 += 8
-17:  r1 = *(u32 *)(r1 +80) /* load skb->data_end */
-18:  if r2 > r1 goto pc+2
- R0=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R1=pkt_end R2=pkt(id=2,off=8,r=8) R3=pkt(id=2,off=0,r=8) R4=inv(id=0,umax_value=3570,var_off=(0x0; 0xfffe)) R5=pkt(id=0,off=14,r=14) R10=fp
-19:  r1 = *(u8 *)(r3 +4)
+More complex packet access may look like::
+
+
+    R0=inv1 R1=ctx R3=pkt(id=0,off=0,r=14) R4=pkt_end R5=pkt(id=0,off=14,r=14) R10=fp
+    6:  r0 = *(u8 *)(r3 +7) /* load 7th byte from the packet */
+    7:  r4 = *(u8 *)(r3 +12)
+    8:  r4 *= 14
+    9:  r3 = *(u32 *)(r1 +76) /* load skb->data */
+    10:  r3 += r4
+    11:  r2 = r1
+    12:  r2 <<= 48
+    13:  r2 >>= 48
+    14:  r3 += r2
+    15:  r2 = r3
+    16:  r2 += 8
+    17:  r1 = *(u32 *)(r1 +80) /* load skb->data_end */
+    18:  if r2 > r1 goto pc+2
+    R0=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R1=pkt_end R2=pkt(id=2,off=8,r=8) R3=pkt(id=2,off=0,r=8) R4=inv(id=0,umax_value=3570,var_off=(0x0; 0xfffe)) R5=pkt(id=0,off=14,r=14) R10=fp
+    19:  r1 = *(u8 *)(r3 +4)
+
 The state of the register R3 is R3=pkt(id=2,off=0,r=8)
-id=2 means that two 'r3 += rX' instructions were seen, so r3 points to some
+id=2 means that two ``r3 += rX`` instructions were seen, so r3 points to some
 offset within a packet and since the program author did
-'if (r3 + 8 > r1) goto err' at insn #18, the safe range is [R3, R3 + 8).
+``if (r3 + 8 > r1) goto err`` at insn #18, the safe range is [R3, R3 + 8).
 The verifier only allows 'add'/'sub' operations on packet registers. Any other
 operation will set the register state to 'SCALAR_VALUE' and it won't be
 available for direct packet access.
-Operation 'r3 += rX' may overflow and become less than original skb->data,
-therefore the verifier has to prevent that.  So when it sees 'r3 += rX'
+
+Operation ``r3 += rX`` may overflow and become less than original skb->data,
+therefore the verifier has to prevent that.  So when it sees ``r3 += rX``
 instruction and rX is more than 16-bit value, any subsequent bounds-check of r3
 against skb->data_end will not give us 'range' information, so attempts to read
 through the pointer will give "invalid access to packet" error.
-Ex. after insn 'r4 = *(u8 *)(r3 +12)' (insn #7 above) the state of r4 is
+
+Ex. after insn ``r4 = *(u8 *)(r3 +12)`` (insn #7 above) the state of r4 is
 R4=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) which means that upper 56 bits
 of the register are guaranteed to be zero, and nothing is known about the lower
-8 bits. After insn 'r4 *= 14' the state becomes
+8 bits. After insn ``r4 *= 14`` the state becomes
 R4=inv(id=0,umax_value=3570,var_off=(0x0; 0xfffe)), since multiplying an 8-bit
 value by constant 14 will keep upper 52 bits as zero, also the least significant
-bit will be zero as 14 is even.  Similarly 'r2 >>= 48' will make
+bit will be zero as 14 is even.  Similarly ``r2 >>= 48`` will make
 R2=inv(id=0,umax_value=65535,var_off=(0x0; 0xffff)), since the shift is not sign
 extending.  This logic is implemented in adjust_reg_min_max_vals() function,
 which calls adjust_ptr_min_max_vals() for adding pointer to scalar (or vice
 versa) and adjust_scalar_min_max_vals() for operations on two scalars.
 
 The end result is that bpf program author can access packet directly
-using normal C code as:
+using normal C code as::
+
   void *data = (void *)(long)skb->data;
   void *data_end = (void *)(long)skb->data_end;
   struct eth_hdr *eth = data;
@@ -1268,13 +1339,14 @@ using normal C code as:
   struct udphdr *udp = data + sizeof(*eth) + sizeof(*iph);
 
   if (data + sizeof(*eth) + sizeof(*iph) + sizeof(*udp) > data_end)
-          return 0;
+	  return 0;
   if (eth->h_proto != htons(ETH_P_IP))
-          return 0;
+	  return 0;
   if (iph->protocol != IPPROTO_UDP || iph->ihl != 5)
-          return 0;
+	  return 0;
   if (udp->dest == 53 || udp->source == 9)
-          ...;
+	  ...;
+
 which makes such programs easier to write comparing to LD_ABS insn
 and significantly faster.
 
@@ -1284,23 +1356,24 @@ eBPF maps
 and userspace.
 
 The maps are accessed from user space via BPF syscall, which has commands:
+
 - create a map with given type and attributes
-  map_fd = bpf(BPF_MAP_CREATE, union bpf_attr *attr, u32 size)
+  ``map_fd = bpf(BPF_MAP_CREATE, union bpf_attr *attr, u32 size)``
   using attr->map_type, attr->key_size, attr->value_size, attr->max_entries
   returns process-local file descriptor or negative error
 
 - lookup key in a given map
-  err = bpf(BPF_MAP_LOOKUP_ELEM, union bpf_attr *attr, u32 size)
+  ``err = bpf(BPF_MAP_LOOKUP_ELEM, union bpf_attr *attr, u32 size)``
   using attr->map_fd, attr->key, attr->value
   returns zero and stores found elem into value or negative error
 
 - create or update key/value pair in a given map
-  err = bpf(BPF_MAP_UPDATE_ELEM, union bpf_attr *attr, u32 size)
+  ``err = bpf(BPF_MAP_UPDATE_ELEM, union bpf_attr *attr, u32 size)``
   using attr->map_fd, attr->key, attr->value
   returns zero or negative error
 
 - find and delete element by key in a given map
-  err = bpf(BPF_MAP_DELETE_ELEM, union bpf_attr *attr, u32 size)
+  ``err = bpf(BPF_MAP_DELETE_ELEM, union bpf_attr *attr, u32 size)``
   using attr->map_fd, attr->key
 
 - to delete map: close(fd)
@@ -1312,10 +1385,11 @@ are concurrently updating.
 maps can have different types: hash, array, bloom filter, radix-tree, etc.
 
 The map is defined by:
-  . type
-  . max number of elements
-  . key size in bytes
-  . value size in bytes
+
+  - type
+  - max number of elements
+  - key size in bytes
+  - value size in bytes
 
 Pruning
 -------
@@ -1339,57 +1413,75 @@ Understanding eBPF verifier messages
 The following are few examples of invalid eBPF programs and verifier error
 messages as seen in the log:
 
-Program with unreachable instructions:
-static struct bpf_insn prog[] = {
+Program with unreachable instructions::
+
+  static struct bpf_insn prog[] = {
   BPF_EXIT_INSN(),
   BPF_EXIT_INSN(),
-};
+  };
+
 Error:
+
   unreachable insn 1
 
-Program that reads uninitialized register:
+Program that reads uninitialized register::
+
   BPF_MOV64_REG(BPF_REG_0, BPF_REG_2),
   BPF_EXIT_INSN(),
-Error:
+
+Error::
+
   0: (bf) r0 = r2
   R2 !read_ok
 
-Program that doesn't initialize R0 before exiting:
+Program that doesn't initialize R0 before exiting::
+
   BPF_MOV64_REG(BPF_REG_2, BPF_REG_1),
   BPF_EXIT_INSN(),
-Error:
+
+Error::
+
   0: (bf) r2 = r1
   1: (95) exit
   R0 !read_ok
 
-Program that accesses stack out of bounds:
-  BPF_ST_MEM(BPF_DW, BPF_REG_10, 8, 0),
-  BPF_EXIT_INSN(),
-Error:
-  0: (7a) *(u64 *)(r10 +8) = 0
-  invalid stack off=8 size=8
-
-Program that doesn't initialize stack before passing its address into function:
+Program that accesses stack out of bounds::
+
+    BPF_ST_MEM(BPF_DW, BPF_REG_10, 8, 0),
+    BPF_EXIT_INSN(),
+
+Error::
+
+    0: (7a) *(u64 *)(r10 +8) = 0
+    invalid stack off=8 size=8
+
+Program that doesn't initialize stack before passing its address into function::
+
   BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
   BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
   BPF_LD_MAP_FD(BPF_REG_1, 0),
   BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
   BPF_EXIT_INSN(),
-Error:
+
+Error::
+
   0: (bf) r2 = r10
   1: (07) r2 += -8
   2: (b7) r1 = 0x0
   3: (85) call 1
   invalid indirect read from stack off -8+0 size 8
 
-Program that uses invalid map_fd=0 while calling to map_lookup_elem() function:
+Program that uses invalid map_fd=0 while calling to map_lookup_elem() function::
+
   BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
   BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
   BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
   BPF_LD_MAP_FD(BPF_REG_1, 0),
   BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
   BPF_EXIT_INSN(),
-Error:
+
+Error::
+
   0: (7a) *(u64 *)(r10 -8) = 0
   1: (bf) r2 = r10
   2: (07) r2 += -8
@@ -1398,7 +1490,8 @@ Error:
   fd 0 is not pointing to valid bpf_map
 
 Program that doesn't check return value of map_lookup_elem() before accessing
-map element:
+map element::
+
   BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
   BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
   BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
@@ -1406,7 +1499,9 @@ map element:
   BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
   BPF_ST_MEM(BPF_DW, BPF_REG_0, 0, 0),
   BPF_EXIT_INSN(),
-Error:
+
+Error::
+
   0: (7a) *(u64 *)(r10 -8) = 0
   1: (bf) r2 = r10
   2: (07) r2 += -8
@@ -1416,7 +1511,8 @@ Error:
   R0 invalid mem access 'map_value_or_null'
 
 Program that correctly checks map_lookup_elem() returned value for NULL, but
-accesses the memory with incorrect alignment:
+accesses the memory with incorrect alignment::
+
   BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
   BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
   BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
@@ -1425,7 +1521,9 @@ accesses the memory with incorrect alignment:
   BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 1),
   BPF_ST_MEM(BPF_DW, BPF_REG_0, 4, 0),
   BPF_EXIT_INSN(),
-Error:
+
+Error::
+
   0: (7a) *(u64 *)(r10 -8) = 0
   1: (bf) r2 = r10
   2: (07) r2 += -8
@@ -1438,7 +1536,8 @@ Error:
 
 Program that correctly checks map_lookup_elem() returned value for NULL and
 accesses memory with correct alignment in one side of 'if' branch, but fails
-to do so in the other side of 'if' branch:
+to do so in the other side of 'if' branch::
+
   BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
   BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
   BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
@@ -1449,7 +1548,9 @@ to do so in the other side of 'if' branch:
   BPF_EXIT_INSN(),
   BPF_ST_MEM(BPF_DW, BPF_REG_0, 0, 1),
   BPF_EXIT_INSN(),
-Error:
+
+Error::
+
   0: (7a) *(u64 *)(r10 -8) = 0
   1: (bf) r2 = r10
   2: (07) r2 += -8
@@ -1465,8 +1566,8 @@ Error:
   R0 invalid mem access 'imm'
 
 Program that performs a socket lookup then sets the pointer to NULL without
-checking it:
-value:
+checking it::
+
   BPF_MOV64_IMM(BPF_REG_2, 0),
   BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_2, -8),
   BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
@@ -1477,7 +1578,9 @@ value:
   BPF_EMIT_CALL(BPF_FUNC_sk_lookup_tcp),
   BPF_MOV64_IMM(BPF_REG_0, 0),
   BPF_EXIT_INSN(),
-Error:
+
+Error::
+
   0: (b7) r2 = 0
   1: (63) *(u32 *)(r10 -8) = r2
   2: (bf) r2 = r10
@@ -1491,7 +1594,8 @@ Error:
   Unreleased reference id=1, alloc_insn=7
 
 Program that performs a socket lookup but does not NULL-check the returned
-value:
+value::
+
   BPF_MOV64_IMM(BPF_REG_2, 0),
   BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_2, -8),
   BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
@@ -1501,7 +1605,9 @@ value:
   BPF_MOV64_IMM(BPF_REG_5, 0),
   BPF_EMIT_CALL(BPF_FUNC_sk_lookup_tcp),
   BPF_EXIT_INSN(),
-Error:
+
+Error::
+
   0: (b7) r2 = 0
   1: (63) *(u32 *)(r10 -8) = r2
   2: (bf) r2 = r10
@@ -1519,7 +1625,7 @@ Testing
 Next to the BPF toolchain, the kernel also ships a test module that contains
 various test cases for classic and internal BPF that can be executed against
 the BPF interpreter and JIT compiler. It can be found in lib/test_bpf.c and
-enabled via Kconfig:
+enabled via Kconfig::
 
   CONFIG_TEST_BPF=m
 
@@ -1540,6 +1646,6 @@ The document was written in the hope that it is found useful and in order
 to give potential BPF hackers or security auditors a better overview of
 the underlying architecture.
 
-Jay Schulist <jschlst@samba.org>
-Daniel Borkmann <daniel@iogearbox.net>
-Alexei Starovoitov <ast@kernel.org>
+- Jay Schulist <jschlst@samba.org>
+- Daniel Borkmann <daniel@iogearbox.net>
+- Alexei Starovoitov <ast@kernel.org>
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 5f0ab638ef3f..73b573739f67 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -54,6 +54,7 @@ Contents:
    driver
    eql
    fib_trie
+   filter
 
 .. only::  subproject and html
 
-- 
2.24.1

