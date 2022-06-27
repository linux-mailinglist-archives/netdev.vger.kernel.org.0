Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5AF55B656
	for <lists+netdev@lfdr.de>; Mon, 27 Jun 2022 06:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiF0E6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 00:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiF0E6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 00:58:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD342279;
        Sun, 26 Jun 2022 21:58:41 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25R4qKpX030613;
        Mon, 27 Jun 2022 04:58:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : content-type :
 mime-version : subject : message-id : date : cc : to; s=pp1;
 bh=YybAODg02ZY73wWUicqcE1waJinYP2M0+smaxWA4Z+I=;
 b=Q50iIrIh8mGNpfQrASVu7MMDp2ARVWI4y0u17dseO9ZeqKBnQAmUli9rkXwiRtu1UHN9
 oYt2MUtFOg2tsa4bsPy5S/dcJHwCvI5R47qXypsXF/0cntTQh53IEp4VfVS3Xzo+3w9C
 PLdHln6VVxD0fynIcVfLkSTg3n3Z8cPxznjc9mHB2RsSiqtXMYBVqffX4gYNNOm5eSKc
 6yDe5Ll0My+iO69Bl5ANtr+WPzPJ3kxNHBRmaaM0r1rzIdAvqjekgC2rYJtHJKwg+slz
 oD5pl4X2oGm48ZEonUN2gPfcYrxf4wBQYOqPlu51aNmGvMG6qpENHL9W4nO0CBBGx+2t iQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gy5wb0552-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 04:58:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25R4og4r019436;
        Mon, 27 Jun 2022 04:58:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3gwt08t9g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 04:58:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25R4wTrv24183042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 04:58:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8CFE4C04E;
        Mon, 27 Jun 2022 04:58:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58D384C040;
        Mon, 27 Jun 2022 04:58:28 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.43.22.237])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 04:58:28 +0000 (GMT)
From:   Sachin Sant <sachinp@linux.ibm.com>
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_8547D5DE-EAFC-457B-A44F-4A6EC667A4CA"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: [powerpc] Fingerprint systemd service fails to start (next-20220624)
Message-Id: <B2AA3091-796D-475E-9A11-0021996E1C00@linux.ibm.com>
Date:   Mon, 27 Jun 2022 10:28:27 +0530
Cc:     linuxppc-dev@lists.ozlabs.org, davem@davemloft.net,
        linux-next@vger.kernel.org
To:     netdev@vger.kernel.org, kuniyu@amazon.com
X-Mailer: Apple Mail (2.3696.100.31)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sZd_glfW7zZrb-e2mgeV7s5R2EIn-d7X
X-Proofpoint-ORIG-GUID: sZd_glfW7zZrb-e2mgeV7s5R2EIn-d7X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_02,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 clxscore=1011 impostorscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 mlxscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270020
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Apple-Mail=_8547D5DE-EAFC-457B-A44F-4A6EC667A4CA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

With the latest -next I have observed a peculiar issue on IBM Power
server running -next(5.19.0-rc3-next-20220624) .

Fingerprint authentication systemd service (fprintd) fails to start =
while
attempting OS login after kernel boot. There is a visible delay of 18-20
seconds before being prompted for OS login password.

Kernel 5.19.0-rc3-next-20220624 on an ppc64le

ltcden8-lp6 login: root
<<=3D=3D=3D=3D=3D=3D=3D.  delay of 18-20 seconds
Password:=20

Following messages(fprintd service) are seen in /var/log/messages:

systemd[1]: Startup finished in 1.842s (kernel) + 1.466s (initrd) + =
29.230s (userspace) =3D 32.540s.
NetworkManager[1100]: <info>  [1656304146.6686] manager: startup =
complete
dbus-daemon[1027]: [system] Activating via systemd: service =
name=3D'net.reactivated.Fprint' unit=3D'fprintd.service' requested by =
':1.21' (uid=3D0 pid=3D1502 comm=3D"/bin/login -p --      ")
systemd[1]: Starting Fingerprint Authentication Daemon...
fprintd[2521]: (fprintd:2521): fprintd-WARNING **: 00:29:08.568: Failed =
to open connection to bus: Could not connect: Connection refused
systemd[1]: fprintd.service: Main process exited, code=3Dexited, =
status=3D1/FAILURE
systemd[1]: fprintd.service: Failed with result 'exit-code'.
systemd[1]: Failed to start Fingerprint Authentication Daemon.
dbus-daemon[1027]: [system] Failed to activate service =
'net.reactivated.Fprint': timed out (service_start_timeout=3D25000ms)

Mainline (5.19.0-rc3) or older -next does not have this problem.

Git bisect between mainline & -next points to the following patch:

# git bisect bad
cf2f225e2653734e66e91c09e1cbe004bfd3d4a7 is the first bad commit
commit cf2f225e2653734e66e91c09e1cbe004bfd3d4a7

Date:   Tue Jun 21 10:19:12 2022 -0700

    af_unix: Put a socket into a per-netns hash table.

I don=E2=80=99t know how the above identified patch is related to the =
failure,
but given that I can consistently recreate the issue assume the bisect
result can be trusted.

I have attached dmesg log for reference. Let me know if any additional
Information is required.

Thanks
- Sachin


--Apple-Mail=_8547D5DE-EAFC-457B-A44F-4A6EC667A4CA
Content-Disposition: attachment;
	filename=dmesg-next-20220624.log
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="dmesg-next-20220624.log"
Content-Transfer-Encoding: 7bit

[    0.000000] crashkernel: memory value expected
[    0.000000] radix-mmu: Page sizes from device-tree:
[    0.000000] radix-mmu: Page size shift = 12 AP=0x0
[    0.000000] radix-mmu: Page size shift = 16 AP=0x5
[    0.000000] radix-mmu: Page size shift = 21 AP=0x1
[    0.000000] radix-mmu: Page size shift = 30 AP=0x2
[    0.000000] Activating Kernel Userspace Access Prevention
[    0.000000] Activating Kernel Userspace Execution Prevention
[    0.000000] radix-mmu: Mapped 0x0000000000000000-0x0000000002600000 with 2.00 MiB pages (exec)
[    0.000000] radix-mmu: Mapped 0x0000000002600000-0x0000000f00000000 with 2.00 MiB pages
[    0.000000] lpar: Using radix MMU under hypervisor
[    0.000000] Linux version 5.19.0-rc3-next-20220624 (root@ltcden8-lp6.aus.stglabs.ibm.com) (gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-13), GNU ld version 2.30-114.el8) #1 SMP Sun Jun 26 07:08:27 EDT 2022
[    0.000000] Found initrd at 0xc000000011400000:0xc00000001464d6b3
[    0.000000] Using pSeries machine description
[    0.000000] printk: bootconsole [udbg0] enabled
[    0.000000] Partition configured for 128 cpus.
[    0.000000] CPU maps initialized for 8 threads per core
[    0.000000]  (thread shift is 3)
[    0.000000] Allocated 4352 bytes for 128 pacas
[    0.000000] numa: Partition configured for 32 NUMA nodes.
[    0.000000] -----------------------------------------------------
[    0.000000] phys_mem_size     = 0xf00000000
[    0.000000] dcache_bsize      = 0x80
[    0.000000] icache_bsize      = 0x80
[    0.000000] cpu_features      = 0x000c00eb8f5f9187
[    0.000000]   possible        = 0x000ffbfbcf5fb187
[    0.000000]   always          = 0x0000000380008181
[    0.000000] cpu_user_features = 0xdc0065c2 0xaef60000
[    0.000000] mmu_features      = 0x3c007641
[    0.000000] firmware_features = 0x0000019fc45bfc57
[    0.000000] vmalloc start     = 0xc008000000000000
[    0.000000] IO start          = 0xc00a000000000000
[    0.000000] vmemmap start     = 0xc00c000000000000
[    0.000000] -----------------------------------------------------
[    0.000000] numa:   NODE_DATA [mem 0xeff318480-0xeff31fbff]
[    0.000000] rfi-flush: fallback displacement flush available
[    0.000000] rfi-flush: patched 12 locations (no flush)
[    0.000000] count-cache-flush: hardware flush enabled.
[    0.000000] link-stack-flush: software flush enabled.
[    0.000000] entry-flush: patched 61 locations (no flush)
[    0.000000] uaccess-flush: patched 1 locations (no flush)
[    0.000000] stf-barrier: eieio barrier available
[    0.000000] stf-barrier: patched 61 entry locations (no barrier)
[    0.000000] stf-barrier: patched 12 exit locations (no barrier)
[    0.000000] lpar: H_BLOCK_REMOVE supports base psize:0 psize:0 block size:8
[    0.000000] PPC64 nvram contains 15360 bytes
[    0.000000] barrier-nospec: using ORI speculation barrier
[    0.000000] barrier-nospec: patched 275 locations
[    0.000000] Top of RAM: 0xf00000000, Total RAM: 0xf00000000
[    0.000000] Memory hole size: 0MB
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x0000000effffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   3: [mem 0x0000000000000000-0x0000000effffffff]
[    0.000000] Initializing node 0 as memoryless
[    0.000000] Initmem setup node 0 as memoryless
[    0.000000] Initializing node 1 as memoryless
[    0.000000] Initmem setup node 1 as memoryless
[    0.000000] Initializing node 2 as memoryless
[    0.000000] Initmem setup node 2 as memoryless
[    0.000000] Initmem setup node 3 [mem 0x0000000000000000-0x0000000effffffff]
[    0.000000] Initializing node 4 as memoryless
[    0.000000] Initmem setup node 4 as memoryless
[    0.000000] Initializing node 5 as memoryless
[    0.000000] Initmem setup node 5 as memoryless
[    0.000000] Initializing node 6 as memoryless
[    0.000000] Initmem setup node 6 as memoryless
[    0.000000] Initializing node 7 as memoryless
[    0.000000] Initmem setup node 7 as memoryless
[    0.000000] Initializing node 8 as memoryless
[    0.000000] Initmem setup node 8 as memoryless
[    0.000000] Initializing node 9 as memoryless
[    0.000000] Initmem setup node 9 as memoryless
[    0.000000] Initializing node 10 as memoryless
[    0.000000] Initmem setup node 10 as memoryless
[    0.000000] Initializing node 11 as memoryless
[    0.000000] Initmem setup node 11 as memoryless
[    0.000000] Initializing node 12 as memoryless
[    0.000000] Initmem setup node 12 as memoryless
[    0.000000] Initializing node 13 as memoryless
[    0.000000] Initmem setup node 13 as memoryless
[    0.000000] Initializing node 14 as memoryless
[    0.000000] Initmem setup node 14 as memoryless
[    0.000000] Initializing node 15 as memoryless
[    0.000000] Initmem setup node 15 as memoryless
[    0.000000] Initializing node 16 as memoryless
[    0.000000] Initmem setup node 16 as memoryless
[    0.000000] Initializing node 17 as memoryless
[    0.000000] Initmem setup node 17 as memoryless
[    0.000000] Initializing node 18 as memoryless
[    0.000000] Initmem setup node 18 as memoryless
[    0.000000] Initializing node 19 as memoryless
[    0.000000] Initmem setup node 19 as memoryless
[    0.000000] Initializing node 20 as memoryless
[    0.000000] Initmem setup node 20 as memoryless
[    0.000000] Initializing node 21 as memoryless
[    0.000000] Initmem setup node 21 as memoryless
[    0.000000] Initializing node 22 as memoryless
[    0.000000] Initmem setup node 22 as memoryless
[    0.000000] Initializing node 23 as memoryless
[    0.000000] Initmem setup node 23 as memoryless
[    0.000000] Initializing node 24 as memoryless
[    0.000000] Initmem setup node 24 as memoryless
[    0.000000] Initializing node 25 as memoryless
[    0.000000] Initmem setup node 25 as memoryless
[    0.000000] Initializing node 26 as memoryless
[    0.000000] Initmem setup node 26 as memoryless
[    0.000000] Initializing node 27 as memoryless
[    0.000000] Initmem setup node 27 as memoryless
[    0.000000] Initializing node 28 as memoryless
[    0.000000] Initmem setup node 28 as memoryless
[    0.000000] Initializing node 29 as memoryless
[    0.000000] Initmem setup node 29 as memoryless
[    0.000000] Initializing node 30 as memoryless
[    0.000000] Initmem setup node 30 as memoryless
[    0.000000] Initializing node 31 as memoryless
[    0.000000] Initmem setup node 31 as memoryless
[    0.000000] percpu: cpu 32 has no node 0 or node-local memory
[    0.000000] percpu: Embedded 10 pages/cpu s600360 r0 d55000 u655360
[    0.000000] pcpu-alloc: s600360 r0 d55000 u655360 alloc=10*65536
[    0.000000] pcpu-alloc: [0] 000 [0] 001 [0] 002 [0] 003 
[    0.000000] pcpu-alloc: [0] 004 [0] 005 [0] 006 [0] 007 
[    0.000000] pcpu-alloc: [0] 008 [0] 009 [0] 010 [0] 011 
[    0.000000] pcpu-alloc: [0] 012 [0] 013 [0] 014 [0] 015 
[    0.000000] pcpu-alloc: [0] 016 [0] 017 [0] 018 [0] 019 
[    0.000000] pcpu-alloc: [0] 020 [0] 021 [0] 022 [0] 023 
[    0.000000] pcpu-alloc: [0] 024 [0] 025 [0] 026 [0] 027 
[    0.000000] pcpu-alloc: [0] 028 [0] 029 [0] 030 [0] 031 
[    0.000000] pcpu-alloc: [1] 032 [1] 033 [1] 034 [1] 035 
[    0.000000] pcpu-alloc: [1] 036 [1] 037 [1] 038 [1] 039 
[    0.000000] pcpu-alloc: [1] 040 [1] 041 [1] 042 [1] 043 
[    0.000000] pcpu-alloc: [1] 044 [1] 045 [1] 046 [1] 047 
[    0.000000] pcpu-alloc: [1] 048 [1] 049 [1] 050 [1] 051 
[    0.000000] pcpu-alloc: [1] 052 [1] 053 [1] 054 [1] 055 
[    0.000000] pcpu-alloc: [1] 056 [1] 057 [1] 058 [1] 059 
[    0.000000] pcpu-alloc: [1] 060 [1] 061 [1] 062 [1] 063 
[    0.000000] pcpu-alloc: [1] 064 [1] 065 [1] 066 [1] 067 
[    0.000000] pcpu-alloc: [1] 068 [1] 069 [1] 070 [1] 071 
[    0.000000] pcpu-alloc: [1] 072 [1] 073 [1] 074 [1] 075 
[    0.000000] pcpu-alloc: [1] 076 [1] 077 [1] 078 [1] 079 
[    0.000000] pcpu-alloc: [1] 080 [1] 081 [1] 082 [1] 083 
[    0.000000] pcpu-alloc: [1] 084 [1] 085 [1] 086 [1] 087 
[    0.000000] pcpu-alloc: [1] 088 [1] 089 [1] 090 [1] 091 
[    0.000000] pcpu-alloc: [1] 092 [1] 093 [1] 094 [1] 095 
[    0.000000] pcpu-alloc: [1] 096 [1] 097 [1] 098 [1] 099 
[    0.000000] pcpu-alloc: [1] 100 [1] 101 [1] 102 [1] 103 
[    0.000000] pcpu-alloc: [1] 104 [1] 105 [1] 106 [1] 107 
[    0.000000] pcpu-alloc: [1] 108 [1] 109 [1] 110 [1] 111 
[    0.000000] pcpu-alloc: [1] 112 [1] 113 [1] 114 [1] 115 
[    0.000000] pcpu-alloc: [1] 116 [1] 117 [1] 118 [1] 119 
[    0.000000] pcpu-alloc: [1] 120 [1] 121 [1] 122 [1] 123 
[    0.000000] pcpu-alloc: [1] 124 [1] 125 [1] 126 [1] 127 
[    0.000000] Fallback order for Node 0: 0 3 
[    0.000000] Fallback order for Node 1: 1 3 
[    0.000000] Fallback order for Node 2: 2 3 
[    0.000000] Fallback order for Node 3: 3 
[    0.000000] Fallback order for Node 4: 4 3 
[    0.000000] Fallback order for Node 5: 5 3 
[    0.000000] Fallback order for Node 6: 6 3 
[    0.000000] Fallback order for Node 7: 7 3 
[    0.000000] Fallback order for Node 8: 8 3 
[    0.000000] Fallback order for Node 9: 9 3 
[    0.000000] Fallback order for Node 10: 10 3 
[    0.000000] Fallback order for Node 11: 11 3 
[    0.000000] Fallback order for Node 12: 12 3 
[    0.000000] Fallback order for Node 13: 13 3 
[    0.000000] Fallback order for Node 14: 14 3 
[    0.000000] Fallback order for Node 15: 15 3 
[    0.000000] Fallback order for Node 16: 16 3 
[    0.000000] Fallback order for Node 17: 17 3 
[    0.000000] Fallback order for Node 18: 18 3 
[    0.000000] Fallback order for Node 19: 19 3 
[    0.000000] Fallback order for Node 20: 20 3 
[    0.000000] Fallback order for Node 21: 21 3 
[    0.000000] Fallback order for Node 22: 22 3 
[    0.000000] Fallback order for Node 23: 23 3 
[    0.000000] Fallback order for Node 24: 24 3 
[    0.000000] Fallback order for Node 25: 25 3 
[    0.000000] Fallback order for Node 26: 26 3 
[    0.000000] Fallback order for Node 27: 27 3 
[    0.000000] Fallback order for Node 28: 28 3 
[    0.000000] Fallback order for Node 29: 29 3 
[    0.000000] Fallback order for Node 30: 30 3 
[    0.000000] Fallback order for Node 31: 31 3 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 982080
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-5.19.0-rc3-next-20220624 root=UUID=9ee07e5c-c0f8-432c-b7b1-ad9124f4dfaa ro selinux=0 crashkernel=auto biosdevname=0
[    0.000000] Unknown kernel command line parameters "BOOT_IMAGE=/boot/vmlinuz-5.19.0-rc3-next-20220624 biosdevname=0", will be passed to user space.
[    0.000000] Dentry cache hash table entries: 8388608 (order: 10, 67108864 bytes, linear)
[    0.000000] Inode-cache hash table entries: 4194304 (order: 9, 33554432 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 62520000K/62914560K available (15104K kernel code, 5696K rwdata, 4672K rodata, 5568K init, 2750K bss, 394560K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=128, Nodes=32
[    0.000000] ftrace: allocating 38175 entries in 14 pages
[    0.000000] ftrace: allocated 14 pages with 3 groups
[    0.000000] trace event string verifier disabled
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu: 	RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=128.
[    0.000000] 	Rude variant of Tasks RCU enabled.
[    0.000000] 	Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=128
[    0.000000] NR_IRQS: 512, nr_irqs: 512, preallocated irqs: 16
[    0.000000] xive: Using IRQ range [400000-40007f]
[    0.000000] xive: Interrupt handling initialized with spapr backend
[    0.000000] xive: Using priority 7 for all interrupts
[    0.000000] xive: Using 64kB queues
[    0.000000] rcu: srcu_init: Setting srcu_struct sizes to big.
[    0.000000] time_init: decrementer frequency = 512.000000 MHz
[    0.000000] time_init: processor frequency   = 3450.000000 MHz
[    0.000001] time_init: 56 bit decrementer (max: 7fffffffffffff)
[    0.000014] clocksource: timebase: mask: 0xffffffffffffffff max_cycles: 0x761537d007, max_idle_ns: 440795202126 ns
[    0.000037] clocksource: timebase mult[1f40000] shift[24] registered
[    0.000055] clockevent: decrementer mult[83126f] shift[24] cpu[0]
[    0.000091] random: crng init done
[    0.000169] Console: colour dummy device 80x25
[    0.000182] printk: console [hvc0] enabled
[    0.000193] printk: bootconsole [udbg0] disabled
[    0.000264] pid_max: default: 131072 minimum: 1024
[    0.000379] LSM: Security Framework initializing
[    0.000409] Yama: becoming mindful.
[    0.000423] LSM support for eBPF active
[    0.000541] Mount-cache hash table entries: 131072 (order: 4, 1048576 bytes, linear)
[    0.000606] Mountpoint-cache hash table entries: 131072 (order: 4, 1048576 bytes, linear)
[    0.001871] cblist_init_generic: Setting adjustable number of callback queues.
[    0.001889] cblist_init_generic: Setting shift to 7 and lim to 1.
[    0.001916] cblist_init_generic: Setting shift to 7 and lim to 1.
[    0.001934] POWER10 performance monitor hardware support registered
[    0.001962] rcu: Hierarchical SRCU implementation.
[    0.003221] smp: Bringing up secondary CPUs ...
[    0.010771] smp: Brought up 1 node, 32 CPUs
[    0.010784] numa: Node 3 CPUs: 0-31
[    0.010788] Big cores detected but using small core scheduling
[    0.013468] devtmpfs: initialized
[    0.015762] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.015770] futex hash table entries: 32768 (order: 6, 4194304 bytes, linear)
[    0.016367] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.016515] audit: initializing netlink subsys (disabled)
[    0.016569] audit: type=2000 audit(1656304110.010:1): state=initialized audit_enabled=0 res=1
[    0.016630] thermal_sys: Registered thermal governor 'fair_share'
[    0.016631] thermal_sys: Registered thermal governor 'step_wise'
[    0.016682] cpuidle: using governor menu
[    0.016752] RTAS daemon started
[    0.016997] pstore: Registered nvram as persistent store backend
[    0.017367] EEH: pSeries platform initialized
[    0.021617] PCI: Probing PCI hardware
[    0.021622] EEH: No capable adapters found: recovery disabled.
[    0.021624] PCI: Probing PCI hardware done
[    0.022560] kprobes: kprobe jump-optimization is enabled. All kprobes are optimized if possible.
[    0.022758] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.022763] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.023202] cryptd: max_cpu_qlen set to 1000
[    0.023558] iommu: Default domain type: Translated 
[    0.023562] iommu: DMA domain TLB invalidation policy: strict mode 
[    0.023705] SCSI subsystem initialized
[    0.023734] usbcore: registered new interface driver usbfs
[    0.023743] usbcore: registered new interface driver hub
[    0.023767] usbcore: registered new device driver usb
[    0.023788] pps_core: LinuxPPS API ver. 1 registered
[    0.023791] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.023796] PTP clock support registered
[    0.023877] EDAC MC: Ver: 3.0.0
[    0.024063] NetLabel: Initializing
[    0.024066] NetLabel:  domain hash size = 128
[    0.024068] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.024083] NetLabel:  unlabeled traffic allowed by default
[    0.024136] vgaarb: loaded
[    0.027291] clocksource: Switched to clocksource timebase
[    0.027634] VFS: Disk quotas dquot_6.6.0
[    0.027676] VFS: Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
[    0.029162] NET: Registered PF_INET protocol family
[    0.029333] IP idents hash table entries: 262144 (order: 5, 2097152 bytes, linear)
[    0.032594] tcp_listen_portaddr_hash hash table entries: 32768 (order: 3, 524288 bytes, linear)
[    0.032658] Table-perturb hash table entries: 65536 (order: 2, 262144 bytes, linear)
[    0.032673] TCP established hash table entries: 524288 (order: 6, 4194304 bytes, linear)
[    0.033561] TCP bind hash table entries: 65536 (order: 4, 1048576 bytes, linear)
[    0.033647] TCP: Hash tables configured (established 524288 bind 65536)
[    0.033964] MPTCP token hash table entries: 65536 (order: 4, 1572864 bytes, linear)
[    0.034083] UDP hash table entries: 32768 (order: 4, 1048576 bytes, linear)
[    0.034186] UDP-Lite hash table entries: 32768 (order: 4, 1048576 bytes, linear)
[    0.034448] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.034457] NET: Registered PF_XDP protocol family
[    0.034467] PCI: CLS 0 bytes, default 128
[    0.034592] Trying to unpack rootfs image as initramfs...
[    0.035318] IOMMU table initialized, virtual merging enabled
[    0.043223] vio_register_device_node: node lid missing 'reg'
[    0.043328] vas: GZIP feature is available
[    0.043967] hv-24x7: read 548 catalog entries, created 387 event attrs (0 failures), 387 descs
[    0.046219] Initialise system trusted keyrings
[    0.046268] workingset: timestamp_bits=38 max_order=20 bucket_order=0
[    0.047260] zbud: loaded
[    0.056777] NET: Registered PF_ALG protocol family
[    0.056782] xor: measuring software checksum speed
[    0.057161]    8regs           : 26126 MB/sec
[    0.057651]    8regs_prefetch  : 20800 MB/sec
[    0.058027]    32regs          : 26359 MB/sec
[    0.058458]    32regs_prefetch : 22904 MB/sec
[    0.058706]    altivec         : 40176 MB/sec
[    0.058708] xor: using function: altivec (40176 MB/sec)
[    0.058712] Key type asymmetric registered
[    0.058714] Asymmetric key parser 'x509' registered
[    0.591577] Freeing initrd memory: 51456K
[    0.593904] alg: self-tests for CTR-KDF (hmac(sha256)) passed
[    0.593950] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
[    0.594007] io scheduler mq-deadline registered
[    0.594010] io scheduler kyber registered
[    0.594043] io scheduler bfq registered
[    0.595311] atomic64_test: passed
[    0.595619] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    0.595622] PowerPC PowerNV PCI Hotplug Driver version: 0.1
[    0.595869] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.596177] tpm_ibmvtpm 30000003: CRQ initialization completed
[    1.601584] rdac: device handler registered
[    1.601628] hp_sw: device handler registered
[    1.601631] emc: device handler registered
[    1.601682] alua: device handler registered
[    1.601770] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.601777] ehci-pci: EHCI PCI platform driver
[    1.601783] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.601789] ohci-pci: OHCI PCI platform driver
[    1.601794] uhci_hcd: USB Universal Host Controller Interface driver
[    1.601847] usbcore: registered new interface driver usbserial_generic
[    1.601853] usbserial: USB Serial support registered for generic
[    1.601876] mousedev: PS/2 mouse device common for all mice
[    1.601929] rtc-generic rtc-generic: registered as rtc0
[    1.601949] rtc-generic rtc-generic: setting system clock to 2022-06-27T04:28:32 UTC (1656304112)
[    1.602014] xcede: xcede_record_size = 10
[    1.602016] xcede: Record 0 : hint = 1, latency = 0x1800 tb ticks, Wake-on-irq = 1
[    1.602019] xcede: Record 1 : hint = 2, latency = 0x3c00 tb ticks, Wake-on-irq = 0
[    1.602022] cpuidle: Skipping the 2 Extended CEDE idle states
[    1.602025] cpuidle: Fixed up CEDE exit latency to 12 us
[    1.602825] pseries_idle_driver registered
[    1.602853] nx_compress_pseries ibm,compression-v1: nx842_OF_upd: max_sync_size new:65536 old:0
[    1.602857] nx_compress_pseries ibm,compression-v1: nx842_OF_upd: max_sync_sg new:510 old:0
[    1.602860] nx_compress_pseries ibm,compression-v1: nx842_OF_upd: max_sg_len new:4080 old:0
[    1.602915] hid: raw HID events driver (C) Jiri Kosina
[    1.602940] usbcore: registered new interface driver usbhid
[    1.602942] usbhid: USB HID core driver
[    1.602964] drop_monitor: Initializing network drop monitor service
[    1.603024] Initializing XFRM netlink socket
[    1.603118] NET: Registered PF_INET6 protocol family
[    1.603503] Segment Routing with IPv6
[    1.603509] In-situ OAM (IOAM) with IPv6
[    1.603524] NET: Registered PF_PACKET protocol family
[    1.603545] mpls_gso: MPLS GSO support
[    1.603576] secvar-sysfs: secvar: failed to retrieve secvar operations.
[    1.603591] Running feature fixup self-tests ...
[    1.603596] Running MSI bitmap self-tests ...
[    1.604360] registered taskstats version 1
[    1.604886] Loading compiled-in X.509 certificates
[    1.629328] Loaded X.509 cert 'Build time autogenerated kernel key: 8fcca64b3f3a7b31c9bd7dff28639a75f6cf816e'
[    1.629795] zswap: loaded using pool lzo/zbud
[    1.629860] page_owner is disabled
[    1.630063] pstore: Using crash dump compression: deflate
[    1.630077] Key type big_key registered
[    1.631849] Key type trusted registered
[    1.633297] Key type encrypted registered
[    1.633318] Secure boot mode disabled
[    1.633323] Loading compiled-in module X.509 certificates
[    1.633797] Loaded X.509 cert 'Build time autogenerated kernel key: 8fcca64b3f3a7b31c9bd7dff28639a75f6cf816e'
[    1.633802] ima: Allocated hash algorithm: sha256
[    1.644894] Secure boot mode disabled
[    1.644905] Trusted boot mode disabled
[    1.644907] ima: No architecture policies found
[    1.644915] evm: Initialising EVM extended attributes:
[    1.644918] evm: security.selinux
[    1.644919] evm: security.SMACK64 (disabled)
[    1.644921] evm: security.SMACK64EXEC (disabled)
[    1.644923] evm: security.SMACK64TRANSMUTE (disabled)
[    1.644925] evm: security.SMACK64MMAP (disabled)
[    1.644926] evm: security.apparmor (disabled)
[    1.644928] evm: security.ima
[    1.644929] evm: security.capability
[    1.644931] evm: HMAC attrs: 0x1
[    1.644972] alg: No test for 842 (842-nx)
[    1.771255] Freeing unused kernel image (initmem) memory: 5568K
[    1.847296] Run /init as init process
[    1.847300]   with arguments:
[    1.847301]     /init
[    1.847302]   with environment:
[    1.847302]     HOME=/
[    1.847303]     TERM=linux
[    1.847304]     BOOT_IMAGE=/boot/vmlinuz-5.19.0-rc3-next-20220624
[    1.847305]     biosdevname=0
[    1.853702] systemd[1]: systemd 239 (239-58.el8_6.1) running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=legacy)
[    1.853740] systemd[1]: Detected virtualization powervm.
[    1.853745] systemd[1]: Detected architecture ppc64-le.
[    1.853749] systemd[1]: Running in initial RAM disk.
[    1.897876] systemd[1]: Set hostname to <ltcden8-lp6.aus.stglabs.ibm.com>.
[    1.928406] systemd[1]: Listening on Journal Socket.
[    1.929866] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    1.930686] systemd[1]: Starting Load Kernel Modules...
[    1.931481] systemd[1]: Started Memstrack Anylazing Service.
[    1.931671] systemd[1]: Listening on udev Control Socket.
[    1.934568] fuse: module verification failed: signature and/or required key missing - tainting kernel
[    1.946186] fuse: init (API version 7.36)
[    1.949997] IPMI message handler: version 39.2
[    1.951309] ipmi device interface
[    2.084535] synth uevent: /devices/vio: failed to send uevent
[    2.084548] vio vio: uevent: failed to send synthetic uevent
[    2.084605] synth uevent: /devices/vio/4000: failed to send uevent
[    2.084608] vio 4000: uevent: failed to send synthetic uevent
[    2.084617] synth uevent: /devices/vio/4001: failed to send uevent
[    2.084620] vio 4001: uevent: failed to send synthetic uevent
[    2.084629] synth uevent: /devices/vio/4002: failed to send uevent
[    2.084632] vio 4002: uevent: failed to send synthetic uevent
[    2.084640] synth uevent: /devices/vio/4004: failed to send uevent
[    2.084643] vio 4004: uevent: failed to send synthetic uevent
[    2.453041] ibmveth: IBM Power Virtual Ethernet Driver 1.06
[    2.455623] ibmvscsi 3000006a: SRP_VERSION: 16.a
[    2.455742] ibmvscsi 3000006a: Maximum ID: 64 Maximum LUN: 32 Maximum Channel: 3
[    2.455749] scsi host0: IBM POWER Virtual SCSI Adapter 1.5.9
[    2.456048] ibmvscsi 3000006a: partner initialization complete
[    2.456070] ibmvscsi 3000006a: host srp version: 16.a, host partition ltcden8-vios1 (100), OS 3, max io 262144
[    2.456097] ibmvscsi 3000006a: Client reserve enabled
[    2.456101] ibmvscsi 3000006a: sent SRP login
[    2.456117] ibmvscsi 3000006a: SRP_LOGIN succeeded
[    2.457032] ibmveth 30000002 net0: renamed from eth0
[    2.477852] scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
[    2.497759] scsi 0:0:1:0: Attached scsi generic sg0 type 0
[    2.505167] sd 0:0:1:0: [sda] 26214400 4096-byte logical blocks: (107 GB/100 GiB)
[    2.505203] sd 0:0:1:0: [sda] Write Protect is off
[    2.505206] sd 0:0:1:0: [sda] Mode Sense: 17 00 00 08
[    2.505223] sd 0:0:1:0: [sda] Cache data unavailable
[    2.505227] sd 0:0:1:0: [sda] Assuming drive cache: write through
[    2.627971]  sda: sda1 sda2 sda3
[    2.628104] sd 0:0:1:0: [sda] Attached SCSI disk
[    3.030458] SGI XFS with ACLs, security attributes, scrub, quota, no debug enabled
[    3.032060] XFS (sda3): Mounting V5 Filesystem
[    3.042451] XFS (sda3): Ending clean mount
[    3.274314] printk: systemd: 19 output lines suppressed due to ratelimiting
[    3.324130] systemd[1]: systemd 239 (239-58.el8_6.1) running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=legacy)
[    3.324162] systemd[1]: Detected virtualization powervm.
[    3.324168] systemd[1]: Detected architecture ppc64-le.
[    3.324952] systemd[1]: Set hostname to <ltcden8-lp6.aus.stglabs.ibm.com>.
[    3.428963] systemd[1]: /usr/lib/systemd/system/pmie.service:14: EnvironmentFile= path is not absolute, ignoring: @PCP_SYSCONFIG_DIR@/pmie
[    3.464559] systemd[1]: systemd-journald.service: Succeeded.
[    3.465266] systemd[1]: initrd-switch-root.service: Succeeded.
[    3.465637] systemd[1]: Stopped Switch Root.
[    3.465918] systemd[1]: systemd-journald.service: Service has no hold-off time (RestartSec=0), scheduling restart.
[    3.466015] systemd[1]: systemd-journald.service: Scheduled restart job, restart counter is at 1.
[    3.480275] Adding 10485696k swap on /dev/sda2.  Priority:-2 extents:1 across:10485696k SSFS
[    3.485730] xfs filesystem being remounted at / supports timestamps until 2038 (0x7fffffff)
[    3.541570] synth uevent: /devices/vio: failed to send uevent
[    3.541583] vio vio: uevent: failed to send synthetic uevent
[    3.541752] synth uevent: /devices/vio/4000: failed to send uevent
[    3.541755] vio 4000: uevent: failed to send synthetic uevent
[    3.541764] synth uevent: /devices/vio/4001: failed to send uevent
[    3.541767] vio 4001: uevent: failed to send synthetic uevent
[    3.541776] synth uevent: /devices/vio/4002: failed to send uevent
[    3.541779] vio 4002: uevent: failed to send synthetic uevent
[    3.541788] synth uevent: /devices/vio/4004: failed to send uevent
[    3.541791] vio 4004: uevent: failed to send synthetic uevent
[    5.633642] pseries_rng: Registering IBM pSeries RNG driver
[    6.249503] RPC: Registered named UNIX socket transport module.
[    6.249510] RPC: Registered udp transport module.
[    6.249513] RPC: Registered tcp transport module.
[    6.249515] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   32.276207] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is disabled. Duplicate IMA measurements will not be recorded in the IMA log.
[   32.276246] device-mapper: uevent: version 1.0.3
[   32.276345] device-mapper: ioctl: 4.46.0-ioctl (2022-02-22) initialised: dm-devel@redhat.com

--Apple-Mail=_8547D5DE-EAFC-457B-A44F-4A6EC667A4CA--

